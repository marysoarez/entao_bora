import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_heat.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_markers.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

class MapSection extends StatefulWidget {
  const MapSection({
    super.key,
    required this.places,
    required this.events,
  });

  final List<PlaceEntity> places;
  final List<EventEntity> events;

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  google.GoogleMapController? _mapController;

  static final google.LatLng _initialCenter = google.LatLng(
    -22.9068,
    -43.1729,
  );

  bool _mapReady = false;
  bool _initialFitDone = false;

  @override
  void didUpdateWidget(covariant MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final placesChanged = oldWidget.places != widget.places;
    final eventsChanged = oldWidget.events != widget.events;

    if (!placesChanged && !eventsChanged) {
      return;
    }

    _initialFitDone = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_mapReady) return;

      _fitAllMarkers();
      _initialFitDone = true;
    });
  }

  void _onMapCreated(google.GoogleMapController controller) {
    _mapController = controller;
    _mapReady = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _fitAllMarkers();
      _initialFitDone = true;
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
          google.CameraPosition(
            target: points.first,
            zoom: 14,
          ),
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

    controller.animateCamera(
      google.CameraUpdate.newLatLngBounds(
        bounds,
        60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('');
    debugPrint('================ MAP SECTION ================');
    debugPrint('PLACES: ${widget.places.length}');
    debugPrint('EVENTS: ${widget.events.length}');

    for (final event in widget.events) {
      debugPrint(
        'EVENT MAP -> '
        'id=${event.id} | '
        'title=${event.title} | '
        'placeId=${event.placeId} | '
        'lat=${event.address.location.latitude} | '
        'lng=${event.address.location.longitude}',
      );
    }

    final markers = MapMarkers.build(
      places: widget.places,
      events: widget.events,
      owners: const {},
      context: context,
    );

    final circles = MapHeatLayer.build(widget.events);

    debugPrint('MARKERS GERADOS: ${markers.length}');
    debugPrint('CIRCLES GERADOS: ${circles.length}');
    debugPrint('============================================');

    return google.GoogleMap(
      initialCameraPosition: google.CameraPosition(
        target: _initialCenter,
        zoom: 11,
      ),

      onMapCreated: _onMapCreated,

      // Google Maps exige Set
      markers: markers.toSet(),
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