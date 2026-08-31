import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';

class AddressDto extends AddressEntity {
  const AddressDto({
    required super.displayName,
    required super.location,
    super.street,
    super.number,
    super.complement,
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
      complement: entity.complement,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      postalCode: entity.postalCode,
      location: entity.location,
    );
  }

  factory AddressDto.fromMap(Map<String, dynamic> map) {
    final latitude = map['latitude'];
    final longitude = map['longitude'];

    return AddressDto(
      displayName: map['displayName']?.toString() ?? '',
      street: map['street']?.toString(),
      number: map['number']?.toString(),
      complement: map['complement']?.toString(),
      neighborhood: map['neighborhood']?.toString(),
      city: map['city']?.toString(),
      state: map['state']?.toString(),
      country: map['country']?.toString(),
      postalCode: map['postalCode']?.toString(),
      location: LocationEntity(
        latitude: (latitude as num).toDouble(),
        longitude: (longitude as num).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'street': street,
      'number': number,
      'complement': complement,
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
    final address =
        json['address'] as Map<String, dynamic>? ?? {};

    final lat = double.tryParse(
      json['lat']?.toString() ?? '',
    );

    final lon = double.tryParse(
      json['lon']?.toString() ?? '',
    );

    if (lat == null || lon == null) {
      throw const FormatException(
        'Nominatim retornou uma coordenada inválida.',
      );
    }

    final street =
        address['road']?.toString() ??
        address['pedestrian']?.toString() ??
        address['street']?.toString();

    final number =
        address['house_number']?.toString();

    final neighborhood =
        address['suburb']?.toString() ??
        address['neighbourhood']?.toString() ??
        address['quarter']?.toString() ??
        address['residential']?.toString();

    final city =
        address['city']?.toString() ??
        address['town']?.toString() ??
        address['village']?.toString() ??
        address['municipality']?.toString();

    return AddressDto(
      displayName: json['display_name']?.toString() ?? '',
      street: street,
      number: number,
      complement: null,
      neighborhood: neighborhood,
      city: city,
      state: address['state']?.toString(),
      country: address['country']?.toString(),
      postalCode: address['postcode']?.toString(),
      location: LocationEntity(
        latitude: lat,
        longitude: lon,
      ),
    );
  }
}