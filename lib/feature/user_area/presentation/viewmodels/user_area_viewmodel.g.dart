// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_area_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserAreaViewModel on UserAreaViewModelBase, Store {
  Computed<bool>? _$isLoggedComputed;

  @override
  bool get isLogged => (_$isLoggedComputed ??= Computed<bool>(
    () => super.isLogged,
    name: 'UserAreaViewModelBase.isLogged',
  )).value;
  Computed<bool>? _$locationEnabledComputed;

  @override
  bool get locationEnabled => (_$locationEnabledComputed ??= Computed<bool>(
    () => super.locationEnabled,
    name: 'UserAreaViewModelBase.locationEnabled',
  )).value;
  Computed<int>? _$totalPersonalActionsComputed;

  @override
  int get totalPersonalActions =>
      (_$totalPersonalActionsComputed ??= Computed<int>(
        () => super.totalPersonalActions,
        name: 'UserAreaViewModelBase.totalPersonalActions',
      )).value;
  Computed<List<EventEntity>>? _$recentActivityComputed;

  @override
  List<EventEntity> get recentActivity =>
      (_$recentActivityComputed ??= Computed<List<EventEntity>>(
        () => super.recentActivity,
        name: 'UserAreaViewModelBase.recentActivity',
      )).value;

  late final _$loadingAtom = Atom(
    name: 'UserAreaViewModelBase.loading',
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

  late final _$activatingNotificationsAtom = Atom(
    name: 'UserAreaViewModelBase.activatingNotifications',
    context: context,
  );

  @override
  bool get activatingNotifications {
    _$activatingNotificationsAtom.reportRead();
    return super.activatingNotifications;
  }

  @override
  set activatingNotifications(bool value) {
    _$activatingNotificationsAtom.reportWrite(
      value,
      super.activatingNotifications,
      () {
        super.activatingNotifications = value;
      },
    );
  }

  late final _$errorAtom = Atom(
    name: 'UserAreaViewModelBase.error',
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

  late final _$userAtom = Atom(
    name: 'UserAreaViewModelBase.user',
    context: context,
  );

  @override
  UserSummaryEntity? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserSummaryEntity? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$boraEventsAtom = Atom(
    name: 'UserAreaViewModelBase.boraEvents',
    context: context,
  );

  @override
  List<EventEntity> get boraEvents {
    _$boraEventsAtom.reportRead();
    return super.boraEvents;
  }

  @override
  set boraEvents(List<EventEntity> value) {
    _$boraEventsAtom.reportWrite(value, super.boraEvents, () {
      super.boraEvents = value;
    });
  }

  late final _$checkinEventsAtom = Atom(
    name: 'UserAreaViewModelBase.checkinEvents',
    context: context,
  );

  @override
  List<EventEntity> get checkinEvents {
    _$checkinEventsAtom.reportRead();
    return super.checkinEvents;
  }

  @override
  set checkinEvents(List<EventEntity> value) {
    _$checkinEventsAtom.reportWrite(value, super.checkinEvents, () {
      super.checkinEvents = value;
    });
  }

  late final _$currentLocationAtom = Atom(
    name: 'UserAreaViewModelBase.currentLocation',
    context: context,
  );

  @override
  LocationEntity? get currentLocation {
    _$currentLocationAtom.reportRead();
    return super.currentLocation;
  }

  @override
  set currentLocation(LocationEntity? value) {
    _$currentLocationAtom.reportWrite(value, super.currentLocation, () {
      super.currentLocation = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'UserAreaViewModelBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$enableLocationAsyncAction = AsyncAction(
    'UserAreaViewModelBase.enableLocation',
    context: context,
  );

  @override
  Future<bool> enableLocation() {
    return _$enableLocationAsyncAction.run(() => super.enableLocation());
  }

  late final _$activateNotificationsAsyncAction = AsyncAction(
    'UserAreaViewModelBase.activateNotifications',
    context: context,
  );

  @override
  Future<String> activateNotifications() {
    return _$activateNotificationsAsyncAction.run(
      () => super.activateNotifications(),
    );
  }

  late final _$UserAreaViewModelBaseActionController = ActionController(
    name: 'UserAreaViewModelBase',
    context: context,
  );

  @override
  void disableLocation() {
    final _$actionInfo = _$UserAreaViewModelBaseActionController.startAction(
      name: 'UserAreaViewModelBase.disableLocation',
    );
    try {
      return super.disableLocation();
    } finally {
      _$UserAreaViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
activatingNotifications: ${activatingNotifications},
error: ${error},
user: ${user},
boraEvents: ${boraEvents},
checkinEvents: ${checkinEvents},
currentLocation: ${currentLocation},
isLogged: ${isLogged},
locationEnabled: ${locationEnabled},
totalPersonalActions: ${totalPersonalActions},
recentActivity: ${recentActivity}
    ''';
  }
}
