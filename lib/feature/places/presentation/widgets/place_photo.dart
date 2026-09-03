import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';

class PlacePhoto extends StatelessWidget {
  final PlaceEntity place;
  final double size;

  const PlacePhoto({
    super.key,
    required this.place,
    this.size = 112,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        color: DsColors.adminBackground,
        child: place.photos.isEmpty
            ? const Icon(
                Icons.storefront_outlined,
              )
            : Image.memory(
                ImageHelper.base64ToBytes(
                  place.photos.first,
                ),
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.broken_image,
                  );
                },
              ),
      ),
    );
  }
}