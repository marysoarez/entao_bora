import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/config/map_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MapSection extends StatelessWidget {
  final LocationEntity currentLocation;
  final List<PlaceEntity> places;
  final List<EventEntity> events;

  const MapSection({
    super.key,
    required this.currentLocation,
    required this.places,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ),
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

        MarkerLayer(markers: _buildCurrentLocationMarker()),

        MarkerLayer(markers: _buildMapMarkers(context)),
      ],
    );
  }

  List<Marker> _buildCurrentLocationMarker() {
    return [
      Marker(
        width: 35,
        height: 35,
        point: LatLng(currentLocation.latitude, currentLocation.longitude),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: const Icon(Icons.my_location, color: Colors.white, size: 28),
        ),
      ),
    ];
  }

  List<Marker> _buildMapMarkers(BuildContext context) {
    final markers = <Marker>[];
    debugPrint('Places: ${places.length}');
    debugPrint('Events: ${events.length}');
    const offset = 0.00008;

    // Estabelecimentos
    for (final place in places) {
      markers.add(
        Marker(
          width: 42,
          height: 42,
          point: LatLng(
            place.address.location.latitude,
            place.address.location.longitude,
          ),
          child: GestureDetector(
            onTap: () {
              Modular.to.pushNamed('/places/events', arguments: place);
            },
            child: const Icon(Icons.store, color: Colors.blue, size: 42),
          ),
        ),
      );
    }

    // Eventos
    for (final event in events) {
      markers.add(
        Marker(
          width: 46,
          height: 46,
          point: LatLng(
            event.address.location.latitude + offset,
            event.address.location.longitude + offset,
          ),
          child: GestureDetector(
            onTap: () {
              Modular.to.pushNamed('/events/${event.id}');
            },
            child: const Icon(
              Icons.local_activity,
              color: Colors.red,
              size: 46,
            ),
          ),
        ),
      );
    }

    return markers;
  }
}
