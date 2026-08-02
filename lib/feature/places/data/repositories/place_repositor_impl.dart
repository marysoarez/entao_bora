import 'package:dartz/dartz.dart';
import 'package:entao_bora/feature/places/data/datasource/place_datasource.dart';
import 'package:entao_bora/feature/places/data/dtos/place_dto.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/errors/place_errors.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/errors/handle_log_error.dart';

class PlaceRepositoryImpl extends HandleLogError implements IPlaceRepository {
  final IPlaceDatasource datasource;

  PlaceRepositoryImpl({required this.datasource});

  @override
  Future<Either<FailureGetPlaces, List<PlaceEntity>>> getPlaces() async {
    try {
      final places = await datasource.getPlaces();

      return Right(places);
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
    await datasource.updatePlace(
      PlaceDto.fromEntity(place),
    );

    return const Right(unit);
  } catch (e, s) {
    logError(
      error: e,
      failure: FailureUpdatePlace(
        exception: e,
        stackTrace: s,
      ),
      stackTrace: s,
    );

    return Left(
      FailureUpdatePlace(
        exception: e,
        stackTrace: s,
      ),
    );
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

      return Right(place);
    } catch (e, s) {
      logError(
        error: e,
        failure: FailureGetPlaceById(exception: e, stackTrace: s),
        stackTrace: s,
      );

      return Left(FailureGetPlaceById(exception: e, stackTrace: s));
    }
  }
}
