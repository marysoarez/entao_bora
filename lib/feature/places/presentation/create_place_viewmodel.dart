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
  ObservableList<String> existingPhotos = ObservableList();

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
  void removeExistingPhoto(String photo) {
    existingPhotos.remove(photo);
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
  Future<void> setAddressNumber(String number) async {
    if (address == null) return;

    address = address!.copyWith(number: number);

    if (number.trim().isEmpty) return;

    await resolveAddressLocation();
  }

  @action
  Future<void> resolveAddressLocation() async {
    if (address == null) return;

    final currentAddress = address!;
    final number = currentAddress.number?.trim();

    if (number == null || number.isEmpty) return;

    final result = await _locationRepository.geocodeAddress(currentAddress);

    result.fold(
      (failure) {
        error = failure.message;
      },
      (resolvedAddress) {
        if (resolvedAddress == null) return;

        address = currentAddress.copyWith(
          location: resolvedAddress.location,
          displayName: resolvedAddress.displayName,
        );
      },
    );
  }

  @action
  Future<bool> save() async {
    if (loading) return false;

    loading = true;
    error = null;

    try {
      final validation = _validate();

      if (validation != null) {
        error = validation;
        return false;
      }

      await resolveAddressLocation();

      final user = await _authRepository.getCurrentUser();

      if (user == null) {
        error = 'Usuario nao autenticado.';
        return false;
      }

      final photosBase64 = <String>[];

      for (final photo in photos) {
        photosBase64.add(await ImageHelper.fileToBase64(photo));
      }

      final place = PlaceEntity(
        id: editingPlace?.id ?? '',
        name: name.trim(),
        description: description.trim(),
        address: address!,
        musicGenres: musicGenres.toList(),
        type: type,
        ownerId: editingPlace?.ownerId ?? user,
        phone: phone.trim(),
        instagram: instagram.trim(),
        website: website.trim(),
        openingHours: openingHours.toList(),
        photos: [...existingPhotos, ...photosBase64],
      );

      if (isEditing) {
        final result = await _placeRepository.updatePlace(place);

        return result.fold((failure) {
          error = failure.message;
          return false;
        }, (_) => true);
      }

      final result = await _placeRepository.createPlace(place);

      return result.fold((failure) {
        error = failure.message;
        return false;
      }, (success) => success);
    } catch (e) {
      error = e.toString();
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
    existingPhotos
      ..clear()
      ..addAll(place.photos);
  }

  String? _validate() {
    if (name.trim().isEmpty) {
      return 'Informe o nome.';
    }

    if (description.trim().isEmpty) {
      return 'Informe uma descricao.';
    }

    if (address == null) {
      return 'Selecione um endereco.';
    }

    if (musicGenres.isEmpty) {
      return 'Selecione pelo menos um estilo musical.';
    }

    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome.';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe uma descricao.';
    }

    return null;
  }
}
