import 'dart:ui' as ui;

import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/home/presentation/widgets/halloween_pin.dart';
import 'package:entao_bora/feature/home/presentation/widgets/map_heat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'home_explore_test.dart' as fixtures;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'SDK bitmap pipeline encodes heat and density-aware pumpkin pins',
    () async {
      final provider = BoraTileProvider([const BoraHeatPoint(0, 0, 10)], 0);
      final tile = await provider.getTile(0, 0, 0);
      final codec = await ui.instantiateImageCodec(tile.data!);
      final frame = await codec.getNextFrame();
      expect(frame.image.width, 256);
      final bytes = (await frame.image.toByteData(
        format: ui.ImageByteFormat.rawStraightRgba,
      ))!;
      final center = (128 * 256 + 128) * 4;
      expect(bytes.getUint8(center), 0);
      expect(bytes.getUint8(center + 1), closeTo(210, 2));
      expect(bytes.getUint8(center + 3), inInclusiveRange(175, 190));
      frame.image.dispose();
      codec.dispose();
      for (final density in [1.0, 2.0, 3.0]) {
        final pin = await halloweenPin(2, density) as google.BytesMapBitmap;
        final pinCodec = await ui.instantiateImageCodec(pin.byteData);
        final image = (await pinCodec.getNextFrame()).image;
        expect(image.width, (42 * density).toInt());
        expect(image.height, (48 * density).toInt());
        expect(pin.width, 42);
        expect(pin.height, 48);
        image.dispose();
        pinCodec.dispose();
      }
    },
  );
  test(
    'aggregates linked and independent Boras, ignores check-ins and invalid points',
    () {
      final points = aggregateBoraHeat([
        fixtures
            .event('linked', placeId: 'p')
            .copyWith(boraCount: 8, checkinCount: 90),
        fixtures.event('independent').copyWith(boraCount: 2),
        fixtures.event('zero').copyWith(checkinCount: 200),
        fixtures.event('negative').copyWith(boraCount: -1),
        for (final location in [
          const LocationEntity(latitude: double.nan, longitude: 0),
          const LocationEntity(latitude: 91, longitude: 0),
          const LocationEntity(latitude: 0, longitude: double.infinity),
          const LocationEntity(latitude: 0, longitude: 181),
        ])
          fixtures
              .event('invalid')
              .copyWith(
                boraCount: 10,
                address: fixtures.address.copyWith(location: location),
              ),
        fixtures
            .event('nearby')
            .copyWith(
              boraCount: 1,
              address: fixtures.address.copyWith(
                location: const LocationEntity(
                  latitude: -22.910001,
                  longitude: -43.18,
                ),
              ),
            ),
      ]);
      expect(points.map((p) => p.count), [10, 1]);
      expect(boraHeatBand(points.first.count), 1);
    },
  );

  test('all band boundaries preserve RGB and the alpha formula', () {
    for (final entry in {
      1: 0,
      9: 0,
      10: 1,
      49: 1,
      50: 2,
      99: 2,
      100: 3,
    }.entries) {
      final rgba = rasterBoraHeat(11, 11, [
        (x: 5.0, y: 5.0, count: entry.key),
      ], radius: 4);
      final rgb = boraHeatColors[entry.value].toARGB32() & 0xffffff;
      int pixelRgb(int x) {
        final i = (5 * 11 + x) * 4;
        return rgba[i] << 16 | rgba[i + 1] << 8 | rgba[i + 2];
      }

      expect(pixelRgb(5), rgb);
      expect(pixelRgb(7), rgb);
      expect(rgba[(5 * 11 + 5) * 4 + 3], 190);
      expect(rgba[(5 * 11 + 7) * 4 + 3], 107);
      expect(rgba[(5 * 11 + 9) * 4 + 3], 0);
    }
  });

  test('overlap selects nearest strength, never mixes or favors red', () {
    final rgba = rasterBoraHeat(12, 12, [
      (x: 4.0, y: 5.0, count: 100),
      (x: 6.0, y: 5.0, count: 1),
    ], radius: 4);
    expect(rgba.sublist((5 * 12 + 6) * 4, (5 * 12 + 6) * 4 + 4), [
      37,
      99,
      235,
      190,
    ]);
    expect(rgba.sublist((5 * 12 + 5) * 4, (5 * 12 + 5) * 4 + 3), [239, 45, 35]);
  });
}
