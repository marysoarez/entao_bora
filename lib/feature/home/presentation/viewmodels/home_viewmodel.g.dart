// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeViewModel on HomeViewModelBase, Store {
  late final _$_loadingAtom = Atom(
    name: 'HomeViewModelBase._loading',
    context: context,
  );

  bool get loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  bool get _loading => loading;

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_currentLocationAtom = Atom(
    name: 'HomeViewModelBase._currentLocation',
    context: context,
  );

  LocationEntity? get currentLocation {
    _$_currentLocationAtom.reportRead();
    return super._currentLocation;
  }

  @override
  LocationEntity? get _currentLocation => currentLocation;

  @override
  set _currentLocation(LocationEntity? value) {
    _$_currentLocationAtom.reportWrite(value, super._currentLocation, () {
      super._currentLocation = value;
    });
  }

  late final _$_placesAtom = Atom(
    name: 'HomeViewModelBase._places',
    context: context,
  );

  List<PlaceEntity> get places {
    _$_placesAtom.reportRead();
    return super._places;
  }

  @override
  List<PlaceEntity> get _places => places;

  @override
  set _places(List<PlaceEntity> value) {
    _$_placesAtom.reportWrite(value, super._places, () {
      super._places = value;
    });
  }

  late final _$_errorAtom = Atom(
    name: 'HomeViewModelBase._error',
    context: context,
  );

  String? get error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  String? get _error => error;

  @override
  set _error(String? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'HomeViewModelBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$reloadPlacesAsyncAction = AsyncAction(
    'HomeViewModelBase.reloadPlaces',
    context: context,
  );

  @override
  Future<void> reloadPlaces() {
    return _$reloadPlacesAsyncAction.run(() => super.reloadPlaces());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
