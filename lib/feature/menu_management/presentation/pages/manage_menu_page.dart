import 'package:entao_bora/feature/menu_management/presentation/dialogs/confirma_delete_dialog.dart';
import 'package:entao_bora/feature/menu_management/presentation/dialogs/create_category_dialog.dart';
import 'package:entao_bora/feature/menu_management/presentation/dialogs/menu_item_dialog.dart';
import 'package:entao_bora/feature/menu_management/presentation/viewmodels/manage_menu_viewmodel.dart';
import 'package:entao_bora/feature/menu_management/presentation/widgets/menu_category_section.dart';
import 'package:entao_bora/feature/menu_management/presentation/widgets/menu_toolbar.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ManageMenuPage extends StatefulWidget {
  final PlaceEntity? place;

  const ManageMenuPage({super.key, this.place});

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  late final ManageMenuViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = Modular.get<ManageMenuViewModel>();
    vm.load(initialPlace: widget.place);
  }

  Future<void> _openMenuItemForm([
    MenuItemEntity? item,
    String? initialCategory,
  ]) async {
    final place = vm.selectedPlace;

    if (place == null) return;

    final savedItem = await showDialog<MenuItemEntity>(
      context: context,
      builder: (context) {
        return MenuItemDialog(
          item: item,
          categories: vm.categoriesFor(place),
          initialCategory: initialCategory,
        );
      },
    );

    if (savedItem == null) return;

    final success = await vm.saveMenuItem(savedItem, replacingItem: item);

    if (!mounted) return;

    _showSaveFeedback(success);
  }

  Future<void> _createCategory() async {
    final category = await showCreateCategoryDialog(context);

    if (category == null || category.isEmpty) {
      return;
    }

    final success = await vm.createCategory(category);

    if (!mounted) return;

    _showSaveFeedback(success);
  }

  Future<void> _deleteMenuItem(MenuItemEntity item) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      itemName: item.title,
    );

    if (!confirmed) return;

    final success = await vm.deleteMenuItem(item);

    if (!mounted) return;

    _showSaveFeedback(success);
  }

  void _showSaveFeedback(bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Cardapio atualizado.' : vm.error ?? 'Erro ao salvar.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: DsColors.adminBackground,
          appBar: AppBar(
            title: const Text('Editar cardapio'),
            actions: [
              IconButton(
                tooltip: 'Atualizar',
                onPressed: vm.loading ? null : () => vm.load(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: vm.loading
              ? const Center(child: CircularProgressIndicator())
              : DsAdminPage(
                  maxWidth: DsSizes.maxFormWidth,
                  child: _buildContent(),
                ),
          floatingActionButton: vm.canEditMenu
              ? FloatingActionButton.extended(
                  onPressed: () => _openMenuItemForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar item'),
                )
              : null,
        );
      },
    );
  }

  Widget _buildContent() {
    if (vm.error != null && !vm.hasPlaces) {
      return DsEmptyState(
        icon: Icons.lock_outline,
        title: 'Nao foi possivel editar o cardapio',
        message: vm.error!,
        actionLabel: 'Tentar novamente',
        onAction: () => vm.load(),
      );
    }

    if (!vm.hasPlaces) {
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

    final place = vm.selectedPlace!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuToolbar(
          selectedPlace: place,
          places: vm.places,
          onPlaceSelected: vm.selectPlace,
          onAddItem: () => _openMenuItemForm(),
          onAddCategory: _createCategory,
        ),
        const SizedBox(height: 8),
        Text(
          place.address.displayName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (vm.error != null) ...[
          const SizedBox(height: 16),
          DsInlineError(message: vm.error!),
        ],
        const SizedBox(height: 24),
        if (place.menuItems.isEmpty)
          DsEmptyState(
            icon: Icons.restaurant_menu_outlined,
            title: 'Nenhum item no cardapio',
            message:
                'Cadastre pratos, bebidas ou combos para exibir no estabelecimento.',
            actionLabel: 'Adicionar item',
            onAction: () => _openMenuItemForm(),
          )
        else
          ...vm.itemsByCategory.entries.map((entry) {
            return MenuCategorySection(
              title: entry.key,
              items: entry.value,
              onAdd: () {
                _openMenuItemForm(null, entry.key);
              },
              onEdit: _openMenuItemForm,
              onDelete: _deleteMenuItem,
            );
          }),
      ],
    );
  }
}
