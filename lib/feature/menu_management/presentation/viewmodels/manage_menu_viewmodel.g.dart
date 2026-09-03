// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_menu_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ManageMenuViewModel on ManageMenuViewModelBase, Store {
  Computed<bool>? _$hasPlacesComputed;

  @override
  bool get hasPlaces => (_$hasPlacesComputed ??= Computed<bool>(
    () => super.hasPlaces,
    name: 'ManageMenuViewModelBase.hasPlaces',
  )).value;
  Computed<bool>? _$canEditMenuComputed;

  @override
  bool get canEditMenu => (_$canEditMenuComputed ??= Computed<bool>(
    () => super.canEditMenu,
    name: 'ManageMenuViewModelBase.canEditMenu',
  )).value;
  Computed<List<String>>? _$categoriesComputed;

  @override
  List<String> get categories =>
      (_$categoriesComputed ??= Computed<List<String>>(
        () => super.categories,
        name: 'ManageMenuViewModelBase.categories',
      )).value;
  Computed<Map<String, List<MenuItemEntity>>>? _$itemsByCategoryComputed;

  @override
  Map<String, List<MenuItemEntity>> get itemsByCategory =>
      (_$itemsByCategoryComputed ??=
              Computed<Map<String, List<MenuItemEntity>>>(
                () => super.itemsByCategory,
                name: 'ManageMenuViewModelBase.itemsByCategory',
              ))
          .value;

  late final _$loadingAtom = Atom(
    name: 'ManageMenuViewModelBase.loading',
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
    name: 'ManageMenuViewModelBase.error',
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
    name: 'ManageMenuViewModelBase.user',
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
    name: 'ManageMenuViewModelBase.places',
    context: context,
  );

  @override
  ObservableList<PlaceEntity> get places {
    _$placesAtom.reportRead();
    return super.places;
  }

  @override
  set places(ObservableList<PlaceEntity> value) {
    _$placesAtom.reportWrite(value, super.places, () {
      super.places = value;
    });
  }

  late final _$selectedPlaceAtom = Atom(
    name: 'ManageMenuViewModelBase.selectedPlace',
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

  late final _$loadAsyncAction = AsyncAction(
    'ManageMenuViewModelBase.load',
    context: context,
  );

  @override
  Future<void> load({PlaceEntity? initialPlace}) {
    return _$loadAsyncAction.run(() => super.load(initialPlace: initialPlace));
  }

  late final _$saveMenuItemAsyncAction = AsyncAction(
    'ManageMenuViewModelBase.saveMenuItem',
    context: context,
  );

  @override
  Future<bool> saveMenuItem(
    MenuItemEntity savedItem, {
    MenuItemEntity? replacingItem,
  }) {
    return _$saveMenuItemAsyncAction.run(
      () => super.saveMenuItem(savedItem, replacingItem: replacingItem),
    );
  }

  late final _$createCategoryAsyncAction = AsyncAction(
    'ManageMenuViewModelBase.createCategory',
    context: context,
  );

  @override
  Future<bool> createCategory(String category) {
    return _$createCategoryAsyncAction.run(
      () => super.createCategory(category),
    );
  }

  late final _$deleteMenuItemAsyncAction = AsyncAction(
    'ManageMenuViewModelBase.deleteMenuItem',
    context: context,
  );

  @override
  Future<bool> deleteMenuItem(MenuItemEntity item) {
    return _$deleteMenuItemAsyncAction.run(() => super.deleteMenuItem(item));
  }

  late final _$ManageMenuViewModelBaseActionController = ActionController(
    name: 'ManageMenuViewModelBase',
    context: context,
  );

  @override
  void selectPlace(PlaceEntity place) {
    final _$actionInfo = _$ManageMenuViewModelBaseActionController.startAction(
      name: 'ManageMenuViewModelBase.selectPlace',
    );
    try {
      return super.selectPlace(place);
    } finally {
      _$ManageMenuViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
user: ${user},
places: ${places},
selectedPlace: ${selectedPlace},
hasPlaces: ${hasPlaces},
canEditMenu: ${canEditMenu},
categories: ${categories},
itemsByCategory: ${itemsByCategory}
    ''';
  }
}
