import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';

class PublicMenuItemTile extends StatelessWidget {
  final MenuItemEntity item;

  const PublicMenuItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 86,
              height: 86,
              color: Colors.white.withValues(alpha: .06),
              child: item.photo.isEmpty
                  ? const Icon(
                      Icons.restaurant_menu_outlined,
                      color: Colors.white54,
                    )
                  : Image.memory(
                      ImageHelper.base64ToBytes(item.photo),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.white54),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 8),
                Text(
                  DsFormatters.brl(item.price),
                  style: DsTextStyles.publicPrice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
