import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/core/firestore/PATHS/firestore_paths.dart';
import 'package:entao_bora/core/firestore/data/firestore_client.dart';
import 'package:entao_bora/feature/events/data/data_source/events_data_source.dart';
import 'package:entao_bora/feature/events/data/dtos/event_bora_dto.dart';
import 'package:entao_bora/feature/events/data/dtos/event_checkin_dto.dart';
import 'package:entao_bora/feature/events/data/dtos/event_dto.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource.dart';
import 'package:flutter/foundation.dart';

class EventDatasourceImpl implements EventDatasource {
  final FirestoreClient firestore;
  final UserDatasource userDatasource;

  EventDatasourceImpl(this.firestore, this.userDatasource);

  String? _createdByIdFrom(Map<String, dynamic> data) {
    final rawCreatedBy = data['createdBy'];

    if (rawCreatedBy is String) {
      return rawCreatedBy;
    }

    if (rawCreatedBy is Map) {
      return rawCreatedBy['id'] as String?;
    }

    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _runQuery(
    Query<Map<String, dynamic>> query,
  ) async {
    try {
      return await query.get();
    } on FirebaseException catch (e) {
      if (e.message != null) {
        final match = RegExp(r'https://\S+').firstMatch(e.message!);

        if (match != null) {}
      }

      rethrow;
    }
  }

  @override
  Future<List<EventDto>> getEvents() async {
    final snapshot = await _runQuery(
      firestore
          .collection(FirestorePaths.events)
          .where('status', isEqualTo: 'published')
          .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('endDate'),
    );

    final events = <EventDto>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final createdById = _createdByIdFrom(data);

      if (createdById == null || createdById.isEmpty) {
        continue;
      }

      final users = await userDatasource.getUsersByIds([createdById]);

      if (users.isEmpty) {
        continue;
      }

      final creator = users.first;

      final event = EventDto.fromMap(doc.id, data, createdBy: creator);

      events.add(event);
    }

    return events;
  }

