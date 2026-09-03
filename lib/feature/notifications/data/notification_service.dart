import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/notifications/domain/entities/notification_activation_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService(this._firestore, this._messaging);

  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  static const _webVapidKey = String.fromEnvironment('FCM_WEB_VAPID_KEY');

  Future<NotificationActivationResult> activate({
    required UserSummaryEntity user,
    required LocationEntity location,
  }) async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return const NotificationActivationResult(
        success: false,
        message: 'Permissao de notificacao negada.',
      );
    }

    final token = await _getToken();

    if (token == null || token.isEmpty) {
      return NotificationActivationResult(
        success: false,
        message: kIsWeb && _webVapidKey.isEmpty
            ? 'Informe a chave VAPID web para ativar notificacoes no navegador.'
            : 'Nao foi possivel gerar o token de notificacao.',
      );
    }

    await _saveToken(user: user, token: token, location: location);

    _messaging.onTokenRefresh.listen((newToken) {
      _saveToken(user: user, token: newToken, location: location);
    });

    return const NotificationActivationResult(
      success: true,
      message: 'Notificacoes ativadas com sucesso.',
    );
  }

  Future<String?> _getToken() {
    if (kIsWeb) {
      if (_webVapidKey.isEmpty) {
        return Future.value();
      }

      return _messaging.getToken(vapidKey: _webVapidKey);
    }

    return _messaging.getToken();
  }

  Future<void> _saveToken({
    required UserSummaryEntity user,
    required String token,
    required LocationEntity location,
  }) async {
    final encodedToken = base64Url.encode(utf8.encode(token));
    final userRef = _firestore.collection('users').doc(user.id);
    final tokenRef = userRef
        .collection('notification_tokens')
        .doc(encodedToken);
    final now = FieldValue.serverTimestamp();

    await _firestore.runTransaction((transaction) async {
      transaction.set(userRef, {
        'notificationsEnabled': true,
        'locationSharingEnabled': true,
        'notificationUpdatedAt': now,
        'lastKnownLocation': GeoPoint(location.latitude, location.longitude),
      }, SetOptions(merge: true));

      transaction.set(tokenRef, {
        'token': token,
        'platform': defaultTargetPlatform.name,
        'isWeb': kIsWeb,
        'enabled': true,
        'updatedAt': now,
        'lastKnownLocation': GeoPoint(location.latitude, location.longitude),
      }, SetOptions(merge: true));
    });
  }
}
