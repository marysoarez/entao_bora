import 'package:entao_bora/core/location/domain/entities/location_entity.dart';

class AddressEntity {
  final String displayName;

  final String? street;
  final String? number;
  final String? neighborhood;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  final LocationEntity location;

  const AddressEntity({
    required this.displayName,
    required this.location,
    this.street,
    this.number,
    this.neighborhood,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  String get fullAddress {
    final parts = <String>[
      if (street != null && street!.isNotEmpty) street!,
      if (number != null && number!.isNotEmpty) number!,
      if (neighborhood != null && neighborhood!.isNotEmpty) neighborhood!,
      if (city != null && city!.isNotEmpty) city!,
      if (state != null && state!.isNotEmpty) state!,
    ];

    return parts.join(', ');
  }
}