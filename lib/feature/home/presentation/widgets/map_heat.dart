import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapHeatLayer {
  const MapHeatLayer._();

  static List<CircleMarker> build(
    List<EventEntity> events,
  ) {
    final circles = <CircleMarker>[];

    for (final event in events) {
      final pulse =
          event.boraCount + (event.checkinCount * 3);

      if (pulse <= 0) continue;

      circles.add(
        CircleMarker(
          point: LatLng(
            event.address.location.latitude,
            event.address.location.longitude,
          ),
          radius: _radius(pulse),
          useRadiusInMeter: true,
          color: _color(pulse),
          borderStrokeWidth: 0,
        ),
      );
    }

    return circles;
  }

  static Color _color(int pulse) {
    if (pulse > 100) {
      return Colors.red.withOpacity(.45);
    }

    if (pulse > 50) {
      return Colors.deepOrange.withOpacity(.38);
    }

    if (pulse > 10) {
      return Colors.orange.withOpacity(.32);
    }

    if (pulse > 3) {
      return Colors.green.withOpacity(.28);
    }

    return Colors.greenAccent.withOpacity(.22);
  }

  static double _radius(int pulse) {
    if (pulse > 100) return 350;
    if (pulse > 50) return 250;
    if (pulse > 10) return 180;
    if (pulse > 3) return 120;

    return 80;
  }
}