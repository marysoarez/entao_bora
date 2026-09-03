import 'package:entao_bora/feature/places/data/dtos/place_dto.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';

abstract class IPlaceDatasource {
  Future<List<PlaceDto>> getPlaces();
  Future<void> updatePlace(PlaceDto place);
  Future<void> createPlace(PlaceDto place);
  Future<PlaceEntity?> getPlaceById(String id);
  Future<PlaceEntity?> getPlaceBySlug(String slug);
  Future<bool> slugExists(String slug, {String? exceptId});
  Future<List<PlaceDto>> getPlacesByOwnerId(String ownerId);
}
