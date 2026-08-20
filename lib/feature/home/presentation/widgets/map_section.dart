import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_heat.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_markers.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/config/map_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key, required this.places, required this.events});

  final List<PlaceEntity> places;
  final List<EventEntity> events;

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  final MapController _mapController = MapController();

  static const LatLng _initialCenter = LatLng(-22.9068, -43.1729);

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

  void _onMapReady() {
    _mapReady = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _fitAllMarkers();
      _initialFitDone = true;
    });
  }

  void _onMapEvent(MapEvent event) {
    if (event is MapEventNonRotatedSizeChange && !_initialFitDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_mapReady) return;

        _fitAllMarkers();
        _initialFitDone = true;
      });
    }
  }

  void _fitAllMarkers() {
    if (!_mapReady) return;

    final points = <LatLng>[];

    for (final place in widget.places) {
      points.add(
        LatLng(
          place.address.location.latitude,
          place.address.location.longitude,
        ),
      );
    }

    for (final event in widget.events.where((e) => e.placeId == null)) {
      points.add(
        LatLng(
          event.address.location.latitude,
          event.address.location.longitude,
        ),
      );
    }

    if (points.isEmpty) return;

    final bounds = LatLngBounds.fromPoints(points);

    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialCenter,
        initialZoom: 11,
        onMapReady: _onMapReady,
        onMapEvent: _onMapEvent,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: MapConfig.tileUrl,
          subdomains: MapConfig.subdomains,
          userAgentPackageName: 'com.entaobora',
        ),

        CircleLayer(circles: MapHeatLayer.build(widget.events)),

        MarkerLayer(
          markers: MapMarkers.build(
            places: widget.places,
            events: widget.events,
            owners: const {},
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
