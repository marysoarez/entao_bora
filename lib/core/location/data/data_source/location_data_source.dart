import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';

abstract class ILocationDatasource {
  Future<LocationEntity> getCurrentLocation();

  Future<List<AddressEntity>> searchAddress(String query);

  Future<AddressEntity?> reverseGeocode(
    LocationEntity location,
  );
}