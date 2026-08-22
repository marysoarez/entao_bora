import 'package:dartz/dartz.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/errors/place_errors.dart';

abstract class IPlaceRepository {
  Future<Either<FailureGetPlaces, List<PlaceEntity>>> getPlaces();
  Future<Either<FailureUpdatePlace, Unit>> updatePlace(PlaceEntity place);
  Future<Either<FailureCreatePlace, bool>> createPlace(PlaceEntity place);
  Future<Either<FailureGetPlaceById, PlaceEntity?>> getPlaceById(String id);
  Future<Either<FailureGetPlaceByOwner, List<PlaceEntity>>> getPlacesByOwnerId(
    String ownerId,
  );
}
