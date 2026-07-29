import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/location/domain/entities/location_entity.dart';
import '../../../../core/location/domain/repositories/location_repository.dart';

part 'home_viewmodel.g.dart';

class HomeViewModel = HomeViewModelBase with _$HomeViewModel;

abstract class HomeViewModelBase with Store {
  HomeViewModelBase(
    this._locationRepository,
    this._placeRepository,
    this._eventRepository,
  );

  final IEventRepository _eventRepository;
  final ILocationRepository _locationRepository;
  final IPlaceRepository _placeRepository;

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

  @action
  Future<void> load() async {
    _loading = true;
    _error = null;

    final locationResult = await _locationRepository.getCurrentLocation();

    locationResult.fold(
      (failure) {
        _error = failure.message;
      },
      (location) {
        _currentLocation = location;
      },
    );

    if (_error != null) {
      _loading = false;
      return;
    }

    final placesResult = await _placeRepository.getPlaces();

    placesResult.fold(
      (failure) {
        _error = failure.message;
      },
      (places) {
        _places = places;
      },
    );
    final eventsResult = await _eventRepository.getEvents();

    eventsResult.fold(
      (failure) {
        _error = failure.message;
      },
      (events) {
        _events = events;
      },
    );
    print('HomeViewModel -> ${_events.length} eventos');
    _loading = false;
  }

  @action
  Future<void> reloadPlaces() async {
    final placesResult = await _placeRepository.getPlaces();

    placesResult.fold(
      (failure) {
        _error = failure.message;
      },
      (places) {
        _places = places;
      },
    );

    final eventsResult = await _eventRepository.getEvents();

    eventsResult.fold(
      (failure) {
        _error = failure.message;
      },
      (events) {
        _events = events;
      },
    );
  }
}
