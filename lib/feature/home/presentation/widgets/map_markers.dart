import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/presentation/pages/place_botton_sheet.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

class MapMarkers {
  const MapMarkers._();

  static List<google.Marker> build({
    required BuildContext context,
    required List<PlaceEntity> places,
    required List<EventEntity> events,
    required Map<String, UserSummaryEntity> owners,
  }) {
    return [
      ..._buildPlaceMarkers(
        places: places,
        owners: owners,
        context: context,
      ),
      ..._buildEventMarkers(events),
    ];
  }

  static List<google.Marker> _buildPlaceMarkers({
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
        '  photoUrl: ${place.ownerId.photoUrl}',
      );

      return google.Marker(
        markerId: google.MarkerId('place_${place.id}'),
        position: google.LatLng(
          place.address.location.latitude,
          place.address.location.longitude,
        ),
        icon: google.BitmapDescriptor.defaultMarkerWithHue(
          google.BitmapDescriptor.hueRed,
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => PlaceDetailsSheet(
              place: place,
            ),
          );
        },
      );
    }).toList();
  }

  static List<google.Marker> _buildEventMarkers(
    List<EventEntity> events,
  ) {
    return events
        .where((event) => event.placeId == null)
        .map((event) {
      return google.Marker(
        markerId: google.MarkerId('event_${event.id}'),
        position: google.LatLng(
          event.address.location.latitude,
          event.address.location.longitude,
        ),
        icon: google.BitmapDescriptor.defaultMarkerWithHue(
          google.BitmapDescriptor.hueBlue,
        ),
        onTap: () {
          Modular.to.pushNamed(
            '/events/${event.id}',
          );
        },
      );
    }).toList();
  }
}