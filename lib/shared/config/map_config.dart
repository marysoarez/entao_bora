class MapConfig {
  const MapConfig._();

  static const double initialLatitude = -22.9068;
  static const double initialLongitude = -43.1729;
  static const double initialZoom = 11;

  static const String mapId =
      String.fromEnvironment('GOOGLE_MAPS_MAP_ID');
}