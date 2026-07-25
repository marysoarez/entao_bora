import 'package:dartz/dartz.dart';
import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/errors/location_errors.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
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
  CreatePlaceViewModelBase(this._locationRepository, this._placeRepository);

  final ILocationRepository _locationRepository;
  final IPlaceRepository _placeRepository;

  //==========================================================
  // Estado
  //==========================================================

  @observable
  bool loading = false;

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

  //==========================================================
  // Campos
  //==========================================================

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

  //==========================================================
  // Actions
  //==========================================================

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
    print('SAVE 1');

    loading = true;

    try {
      print('SAVE 2');

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
        phone: phone.trim(),
        instagram: instagram.trim(),
        website: website.trim(),
        openingHours: openingHours.toList(),
        photos: photosBase64,
      );

      print('SAVE 3');

      await _placeRepository.createPlace(place);

      print('SAVE 4');

      return true;
    } catch (e, s) {
      print(e);
      print(s);

      error = e.toString();
      return false;
    } finally {
      print('SAVE 5');

      loading = false;
    }
  }
  //==========================================================
  // Validators
  //==========================================================

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
