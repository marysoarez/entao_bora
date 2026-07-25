// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_events_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaceEventsViewModel on PlaceEventsViewModelBase, Store {
  late final _$loadingAtom = Atom(
    name: 'PlaceEventsViewModelBase.loading',
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
    name: 'PlaceEventsViewModelBase.error',
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

  late final _$eventsAtom = Atom(
    name: 'PlaceEventsViewModelBase.events',
    context: context,
  );

  @override
  ObservableList<EventEntity> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(ObservableList<EventEntity> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'PlaceEventsViewModelBase.load',
    context: context,
  );

  @override
  Future<void> load(String placeId) {
    return _$loadAsyncAction.run(() => super.load(placeId));
  }

  late final _$PlaceEventsViewModelBaseActionController = ActionController(
    name: 'PlaceEventsViewModelBase',
    context: context,
  );

  @override
  Future<void> reload(String placeId) {
    final _$actionInfo = _$PlaceEventsViewModelBaseActionController.startAction(
      name: 'PlaceEventsViewModelBase.reload',
    );
    try {
      return super.reload(placeId);
    } finally {
      _$PlaceEventsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
events: ${events}
    ''';
  }
}
