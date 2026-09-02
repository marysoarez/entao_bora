import 'package:entao_bora/core/location/data/dtos/address_dto.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/oppening_hours.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';

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
    super.menuItems,
    super.menuCategories,
    required super.ownerId,
  });

  factory PlaceDto.fromMap(Map<String, dynamic> map) {
    final rawOwnerId = map['ownerId'];
    final ownerId = rawOwnerId is Map
        ? rawOwnerId['id']?.toString() ?? ''
        : rawOwnerId?.toString() ?? '';

    return PlaceDto(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      address: AddressDto.fromMap(map['address']),
      ownerId: UserSummaryEntity(id: ownerId, name: '', email: ''),
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
      menuItems: (map['menuItems'] as List<dynamic>? ?? [])
          .map((e) => MenuItemDto.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      menuCategories: List<String>.from(map['menuCategories'] ?? []),
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
      'ownerId': ownerId.id,
      'musicGenres': musicGenres.map((e) => e.name).toList(),
      'openingHours': openingHours.map((e) => e.toMap()).toList(),
      'menuItems': menuItems
          .map((e) => MenuItemDto.fromEntity(e).toMap())
          .toList(),
      'menuCategories': menuCategories,
    };
  }

  factory PlaceDto.fromEntity(PlaceEntity entity) {
    return PlaceDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      ownerId: entity.ownerId,

      musicGenres: entity.musicGenres,
      type: entity.type,
      phone: entity.phone,
      instagram: entity.instagram,
      website: entity.website,
      openingHours: entity.openingHours,
      photos: entity.photos,
      menuItems: entity.menuItems,
      menuCategories: entity.menuCategories,
    );
  }
}

class MenuItemDto extends MenuItemEntity {
  const MenuItemDto({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.photo,
    super.category,
  });

  factory MenuItemDto.fromMap(Map<String, dynamic> map) {
    return MenuItemDto(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      photo: map['photo']?.toString() ?? '',
      category: map['category']?.toString() ?? 'Geral',
    );
  }

  factory MenuItemDto.fromEntity(MenuItemEntity entity) {
    return MenuItemDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      photo: entity.photo,
      category: entity.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'photo': photo,
      'category': category,
    };
  }
}
