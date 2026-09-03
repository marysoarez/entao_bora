import 'package:entao_bora/shared/design_system/ds_tokens.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';

class MenuItemPhoto extends StatelessWidget {
  final String photo;
  final double size;

  const MenuItemPhoto({super.key, required this.photo, this.size = 112});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
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
