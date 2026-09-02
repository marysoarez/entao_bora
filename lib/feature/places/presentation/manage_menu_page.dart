import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/errors/image_exception.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

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
    if (partnerPlaces.isEmpty) return null;

    final currentSelected = selectedPlace;
    if (currentSelected != null) {
      for (final place in partnerPlaces) {
        if (place.id == currentSelected.id) return place;
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
      builder: (context) => _MenuItemDialog(
        item: item,
        categories: _categoriesFor(place),
        initialCategory: initialCategory,
      ),
    );

    if (savedItem == null) return;

    final updatedItems = item == null
        ? [...place.menuItems, savedItem]
        : place.menuItems
              .map((current) => current.id == item.id ? savedItem : current)
              .toList();

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

    final controller = TextEditingController();

    final category = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova categoria'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome da categoria',
              hintText: 'Ex: Drinks, Porcoes, Sobremesas',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (category == null || category.isEmpty) return;

    final exists = _categoriesFor(
      place,
    ).any((current) => current.toLowerCase() == category.toLowerCase());

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

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir item'),
          content: Text('Deseja excluir "${item.title}" do cardapio?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

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
          places = places
              .map(
                (current) =>
                    current.id == updatedPlace.id ? updatedPlace : current,
              )
              .toList();
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
        onAction: () => Modular.to.pushNamed('/places/create'),
      );
    }

    final place = selectedPlace!;
    final items = place.menuItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.restaurant_menu_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PlaceEntity>(
                  isExpanded: true,
                  value: place,
                  items: places.map((place) {
                    return DropdownMenuItem(
                      value: place,
                      child: Text(place.name),
                    );
                  }).toList(),
                  onChanged: (place) {
                    if (place != null) selectPlace(place);
                  },
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () => openMenuItemForm(),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar item'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: createCategory,
              icon: const Icon(Icons.create_new_folder_outlined),
              label: const Text('Nova categoria'),
            ),
          ],
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
        if (items.isEmpty)
          DsEmptyState(
            icon: Icons.restaurant_menu_outlined,
            title: 'Nenhum item no cardapio',
            message:
                'Cadastre pratos, bebidas ou combos para exibir no estabelecimento.',
            actionLabel: 'Adicionar item',
            onAction: () => openMenuItemForm(),
          )
        else
          for (final entry in _itemsByCategory(place).entries) ...[
            _CategoryHeader(title: entry.key, count: entry.value.length),
            const SizedBox(height: 10),
            if (entry.value.isEmpty)
              _EmptyCategory(onAdd: () => openMenuItemForm(null, entry.key))
            else
              Card(
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < entry.value.length;
                      index++
                    ) ...[
                      _MenuItemTile(
                        item: entry.value[index],
                        onEdit: () => openMenuItemForm(entry.value[index]),
                        onDelete: () => deleteMenuItem(entry.value[index]),
                      ),
                      if (index != entry.value.length - 1)
                        const Divider(height: 1),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
      ],
    );
  }
}

class _MenuItemDialog extends StatefulWidget {
  final MenuItemEntity? item;
  final List<String> categories;
  final String? initialCategory;

  const _MenuItemDialog({
    this.item,
    required this.categories,
    this.initialCategory,
  });

  @override
  State<_MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<_MenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _picker = ImagePicker();

  String _photo = '';
  String? _selectedCategory;
  bool _processingPhoto = false;

  @override
  void initState() {
    super.initState();

    final item = widget.item;
    _selectedCategory = item?.category.trim().isNotEmpty == true
        ? item!.category
        : widget.initialCategory ?? widget.categories.first;

    if (item == null) return;

    _titleController.text = item.title;
    _descriptionController.text = item.description;
    _priceController.text = item.price.toStringAsFixed(2).replaceAll('.', ',');
    _photo = item.photo;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_processingPhoto) return;

    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _processingPhoto = true;
    });

    try {
      final base64 = await ImageHelper.fileToBase64(image);

      if (!mounted) return;

      setState(() {
        _photo = base64;
      });
    } on ImageTooLargeException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel processar a imagem.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _processingPhoto = false;
        });
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final category = _categoryController.text.trim().isNotEmpty
        ? _categoryController.text.trim()
        : _selectedCategory?.trim() ?? 'Geral';

    Navigator.of(context).pop(
      MenuItemEntity(
        id: widget.item?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _parsePrice(_priceController.text),
        photo: _photo,
        category: category,
      ),
    );
  }

  double _parsePrice(String value) {
    final normalized = value.contains(',')
        ? value.replaceAll('.', '').replaceAll(',', '.')
        : value;

    return double.parse(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Novo item' : 'Editar item'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: _processingPhoto ? null : _pickPhoto,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      color: DsColors.adminBackground,
                    ),
                    child: _processingPhoto
                        ? const Center(child: CircularProgressIndicator())
                        : _photo.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 42,
                              ),
                              SizedBox(height: 8),
                              Text('Selecionar foto'),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              ImageHelper.base64ToBytes(_photo),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: widget.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _categoryController.clear();
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Nova categoria personalizada',
                    hintText: 'Ex: Drinks, Porcoes, Sobremesas',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Titulo'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe o titulo.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descricao'),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe a descricao.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Preco',
                    prefixText: 'R\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o preco.';
                    }

                    final normalized = value.contains(',')
                        ? value.replaceAll('.', '').replaceAll(',', '.')
                        : value;
                    final price = double.tryParse(normalized);

                    if (price == null || price <= 0) {
                      return 'Informe um preco valido.';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Salvar')),
      ],
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final MenuItemEntity item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MenuItemTile({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MenuItemPhoto(photo: item.photo),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  _formatPrice(item.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              IconButton(
                tooltip: 'Editar item',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Excluir item',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double value) {
    return DsFormatters.brl(value);
  }
}

class _CategoryHeader extends StatelessWidget {
  final String title;
  final int count;

  const _CategoryHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Chip(
          label: Text('$count item(s)'),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyCategory({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: DsColors.adminTextMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Categoria sem itens.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar item'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemPhoto extends StatelessWidget {
  final String photo;

  const _MenuItemPhoto({required this.photo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 112,
        height: 112,
        color: DsColors.adminBackground,
        child: photo.isEmpty
            ? const Icon(Icons.restaurant_menu_outlined)
            : Image.memory(
                ImageHelper.base64ToBytes(photo),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
      ),
    );
  }
}
