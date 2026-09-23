import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

const boraHeatColors = [
  Color(0xFF2563EB),
  Color(0xFF00D2D2),
  Color(0xFFFFDC00),
  Color(0xFFEF2D23),
];
const boraHeatLabels = ['1–9', '10–49', '50–99', '100+'];

int boraHeatBand(num count) => count >= 100
    ? 3
    : count >= 50
    ? 2
    : count >= 10
    ? 1
    : 0;

class BoraHeatPoint {
  const BoraHeatPoint(this.latitude, this.longitude, this.count);
  final double latitude, longitude;
  final int count;
}

List<BoraHeatPoint> aggregateBoraHeat(Iterable<EventEntity> events) {
  final sums = <(double, double), int>{};
  for (final event in events) {
    final p = event.address.location;
    if (!p.latitude.isFinite ||
        !p.longitude.isFinite ||
        p.latitude.abs() > 90 ||
        p.longitude.abs() > 180 ||
        event.boraCount <= 0) {
      continue;
    }
    final key = (p.latitude, p.longitude);
    sums[key] = (sums[key] ?? 0) + event.boraCount;
  }
  return [
    for (final e in sums.entries) BoraHeatPoint(e.key.$1, e.key.$2, e.value),
  ];
}

/// Straight-alpha RGBA, with Float32 strengths as in the web reference.
Uint8List rasterBoraHeat(
  int width,
  int height,
  Iterable<({double x, double y, int count})> points, {
  double radius = 6.25,
}) {
  final pixels = Uint8List(width * height * 4);
  final strengths = Float32List(width * height);
  for (final p in points) {
    final color = boraHeatColors[boraHeatBand(p.count)].toARGB32();
    for (
      var y = math.max(0, (p.y - radius).floor());
      y < math.min(height, p.y + radius);
      y++
    ) {
      for (
        var x = math.max(0, (p.x - radius).floor());
        x < math.min(width, p.x + radius);
        x++
      ) {
        final d2 =
            ((x - p.x) * (x - p.x) + (y - p.y) * (y - p.y)) / (radius * radius);
        if (d2 >= 1) continue;
        final strength = (1 - d2) * (1 - d2);
        final index = y * width + x;
        if (strength <= strengths[index]) continue;
        strengths[index] = strength;
        pixels[index * 4] = (color >> 16) & 255;
        pixels[index * 4 + 1] = (color >> 8) & 255;
        pixels[index * 4 + 2] = color & 255;
        pixels[index * 4 + 3] = (190 * strength).round();
      }
    }
  }
  return pixels;
}

/// SDK tiles remain below native markers and move with the map without gestures
/// or asynchronous screen-coordinate callbacks. Bearing/tilt are disabled by the
/// host to keep the screen-space radius circular.
class BoraTileProvider implements google.TileProvider {
  BoraTileProvider(this.points, this.cameraZoom);
  final List<BoraHeatPoint> points;
  final double cameraZoom;

  @override
  Future<google.Tile> getTile(int x, int y, int? zoom) async {
    if (zoom == null || points.isEmpty) return google.TileProvider.noTile;
    final world = 256.0 * math.pow(2, zoom);
    final radius = 25 * math.pow(2, zoom - cameraZoom) / 4;
    // One buffer pixel of padding allows smooth interpolation across tile edges.
    final projected = <({double x, double y, int count})>[];
    for (final p in points) {
      final sinLat = math.sin(
        p.latitude.clamp(-85.05112878, 85.05112878) * math.pi / 180,
      );
      final py =
          (.5 - math.log((1 + sinLat) / (1 - sinLat)) / (4 * math.pi)) * world;
      final px = (p.longitude + 180) / 360 * world;
      for (final wrap in [-world, 0.0, world]) {
        final tx = (px + wrap - x * 256) / 4 + 1;
        final ty = (py - y * 256) / 4 + 1;
        if (tx + radius >= 0 &&
            tx - radius < 66 &&
            ty + radius >= 0 &&
            ty - radius < 66) {
          projected.add((x: tx, y: ty, count: p.count));
        }
      }
    }
    if (projected.isEmpty) return google.TileProvider.noTile;
    final rgba = rasterBoraHeat(66, 66, projected, radius: radius);
    // decodeImageFromPixels expects premultiplied RGBA.
    for (var i = 0; i < rgba.length; i += 4) {
      for (var c = 0; c < 3; c++) {
        rgba[i + c] = (rgba[i + c] * rgba[i + 3] / 255).round();
      }
    }
    final decoded = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      rgba,
      66,
      66,
      ui.PixelFormat.rgba8888,
      decoded.complete,
    );
    final source = await decoded.future;
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawImageRect(
      source,
      const Rect.fromLTWH(1, 1, 64, 64),
      const Rect.fromLTWH(0, 0, 256, 256),
      Paint()..filterQuality = FilterQuality.low,
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(256, 256);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    source.dispose();
    picture.dispose();
    image.dispose();
    return google.Tile(256, 256, bytes?.buffer.asUint8List());
  }
}

class BoraHeatLegend extends StatelessWidget {
  const BoraHeatLegend({super.key, required this.hasHeat});
  final bool hasHeat;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xE8101010),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 11, color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Calor de Boras',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (!hasHeat)
              const Text('Sem Boras nos eventos filtrados')
            else
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  for (var i = 0; i < 4; i++)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 30,
                          height: 7,
                          decoration: BoxDecoration(
                            color: boraHeatColors[i],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(boraHeatLabels[i]),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}
