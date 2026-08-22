import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PlaceDetailsSheet extends StatelessWidget {
  const PlaceDetailsSheet({super.key, required this.place});

  final PlaceEntity place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .55,
      minChildSize: .35,
      maxChildSize: .95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              const SizedBox(height: 12),

              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (place.photos.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.memory(
                      ImageHelper.base64ToBytes(place.photos.first),
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          size: 72,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        const Text("Nenhuma foto cadastrada"),
                      ],
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, style: theme.textTheme.headlineMedium),

                    const SizedBox(height: 12),

                    Text(place.description),

                    const SizedBox(height: 24),

                    Text("📍 Endereço", style: theme.textTheme.titleMedium),

                    const SizedBox(height: 8),

                    Text(place.address.fullAddress),

                    if (place.instagram.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      Text("📸 Instagram", style: theme.textTheme.titleMedium),

                      const SizedBox(height: 8),

                      Text(place.instagram),
                    ],

                    if (place.phone.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      Text("📞 Telefone", style: theme.textTheme.titleMedium),

                      const SizedBox(height: 8),

                      Text(place.phone),
                    ],

                    if (place.website.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      Text("🌐 Website", style: theme.textTheme.titleMedium),

                      const SizedBox(height: 8),

                      Text(place.website),
                    ],

                    if (place.musicGenres.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      Text("🎵 Gêneros", style: theme.textTheme.titleMedium),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: place.musicGenres
                            .map((genre) => Chip(label: Text(genre.name)))
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);

                          Modular.to.pushNamed(
                            '/place',
                            arguments: place,
                          );
                        },
                        icon: const Icon(Icons.event),
                        label: const Text("Ver agenda da casa"),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
