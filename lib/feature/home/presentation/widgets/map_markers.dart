// ignore_for_file: use_build_context_synchronously

import 'dart:ui' as ui;

import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/presentation/pages/place_botton_sheet.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

class MapMarkers {
  const MapMarkers._();

  static Future<List<google.Marker>> build({
    required BuildContext context,
    required List<PlaceEntity> places,
    required List<EventEntity> events,
    required Map<String, UserSummaryEntity> owners,
  }) async {
    final itemsByPosition = <String, List<_MapMarkerItem>>{};

    for (final place in places) {
      final owner = owners[place.ownerId.id];
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

      final item = _MapMarkerItem.place(place);
      itemsByPosition.putIfAbsent(item.positionKey, () => []).add(item);
    }

    for (final event in events.where((event) => event.placeId == null)) {
      final item = _MapMarkerItem.event(event);
      itemsByPosition.putIfAbsent(item.positionKey, () => []).add(item);
    }

    final markers = <google.Marker>[];

    for (final entry in itemsByPosition.entries) {
      final items = entry.value;
      final first = items.first;

      if (items.length == 1) {
        markers.add(first.toMarker(context));
        continue;
      }

      markers.add(
        google.Marker(
          markerId: google.MarkerId('group_${entry.key}'),
          position: first.position,
          icon: await _buildGroupIcon(items.length),
          onTap: () => _showGroupedItemsSheet(context, items),
        ),
      );
    }

    return markers;
  }

  static Future<google.BitmapDescriptor> _buildGroupIcon(int count) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(48, 58);
    const center = Offset(24, 22);

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: .22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final markerPaint = Paint()..color = const Color(0xFFFFC107);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: 17))
      ..moveTo(24, 54)
      ..lineTo(14.5, 35)
      ..lineTo(33.5, 35)
      ..close();

    canvas.drawPath(path.shift(const Offset(0, 1.5)), shadowPaint);
    canvas.drawPath(path, markerPaint);
    canvas.drawPath(path, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 34);

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    final image = await recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return google.BitmapDescriptor.bytes(
      byteData!.buffer.asUint8List(),
      imagePixelRatio: 1,
    );
  }

  static void _showGroupedItemsSheet(
    BuildContext context,
    List<_MapMarkerItem> items,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                leading: Icon(item.icon),
                title: Text(item.title),
                subtitle: Text(item.subtitle),
                onTap: () {
                  Navigator.pop(context);
                  item.open(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _MapMarkerItem {
  const _MapMarkerItem._({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.position,
    required this.icon,
    required this.open,
    required this.markerHue,
  });

  factory _MapMarkerItem.place(PlaceEntity place) {
    return _MapMarkerItem._(
      id: 'place_${place.id}',
      title: place.name,
      subtitle: place.address.fullAddress,
      position: google.LatLng(
        place.address.location.latitude,
        place.address.location.longitude,
      ),
      icon: Icons.storefront,
      markerHue: google.BitmapDescriptor.hueRed,
      open: (context) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => PlaceDetailsSheet(place: place),
        );
      },
    );
  }

  factory _MapMarkerItem.event(EventEntity event) {
    return _MapMarkerItem._(
      id: 'event_${event.id}',
      title: event.title,
      subtitle: event.address.fullAddress,
      position: google.LatLng(
        event.address.location.latitude,
        event.address.location.longitude,
      ),
      icon: Icons.event,
      markerHue: google.BitmapDescriptor.hueBlue,
      open: (_) {
        Modular.to.pushNamed('/events/${event.id}');
      },
    );
  }

  final String id;
  final String title;
  final String subtitle;
  final google.LatLng position;
  final IconData icon;
  final void Function(BuildContext context) open;
  final double markerHue;

  String get positionKey {
    final latitude = position.latitude.toStringAsFixed(6);
    final longitude = position.longitude.toStringAsFixed(6);

    return '${latitude}_$longitude';
  }

  google.Marker toMarker(BuildContext context) {
    return google.Marker(
      markerId: google.MarkerId(id),
      position: position,
      icon: google.BitmapDescriptor.defaultMarkerWithHue(markerHue),
      onTap: () => open(context),
    );
  }
}
