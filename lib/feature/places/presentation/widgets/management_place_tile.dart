import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_info_chip.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_photo.dart';
import 'package:flutter/material.dart';

class PlaceManagementTile extends StatelessWidget {
  final PlaceEntity place;

  final VoidCallback onOpen;
  final VoidCallback onDashboard;
  final VoidCallback onMenu;
  final VoidCallback onEdit;

  const PlaceManagementTile({
    super.key,
    required this.place,
    required this.onOpen,
    required this.onDashboard,
    required this.onMenu,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          return _buildMobile(context);
        }

        return _buildDesktop(context);
      },
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlacePhoto(place: place, size: 88),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      place.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                tooltip: 'Opcoes',
                onSelected: (value) {
                  switch (value) {
                    case 'open':
                      onOpen();
                      break;

                    case 'dashboard':
                      onDashboard();
                      break;

                    case 'menu':
                      onMenu();
                      break;

                    case 'edit':
                      onEdit();
                      break;
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: 'open',
                      child: _MenuOption(
                        icon: Icons.open_in_new,
                        label: 'Abrir pagina',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'dashboard',
                      child: _MenuOption(
                        icon: Icons.dashboard_outlined,
                        label: 'Eventos e cardapio',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'menu',
                      child: _MenuOption(
                        icon: Icons.restaurant_menu_outlined,
                        label: 'Editar cardapio',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: _MenuOption(
                        icon: Icons.edit_outlined,
                        label: 'Editar estabelecimento',
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildInfo(),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlacePhoto(place: place),

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

                _buildInfo(),
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

  Widget _buildInfo() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        PlaceInfoChip(
          icon: Icons.place_outlined,
          label: place.address.city ?? place.address.displayName,
        ),
        PlaceInfoChip(
          icon: Icons.restaurant_menu_outlined,
          label: '${place.menuItems.length} item(s)',
        ),
        PlaceInfoChip(
          icon: Icons.photo_library_outlined,
          label: '${place.photos.length} foto(s)',
        ),
      ],
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon), const SizedBox(width: 10), Text(label)]);
  }
}
