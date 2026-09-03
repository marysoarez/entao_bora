import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/menu_management/dialog/confirma_delete_dialog.dart';
import 'package:entao_bora/feature/menu_management/dialog/create_category_dialog.dart';
import 'package:entao_bora/feature/menu_management/dialog/menu_item_dialog.dart';
import 'package:entao_bora/feature/menu_management/widgets/menu_category_section.dart';
import 'package:entao_bora/feature/menu_management/widgets/menu_toolbar.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ManageMenuPage extends StatefulWidget {
  final PlaceEntity? place;

  const ManageMenuPage({super.key, this.place});

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  final _authRepository = Modular.get<IAuthRepository>();
  final _placeRepository = Modular.get<IPlaceRepository>();

  bool loading = true;

  String? error;

  UserSummaryEntity? user;

  List<PlaceEntity> places = [];

  PlaceEntity? selectedPlace;

  @override
  void initState() {
    super.initState();

    selectedPlace = widget.place;

    loadMenu();
  }

  Future<void> loadMenu() async {
    setState(() {
      loading = true;
      error = null;
    });

    final currentUser = await _authRepository.getCurrentUser();

    if (currentUser == null) {
      setState(() {
        user = null;
        loading = false;
        error = 'Faca login para editar o cardapio.';
      });

      return;
    }

    if (!currentUser.isPartner) {
      setState(() {
        user = currentUser;
        loading = false;
        error = 'Voce precisa ser parceiro para editar cardapios.';
      });

      return;
    }

    final loadedPlaces = <PlaceEntity>[];

    for (final ownerId in _ownerIdsFor(currentUser)) {
      final result = await _placeRepository.getPlacesByOwnerId(ownerId);

      final failed = result.fold(
        (failure) {
          setState(() {
            user = currentUser;
            loading = false;
            error = failure.message;
          });

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

    if (!mounted) return;

    setState(() {
      user = currentUser;
      places = uniquePlaces;
      selectedPlace = _resolveSelectedPlace(uniquePlaces);
      loading = false;
    });
  }

  List<String> _ownerIdsFor(UserSummaryEntity user) {
    return {
      user.id,
      if (user.partnerId != null && user.partnerId!.trim().isNotEmpty)
        user.partnerId!,
    }.toList();
  }

  PlaceEntity? _resolveSelectedPlace(List<PlaceEntity> partnerPlaces) {
    if (partnerPlaces.isEmpty) {
      return null;
    }

    final currentSelected = selectedPlace;

    if (currentSelected != null) {
      for (final place in partnerPlaces) {
        if (place.id == currentSelected.id) {
          return place;
        }
      }
    }

    return partnerPlaces.first;
  }

  void selectPlace(PlaceEntity place) {
    setState(() {
      selectedPlace = place;
      error = null;
    });
  }

  Future<void> openMenuItemForm([
    MenuItemEntity? item,
    String? initialCategory,
  ]) async {
    final place = selectedPlace;

    if (place == null) return;

    final savedItem = await showDialog<MenuItemEntity>(
      context: context,
      builder: (context) {
        return MenuItemDialog(
          item: item,
          categories: _categoriesFor(place),
          initialCategory: initialCategory,
        );
      },
    );

    if (savedItem == null) return;

    final updatedItems = item == null
        ? [...place.menuItems, savedItem]
        : place.menuItems.map((current) {
            return current.id == item.id ? savedItem : current;
          }).toList();

    await _saveMenu(place, menuItems: updatedItems);
  }

  List<String> _categoriesFor(PlaceEntity place) {
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

  Future<void> createCategory() async {
    final place = selectedPlace;

    if (place == null) return;

    final category = await showCreateCategoryDialog(context);

    if (category == null || category.isEmpty) {
      return;
    }

    final exists = _categoriesFor(place).any((current) {
      return current.toLowerCase() == category.toLowerCase();
    });

    if (exists) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Categoria ja existe.')));

      return;
    }

    await _saveMenu(
      place,
      menuItems: place.menuItems,
      menuCategories: [...place.menuCategories, category],
    );
  }

  Map<String, List<MenuItemEntity>> _itemsByCategory(PlaceEntity place) {
    final grouped = {
      for (final category in _categoriesFor(place))
        category: <MenuItemEntity>[],
    };

    for (final item in place.menuItems) {
      final category = item.category.trim().isEmpty ? 'Geral' : item.category;

      grouped.putIfAbsent(category, () => []).add(item);
    }

    return grouped;
  }

  Future<void> deleteMenuItem(MenuItemEntity item) async {
    final place = selectedPlace;

    if (place == null) return;

    final confirmed = await showConfirmDeleteDialog(
      context,
      itemName: item.title,
    );

    if (!confirmed) return;

    await _saveMenu(
      place,
      menuItems: place.menuItems
          .where((current) => current.id != item.id)
          .toList(),
    );
  }

  Future<void> _saveMenu(
    PlaceEntity place, {
    required List<MenuItemEntity> menuItems,
    List<String>? menuCategories,
  }) async {
    setState(() {
      loading = true;
      error = null;
    });

    final updatedPlace = place.copyWith(
      menuItems: menuItems,
      menuCategories: menuCategories,
    );

    final result = await _placeRepository.updatePlace(updatedPlace);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          loading = false;
          error = failure.message;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        setState(() {
          places = places.map((current) {
            return current.id == updatedPlace.id ? updatedPlace : current;
          }).toList();

          selectedPlace = updatedPlace;

          loading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cardapio atualizado.')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DsColors.adminBackground,
      appBar: AppBar(
        title: const Text('Editar cardapio'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: loading ? null : loadMenu,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : DsAdminPage(maxWidth: DsSizes.maxFormWidth, child: _buildContent()),
      floatingActionButton: selectedPlace == null || error != null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => openMenuItemForm(),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar item'),
            ),
    );
  }

  Widget _buildContent() {
    if (error != null && places.isEmpty) {
      return DsEmptyState(
        icon: Icons.lock_outline,
        title: 'Nao foi possivel editar o cardapio',
        message: error!,
        actionLabel: 'Tentar novamente',
        onAction: loadMenu,
      );
    }

    if (places.isEmpty) {
      return DsEmptyState(
        icon: Icons.storefront_outlined,
        title: 'Nenhum estabelecimento cadastrado',
        message: 'Cadastre um local antes de montar o cardapio.',
        actionLabel: 'Novo local',
        onAction: () {
          Modular.to.pushNamed('/places/create');
        },
      );
    }

    final place = selectedPlace!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuToolbar(
          selectedPlace: place,
          places: places,
          onPlaceSelected: selectPlace,
          onAddItem: () => openMenuItemForm(),
          onAddCategory: createCategory,
        ),

        const SizedBox(height: 8),

        Text(
          place.address.displayName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        if (error != null) ...[
          const SizedBox(height: 16),
          DsInlineError(message: error!),
        ],

        const SizedBox(height: 24),

        if (place.menuItems.isEmpty)
          DsEmptyState(
            icon: Icons.restaurant_menu_outlined,
            title: 'Nenhum item no cardapio',
            message:
                'Cadastre pratos, bebidas ou combos para exibir no estabelecimento.',
            actionLabel: 'Adicionar item',
            onAction: () => openMenuItemForm(),
          )
        else
          ..._itemsByCategory(place).entries.map((entry) {
            return MenuCategorySection(
              title: entry.key,
              items: entry.value,
              onAdd: () {
                openMenuItemForm(null, entry.key);
              },
              onEdit: openMenuItemForm,
              onDelete: deleteMenuItem,
            );
          }),
      ],
    );
  }
}
