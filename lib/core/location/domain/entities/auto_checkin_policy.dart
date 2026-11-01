class AutoCheckinPlace {
  const AutoCheckinPlace({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.minimumStay,
  });

  final String id;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final Duration minimumStay;
}

class AutoCheckinDecision {
  const AutoCheckinDecision({
    required this.checkInPlaceIds,
    required this.checkOutPlaceIds,
  });

  final List<String> checkInPlaceIds;
  final List<String> checkOutPlaceIds;
}

class AutoCheckinPolicy {
  AutoCheckinPolicy({
    this.exitTolerance = 1.5,
    this.cooldown = const Duration(minutes: 30),
    this.maximumAcceptedAccuracyMeters = 50,
  });

  final double exitTolerance;
  final Duration cooldown;
  final double maximumAcceptedAccuracyMeters;
  final Map<String, DateTime> _enteredAt = {};
  final Map<String, DateTime> _outsideSince = {};
  final Map<String, DateTime> _lastTransitionAt = {};
  final Set<String> _active = {};

  AutoCheckinDecision evaluate({
    required DateTime now,
    required double accuracyMeters,
    required Map<String, double> distancesMeters,
    required List<AutoCheckinPlace> places,
  }) {
    final checkIns = <String>[];
    final checkOuts = <String>[];
    if (!accuracyMeters.isFinite ||
        accuracyMeters <= 0 ||
        accuracyMeters > maximumAcceptedAccuracyMeters) {
      return AutoCheckinDecision(
        checkInPlaceIds: checkIns,
        checkOutPlaceIds: checkOuts,
      );
    }
    final inactiveByDistance =
        places
            .where(
              (place) =>
                  !_active.contains(place.id) &&
                  distancesMeters[place.id]?.isFinite == true,
            )
            .toList()
          ..sort(
            (a, b) => distancesMeters[a.id]!.compareTo(distancesMeters[b.id]!),
          );
    final nearestInactiveId = inactiveByDistance.isEmpty
        ? null
        : inactiveByDistance.first.id;
    for (final place in places) {
      final distance = distancesMeters[place.id];
      if (distance == null || !distance.isFinite) continue;
      final inRadius = distance + accuracyMeters <= place.radiusMeters;
      if (!_active.contains(place.id)) {
        if (place.id != nearestInactiveId) {
          _enteredAt.remove(place.id);
          continue;
        }
        if (!inRadius) {
          _enteredAt.remove(place.id);
          continue;
        }
        final entered = _enteredAt.putIfAbsent(place.id, () => now);
        final last = _lastTransitionAt[place.id];
        if (now.difference(entered) >= place.minimumStay &&
            (last == null || now.difference(last) >= cooldown)) {
          _active.add(place.id);
          _lastTransitionAt[place.id] = now;
          _outsideSince.remove(place.id);
          checkIns.add(place.id);
        }
      } else {
        final clearlyOutside =
            distance - accuracyMeters > place.radiusMeters * exitTolerance;
        if (!clearlyOutside) {
          _outsideSince.remove(place.id);
          continue;
        }
        final outside = _outsideSince.putIfAbsent(place.id, () => now);
        if (now.difference(outside) >= place.minimumStay) {
          _active.remove(place.id);
          _enteredAt.remove(place.id);
          _lastTransitionAt[place.id] = now;
          checkOuts.add(place.id);
        }
      }
    }
    return AutoCheckinDecision(
      checkInPlaceIds: checkIns,
      checkOutPlaceIds: checkOuts,
    );
  }

  void reset() {
    _enteredAt.clear();
    _outsideSince.clear();
    _lastTransitionAt.clear();
    _active.clear();
  }
}
