class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  GeoPoint copyWith({
    double? latitude,
    double? longitude,
  }) {
    return GeoPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() => '$latitude,$longitude';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoPoint &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}