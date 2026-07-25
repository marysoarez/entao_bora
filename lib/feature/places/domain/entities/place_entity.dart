import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/oppening_hours.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';

class PlaceEntity {
  final String id;
  final String name;
  final String description;

  final AddressEntity address;

  final List<MusicGenre> musicGenres;
  final PlaceType type;

  final String phone;
  final String instagram;
  final String website;

  final List<OpeningHours> openingHours;

  final List<String> photos;

  const PlaceEntity({
    required this.id,
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
  });
}