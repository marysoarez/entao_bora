import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_heat.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_markers.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

class MapSection extends StatefulWidget {
  const MapSection({super.key, required this.places, required this.events});

  final List<PlaceEntity> places;
  final List<EventEntity> events;

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  google.GoogleMapController? _mapController;

  static final google.LatLng _initialCenter = google.LatLng(-22.9068, -43.1729);
  static const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#141414"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8f8f8f"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#141414"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#2f2f2f"}]},
  {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#1c1c1c"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#7f7f7f"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#292929"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#1a1a1a"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#a0a0a0"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3a2a2a"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#4a2222"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#202020"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#070707"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#4f4f4f"}]}
]
''';

  bool _mapReady = false;
  bool _markersLoaded = false;
  int _markerBuildVersion = 0;
  Set<google.Marker> _markers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_markersLoaded) return;

    _markersLoaded = true;
    _refreshMarkers();
  }

  @override
  void didUpdateWidget(covariant MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final placesChanged = oldWidget.places != widget.places;
    final eventsChanged = oldWidget.events != widget.events;

    if (!placesChanged && !eventsChanged) {
      return;
    }

    _refreshMarkers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_mapReady) return;

      _fitAllMarkers();
    });
  }

  Future<void> _refreshMarkers() async {
    final version = ++_markerBuildVersion;

    final markers = await MapMarkers.build(
      places: widget.places,
      events: widget.events,
      owners: const {},
      context: context,
    );

    if (!mounted || version != _markerBuildVersion) {
      return;
    }

    setState(() {
      _markers = markers.toSet();
    });
  }

  void _onMapCreated(google.GoogleMapController controller) {
    _mapController = controller;
    _mapReady = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _fitAllMarkers();
    });
  }

  void _fitAllMarkers() {
    final controller = _mapController;

    if (controller == null || !_mapReady) {
      return;
    }

    final points = <google.LatLng>[];

    for (final place in widget.places) {
      points.add(
        google.LatLng(
          place.address.location.latitude,
          place.address.location.longitude,
        ),
      );
    }

    for (final event in widget.events.where((e) => e.placeId == null)) {
      points.add(
        google.LatLng(
          event.address.location.latitude,
          event.address.location.longitude,
        ),
      );
    }

    if (points.isEmpty) {
      return;
    }

    // Apenas um ponto
    if (points.length == 1) {
      controller.animateCamera(
        google.CameraUpdate.newCameraPosition(
          google.CameraPosition(target: points.first, zoom: 14),
        ),
      );

      return;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points.skip(1)) {
      minLat = point.latitude < minLat ? point.latitude : minLat;
      maxLat = point.latitude > maxLat ? point.latitude : maxLat;
      minLng = point.longitude < minLng ? point.longitude : minLng;
      maxLng = point.longitude > maxLng ? point.longitude : maxLng;
    }

    final bounds = google.LatLngBounds(
      southwest: google.LatLng(minLat, minLng),
      northeast: google.LatLng(maxLat, maxLng),
    );

    controller.animateCamera(google.CameraUpdate.newLatLngBounds(bounds, 60));
  }

  @override
  Widget build(BuildContext context) {
    final circles = MapHeatLayer.build(widget.events);

    return google.GoogleMap(
      initialCameraPosition: google.CameraPosition(
        target: _initialCenter,
        zoom: 11,
      ),
      style: _darkMapStyle,

      onMapCreated: _onMapCreated,

      // Google Maps exige Set
      markers: _markers,
      circles: circles.toSet(),

      // Interações
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,

      // UI
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,

      // Localização
      myLocationEnabled: false,
      myLocationButtonEnabled: false,

      // Extras
      buildingsEnabled: false,
      trafficEnabled: false,
      indoorViewEnabled: false,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
