import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/presentation/widgets/public_menu_item_tile.dart';
import 'package:flutter/material.dart';

class PlaceMenuSheet extends StatelessWidget {
  final PlaceEntity place;

  const PlaceMenuSheet({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final groupedItems = _itemsByCategory(place.menuItems);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.42,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return SafeArea(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text(
                'Cardapio',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(place.name, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
              for (final entry in groupedItems.entries) ...[
                Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                for (final item in entry.value) ...[
                  PublicMenuItemTile(item: item),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }

  Map<String, List<MenuItemEntity>> _itemsByCategory(
    List<MenuItemEntity> items,
  ) {
    final grouped = <String, List<MenuItemEntity>>{};

    for (final item in items) {
      final category = item.category.trim().isEmpty ? 'Geral' : item.category;
      grouped.putIfAbsent(category, () => []).add(item);
    }

    return grouped;
  }
}
