import 'package:dartz/dartz.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/errors/event_errors.dart';

abstract class IEventRepository {
  Future<Either<FailureGetEvents, List<EventEntity>>> getEvents();

  Future<Either<FailureGetEventById, EventEntity?>> getEventById(String id);

  Future<Either<FailureCreateEvent, bool>> createEvent(
    EventEntity event,
  );

  Future<Either<FailureUpdateEvent, bool>> updateEvent(
    EventEntity event,
  );

  Future<Either<FailureDeleteEvent, bool>> deleteEvent(
    String id,
  );

  Future<Either<FailureIncrementEventViews, bool>> incrementViews(
    String id,
  );

  Future<Either<FailureIncrementEventShares, bool>> incrementShares(
    String id,
  );

  Future<Either<FailureGetUpcomingEventsByPlace, List<EventEntity>>>
      getUpcomingEventsByPlace(
    String placeId,
  );

  Future<Either<FailureIsUserGoing, bool>> isUserGoing({
    required String eventId,
    required String userId,
  });

  Future<Either<FailureToggleBora, bool>> toggleBora({
    required String eventId,
    required UserSummaryEntity user,
    required bool isBora,
  });

  Future<Either<FailureCheckIn, bool>> checkIn({
    required String eventId,
    required UserSummaryEntity user,
    required double latitude,
    required double longitude,
  });

  Future<Either<FailureHasCheckedIn, bool>> hasCheckedIn({
    required String eventId,
    required String userId,
  });
}