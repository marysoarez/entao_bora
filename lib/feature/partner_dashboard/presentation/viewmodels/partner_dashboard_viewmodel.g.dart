// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_dashboard_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PartnerDashboardViewModel on PartnerDashboardViewModelBase, Store {
  Computed<int>? _$totalViewsComputed;

  @override
  int get totalViews => (_$totalViewsComputed ??= Computed<int>(
    () => super.totalViews,
    name: 'PartnerDashboardViewModelBase.totalViews',
  )).value;
  Computed<int>? _$totalBorasComputed;

  @override
  int get totalBoras => (_$totalBorasComputed ??= Computed<int>(
    () => super.totalBoras,
    name: 'PartnerDashboardViewModelBase.totalBoras',
  )).value;
  Computed<int>? _$totalCheckinsComputed;

  @override
  int get totalCheckins => (_$totalCheckinsComputed ??= Computed<int>(
    () => super.totalCheckins,
    name: 'PartnerDashboardViewModelBase.totalCheckins',
  )).value;

  late final _$loadingAtom = Atom(
    name: 'PartnerDashboardViewModelBase.loading',
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
    name: 'PartnerDashboardViewModelBase.error',
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
    name: 'PartnerDashboardViewModelBase.user',
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

  late final _$placesAtom = Atom(
    name: 'PartnerDashboardViewModelBase.places',
    context: context,
  );

  @override
  List<PlaceEntity> get places {
    _$placesAtom.reportRead();
    return super.places;
  }

  @override
  set places(List<PlaceEntity> value) {
    _$placesAtom.reportWrite(value, super.places, () {
      super.places = value;
    });
  }

  late final _$eventsAtom = Atom(
    name: 'PartnerDashboardViewModelBase.events',
    context: context,
  );

  @override
  List<EventEntity> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(List<EventEntity> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
    });
  }

  late final _$visibleEventsAtom = Atom(
    name: 'PartnerDashboardViewModelBase.visibleEvents',
    context: context,
  );

  @override
  List<EventEntity> get visibleEvents {
    _$visibleEventsAtom.reportRead();
    return super.visibleEvents;
  }

  @override
  set visibleEvents(List<EventEntity> value) {
    _$visibleEventsAtom.reportWrite(value, super.visibleEvents, () {
      super.visibleEvents = value;
    });
  }

  late final _$selectedPlaceAtom = Atom(
    name: 'PartnerDashboardViewModelBase.selectedPlace',
    context: context,
  );

  @override
  PlaceEntity? get selectedPlace {
    _$selectedPlaceAtom.reportRead();
    return super.selectedPlace;
  }

  @override
  set selectedPlace(PlaceEntity? value) {
    _$selectedPlaceAtom.reportWrite(value, super.selectedPlace, () {
      super.selectedPlace = value;
    });
  }

  late final _$loadDashboardAsyncAction = AsyncAction(
    'PartnerDashboardViewModelBase.loadDashboard',
    context: context,
  );

  @override
  Future<void> loadDashboard() {
    return _$loadDashboardAsyncAction.run(() => super.loadDashboard());
  }

  late final _$selectPlaceAsyncAction = AsyncAction(
    'PartnerDashboardViewModelBase.selectPlace',
    context: context,
  );

  @override
  Future<void> selectPlace(PlaceEntity place) {
    return _$selectPlaceAsyncAction.run(() => super.selectPlace(place));
  }

  late final _$PartnerDashboardViewModelBaseActionController = ActionController(
    name: 'PartnerDashboardViewModelBase',
    context: context,
  );

  @override
  void setInitialPlace(PlaceEntity? place) {
    final _$actionInfo = _$PartnerDashboardViewModelBaseActionController
        .startAction(name: 'PartnerDashboardViewModelBase.setInitialPlace');
    try {
      return super.setInitialPlace(place);
    } finally {
      _$PartnerDashboardViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
user: ${user},
places: ${places},
events: ${events},
visibleEvents: ${visibleEvents},
selectedPlace: ${selectedPlace},
totalViews: ${totalViews},
totalBoras: ${totalBoras},
totalCheckins: ${totalCheckins}
    ''';
  }
}
