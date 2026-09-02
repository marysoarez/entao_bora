import 'package:entao_bora/core/app_theme.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
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

  Future<void> openMenuItemForm([MenuItemEntity? item]) async {
    final place = selectedPlace;
    if (place == null) return;

    final savedItem = await showDialog<MenuItemEntity>(
      context: context,
      builder: (context) => _MenuItemDialog(item: item),
    );

    if (savedItem == null) return;

    final updatedItems = item == null
        ? [...place.menuItems, savedItem]
        : place.menuItems
              .map((current) => current.id == item.id ? savedItem : current)
              .toList();

    await _saveMenuItems(place, updatedItems);
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

    await _saveMenuItems(
      place,
      place.menuItems.where((current) => current.id != item.id).toList(),
    );
  }

  Future<void> _saveMenuItems(
    PlaceEntity place,
    List<MenuItemEntity> menuItems,
  ) async {
    setState(() {
      loading = true;
      error = null;
    });

    final updatedPlace = place.copyWith(menuItems: menuItems);
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
      backgroundColor: AppTheme.background,
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildContent(),
                ),
              ),
            ),
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
      return _EmptyState(
        icon: Icons.lock_outline,
        title: 'Nao foi possivel editar o cardapio',
        message: error!,
        actionLabel: 'Tentar novamente',
        onAction: loadMenu,
      );
    }

    if (places.isEmpty) {
      return _EmptyState(
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
          ],
        ),
        const SizedBox(height: 8),
        Text(
          place.address.displayName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (error != null) ...[
          const SizedBox(height: 16),
          _InlineError(message: error!),
        ],
        const SizedBox(height: 24),
        if (items.isEmpty)
          _EmptyState(
            icon: Icons.restaurant_menu_outlined,
            title: 'Nenhum item no cardapio',
            message:
                'Cadastre pratos, bebidas ou combos para exibir no estabelecimento.',
            actionLabel: 'Adicionar item',
            onAction: () => openMenuItemForm(),
          )
        else
          Card(
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  _MenuItemTile(
                    item: items[index],
                    onEdit: () => openMenuItemForm(items[index]),
                    onDelete: () => deleteMenuItem(items[index]),
                  ),
                  if (index != items.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _MenuItemDialog extends StatefulWidget {
  final MenuItemEntity? item;

  const _MenuItemDialog({this.item});

  @override
  State<_MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<_MenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _picker = ImagePicker();

  String _photo = '';
  bool _processingPhoto = false;

  @override
  void initState() {
    super.initState();

    final item = widget.item;
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

    Navigator.of(context).pop(
      MenuItemEntity(
        id: widget.item?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _parsePrice(_priceController.text),
        photo: _photo,
      ),
    );
  }

  double _parsePrice(String value) {
    return double.parse(value.replaceAll('.', '').replaceAll(',', '.'));
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
                      color: AppTheme.background,
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
                  decoration: const InputDecoration(labelText: 'Preco'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o preco.';
                    }

                    final price = double.tryParse(
                      value.replaceAll('.', '').replaceAll(',', '.'),
                    );

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
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
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
        color: AppTheme.background,
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

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 34, color: AppTheme.primary),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondary),
      ),
    );
  }
}
