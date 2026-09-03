import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:mobx/mobx.dart';

part 'place_details_viewmodel.g.dart';

class PlaceDetailsViewModel = PlaceDetailsViewModelBase
    with _$PlaceDetailsViewModel;

abstract class PlaceDetailsViewModelBase with Store {
  PlaceDetailsViewModelBase(this._placeRepository);

  final IPlaceRepository _placeRepository;

  @observable
  bool loading = false;

  @observable
  String? error;

  @observable
  PlaceEntity? place;

  @action
  void setPlace(PlaceEntity selectedPlace) {
    place = selectedPlace;
    error = null;
    loading = false;
  }

  @action
  Future<void> load(String id) async {
    loading = true;
    error = null;

    final result = await _placeRepository.getPlaceById(id);

    result.fold(
      (failure) {
        error = failure.message;
        place = null;
      },
      (loadedPlace) {
        place = loadedPlace;
        error = loadedPlace == null ? 'Estabelecimento nao encontrado.' : null;
      },
    );

    loading = false;
  }

  @action
  Future<void> reload() async {
    final currentPlace = place;
    if (currentPlace == null) return;

    final result = await _placeRepository.getPlaceById(currentPlace.id);

    result.fold((_) {}, (loadedPlace) {
      if (loadedPlace != null) {
        place = loadedPlace;
      }
    });
  }
}
