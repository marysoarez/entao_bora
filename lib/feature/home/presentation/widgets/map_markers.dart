import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/presentation/pages/place_botton_sheet.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';

class MapMarkers {
  const MapMarkers._();

  static List<Marker> build({
    required BuildContext context,

    required List<PlaceEntity> places,
    required List<EventEntity> events,
    required Map<String, UserSummaryEntity> owners,
  }) {
    return [
      ..._buildPlaceMarkers(places: places, owners: owners, context: context),
      ..._buildEventMarkers(events),
    ];
  }

  static List<Marker> _buildPlaceMarkers({
    required BuildContext context,
    required List<PlaceEntity> places,
    required Map<String, UserSummaryEntity> owners,
  }) {
    return places.map((place) {
      final owner = owners[place.ownerId];
      final isPartner = place.ownerId.isPartner;

      debugPrint(
        'PLACE: ${place.name}\n'
        '  ownerId: ${place.ownerId.id}\n'
        '  owner: ${place.ownerId.name}\n'
        '  role: ${place.ownerId.role}\n'
        '  isPartner: $isPartner\n'
        '  owner: $owner\n'
        '  owner: ${place.ownerId.photoUrl}\n'
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
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => PlaceDetailsSheet(place: place),
            );
          },
          child: isPartner
              ? _buildPartnerMarker(place.ownerId.photoUrl)
              : const Icon(Icons.store, color: Colors.red, size: 18),
        ),
      );
    }).toList();
  }

  static Widget _buildPartnerMarker(String? photoUrl) {
    debugPrint('PARTNER PHOTO URL: $photoUrl');

    if (photoUrl == null || photoUrl.isEmpty) {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 3),
        ),
        child: const Icon(Icons.store, color: Colors.red, size: 20),
      );
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red, width: 3),
      ),
      child: ClipOval(
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, error, stackTrace) {
            debugPrint('ERRO AO CARREGAR FOTO: $error');

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
