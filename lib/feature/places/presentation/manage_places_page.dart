import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ManagePlacesPage extends StatefulWidget {
  const ManagePlacesPage({super.key});

  @override
  State<ManagePlacesPage> createState() => _ManagePlacesPageState();
}

class _ManagePlacesPageState extends State<ManagePlacesPage> {
  final _authRepository = Modular.get<IAuthRepository>();
  final _placeRepository = Modular.get<IPlaceRepository>();

  bool loading = true;
  String? error;
  UserSummaryEntity? user;
  List<PlaceEntity> places = [];

  @override
  void initState() {
    super.initState();
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    setState(() {
      loading = true;
      error = null;
    });

    final currentUser = await _authRepository.getCurrentUser();

    if (currentUser == null) {
      setState(() {
        user = null;
        loading = false;
        error = 'Faca login para acessar seus estabelecimentos.';
      });
      return;
    }

    if (!currentUser.isPartner) {
      setState(() {
        user = currentUser;
        loading = false;
        error = 'Voce precisa ser parceiro para controlar estabelecimentos.';
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

    if (!mounted) return;

    setState(() {
      user = currentUser;
      places = {
        for (final place in loadedPlaces) place.id: place,
      }.values.toList();
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

  Future<void> openCreatePlace() async {
    final created = await Modular.to.pushNamed('/places/create');

    if (created == true) {
      await loadPlaces();
    }
  }

  Future<void> openEditPlace(PlaceEntity place) async {
    final updated = await Modular.to.pushNamed(
      '/places/create',
      arguments: place,
    );

    if (updated == true) {
      await loadPlaces();
    }
  }

  void openPlaceDashboard(PlaceEntity place) {
    Modular.to.pushNamed('/partner-dashboard', arguments: place);
  }

  void openPlaceMenu(PlaceEntity place) {
    Modular.to.pushNamed('/places/menu', arguments: place);
  }

  void openPlaceDetails(PlaceEntity place) {
    Modular.to.pushNamed('/places/${place.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DsColors.adminBackground,
      appBar: AppBar(
        title: const Text('Meus estabelecimentos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: loading ? null : loadPlaces,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : DsAdminPage(maxWidth: DsSizes.maxFormWidth, child: _buildContent()),
      floatingActionButton: error == null
          ? FloatingActionButton.extended(
              onPressed: openCreatePlace,
              icon: const Icon(Icons.add_business_outlined),
              label: const Text('Novo local'),
            )
          : null,
    );
  }

  Widget _buildContent() {
    if (error != null) {
      return DsEmptyState(
        icon: Icons.lock_outline,
        title: 'Nao foi possivel abrir esta area',
        message: error!,
        actionLabel: 'Tentar novamente',
        onAction: loadPlaces,
      );
    }

    if (places.isEmpty) {
      return DsEmptyState(
        icon: Icons.storefront_outlined,
        title: 'Nenhum estabelecimento cadastrado',
        message:
            'Reivindique ou cadastre um local para controlar informacoes, eventos e cardapio.',
        actionLabel: 'Novo local',
        onAction: openCreatePlace,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ola, ${user?.name ?? 'parceiro'}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Controle seus estabelecimentos publicados.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: openCreatePlace,
              icon: const Icon(Icons.add),
              label: const Text('Novo local'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              for (var index = 0; index < places.length; index++) ...[
                _PlaceManagementTile(
                  place: places[index],
                  onOpen: () => openPlaceDetails(places[index]),
                  onDashboard: () => openPlaceDashboard(places[index]),
                  onMenu: () => openPlaceMenu(places[index]),
                  onEdit: () => openEditPlace(places[index]),
                ),
                if (index != places.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceManagementTile extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback onOpen;
  final VoidCallback onDashboard;
  final VoidCallback onMenu;
  final VoidCallback onEdit;

  const _PlaceManagementTile({
    required this.place,
    required this.onOpen,
    required this.onDashboard,
    required this.onMenu,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlacePhoto(place: place),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  place.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: Icons.place_outlined,
                      label: place.address.city ?? place.address.displayName,
                    ),
                    _InfoChip(
                      icon: Icons.restaurant_menu_outlined,
                      label: '${place.menuItems.length} item(s)',
                    ),
                    _InfoChip(
                      icon: Icons.photo_library_outlined,
                      label: '${place.photos.length} foto(s)',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              IconButton(
                tooltip: 'Abrir pagina',
                onPressed: onOpen,
                icon: const Icon(Icons.open_in_new),
              ),
              IconButton(
                tooltip: 'Eventos e cardapio',
                onPressed: onDashboard,
                icon: const Icon(Icons.dashboard_outlined),
              ),
              IconButton(
                tooltip: 'Editar cardapio',
                onPressed: onMenu,
                icon: const Icon(Icons.restaurant_menu_outlined),
              ),
              IconButton(
                tooltip: 'Editar estabelecimento',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlacePhoto extends StatelessWidget {
  final PlaceEntity place;

  const _PlacePhoto({required this.place});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 112,
        height: 112,
        color: DsColors.adminBackground,
        child: place.photos.isEmpty
            ? const Icon(Icons.storefront_outlined)
            : Image.memory(
                ImageHelper.base64ToBytes(place.photos.first),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}
