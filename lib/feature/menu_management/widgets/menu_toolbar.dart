import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';

class MenuToolbar extends StatelessWidget {
  final PlaceEntity selectedPlace;
  final List<PlaceEntity> places;
  final ValueChanged<PlaceEntity> onPlaceSelected;
  final VoidCallback onAddItem;
  final VoidCallback onAddCategory;

  const MenuToolbar({
    super.key,
    required this.selectedPlace,
    required this.places,
    required this.onPlaceSelected,
    required this.onAddItem,
    required this.onAddCategory,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        final placeSelector = Row(
          children: [
            const Icon(Icons.restaurant_menu_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PlaceEntity>(
                  isExpanded: true,
                  value: selectedPlace,
                  items: places.map((place) {
                    return DropdownMenuItem<PlaceEntity>(
                      value: place,
                      child: Text(
                        place.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (place) {
                    if (place != null) {
                      onPlaceSelected(place);
                    }
                  },
                ),
              ),
            ),
          ],
        );

        final actions = Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: onAddItem,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar item'),
            ),
            OutlinedButton.icon(
              onPressed: onAddCategory,
              icon: const Icon(Icons.create_new_folder_outlined),
              label: const Text('Nova categoria'),
            ),
          ],
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              placeSelector,
              const SizedBox(height: 12),
              actions,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: placeSelector),
            const SizedBox(width: 16),
            actions,
          ],
        );
      },
    );
  }
}