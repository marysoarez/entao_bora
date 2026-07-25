import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:entao_bora/shared/models/geopoint.dart';


class GeoPointDto extends GeoPoint {
  const GeoPointDto({
    required super.latitude,
    required super.longitude,
  });

  factory GeoPointDto.fromEntity(GeoPoint entity) {
    return GeoPointDto(
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  factory GeoPointDto.fromFirestore(firestore.GeoPoint point) {
    return GeoPointDto(
      latitude: point.latitude,
      longitude: point.longitude,
    );
  }

  firestore.GeoPoint toFirestore() {
    return firestore.GeoPoint(
      latitude,
      longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GeoPointDto.fromMap(Map<String, dynamic> map) {
    return GeoPointDto(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }
}