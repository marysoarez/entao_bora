import 'package:dartz/dartz.dart';
import 'package:entao_bora/feature/places/data/datasource/place_datasource.dart';
import 'package:entao_bora/feature/places/data/dtos/place_dto.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/errors/place_errors.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource.dart';
import 'package:entao_bora/shared/errors/handle_log_error.dart';

class PlaceRepositoryImpl extends HandleLogError implements IPlaceRepository {
  final IPlaceDatasource datasource;
  final UserDatasource userDatasource;

  PlaceRepositoryImpl({required this.datasource, required this.userDatasource});

  @override
  Future<Either<FailureGetPlaces, List<PlaceEntity>>> getPlaces() async {
    try {
      final places = await datasource.getPlaces();

      final placesWithOwners = await _withOwners(places);

      return Right(placesWithOwners);
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureGetPlaces(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureGetPlaces(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureUpdatePlace, Unit>> updatePlace(
    PlaceEntity place,
  ) async {
    try {
      await datasource.updatePlace(PlaceDto.fromEntity(place));

      return const Right(unit);
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureUpdatePlace(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureUpdatePlace(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureCreatePlace, bool>> createPlace(
    PlaceEntity place,
  ) async {
    try {
      await datasource.createPlace(PlaceDto.fromEntity(place));

      return const Right(true);
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureCreatePlace(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureCreatePlace(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureGetPlaceById, PlaceEntity?>> getPlaceById(
    String id,
  ) async {
    try {
      final place = await datasource.getPlaceById(id);

      if (place == null) {
        return const Right(null);
      }

      final placesWithOwners = await _withOwners([place]);

      return Right(placesWithOwners.first);
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureGetPlaceById(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureGetPlaceById(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureGetPlaceById, PlaceEntity?>> getPlaceBySlug(
    String slug,
  ) async {
    try {
      final place = await datasource.getPlaceBySlug(slug);

      if (place == null) {
        return const Right(null);
      }

      final placesWithOwners = await _withOwners([place]);

      return Right(placesWithOwners.first);
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureGetPlaceById(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureGetPlaceById(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<FailureGetPlaces, bool>> slugExists(
    String slug, {
    String? exceptId,
  }) async {
    try {
      return Right(await datasource.slugExists(slug, exceptId: exceptId));
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureGetPlaces(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureGetPlaces(exception: e, stackTrace: s));
    }
  }

  Future<List<PlaceEntity>> _withOwners(List<PlaceEntity> places) async {
    if (places.isEmpty) {
      return places;
    }

    final ownerIds = places
        .map((place) => place.ownerId.id)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (ownerIds.isEmpty) {
      return places;
    }

    final users = await userDatasource.getUsersByIds(ownerIds);

    final usersById = {for (final user in users) user.id: user};

    return places.map((place) {
      final owner = usersById[place.ownerId.id];

      if (owner == null) {
        return place;
      }

      return place.copyWith(ownerId: owner.toEntity());
    }).toList();
  }

  @override
  Future<Either<FailureGetPlaceByOwner, List<PlaceEntity>>> getPlacesByOwnerId(
    String ownerId,
  ) async {
    try {
      final places = await datasource.getPlacesByOwnerId(ownerId);

      final placesWithOwners = await _withOwners(places);

      return Right(placesWithOwners);
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureGetPlaceByOwner(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureGetPlaceByOwner(exception: e, stackTrace: s));
    }
  }
}
