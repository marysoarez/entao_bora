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
    _loading = true;
    _error = null;

    try {
      await _loadPlaces();
      await _loadEvents();
      _watchEvents();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
    }
  }

  Future<void> _loadPlaces() async {
    final placesResult = await _placeRepository.getPlaces();

    placesResult.fold(
      (failure) {
        _error = failure.message;
      },
      (places) {
        _places = places;
      },
    );
  }

  Future<void> _loadEvents() async {
    final eventsResult = await _eventRepository.getEvents();

    eventsResult.fold((failure) {}, (events) {
      _events = events;
    });
  }

  void _watchEvents() {
    _eventsSubscription?.cancel();

    _eventsSubscription = _eventRepository.watchEvents().listen(
      (result) {
        result.fold(
          (failure) {
            runInAction(() {
              _error = failure.message;
            });
          },
          (events) {
            runInAction(() {
              _events = events;
              _error = null;
            });
          },
        );
      },
      onError: (Object error) {
        runInAction(() {
          _error = error.toString();
        });
      },
    );
  }

  @action
  Future<void> reloadPlaces() async {
    _error = null;

    try {
      await _loadPlaces();
      await _loadEvents();
      _watchEvents();
    } catch (e) {
      _error = e.toString();
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
    _eventsSubscription?.cancel();
    _eventsSubscription = null;
  }
}
