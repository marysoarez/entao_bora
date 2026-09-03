import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';

class PlaceAbout extends StatelessWidget {
  final PlaceEntity place;

  const PlaceAbout({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sobre",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            place.description,
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }
}
