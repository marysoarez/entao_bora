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
  final String? complement;
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
    this.complement,
  });

  String get fullAddress {
    final parts = <String>[
      if (street != null && street!.isNotEmpty) street!,
      if (number != null && number!.isNotEmpty) number!,
      if (neighborhood != null && neighborhood!.isNotEmpty) neighborhood!,
      if (city != null && city!.isNotEmpty) city!,
      if (state != null && state!.isNotEmpty) state!,
      if (complement?.isNotEmpty ?? false) complement!,
    ];

    return parts.join(', ');
  }

  AddressEntity copyWith({
    String? displayName,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    LocationEntity? location,
  }) {
    return AddressEntity(
      displayName: displayName ?? this.displayName,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      location: location ?? this.location,
    );
  }
}
