import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/home/presentation/widgets/pulse_marker.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/config/map_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
  final MapController _mapController = MapController();

  static const LatLng _initialCenter = LatLng(
    -22.9068,
    -43.1729,
  ); // Rio de Janeiro

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitAllMarkers();
    });
  }

  @override
  void didUpdateWidget(covariant MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitAllMarkers();
    });
  }

  void _fitAllMarkers() {
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
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(60),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialCenter,
        initialZoom: 11,
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

        CircleLayer(
          circles: _buildHeatCircles(),
        ),

        MarkerLayer(
          markers: _buildMapMarkers(context),
        ),
      ],
    );
  }

  List<CircleMarker> _buildHeatCircles() {
    final circles = <CircleMarker>[];

    for (final event in widget.events) {
      final pulse = event.boraCount + (event.checkinCount * 3);

      if (pulse <= 0) continue;

      circles.add(
        CircleMarker(
          point: LatLng(
            event.address.location.latitude,
            event.address.location.longitude,
          ),
          radius: _heatRadius(pulse),
          useRadiusInMeter: true,
          color: _heatColor(pulse),
          borderStrokeWidth: 0,
        ),
      );
    }

    return circles;
  }

  Color _heatColor(int pulse) {
    if (pulse > 100) return Colors.red.withOpacity(.45);
    if (pulse > 50) return Colors.deepOrange.withOpacity(.38);
    if (pulse > 10) return Colors.orange.withOpacity(.32);
    if (pulse > 3) return Colors.green.withOpacity(.28);

    return Colors.greenAccent.withOpacity(.22);
  }

  double _heatRadius(int pulse) {
    if (pulse > 100) return 350;
    if (pulse > 50) return 250;
    if (pulse > 10) return 180;
    if (pulse > 3) return 120;

    return 80;
  }

  List<Marker> _buildMapMarkers(BuildContext context) {
    final markers = <Marker>[];

    final pulses = <String, int>{};

    for (final event in widget.events) {
      final placeId = event.placeId;

      if (placeId == null) continue;

      pulses.update(
        placeId,
        (value) => value + event.boraCount + (event.checkinCount * 3),
        ifAbsent: () => event.boraCount + (event.checkinCount * 3),
      );
    }

    for (final place in widget.places) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(
            place.address.location.latitude,
            place.address.location.longitude,
          ),
          child: GestureDetector(
            onTap: () {
              Modular.to.pushNamed('/places/events', arguments: place);
            },
            child: const Icon(
              Icons.store,
              color: Colors.red,
              size: 18,
            ),
          ),
        ),
      );
    }

    for (final event in widget.events.where((e) => e.placeId == null)) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(
            event.address.location.latitude,
            event.address.location.longitude,
          ),
          child: GestureDetector(
            onTap: () {
              Modular.to.pushNamed('/events/${event.id}');
            },
            child: const Icon(
              Icons.celebration,
              color: Colors.red,
              size: 18,
            ),
          ),
        ),
      );
    }

    return markers;
  }
}