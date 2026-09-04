import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:mobx/mobx.dart';

part 'manage_menu_viewmodel.g.dart';

class ManageMenuViewModel = ManageMenuViewModelBase with _$ManageMenuViewModel;

abstract class ManageMenuViewModelBase with Store {
  ManageMenuViewModelBase(this._authRepository, this._placeRepository);

  final IAuthRepository _authRepository;
  final IPlaceRepository _placeRepository;

  @observable
  bool loading = true;

  @observable
  String? error;

  @observable
  UserSummaryEntity? user;

  @observable
  ObservableList<PlaceEntity> places = ObservableList<PlaceEntity>();

  @observable
  PlaceEntity? selectedPlace;

  @computed
  bool get hasPlaces => places.isNotEmpty;

  @computed
  bool get canEditMenu => selectedPlace != null && error == null;

  @computed
  List<String> get categories {
    final place = selectedPlace;

    if (place == null) {
      return const ['Geral'];
    }

    return categoriesFor(place);
  }

  @computed
  Map<String, List<MenuItemEntity>> get itemsByCategory {
    final place = selectedPlace;

    if (place == null) {
      return const {};
    }

    final grouped = {
      for (final category in categoriesFor(place)) category: <MenuItemEntity>[],
    };

    for (final item in place.menuItems) {
      final category = item.category.trim().isEmpty ? 'Geral' : item.category;

      grouped.putIfAbsent(category, () => []).add(item);
    }

    return grouped;
  }

  @action
  Future<void> load({PlaceEntity? initialPlace}) async {
    loading = true;
    error = null;

    final currentUser = await _authRepository.getCurrentUser(
      forceRefresh: true,
    );

    if (currentUser == null) {
      user = null;
      places.clear();
      selectedPlace = null;
      loading = false;
      error = 'Faca login para editar o cardapio.';
      return;
    }

    if (!currentUser.isPartner) {
      user = currentUser;
      places.clear();
      selectedPlace = null;
      loading = false;
      error = 'Voce precisa ser parceiro para editar cardapios.';
      return;
    }

    final loadedPlaces = <PlaceEntity>[];

    for (final ownerId in _ownerIdsFor(currentUser)) {
      final result = await _placeRepository.getPlacesByOwnerId(ownerId);

      final failed = result.fold(
        (failure) {
          user = currentUser;
          places.clear();
          selectedPlace = null;
          loading = false;
          error = failure.message;
          return true;
        },
        (places) {
          loadedPlaces.addAll(places);
          return false;
        },
      );

      if (failed) return;
    }

    final uniquePlaces = {
      for (final place in loadedPlaces) place.id: place,
    }.values.toList();

    user = currentUser;
    places
      ..clear()
      ..addAll(uniquePlaces);
    selectedPlace = _resolveSelectedPlace(uniquePlaces, initialPlace);
    loading = false;
  }

  @action
  void selectPlace(PlaceEntity place) {
    selectedPlace = place;
    error = null;
  }

  @action
  Future<bool> saveMenuItem(
    MenuItemEntity savedItem, {
    MenuItemEntity? replacingItem,
  }) async {
    final place = selectedPlace;

    if (place == null) return false;

    final updatedItems = replacingItem == null
        ? [...place.menuItems, savedItem]
        : place.menuItems.map((current) {
            return current.id == replacingItem.id ? savedItem : current;
          }).toList();

    return _saveMenu(place, menuItems: updatedItems);
  }

  @action
  Future<bool> createCategory(String category) async {
    final place = selectedPlace;
    final normalized = category.trim();

    if (place == null || normalized.isEmpty) return false;

    final exists = categoriesFor(place).any((current) {
      return current.toLowerCase() == normalized.toLowerCase();
    });

    if (exists) {
      error = 'Categoria ja existe.';
      return false;
    }

    return _saveMenu(
      place,
      menuItems: place.menuItems,
      menuCategories: [...place.menuCategories, normalized],
    );
  }

  @action
  Future<bool> deleteMenuItem(MenuItemEntity item) async {
    final place = selectedPlace;

    if (place == null) return false;

    return _saveMenu(
      place,
      menuItems: place.menuItems
          .where((current) => current.id != item.id)
          .toList(),
    );
  }

  List<String> categoriesFor(PlaceEntity place) {
    final categories =
        [
              ...place.menuCategories,
              ...place.menuItems.map((item) => item.category),
            ]
            .map((category) => category.trim())
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList();

    if (!categories.contains('Geral')) {
      categories.insert(0, 'Geral');
    }

    categories.sort((a, b) {
      if (a == 'Geral') return -1;
      if (b == 'Geral') return 1;

      return a.compareTo(b);
    });

    return categories;
  }

  List<String> _ownerIdsFor(UserSummaryEntity user) {
    return {
      user.id,
      if (user.partnerId != null && user.partnerId!.trim().isNotEmpty)
        user.partnerId!,
    }.toList();
  }

  PlaceEntity? _resolveSelectedPlace(
    List<PlaceEntity> partnerPlaces,
    PlaceEntity? initialPlace,
  ) {
    if (partnerPlaces.isEmpty) {
      return null;
    }

    final currentSelected = initialPlace ?? selectedPlace;

    if (currentSelected != null) {
      for (final place in partnerPlaces) {
        if (place.id == currentSelected.id) {
          return place;
        }
      }
    }

    return partnerPlaces.first;
  }

  Future<bool> _saveMenu(
    PlaceEntity place, {
    required List<MenuItemEntity> menuItems,
    List<String>? menuCategories,
  }) async {
    loading = true;
    error = null;

    final updatedPlace = place.copyWith(
      menuItems: menuItems,
      menuCategories: menuCategories,
    );

    final result = await _placeRepository.updatePlace(updatedPlace);

    return result.fold(
      (failure) {
        loading = false;
        error = failure.message;
        return false;
      },
      (_) {
        final updatedPlaces = places.map((current) {
          return current.id == updatedPlace.id ? updatedPlace : current;
        }).toList();

        places
          ..clear()
          ..addAll(updatedPlaces);

        selectedPlace = updatedPlace;
        loading = false;
        return true;
      },
    );
  }
}
