import 'package:dartz/dartz.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/data/data_source/events_data_source.dart';
import 'package:entao_bora/feature/events/data/dtos/event_dto.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/errors/event_errors.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/shared/errors/handle_log_error.dart';

class EventRepositoryImpl extends HandleLogError implements IEventRepository {
  final EventDatasource datasource;

  EventRepositoryImpl({required this.datasource});

  @override
  Future<Either<FailureGetEventById, EventEntity?>> getEventById({
    required String eventId,
    String? userId,
  }) async {
    try {
      final dto = await datasource.getEvent(eventId);

      if (dto == null) {
        return const Right(null);
      }

      var entity = dto.toEntity();

      if (userId != null) {
        final isBora = await datasource.isUserGoing(
          eventId: eventId,
          userId: userId,
        );

        final hasCheckedIn = await datasource.hasCheckedIn(
          eventId: eventId,
          userId: userId,
        );

        entity = entity.copyWith(isBora: isBora, hasCheckedIn: hasCheckedIn);
      }

      return Right(entity);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureGetEventById(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureGetEventById());
    }
  }

  @override
  Future<Either<FailureGetEvents, List<EventEntity>>> getEvents({
    String? userId,
  }) async {
    try {
      final events = await datasource.getEvents();

      final entities = <EventEntity>[];

      for (final dto in events) {
        var entity = dto.toEntity();

        if (userId != null) {
          final isBora = await datasource.isUserGoing(
            eventId: entity.id,
            userId: userId,
          );

          final hasCheckedIn = await datasource.hasCheckedIn(
            eventId: entity.id,
            userId: userId,
          );

          entity = entity.copyWith(isBora: isBora, hasCheckedIn: hasCheckedIn);
        }

        entities.add(entity);
      }

      return Right(entities);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureGetEvents(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureGetEvents());
    }
  }

  @override
  Future<Either<FailureCreateEvent, bool>> createEvent(
    EventEntity event,
  ) async {
    try {
      await datasource.createEvent(EventDto.fromEntity(event));

      return const Right(true);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureCreateEvent(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureCreateEvent());
    }
  }

  @override
  Future<Either<FailureUpdateEvent, bool>> updateEvent(
    EventEntity event,
  ) async {
    try {
      await datasource.updateEvent(EventDto.fromEntity(event));

      return const Right(true);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureUpdateEvent(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureUpdateEvent());
    }
  }

  @override
  Future<Either<FailureDeleteEvent, bool>> deleteEvent(String id) async {
    try {
      await datasource.deleteEvent(id);

      return const Right(true);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureDeleteEvent(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureDeleteEvent());
    }
  }

  @override
  Future<Either<FailureIncrementEventViews, bool>> incrementViews(
    String id,
  ) async {
    try {
      await datasource.incrementViews(id);

      return const Right(true);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureIncrementEventViews(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureIncrementEventViews());
    }
  }

  @override
  Future<Either<FailureIncrementEventShares, bool>> incrementShares(
    String id,
  ) async {
    try {
      await datasource.incrementShares(id);

      return const Right(true);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureIncrementEventShares(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureIncrementEventShares());
    }
  }

  @override
  Future<Either<FailureGetUpcomingEventsByPlace, List<EventEntity>>>
  getUpcomingEventsByPlace(String placeId) async {
    try {
      final events = await datasource.getUpcomingEventsByPlace(placeId);

      return Right(events.map((e) => e.toEntity()).toList());
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureGetUpcomingEventsByPlace(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureGetUpcomingEventsByPlace());
    }
  }

  @override
  Future<Either<FailureIsUserGoing, bool>> isUserGoing({
    required String eventId,
    required String userId,
  }) async {
    try {
      return Right(
        await datasource.isUserGoing(eventId: eventId, userId: userId),
      );
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureIsUserGoing(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureIsUserGoing());
    }
  }

  @override
  Future<Either<FailureToggleBora, bool>> toggleBora({
    required String eventId,
    required UserSummaryEntity user,
    required bool isBora,
  }) async {
    try {
      await datasource.toggleBora(eventId: eventId, user: user, isBora: isBora);

      return const Right(true);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureToggleBora(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureToggleBora());
    }
  }

  @override
  Future<Either<FailureCheckIn, bool>> checkIn({
    required String eventId,
    required UserSummaryEntity user,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await datasource.checkIn(
        eventId: eventId,
        user: user,
        latitude: latitude,
        longitude: longitude,
      );

      return const Right(true);
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureCheckIn(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureCheckIn());
    }
  }

  @override
  Future<Either<FailureHasCheckedIn, bool>> hasCheckedIn({
    required String eventId,
    required String userId,
  }) async {
    try {
      return Right(
        await datasource.hasCheckedIn(eventId: eventId, userId: userId),
      );
    } catch (e) {
      logError(
        error: e as Exception,
        failure: FailureHasCheckedIn(),
        stackTrace: StackTrace.current,
      );

      return Left(FailureHasCheckedIn());
    }
  }
}
