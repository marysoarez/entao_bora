// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_details_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaceDetailsViewModel on PlaceDetailsViewModelBase, Store {
  late final _$loadingAtom = Atom(
    name: 'PlaceDetailsViewModelBase.loading',
    context: context,
  );

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$errorAtom = Atom(
    name: 'PlaceDetailsViewModelBase.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$placeAtom = Atom(
    name: 'PlaceDetailsViewModelBase.place',
    context: context,
  );

  @override
  PlaceEntity? get place {
    _$placeAtom.reportRead();
    return super.place;
  }

  @override
  set place(PlaceEntity? value) {
    _$placeAtom.reportWrite(value, super.place, () {
      super.place = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'PlaceDetailsViewModelBase.load',
    context: context,
  );

  @override
  Future<void> load(String id) {
    return _$loadAsyncAction.run(() => super.load(id));
  }

  late final _$reloadAsyncAction = AsyncAction(
    'PlaceDetailsViewModelBase.reload',
    context: context,
  );

  @override
  Future<void> reload() {
    return _$reloadAsyncAction.run(() => super.reload());
  }

  late final _$PlaceDetailsViewModelBaseActionController = ActionController(
    name: 'PlaceDetailsViewModelBase',
    context: context,
  );

  @override
  void setPlace(PlaceEntity selectedPlace) {
    final _$actionInfo = _$PlaceDetailsViewModelBaseActionController
        .startAction(name: 'PlaceDetailsViewModelBase.setPlace');
    try {
      return super.setPlace(selectedPlace);
    } finally {
      _$PlaceDetailsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
place: ${place}
    ''';
  }
}
