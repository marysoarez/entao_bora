import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';

class MapMarkers {
  const MapMarkers._();

  static List<Marker> build({
    required List<PlaceEntity> places,
    required List<EventEntity> events,
    required Map<String, UserSummaryEntity> owners,
  }) {
    return [
      ..._buildPlaceMarkers(places: places, owners: owners),
      ..._buildEventMarkers(events),
    ];
  }

  static List<Marker> _buildPlaceMarkers({
    required List<PlaceEntity> places,
    required Map<String, UserSummaryEntity> owners,
  }) {
    return places.map((place) {
      final owner = owners[place.ownerId];
      final isPartner = owner?.isPartner == true;

      debugPrint(
        'PLACE: ${place.name}\n'
        '  ownerId: ${place.ownerId.id}\n'
        '  owner: ${place.ownerId.name}\n'
        '  role: ${place.ownerId.role}\n'
        '  isPartner: $isPartner\n'
        '  photoUrl: ${place.ownerId.photoUrl}',
      );

      return Marker(
        width: 48,
        height: 48,
        point: LatLng(
          place.address.location.latitude,
          place.address.location.longitude,
        ),
        child: GestureDetector(
          onTap: () {
            Modular.to.pushNamed('/places/events', arguments: place);
          },
          child: isPartner
              ? _buildPartnerMarker(owner?.photoUrl)
              : const Icon(Icons.store, color: Colors.red, size: 18),
        ),
      );
    }).toList();
  }

  static Widget _buildPartnerMarker(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 3),
        ),
        child: const Icon(Icons.store, color: Colors.red, size: 20),
      );
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red, width: 3),
        boxShadow: const [
          BoxShadow(blurRadius: 4, offset: Offset(0, 2), color: Colors.black26),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return const Icon(Icons.store, color: Colors.red, size: 18);
          },
        ),
      ),
    );
  }

  static List<Marker> _buildEventMarkers(List<EventEntity> events) {
    return events.where((event) => event.placeId == null).map((event) {
      return Marker(
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
          child: const Icon(Icons.celebration, color: Colors.red, size: 18),
        ),
      );
    }).toList();
  }
}
