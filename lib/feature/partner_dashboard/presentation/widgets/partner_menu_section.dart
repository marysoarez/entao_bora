import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';

class PartnerMenuSection extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback onManageMenu;

  const PartnerMenuSection({
    super.key,
    required this.place,
    required this.onManageMenu,
  });

  @override
  Widget build(BuildContext context) {
    final items = place.menuItems;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.restaurant_menu_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cardapio',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items.isEmpty
                        ? 'Nenhum item cadastrado.'
                        : '${items.length} item(s) cadastrado(s).',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: onManageMenu,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar cardapio'),
            ),
          ],
        ),
      ),
    );
  }
}
