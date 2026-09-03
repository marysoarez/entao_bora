import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/places/data/dtos/place_dto.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/oppening_hours.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';

class PlaceEntity {
  final String id;
  final String slug;
  final String name;
  final String description;

  final AddressEntity address;

  final List<MusicGenre> musicGenres;
  final PlaceType type;
  final UserSummaryEntity ownerId;
  final String phone;
  final String instagram;
  final String website;

  final List<OpeningHours> openingHours;
  final List<String> photos;
  final List<MenuItemEntity> menuItems;
  final List<String> menuCategories;

  const PlaceEntity({
    required this.id,
    this.slug = '',
    required this.name,
    required this.description,
    required this.address,
    required this.musicGenres,
    required this.type,
    required this.phone,
    required this.instagram,
    required this.website,
    required this.openingHours,
    required this.photos,
    this.menuItems = const [],
    this.menuCategories = const [],
    required this.ownerId,
  });

  PlaceDto copyWith({
    String? id,
    String? slug,
    String? name,
    String? description,
    AddressEntity? address,
    List<MusicGenre>? musicGenres,
    PlaceType? type,
    String? phone,
    String? instagram,
    String? website,
    List<OpeningHours>? openingHours,
    List<String>? photos,
    List<MenuItemEntity>? menuItems,
    List<String>? menuCategories,
    UserSummaryEntity? ownerId,
  }) {
    return PlaceDto(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      musicGenres: musicGenres ?? this.musicGenres,
      type: type ?? this.type,
      phone: phone ?? this.phone,
      instagram: instagram ?? this.instagram,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
      photos: photos ?? this.photos,
      menuItems: menuItems ?? this.menuItems,
      menuCategories: menuCategories ?? this.menuCategories,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
