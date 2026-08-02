import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/oppening_hours.dart';
import 'package:entao_bora/shared/enum/place_type_enum.dart';
import 'package:entao_bora/shared/enum/week_day_enum.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'create_place_viewmodel.g.dart';

class CreatePlaceViewModel = CreatePlaceViewModelBase
    with _$CreatePlaceViewModel;

abstract class CreatePlaceViewModelBase with Store {
  CreatePlaceViewModelBase(
    this._locationRepository,
    this._placeRepository,
    this._authRepository,
  );

  final ILocationRepository _locationRepository;
  final IPlaceRepository _placeRepository;
  final IAuthRepository _authRepository;

  @observable
  bool loading = false;

  @observable
  PlaceEntity? editingPlace;

  @computed
  bool get isEditing => editingPlace != null;

  @observable
  String? error;

  @observable
  AddressEntity? address;

  @observable
  PlaceType type = PlaceType.bar;

  @observable
  ObservableList<MusicGenre> musicGenres = ObservableList();

  @observable
  ObservableList<OpeningHours> openingHours = ObservableList();

  @observable
  ObservableList<XFile> photos = ObservableList();

  @observable
  String name = '';

  @observable
  String description = '';

  @observable
  String phone = '';

  @observable
  String instagram = '';

  @observable
  String website = '';

  @action
  void setName(String value) => name = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setPhone(String value) => phone = value;

  @action
  void setInstagram(String value) => instagram = value;

  @action
  void setWebsite(String value) => website = value;

  @action
  void setType(PlaceType value) => type = value;

  @action
  void setAddress(AddressEntity value) {
    address = value;
  }

  @action
  void toggleGenre(MusicGenre genre) {
    if (musicGenres.contains(genre)) {
      musicGenres.remove(genre);
    } else {
      musicGenres.add(genre);
    }
  }

  @action
  void setOpeningHours(OpeningHours value) {
    openingHours.removeWhere((e) => e.weekday == value.weekday);

    openingHours.add(value);
  }

  @action
  void removeOpeningHours(Weekday weekday) {
    openingHours.removeWhere((e) => e.weekday == weekday);
  }

  @action
  void addPhoto(XFile file) {
    photos.add(file);
  }

  @action
  void removePhoto(XFile file) {
    photos.remove(file);
  }

  @action
  Future<List<AddressEntity>> searchAddress(String query) async {
    try {
      final result = await _locationRepository.searchAddress(query);

      return result.fold((failure) {
        error = failure.message;
        return [];
      }, (data) => data);
    } catch (e) {
      error = e.toString();
      return [];
    }
  }

  @action
  Future<bool> save() async {
    loading = true;
    final user = await _authRepository.getCurrentUser();

    if (user == null) {
      error = 'Usuário não autenticado.';
      loading = false;
      return false;
    }
    try {
      final photosBase64 = <String>[];
      debugPrint('address == null: ${address == null}');
      debugPrint('photos: ${photos.length}');

      for (final photo in photos) {
        photosBase64.add(await ImageHelper.fileToBase64(photo));
      }
      debugPrint('CHEGOU ANTES DO PLACE');
      final place = PlaceEntity(
        id: '',
        name: name.trim(),
        description: description.trim(),
        address: address!,
        musicGenres: musicGenres.toList(),
        type: type,
        ownerId: user.id,
        ownerName: user.name,
        phone: phone.trim(),
        instagram: instagram.trim(),
        website: website.trim(),
        openingHours: openingHours.toList(),
        photos: photosBase64,
      );

if (isEditing) {
  await _placeRepository.updatePlace(
    place.copyWith(id: editingPlace!.id),
  );
} else {
  await _placeRepository.createPlace(place);
}
      return true;
    } catch (e, s) {
      error = e.toString();
      error = s.toString();
      return false;
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> load(PlaceEntity place) async {
    editingPlace = place;

    name = place.name;
    description = place.description;
    phone = place.phone;
    instagram = place.instagram;
    website = place.website;

    type = place.type;
    address = place.address;

    musicGenres
      ..clear()
      ..addAll(place.musicGenres);

    openingHours
      ..clear()
      ..addAll(place.openingHours);

    photos.clear();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome.';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe uma descrição.';
    }

    return null;
  }
}
