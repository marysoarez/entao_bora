// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_event_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreateEventViewModel on CreateEventViewModelBase, Store {
  Computed<bool>? _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??= Computed<bool>(
    () => super.isValid,
    name: 'CreateEventViewModelBase.isValid',
  )).value;
  Computed<bool>? _$hasExternalTicketComputed;

  @override
  bool get hasExternalTicket => (_$hasExternalTicketComputed ??= Computed<bool>(
    () => super.hasExternalTicket,
    name: 'CreateEventViewModelBase.hasExternalTicket',
  )).value;
  Computed<bool>? _$hasPhotosComputed;

  @override
  bool get hasPhotos => (_$hasPhotosComputed ??= Computed<bool>(
    () => super.hasPhotos,
    name: 'CreateEventViewModelBase.hasPhotos',
  )).value;
  Computed<bool>? _$hasGenresComputed;

  @override
  bool get hasGenres => (_$hasGenresComputed ??= Computed<bool>(
    () => super.hasGenres,
    name: 'CreateEventViewModelBase.hasGenres',
  )).value;
  Computed<bool>? _$hasAttractionsComputed;

  @override
  bool get hasAttractions => (_$hasAttractionsComputed ??= Computed<bool>(
    () => super.hasAttractions,
    name: 'CreateEventViewModelBase.hasAttractions',
  )).value;

  late final _$loadingAtom = Atom(
    name: 'CreateEventViewModelBase.loading',
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
    name: 'CreateEventViewModelBase.error',
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

  late final _$titleAtom = Atom(
    name: 'CreateEventViewModelBase.title',
    context: context,
  );

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$descriptionAtom = Atom(
    name: 'CreateEventViewModelBase.description',
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

  late final _$instagramAtom = Atom(
    name: 'CreateEventViewModelBase.instagram',
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

  late final _$placeAtom = Atom(
    name: 'CreateEventViewModelBase.place',
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

  late final _$startDateAtom = Atom(
    name: 'CreateEventViewModelBase.startDate',
    context: context,
  );

  @override
  DateTime? get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(DateTime? value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  late final _$endDateAtom = Atom(
    name: 'CreateEventViewModelBase.endDate',
    context: context,
  );

  @override
  DateTime? get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(DateTime? value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  late final _$coverPhotoAtom = Atom(
    name: 'CreateEventViewModelBase.coverPhoto',
    context: context,
  );

  @override
  XFile? get coverPhoto {
    _$coverPhotoAtom.reportRead();
    return super.coverPhoto;
  }

  @override
  set coverPhoto(XFile? value) {
    _$coverPhotoAtom.reportWrite(value, super.coverPhoto, () {
      super.coverPhoto = value;
    });
  }

  late final _$musicGenresAtom = Atom(
    name: 'CreateEventViewModelBase.musicGenres',
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

  late final _$attractionsAtom = Atom(
    name: 'CreateEventViewModelBase.attractions',
    context: context,
  );

  @override
  ObservableList<EventAttractionEntity> get attractions {
    _$attractionsAtom.reportRead();
    return super.attractions;
  }

  @override
  set attractions(ObservableList<EventAttractionEntity> value) {
    _$attractionsAtom.reportWrite(value, super.attractions, () {
      super.attractions = value;
    });
  }

  late final _$photosAtom = Atom(
    name: 'CreateEventViewModelBase.photos',
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

  late final _$ticketAtom = Atom(
    name: 'CreateEventViewModelBase.ticket',
    context: context,
  );

  @override
  EventTicketEntity get ticket {
    _$ticketAtom.reportRead();
    return super.ticket;
  }

  @override
  set ticket(EventTicketEntity value) {
    _$ticketAtom.reportWrite(value, super.ticket, () {
      super.ticket = value;
    });
  }

  late final _$addressAtom = Atom(
    name: 'CreateEventViewModelBase.address',
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

  late final _$loadPlacesAsyncAction = AsyncAction(
    'CreateEventViewModelBase.loadPlaces',
    context: context,
  );

  @override
  Future<List<PlaceEntity>> loadPlaces() {
    return _$loadPlacesAsyncAction.run(() => super.loadPlaces());
  }

  late final _$saveAsyncAction = AsyncAction(
    'CreateEventViewModelBase.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$CreateEventViewModelBaseActionController = ActionController(
    name: 'CreateEventViewModelBase',
    context: context,
  );

  @override
  void setTitle(String value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setTitle',
    );
    try {
      return super.setTitle(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setDescription',
    );
    try {
      return super.setDescription(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInstagram(String value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setInstagram',
    );
    try {
      return super.setInstagram(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlace(PlaceEntity value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setPlace',
    );
    try {
      return super.setPlace(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDate(DateTime value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setStartDate',
    );
    try {
      return super.setStartDate(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDate(DateTime value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setEndDate',
    );
    try {
      return super.setEndDate(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCoverPhoto(XFile file) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setCoverPhoto',
    );
    try {
      return super.setCoverPhoto(file);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCoverPhoto() {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.removeCoverPhoto',
    );
    try {
      return super.removeCoverPhoto();
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTicketType(TicketType type) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setTicketType',
    );
    try {
      return super.setTicketType(type);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTicketUrl(String value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setTicketUrl',
    );
    try {
      return super.setTicketUrl(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGenre(MusicGenre genre) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.toggleGenre',
    );
    try {
      return super.toggleGenre(genre);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddress(AddressEntity value) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.setAddress',
    );
    try {
      return super.setAddress(value);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAttraction(EventAttractionEntity attraction) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.addAttraction',
    );
    try {
      return super.addAttraction(attraction);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeAttraction(EventAttractionEntity attraction) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.removeAttraction',
    );
    try {
      return super.removeAttraction(attraction);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPhoto(XFile photo) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.addPhoto',
    );
    try {
      return super.addPhoto(photo);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePhoto(XFile photo) {
    final _$actionInfo = _$CreateEventViewModelBaseActionController.startAction(
      name: 'CreateEventViewModelBase.removePhoto',
    );
    try {
      return super.removePhoto(photo);
    } finally {
      _$CreateEventViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
title: ${title},
description: ${description},
instagram: ${instagram},
place: ${place},
startDate: ${startDate},
endDate: ${endDate},
coverPhoto: ${coverPhoto},
musicGenres: ${musicGenres},
attractions: ${attractions},
photos: ${photos},
ticket: ${ticket},
address: ${address},
isValid: ${isValid},
hasExternalTicket: ${hasExternalTicket},
hasPhotos: ${hasPhotos},
hasGenres: ${hasGenres},
hasAttractions: ${hasAttractions}
    ''';
  }
}
