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
  );

  final ILocationRepository _locationRepository;
  final IPlaceRepository _placeRepository;

  @readonly
  bool _loading = false;

  @readonly
  LocationEntity? _currentLocation;

  @readonly
  List<PlaceEntity> _places = [];

  @readonly
  String? _error;

  @action
  Future<void> load() async {
    _loading = true;
    _error = null;

    final locationResult =
        await _locationRepository.getCurrentLocation();

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

    _loading = false;
  }

  @action
  Future<void> reloadPlaces() async {
    final result = await _placeRepository.getPlaces();

    result.fold(
      (failure) {
        _error = failure.message;
      },
      (places) {
        _places = places;
      },
    );
  }
}