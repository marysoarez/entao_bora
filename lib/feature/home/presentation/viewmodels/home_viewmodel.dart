import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/errors/event_errors.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:mobx/mobx.dart';

part 'home_viewmodel.g.dart';

class HomeViewModel = HomeViewModelBase with _$HomeViewModel;

abstract class HomeViewModelBase with Store {
  HomeViewModelBase(
    this._locationRepository,
    this._placeRepository,
    this._eventRepository,
  );

  final ILocationRepository _locationRepository;
  final IPlaceRepository _placeRepository;
  final IEventRepository _eventRepository;
  StreamSubscription<Either<FailureGetEvents, List<EventEntity>>>?
  _eventsSubscription;
  Timer? _refreshTimer;
  int _generation = 0;
  bool _refreshing = false;

  @readonly
  bool _loading = false;

  @readonly
  LocationEntity? _currentLocation;

  @readonly
  List<PlaceEntity> _places = [];

  @readonly
  List<EventEntity> _events = [];

  @readonly
  String? _error;

  bool get locationEnabled => _currentLocation != null;

  @action
  Future<void> load() async {
    final generation = ++_generation;
    _refreshTimer?.cancel();
    _eventsSubscription?.cancel();
    _refreshing = false;
    _loading = true;
    _error = null;

    try {
      await _loadPlaces(generation);
      if (generation != _generation) return;
      await _loadEvents(generation);
      if (generation != _generation) return;
      _watchEvents();
      _refreshTimer?.cancel();
      _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        reloadPlaces();
      });
    } catch (e) {
      if (generation == _generation) _error = e.toString();
    } finally {
      if (generation == _generation) _loading = false;
    }
  }

  Future<void> _loadPlaces(int generation) async {
    final placesResult = await _placeRepository.getPlaces();
    if (generation != _generation) return;

    placesResult.fold(
      (failure) {
        _error = failure.message;
      },
      (places) {
        _places = places;
      },
    );
  }

  Future<void> _loadEvents(int generation) async {
    final eventsResult = await _eventRepository.getEvents();
    if (generation != _generation) return;

    eventsResult.fold(
      (failure) {
        _error = failure.message;
      },
      (events) {
        _events = events;
      },
    );
  }

  void _watchEvents() {
    final generation = _generation;
    _eventsSubscription?.cancel();

    _eventsSubscription = _eventRepository.watchEvents().listen(
      (result) {
        if (generation != _generation) return;
        result.fold(
          (failure) {
            runInAction(() {
              _error = failure.message;
            });
          },
          (events) {
            runInAction(() {
              _events = events;
            });
          },
        );
      },
      onError: (Object error) {
        if (generation != _generation) return;
        runInAction(() {
          _error = error.toString();
        });
      },
    );
  }

  @action
  Future<void> reloadPlaces() async {
    if (_refreshing) return;
    final generation = _generation;
    _refreshing = true;
    _error = null;

    try {
      await _loadPlaces(generation);
      if (generation != _generation) return;
      await _loadEvents(generation);
      if (generation != _generation) return;
      _watchEvents();
    } catch (e) {
      if (generation == _generation) _error = e.toString();
    } finally {
      if (generation == _generation) _refreshing = false;
    }
  }

  @action
  Future<bool> enableLocation() async {
    final result = await _locationRepository.getCurrentLocation();

    return result.fold(
      (failure) {
        _error = failure.message;
        return false;
      },
      (location) {
        _currentLocation = location;
        _error = null;
        return true;
      },
    );
  }

  @action
  void disableLocation() {
    _currentLocation = null;
  }

  void dispose() {
    _generation++;
    _refreshing = false;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _eventsSubscription?.cancel();
    _eventsSubscription = null;
  }
}
