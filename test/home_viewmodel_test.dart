import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/errors/event_errors.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/errors/place_errors.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _Places implements IPlaceRepository {
  int requests = 0;
  Completer<Either<FailureGetPlaces, List<PlaceEntity>>>? pending;
  bool fail = false;
  @override
  Future<Either<FailureGetPlaces, List<PlaceEntity>>> getPlaces() {
    requests++;
    return pending?.future ??
        Future.value(
          fail
              ? Left(FailureGetPlaces(message: 'Falha dos locais'))
              : const Right([]),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Events implements IEventRepository {
  int requests = 0, subscriptions = 0;
  bool fail = false;
  @override
  Future<Either<FailureGetEvents, List<EventEntity>>> getEvents({
    String? userId,
  }) async {
    requests++;
    return fail
        ? Left(FailureGetEvents(message: 'Falha dos eventos'))
        : const Right([]);
  }

  @override
  Stream<Either<FailureGetEvents, List<EventEntity>>> watchEvents({
    String? userId,
  }) {
    subscriptions++;
    return Stream.value(const Right([]));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Location implements ILocationRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('public data refreshes each minute and stops on dispose', (
    tester,
  ) async {
    final places = _Places(), events = _Events();
    final vm = HomeViewModel(_Location(), places, events);
    await vm.load();
    expect(places.requests, 1);
    expect(events.requests, 1);
    await tester.pump(const Duration(minutes: 1));
    expect(places.requests, 2);
    expect(events.requests, 2);
    expect(events.subscriptions, 2);
    vm.dispose();
    await tester.pump(const Duration(minutes: 2));
    expect(places.requests, 2);
    expect(events.subscriptions, 2);
  });
  testWidgets('leaving during load cannot restart background subscriptions', (
    tester,
  ) async {
    final places = _Places()..pending = Completer();
    final events = _Events();
    final vm = HomeViewModel(_Location(), places, events);
    final loading = vm.load();
    vm.dispose();
    places.pending!.complete(const Right([]));
    await loading;
    await tester.pump(const Duration(minutes: 2));
    expect(events.requests, 0);
    expect(events.subscriptions, 0);
    expect(places.requests, 1);
  });
  testWidgets('event success does not hide a place query failure', (
    tester,
  ) async {
    final places = _Places()..fail = true;
    final vm = HomeViewModel(_Location(), places, _Events());
    await vm.load();
    await tester.pump();
    expect(vm.error, 'Falha dos locais');
    places.fail = false;
    await vm.load();
    await tester.pump();
    expect(vm.error, isNull);
    vm.dispose();
  });
  testWidgets('initial event query failures are reported', (tester) async {
    final vm = HomeViewModel(_Location(), _Places(), _Events()..fail = true);
    await vm.load();
    expect(vm.error, 'Falha dos eventos');
    vm.dispose();
  });
}
