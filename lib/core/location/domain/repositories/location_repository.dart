import 'package:dartz/dartz.dart';
import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/errors/location_errors.dart';
import '../entities/location_entity.dart';

abstract class ILocationRepository {
  Future<Either<FailureGetCurrentLocation, LocationEntity>>
      getCurrentLocation();

  Future<Either<FailureSearchAddress, List<AddressEntity>>>
      searchAddress(String query);

  Future<Either<FailureReverseGeocode, AddressEntity?>>
      reverseGeocode(LocationEntity location);

  Future<Either<FailureIsNear, bool>> isNear(
    LocationEntity destination, {
    double radius = 100,
  });

  Future<Either<FailureGetCurrentLocationIfNear, LocationEntity?>>
      getCurrentLocationIfNear(
    LocationEntity destination, {
    double radius = 100,
  });
}