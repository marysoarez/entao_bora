import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/presentation/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';

class PlaceOwnerSection extends StatelessWidget {
  final PlaceEntity place;
  final String? currentUserId;
  final VoidCallback onEdit;

  const PlaceOwnerSection({
    super.key,
    required this.place,
    required this.currentUserId,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (place.ownerId.isPartner) ...[
          Row(
            children: [
              UserAvatar(photoUrl: place.ownerId.photoUrl, radius: 22),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ResponsÃ¡vel',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  Text(
                    place.ownerId.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
        if (currentUserId == place.ownerId.id)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: FilledButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Editar estabelecimento"),
              onPressed: onEdit,
            ),
          ),
      ],
    );
  }
}
