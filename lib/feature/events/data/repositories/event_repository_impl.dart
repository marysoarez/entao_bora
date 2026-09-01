import 'package:dartz/dartz.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/data/data_source/events_data_source.dart';
import 'package:entao_bora/feature/events/data/dtos/event_dto.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/errors/event_errors.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource.dart';
import 'package:entao_bora/shared/errors/handle_log_error.dart';

class EventRepositoryImpl extends HandleLogError implements IEventRepository {
  final EventDatasource datasource;
  final UserDatasource userDatasource;

  EventRepositoryImpl({required this.datasource, required this.userDatasource});

  Exception _toException(Object error) {
    return error is Exception ? error : Exception(error.toString());
  }

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
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureGetEventById(),
        stackTrace: s,
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
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureGetEvents(),
        stackTrace: s,
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
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureCreateEvent(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureCreateEvent(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureUpdateEvent, bool>> updateEvent(
    EventEntity event,
  ) async {
    try {
      await datasource.updateEvent(EventDto.fromEntity(event));

      return const Right(true);
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureUpdateEvent(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureUpdateEvent(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureDeleteEvent, bool>> deleteEvent(String id) async {
    try {
      await datasource.deleteEvent(id);

      return const Right(true);
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureDeleteEvent(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureDeleteEvent(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureIncrementEventViews, bool>> incrementViews(
    String id,
  ) async {
    try {
      await datasource.incrementViews(id);

      return const Right(true);
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureIncrementEventViews(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureIncrementEventViews(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureIncrementEventShares, bool>> incrementShares(
    String id,
  ) async {
    try {
      await datasource.incrementShares(id);

      return const Right(true);
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureIncrementEventShares(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureIncrementEventShares(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureGetUpcomingEventsByPlace, List<EventEntity>>>
  getUpcomingEventsByPlace(String placeId) async {
    try {
      final events = await datasource.getUpcomingEventsByPlace(placeId);

      return Right(events.map((e) => e.toEntity()).toList());
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureGetUpcomingEventsByPlace(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureGetUpcomingEventsByPlace());
    }
  }

  @override
  Future<Either<FailureGetEvents, List<EventEntity>>> getEventsByCreatorId(
    String creatorId,
  ) async {
    try {
      final events = await datasource.getEventsByCreatorId(creatorId);

      return Right(events.map((event) => event.toEntity()).toList());
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureGetEvents(),
        stackTrace: s,
      );

      return Left(FailureGetEvents());
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
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureIsUserGoing(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureIsUserGoing(exception: e, stackTrace: s));
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
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureToggleBora(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureToggleBora(exception: e, stackTrace: s));
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
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureCheckIn(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureCheckIn(exception: e, stackTrace: s));
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
    } catch (e, s) {
      logError(
        error: _toException(e),
        failure: FailureHasCheckedIn(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureHasCheckedIn(exception: e, stackTrace: s));
    }
  }
}
