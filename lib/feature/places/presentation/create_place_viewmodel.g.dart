// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_place_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreatePlaceViewModel on CreatePlaceViewModelBase, Store {
  Computed<bool>? _$isEditingComputed;

  @override
  bool get isEditing => (_$isEditingComputed ??= Computed<bool>(
    () => super.isEditing,
    name: 'CreatePlaceViewModelBase.isEditing',
  )).value;

  late final _$loadingAtom = Atom(
    name: 'CreatePlaceViewModelBase.loading',
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

  late final _$editingPlaceAtom = Atom(
    name: 'CreatePlaceViewModelBase.editingPlace',
    context: context,
  );

  @override
  PlaceEntity? get editingPlace {
    _$editingPlaceAtom.reportRead();
    return super.editingPlace;
  }

  @override
  set editingPlace(PlaceEntity? value) {
    _$editingPlaceAtom.reportWrite(value, super.editingPlace, () {
      super.editingPlace = value;
    });
  }

  late final _$errorAtom = Atom(
    name: 'CreatePlaceViewModelBase.error',
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

  late final _$addressAtom = Atom(
    name: 'CreatePlaceViewModelBase.address',
    context: context,
  );

  @override
  AddressEntity? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(AddressEntity? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$typeAtom = Atom(
    name: 'CreatePlaceViewModelBase.type',
    context: context,
  );

  @override
  PlaceType get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(PlaceType value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$musicGenresAtom = Atom(
    name: 'CreatePlaceViewModelBase.musicGenres',
    context: context,
  );

  @override
  ObservableList<MusicGenre> get musicGenres {
    _$musicGenresAtom.reportRead();
    return super.musicGenres;
  }

  @override
  set musicGenres(ObservableList<MusicGenre> value) {
    _$musicGenresAtom.reportWrite(value, super.musicGenres, () {
      super.musicGenres = value;
    });
  }

  late final _$openingHoursAtom = Atom(
    name: 'CreatePlaceViewModelBase.openingHours',
    context: context,
  );

  @override
  ObservableList<OpeningHours> get openingHours {
    _$openingHoursAtom.reportRead();
    return super.openingHours;
  }

  @override
  set openingHours(ObservableList<OpeningHours> value) {
    _$openingHoursAtom.reportWrite(value, super.openingHours, () {
      super.openingHours = value;
    });
  }

  late final _$photosAtom = Atom(
    name: 'CreatePlaceViewModelBase.photos',
    context: context,
  );

  @override
  ObservableList<XFile> get photos {
    _$photosAtom.reportRead();
    return super.photos;
  }

  @override
  set photos(ObservableList<XFile> value) {
    _$photosAtom.reportWrite(value, super.photos, () {
      super.photos = value;
    });
  }

  late final _$existingPhotosAtom = Atom(
    name: 'CreatePlaceViewModelBase.existingPhotos',
    context: context,
  );

  @override
  ObservableList<String> get existingPhotos {
    _$existingPhotosAtom.reportRead();
    return super.existingPhotos;
  }

  @override
  set existingPhotos(ObservableList<String> value) {
    _$existingPhotosAtom.reportWrite(value, super.existingPhotos, () {
      super.existingPhotos = value;
    });
  }

  late final _$nameAtom = Atom(
    name: 'CreatePlaceViewModelBase.name',
    context: context,
  );

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$descriptionAtom = Atom(
    name: 'CreatePlaceViewModelBase.description',
    context: context,
  );

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$phoneAtom = Atom(
    name: 'CreatePlaceViewModelBase.phone',
    context: context,
  );

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$instagramAtom = Atom(
    name: 'CreatePlaceViewModelBase.instagram',
    context: context,
  );

  @override
  String get instagram {
    _$instagramAtom.reportRead();
    return super.instagram;
  }

  @override
  set instagram(String value) {
    _$instagramAtom.reportWrite(value, super.instagram, () {
      super.instagram = value;
    });
  }

  late final _$websiteAtom = Atom(
    name: 'CreatePlaceViewModelBase.website',
    context: context,
  );

  @override
  String get website {
    _$websiteAtom.reportRead();
    return super.website;
  }

  @override
  set website(String value) {
    _$websiteAtom.reportWrite(value, super.website, () {
      super.website = value;
    });
  }

  late final _$searchAddressAsyncAction = AsyncAction(
    'CreatePlaceViewModelBase.searchAddress',
    context: context,
  );

  @override
  Future<List<AddressEntity>> searchAddress(String query) {
    return _$searchAddressAsyncAction.run(() => super.searchAddress(query));
  }

  late final _$setAddressNumberAsyncAction = AsyncAction(
    'CreatePlaceViewModelBase.setAddressNumber',
    context: context,
  );

  @override
  Future<void> setAddressNumber(String number) {
    return _$setAddressNumberAsyncAction.run(
      () => super.setAddressNumber(number),
    );
  }

  late final _$resolveAddressLocationAsyncAction = AsyncAction(
    'CreatePlaceViewModelBase.resolveAddressLocation',
    context: context,
  );

  @override
  Future<void> resolveAddressLocation() {
    return _$resolveAddressLocationAsyncAction.run(
      () => super.resolveAddressLocation(),
    );
  }

  late final _$saveAsyncAction = AsyncAction(
    'CreatePlaceViewModelBase.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$loadAsyncAction = AsyncAction(
    'CreatePlaceViewModelBase.load',
    context: context,
  );

  @override
  Future<void> load(PlaceEntity place) {
    return _$loadAsyncAction.run(() => super.load(place));
  }

  late final _$CreatePlaceViewModelBaseActionController = ActionController(
    name: 'CreatePlaceViewModelBase',
    context: context,
  );

  @override
  void setName(String value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setName',
    );
    try {
      return super.setName(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setDescription',
    );
    try {
      return super.setDescription(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setPhone',
    );
    try {
      return super.setPhone(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInstagram(String value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setInstagram',
    );
    try {
      return super.setInstagram(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWebsite(String value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setWebsite',
    );
    try {
      return super.setWebsite(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setType(PlaceType value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setType',
    );
    try {
      return super.setType(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddress(AddressEntity value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setAddress',
    );
    try {
      return super.setAddress(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGenre(MusicGenre genre) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.toggleGenre',
    );
    try {
      return super.toggleGenre(genre);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOpeningHours(OpeningHours value) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.setOpeningHours',
    );
    try {
      return super.setOpeningHours(value);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeOpeningHours(Weekday weekday) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.removeOpeningHours',
    );
    try {
      return super.removeOpeningHours(weekday);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPhoto(XFile file) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.addPhoto',
    );
    try {
      return super.addPhoto(file);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePhoto(XFile file) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.removePhoto',
    );
    try {
      return super.removePhoto(file);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeExistingPhoto(String photo) {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.removeExistingPhoto',
    );
    try {
      return super.removeExistingPhoto(photo);
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$CreatePlaceViewModelBaseActionController.startAction(
      name: 'CreatePlaceViewModelBase.reset',
    );
    try {
      return super.reset();
    } finally {
      _$CreatePlaceViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
editingPlace: ${editingPlace},
error: ${error},
address: ${address},
type: ${type},
musicGenres: ${musicGenres},
openingHours: ${openingHours},
photos: ${photos},
existingPhotos: ${existingPhotos},
name: ${name},
description: ${description},
phone: ${phone},
instagram: ${instagram},
website: ${website},
isEditing: ${isEditing}
    ''';
  }
}
