// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_details_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventDetailsViewModel on _EventDetailsViewModelBase, Store {
  late final _$loadingAtom = Atom(
    name: '_EventDetailsViewModelBase.loading',
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
    name: '_EventDetailsViewModelBase.error',
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

  late final _$eventAtom = Atom(
    name: '_EventDetailsViewModelBase.event',
    context: context,
  );

  @override
  EventEntity? get event {
    _$eventAtom.reportRead();
    return super.event;
  }

  @override
  set event(EventEntity? value) {
    _$eventAtom.reportWrite(value, super.event, () {
      super.event = value;
    });
  }

  late final _$placeAtom = Atom(
    name: '_EventDetailsViewModelBase.place',
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
    '_EventDetailsViewModelBase.load',
    context: context,
  );

  @override
  Future<void> load(String id) {
    return _$loadAsyncAction.run(() => super.load(id));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
event: ${event},
place: ${place}
    ''';
  }
}
