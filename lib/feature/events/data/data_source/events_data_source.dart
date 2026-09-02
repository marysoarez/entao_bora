import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';

import '../dtos/event_dto.dart';

abstract class EventDatasource {
  Future<List<EventDto>> getEvents();

  Stream<List<EventDto>> watchEvents();

  Future<EventDto?> getEvent(String id);

  Future<void> createEvent(EventDto event);

  Future<void> updateEvent(EventDto event);

  Future<void> deleteEvent(String id);

  Future<void> incrementViews(String id);

  Future<void> incrementShares(String id);
  Future<bool> isUserGoing({required String eventId, required String userId});

  Future<void> toggleBora({
    required String eventId,
    required UserSummaryEntity user,
    required bool isBora,
  });

  Future<bool> hasCheckedIn({required String eventId, required String userId});
  Future<void> checkIn({
    required String eventId,
    required UserSummaryEntity user,
    required double latitude,
    required double longitude,
  });
  Future<List<EventDto>> getUpcomingEventsByPlace(String placeId);

  Future<List<EventDto>> getEventsByCreatorId(String creatorId);
}
