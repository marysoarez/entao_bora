import 'package:dartz/dartz.dart';
import 'package:entao_bora/core/location/data/data_source/location_data_source.dart';
import 'package:entao_bora/core/location/data/dtos/address_dto.dart';
import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/core/location/domain/errors/location_errors.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/shared/errors/handle_log_error.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepositoryImpl extends HandleLogError
    implements ILocationRepository {
  final ILocationDatasource datasource;

  LocationRepositoryImpl({required this.datasource});

  @override
  Future<Either<FailureGetCurrentLocation, LocationEntity>>
  getCurrentLocation() async {
    try {
      final result = await datasource.getCurrentLocation();

      return Right(result);
    } catch (error, stackTrace) {
      final failure = FailureGetCurrentLocation(
        message: 'Erro ao obter localização.',
        exception: error,
        stackTrace: stackTrace,
      );

      logError(error: error, failure: failure, stackTrace: stackTrace);

      return Left(failure);
    }
  }

  @override
  Future<Either<FailureSearchAddress, List<AddressEntity>>> searchAddress(
    String query,
  ) async {
    try {
      final result = await datasource.searchAddress(query);

      return Right(result);
    } catch (error, stackTrace) {
      final failure = FailureSearchAddress(
        message: 'Erro ao buscar endereço.',
        exception: error,
        stackTrace: stackTrace,
      );

      logError(error: error, failure: failure, stackTrace: stackTrace);

      return Left(failure);
    }
  }

  @override
  Future<Either<FailureReverseGeocode, AddressEntity?>> reverseGeocode(
    LocationEntity location,
  ) async {
    try {
      final result = await datasource.reverseGeocode(location);

      return Right(result);
    } catch (error, stackTrace) {
      final failure = FailureReverseGeocode(
        message: 'Erro ao obter endereço.',
        exception: error,
        stackTrace: stackTrace,
      );

      logError(error: error, failure: failure, stackTrace: stackTrace);

      return Left(failure);
    }
  }

  @override
  Future<Either<FailureGeocodeAddress, AddressEntity?>> geocodeAddress(
    AddressEntity address,
  ) async {
    try {
      final result = await datasource.geocodeAddress(
        AddressDto.fromEntity(address),
      );

      return Right(result);
    } catch (error, stackTrace) {
      final failure = FailureGeocodeAddress(
        message: 'Erro ao geocodificar endereço.',
        exception: error,
        stackTrace: stackTrace,
      );

      logError(error: error, failure: failure, stackTrace: stackTrace);

      return Left(failure);
    }
  }

  @override
  Future<Either<FailureIsNear, bool>> isNear(
    LocationEntity destination, {
    double radius = 100,
  }) async {
    try {
      final current = await datasource.getCurrentLocation();

      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        destination.latitude,
        destination.longitude,
      );

      return Right(distance <= radius);
    } catch (error, stackTrace) {
      final failure = FailureIsNear(
        message: 'Erro ao verificar proximidade.',
        exception: error,
        stackTrace: stackTrace,
      );

      logError(error: error, failure: failure, stackTrace: stackTrace);

      return Left(failure);
    }
  }

  @override
  Future<Either<FailureGetCurrentLocationIfNear, LocationEntity?>>
  getCurrentLocationIfNear(
    LocationEntity destination, {
    double radius = 100,
  }) async {
    try {
      final current = await datasource.getCurrentLocation();

      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        destination.latitude,
        destination.longitude,
      );

      if (distance > radius) {
        return const Right(null);
      }

      return Right(current);
    } catch (error, stackTrace) {
      final failure = FailureGetCurrentLocationIfNear(
        message: 'Erro ao validar proximidade.',
        exception: error,
        stackTrace: stackTrace,
      );

      logError(error: error, failure: failure, stackTrace: stackTrace);

      return Left(failure);
    }
  }
}
