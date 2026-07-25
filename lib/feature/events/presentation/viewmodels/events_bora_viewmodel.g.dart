// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_bora_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventActionsViewModel on EventActionsViewModelBase, Store {
  Computed<bool>? _$isLoggedComputed;

  @override
  bool get isLogged => (_$isLoggedComputed ??= Computed<bool>(
    () => super.isLogged,
    name: 'EventActionsViewModelBase.isLogged',
  )).value;
  Computed<bool>? _$canCheckInComputed;

  @override
  bool get canCheckIn => (_$canCheckInComputed ??= Computed<bool>(
    () => super.canCheckIn,
    name: 'EventActionsViewModelBase.canCheckIn',
  )).value;

  late final _$eventAtom = Atom(
    name: 'EventActionsViewModelBase.event',
    context: context,
  );

  @override
  EventEntity get event {
    _$eventAtom.reportRead();
    return super.event;
  }

  @override
  set event(EventEntity value) {
    _$eventAtom.reportWrite(value, super.event, () {
      super.event = value;
    });
  }

  late final _$loadingAtom = Atom(
    name: 'EventActionsViewModelBase.loading',
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
    name: 'EventActionsViewModelBase.error',
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

  late final _$toggleBoraAsyncAction = AsyncAction(
    'EventActionsViewModelBase.toggleBora',
    context: context,
  );

  @override
  Future<void> toggleBora() {
    return _$toggleBoraAsyncAction.run(() => super.toggleBora());
  }

  late final _$checkInAsyncAction = AsyncAction(
    'EventActionsViewModelBase.checkIn',
    context: context,
  );

  @override
  Future<CheckInResult?> checkIn() {
    return _$checkInAsyncAction.run(() => super.checkIn());
  }

  @override
  String toString() {
    return '''
event: ${event},
loading: ${loading},
error: ${error},
isLogged: ${isLogged},
canCheckIn: ${canCheckIn}
    ''';
  }
}
