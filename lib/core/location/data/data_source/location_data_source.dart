import 'package:entao_bora/core/location/data/dtos/address_dto.dart';
import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';

abstract class ILocationDatasource {
  Future<LocationEntity> getCurrentLocation();

  Future<List<AddressEntity>> searchAddress(String query);
  Future<AddressDto?> geocodeAddress(AddressDto address);
  Future<AddressEntity?> reverseGeocode(LocationEntity location);
  Future<void> enableLocationSharing({
    required String userId,
    required LocationEntity location,
  });
  Future<void> disableLocationSharing({required String userId});
}