  @override
  Stream<List<EventDto>> watchEvents() {
    final query = firestore
        .collection(FirestorePaths.events)
        .where('status', isEqualTo: 'published')
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('endDate');

    return query.snapshots().asyncMap((snapshot) async {
      final events = <EventDto>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final createdById = _createdByIdFrom(data);

        if (createdById == null || createdById.isEmpty) {
          continue;
        }

        final users = await userDatasource.getUsersByIds([createdById]);

        if (users.isEmpty) {
          continue;
        }

        final creator = users.first;

        events.add(EventDto.fromMap(doc.id, data, createdBy: creator));
      }

      return events;
    });
  }

  @override
  Future<EventDto?> getEvent(String id) async {
    final snapshot = await firestore.getDocument(FirestorePaths.event(id));

    if (snapshot.exists) {
      return _mapEvent(snapshot);
    }

    return getEventBySlug(id);
  }

  @override
  Future<EventDto?> getEventBySlug(String slug) async {
    final snapshot = await _runQuery(
      firestore
          .collection(FirestorePaths.events)
          .where('slug', isEqualTo: slug)
          .limit(1),
    );

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return _mapEvent(snapshot.docs.first);
  }

  @override
  Future<bool> slugExists(String slug, {String? exceptId}) async {
    final event = await getEventBySlug(slug);

    return event != null && event.id != exceptId;
  }

  Future<EventDto?> _mapEvent(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final data = doc.data()!;

    final createdById = _createdByIdFrom(data);

    if (createdById == null || createdById.isEmpty) {
      return null;
    }

    final users = await userDatasource.getUsersByIds([createdById]);

    if (users.isEmpty) {
      return null;
    }

    final creator = users.first;

    return EventDto.fromMap(doc.id, data, createdBy: creator);
  }

  Future<List<EventDto>> _getPersonalEvents({
    required String collectionId,
    required String userId,
  }) async {
    final eventsById = <String, EventDto>{};
    final eventIds = <String>{};

    try {
      final snapshot = await _runQuery(
        firestore.instance
            .collectionGroup(collectionId)
            .where('user.id', isEqualTo: userId),
      );

      await _addEventsFromPersonalSnapshot(
        collectionId: collectionId,
        snapshot: snapshot,
        eventIds: eventIds,
        eventsById: eventsById,
      );
    } on FirebaseException catch (e, stackTrace) {
      _logPersonalQueryError(
        collectionId: collectionId,
        userId: userId,
        exception: e,
        stackTrace: stackTrace,
      );

      rethrow;
    }

    final events = eventsById.values.toList();
    events.sort((a, b) => b.startDate.compareTo(a.startDate));

    debugPrint(
      'UserArea $collectionId loaded: uid=$userId count=${events.length}',
    );

    return events;
  }

  void _logPersonalQueryError({
    required String collectionId,
    required String userId,
    required FirebaseException exception,
    required StackTrace stackTrace,
  }) {
    debugPrint(
      'UserArea personal query failed: collection=$collectionId uid=$userId code=${exception.code}',
    );
    debugPrint('Firebase message: ${exception.message}');
    debugPrintStack(stackTrace: stackTrace);

    final message = exception.message ?? '';
    final urlMatch = RegExp(
      r'https://console\.firebase\.google\.com/[^\s]+',
    ).firstMatch(message);

    if (urlMatch != null) {
      debugPrint('');
      debugPrint('========== FIREBASE INDEX REQUIRED ==========');
      debugPrint('Collection: $collectionId');
      debugPrint('FIREBASE INDEX URL: ${urlMatch.group(0)}');
      debugPrint('=============================================');
      debugPrint('');
    }
  }

  Future<void> _addEventsFromPersonalSnapshot({
    required String collectionId,
    required QuerySnapshot<Map<String, dynamic>> snapshot,
    required Set<String> eventIds,
    required Map<String, EventDto> eventsById,
  }) async {
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final eventId = _eventIdFromPersonalDoc(doc, data);

      if (eventId == null || eventId.isEmpty || eventIds.contains(eventId)) {
        continue;
      }

      eventIds.add(eventId);

      debugPrint(collectionId == 'checkins' ? 'CHECKIN FOUND:' : 'BORA FOUND:');
      debugPrint('eventId=$eventId');
      debugPrint('path=${doc.reference.path}');

      final eventSnapshot = await doc.reference.parent.parent?.get();
      final event = eventSnapshot?.exists == true
          ? await _mapEvent(eventSnapshot!)
          : await getEvent(eventId);

      if (event != null) {
        eventsById[event.id] = event;
      }
    }
  }

  String? _eventIdFromPersonalDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    Map<String, dynamic> data,
  ) {
    final eventId = data['eventId'] as String?;

    if (eventId != null && eventId.isNotEmpty) {
      return eventId;
    }

    final eventRef = doc.reference.parent.parent;

    return eventRef?.id;
  }

  @override
  Future<List<EventDto>> getBoraEventsByUserId(String userId) {
    return _getPersonalEvents(collectionId: 'boras', userId: userId);
  }

  @override
  Future<List<EventDto>> getCheckinEventsByUserId(String userId) {
    return _getPersonalEvents(collectionId: 'checkins', userId: userId);
  }

  @override
  Future<void> createEvent(EventDto event) async {
    final doc = firestore.collection(FirestorePaths.events).doc();

    final dto = event.copyWith(id: doc.id);

    await doc.set(dto.toMap());
  }

  @override
  Future<void> updateEvent(EventDto event) async {
    await firestore.update(FirestorePaths.event(event.id), event.toMap());
  }

  @override
  Future<void> deleteEvent(String id) async {
    await firestore.delete(FirestorePaths.event(id));
  }

  @override
  Future<void> incrementViews(String id) async {
    await firestore.document(FirestorePaths.event(id)).update({
      'views': FieldValue.increment(1),
    });
  }

  @override
  Future<void> incrementShares(String id) async {
    await firestore.document(FirestorePaths.event(id)).update({
      'shares': FieldValue.increment(1),
    });
  }

  @override
  Future<bool> isUserGoing({
    required String eventId,
    required String userId,
  }) async {
    final snapshot = await firestore.getDocument(
      FirestorePaths.eventBora(eventId, userId),
    );

    return snapshot.exists;
  }

  @override
  Future<bool> hasCheckedIn({
    required String eventId,
    required String userId,
  }) async {
    final snapshot = await firestore.getDocument(
      FirestorePaths.eventCheckin(eventId, userId),
    );

    return snapshot.exists;
  }

  @override
  Future<void> toggleBora({
    required String eventId,
    required UserSummaryEntity user,
    required bool isBora,
  }) async {
    await firestore.runTransaction((transaction) async {
      final eventRef = firestore.document(FirestorePaths.event(eventId));

      final boraRef = firestore.document(
        FirestorePaths.eventBora(eventId, user.id),
      );

      if (isBora) {
        transaction.delete(boraRef);

        transaction.update(eventRef, {'boraCount': FieldValue.increment(-1)});
      } else {
        transaction.set(
          boraRef,
          EventBoraDto(
            id: user.id,
            eventId: eventId,
            user: user,
            createdAt: DateTime.now(),
          ).toMap(),
        );

        transaction.update(eventRef, {'boraCount': FieldValue.increment(1)});
      }
    });
  }

  @override
  Future<void> checkIn({
    required String eventId,
    required UserSummaryEntity user,
    required double latitude,
    required double longitude,
  }) async {
    await firestore.runTransaction((transaction) async {
      final eventRef = firestore.document(FirestorePaths.event(eventId));

      final checkinRef = firestore.document(
        FirestorePaths.eventCheckin(eventId, user.id),
      );

      transaction.set(
        checkinRef,
        EventCheckinDto(
          id: user.id,
          eventId: eventId,
          user: user,
          checkedInAt: DateTime.now(),
          latitude: latitude,
          longitude: longitude,
        ).toMap(),
      );

      transaction.update(eventRef, {'checkinCount': FieldValue.increment(1)});
    });
  }

  @override
  Future<List<EventDto>> getUpcomingEventsByPlace(String placeId) async {
    final query = firestore
        .collection(FirestorePaths.events)
        .where('placeId', isEqualTo: placeId)
        .where('status', isEqualTo: 'published')
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('startDate');

    final snapshot = await _runQuery(query);

    final events = <EventDto>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final createdById = _createdByIdFrom(data);

      if (createdById == null || createdById.isEmpty) {
        continue;
      }

      final users = await userDatasource.getUsersByIds([createdById]);

      if (users.isEmpty) {
        continue;
      }

      final creator = users.first;

      events.add(EventDto.fromMap(doc.id, data, createdBy: creator));
    }

    return events;
  }

  @override
  Future<List<EventDto>> getEventsByCreatorId(String creatorId) async {
    final events = <EventDto>[];
    final docsById = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

    final byString = await _runQuery(
      firestore
          .collection(FirestorePaths.events)
          .where('createdBy', isEqualTo: creatorId),
    );

    for (final doc in byString.docs) {
      docsById[doc.id] = doc;
    }

    final byMap = await _runQuery(
      firestore
          .collection(FirestorePaths.events)
          .where('createdBy.id', isEqualTo: creatorId),
    );

    for (final doc in byMap.docs) {
      docsById[doc.id] = doc;
    }

    final users = await userDatasource.getUsersByIds([creatorId]);
    if (users.isEmpty) return events;

    final creator = users.first;

    for (final doc in docsById.values) {
      events.add(EventDto.fromMap(doc.id, doc.data(), createdBy: creator));
    }

    events.sort((a, b) => a.startDate.compareTo(b.startDate));

    return events;
  }
}
