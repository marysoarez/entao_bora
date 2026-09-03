import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';

class PartnerPlaceSelector extends StatelessWidget {
  final List<PlaceEntity> places;
  final PlaceEntity? selectedPlace;
  final ValueChanged<PlaceEntity> onSelectPlace;
  final VoidCallback onEditPlace;

  const PartnerPlaceSelector({
    super.key,
    required this.places,
    required this.selectedPlace,
    required this.onSelectPlace,
    required this.onEditPlace,
  });

  @override
  Widget build(BuildContext context) {
    final place = selectedPlace;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront_outlined),
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
                        if (place != null) {
                          onSelectPlace(place);
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar estabelecimento',
                  onPressed: onEditPlace,
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            if (place != null) ...[
              const SizedBox(height: 12),
              Text(
                place.address.displayName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
