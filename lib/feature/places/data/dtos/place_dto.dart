import 'package:entao_bora/core/location/data/dtos/address_dto.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/oppening_hours.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';

import '../../domain/entities/place_entity.dart';

class PlaceDto extends PlaceEntity {
  const PlaceDto({
    required super.id,
    required super.name,
    required super.description,
    required super.address,
    required super.musicGenres,
    required super.type,
    required super.phone,
    required super.instagram,
    required super.website,
    required super.openingHours,
    required super.photos,
    required super.ownerId,
    required super.ownerName,
  });

  factory PlaceDto.fromMap(Map<String, dynamic> map) {
    return PlaceDto(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      address: AddressDto.fromMap(map['address']),
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      musicGenres: (map['musicGenres'] as List<dynamic>? ?? [])
          .map((e) => MusicGenre.fromSlug(e.toString()))
          .toList(),

      type: PlaceType.values.byName(map['type']),
      phone: map['phone'],
      instagram: map['instagram'],
      website: map['website'],

      openingHours: (map['openingHours'] as List<dynamic>? ?? [])
          .map((e) => OpeningHours.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      photos: List<String>.from(map['photos'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': AddressDto.fromEntity(address).toMap(),
      'type': type.name,
      'phone': phone,
      'instagram': instagram,
      'website': website,
      'photos': photos,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'musicGenres': musicGenres.map((e) => e.name).toList(),
      'openingHours': openingHours.map((e) => e.toMap()).toList(),
    };
  }

  factory PlaceDto.fromEntity(PlaceEntity entity) {
    return PlaceDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      ownerId: entity.ownerId,
      ownerName: entity.ownerName,
      musicGenres: entity.musicGenres,
      type: entity.type,
      phone: entity.phone,
      instagram: entity.instagram,
      website: entity.website,
      openingHours: entity.openingHours,
      photos: entity.photos,
    );
  }
}
