class LocationEntity {
  final double latitude;
  final double longitude;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => '$latitude,$longitude';
}