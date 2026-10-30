import 'package:entao_bora/core/location/domain/entities/auto_checkin_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const place = AutoCheckinPlace(
    id: 'one',
    latitude: 0,
    longitude: 0,
    radiusMeters: 100,
    minimumStay: Duration(minutes: 5),
  );
  late AutoCheckinPolicy policy;
  late DateTime start;

  setUp(() {
    policy = AutoCheckinPolicy(cooldown: const Duration(minutes: 30));
    start = DateTime.utc(2026);
  });

  test('does not check in on entry and requires continuous minimum stay', () {
    expect(
      policy
          .evaluate(
            now: start,
            accuracyMeters: 10,
            distancesMeters: const {'one': 40},
            places: const [place],
          )
          .checkInPlaceIds,
      isEmpty,
    );
    expect(
      policy
          .evaluate(
            now: start.add(const Duration(minutes: 4)),
            accuracyMeters: 10,
            distancesMeters: const {'one': 40},
            places: const [place],
          )
          .checkInPlaceIds,
      isEmpty,
    );
    expect(
      policy
          .evaluate(
            now: start.add(const Duration(minutes: 5)),
            accuracyMeters: 10,
            distancesMeters: const {'one': 40},
            places: const [place],
          )
          .checkInPlaceIds,
      ['one'],
    );
  });

  test('rejects inaccurate readings and resets a drive-by candidate', () {
    policy.evaluate(
      now: start,
      accuracyMeters: 80,
      distancesMeters: const {'one': 10},
      places: const [place],
    );
    policy.evaluate(
      now: start.add(const Duration(minutes: 1)),
      accuracyMeters: 10,
      distancesMeters: const {'one': 20},
      places: const [place],
    );
    policy.evaluate(
      now: start.add(const Duration(minutes: 2)),
      accuracyMeters: 10,
      distancesMeters: const {'one': 500},
      places: const [place],
    );
    expect(
      policy
          .evaluate(
            now: start.add(const Duration(minutes: 6)),
            accuracyMeters: 10,
            distancesMeters: const {'one': 20},
            places: const [place],
          )
          .checkInPlaceIds,
      isEmpty,
    );
  });

  test('uses exit tolerance and dwell time to prevent GPS flapping', () {
    policy.evaluate(
      now: start,
      accuracyMeters: 10,
      distancesMeters: const {'one': 20},
      places: const [place],
    );
    policy.evaluate(
      now: start.add(const Duration(minutes: 5)),
      accuracyMeters: 10,
      distancesMeters: const {'one': 20},
      places: const [place],
    );
    expect(
      policy
          .evaluate(
            now: start.add(const Duration(minutes: 6)),
            accuracyMeters: 10,
            distancesMeters: const {'one': 130},
            places: const [place],
          )
          .checkOutPlaceIds,
      isEmpty,
    );
    expect(
      policy
          .evaluate(
            now: start.add(const Duration(minutes: 7)),
            accuracyMeters: 10,
            distancesMeters: const {'one': 200},
            places: const [place],
          )
          .checkOutPlaceIds,
      isEmpty,
    );
    expect(
      policy
          .evaluate(
            now: start.add(const Duration(minutes: 12)),
            accuracyMeters: 10,
            distancesMeters: const {'one': 200},
            places: const [place],
          )
          .checkOutPlaceIds,
      ['one'],
    );
  });

  test('selects only the closest place when regions overlap', () {
    const second = AutoCheckinPlace(
      id: 'two',
      latitude: 0,
      longitude: 0,
      radiusMeters: 100,
      minimumStay: Duration(minutes: 5),
    );
    policy.evaluate(
      now: start,
      accuracyMeters: 10,
      distancesMeters: const {'one': 40, 'two': 20},
      places: const [place, second],
    );
    final decision = policy.evaluate(
      now: start.add(const Duration(minutes: 5)),
      accuracyMeters: 10,
      distancesMeters: const {'one': 40, 'two': 20},
      places: const [place, second],
    );
    expect(decision.checkInPlaceIds, ['two']);
  });
}
