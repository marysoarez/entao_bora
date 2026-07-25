import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';

class AddressDto extends AddressEntity {
  const AddressDto({
    required super.displayName,
    required super.location,
    super.street,
    super.number,
    super.neighborhood,
    super.city,
    super.state,
    super.country,
    super.postalCode,
  });

  factory AddressDto.fromEntity(AddressEntity entity) {
    return AddressDto(
      displayName: entity.displayName,
      street: entity.street,
      number: entity.number,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      postalCode: entity.postalCode,
      location: entity.location,
    );
  }

  factory AddressDto.fromMap(Map<String, dynamic> map) {
    return AddressDto(
      displayName: map['displayName'] ?? '',
      street: map['street'],
      number: map['number'],
      neighborhood: map['neighborhood'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      postalCode: map['postalCode'],
      location: LocationEntity(
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'street': street,
      'number': number,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
  }

  factory AddressDto.fromNominatim(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};

    return AddressDto(
      displayName: json['display_name'] ?? '',
      street: address['road'] ?? address['pedestrian'] ?? address['street'],
      number: address['house_number'],
      neighborhood:
          address['suburb'] ?? address['neighbourhood'] ?? address['quarter'],
      city:
          address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'],
      state: address['state'],
      country: address['country'],
      postalCode: address['postcode'],
      location: LocationEntity(
        latitude: double.parse(json['lat']),
        longitude: double.parse(json['lon']),
      ),
    );
  }
}
