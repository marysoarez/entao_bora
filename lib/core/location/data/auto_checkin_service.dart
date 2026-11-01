import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/core/location/domain/entities/auto_checkin_policy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class AutoCheckinService {
  AutoCheckinService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final AutoCheckinPolicy _policy = AutoCheckinPolicy();
  StreamSubscription<Position>? _positions;
  StreamSubscription<User?>? _authChanges;
  List<AutoCheckinPlace> _places = const [];

  Future<void> initialize() async {
    if (kIsWeb) return;
    await _authChanges?.cancel();
    _authChanges = _auth.authStateChanges().listen((user) async {
      await stop();
      if (user == null) return;
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.data()?['autoCheckinConsentEnabled'] == true) {
        await start(user.uid, requestPermission: false);
      }
    });
  }

  Future<void> setConsent({
    required String userId,
    required bool enabled,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Check-in automático está disponível somente no aplicativo mobile.',
      );
    }
    if (!enabled) {
      await stop();
      await _firestore.collection('users').doc(userId).set({
        'autoCheckinConsentEnabled': false,
        'autoCheckinConsentUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }
    if (_auth.currentUser?.uid != userId) {
      throw StateError('Usuário deslogado.');
    }
    await _firestore.collection('users').doc(userId).set({
      'autoCheckinConsentEnabled': true,
      'autoCheckinConsentUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    try {
      await start(userId, requestPermission: true);
    } catch (_) {
      await _firestore.collection('users').doc(userId).set({
        'autoCheckinConsentEnabled': false,
        'autoCheckinConsentUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      rethrow;
    }
  }

  Future<void> start(String userId, {required bool requestPermission}) async {
    if (_auth.currentUser?.uid != userId) return;
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Ative a localização do aparelho.');
    }
    var permission = await Geolocator.checkPermission();
    if (requestPermission && permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Permissão de localização negada.');
    }
    _places = await _loadPlaces();
    if (_places.isEmpty) return;
    await _positions?.cancel();
    _positions = Geolocator.getPositionStream(
      locationSettings: _settings(),
    ).listen((position) => _handlePosition(userId, position), onError: (_) {});
  }

  LocationSettings _settings() {
    if (kIsWeb) {
      return const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      );
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
        intervalDuration: const Duration(minutes: 1),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Check-in automático ativo',
          notificationText: 'Validando permanência em locais próximos.',
          enableWakeLock: false,
        ),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
        activityType: ActivityType.otherNavigation,
      );
    }
    return const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );
  }

  Future<List<AutoCheckinPlace>> _loadPlaces() async {
    final result = await _firestore
        .collection('places')
        .where('autoCheckinSettings.autoCheckinEnabled', isEqualTo: true)
        .get();
    return result.docs.expand((doc) {
      final data = doc.data();
      final address = data['address'];
      final settings = data['autoCheckinSettings'];
      if (address is! Map || settings is! Map) {
        return const <AutoCheckinPlace>[];
      }
      final latitude = address['latitude'];
      final longitude = address['longitude'];
      final radius = settings['radiusMeters'];
      final stay = settings['minimumStayMinutes'];
      if (latitude is! num ||
          longitude is! num ||
          radius is! num ||
          stay is! num ||
          radius <= 0 ||
          stay <= 0) {
        return const <AutoCheckinPlace>[];
      }
      return [
        AutoCheckinPlace(
          id: doc.id,
          latitude: latitude.toDouble(),
          longitude: longitude.toDouble(),
          radiusMeters: radius.toDouble(),
          minimumStay: Duration(minutes: stay.ceil()),
        ),
      ];
    }).toList();
  }

  Future<void> _handlePosition(String userId, Position position) async {
    if (_auth.currentUser?.uid != userId) return;
    final distances = {
      for (final place in _places)
        place.id: Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          place.latitude,
          place.longitude,
        ),
    };
    final decision = _policy.evaluate(
      now: position.timestamp,
      accuracyMeters: position.accuracy,
      distancesMeters: distances,
      places: _places,
    );
    for (final placeId in decision.checkInPlaceIds) {
      await _recordCheckIn(userId, placeId, position);
    }
    for (final placeId in decision.checkOutPlaceIds) {
      await _recordCheckOut(userId, placeId);
    }
  }

  Future<void> _recordCheckIn(
    String userId,
    String placeId,
    Position position,
  ) async {
    final ref = _firestore.doc('places/$placeId/checkins/$userId');
    await _firestore.runTransaction((tx) async {
      final current = await tx.get(ref);
      if (current.exists && current.data()?['checkedOutAt'] == null) {
        final sources = List<String>.from(
          current.data()?['sources'] ?? [current.data()?['source']],
        );
        if (!sources.contains('geofence')) {
          tx.update(ref, {
            'sources': [...sources, 'geofence'],
          });
        }
        return;
      }
      tx.set(ref, {
        'userId': userId,
        'placeId': placeId,
        'source': 'geofence',
        'sources': ['geofence'],
        'checkedInAt': FieldValue.serverTimestamp(),
        'checkedOutAt': null,
      });
    });
  }

  Future<void> _recordCheckOut(String userId, String placeId) async {
    final ref = _firestore.doc('places/$placeId/checkins/$userId');
    await _firestore.runTransaction((tx) async {
      final current = await tx.get(ref);
      if (current.exists && current.data()?['checkedOutAt'] == null) {
        tx.update(ref, {'checkedOutAt': FieldValue.serverTimestamp()});
      }
    });
  }

  Future<void> stop() async {
    await _positions?.cancel();
    _positions = null;
    _places = const [];
    _policy.reset();
  }

  Future<void> dispose() async {
    await stop();
    await _authChanges?.cancel();
  }
}
