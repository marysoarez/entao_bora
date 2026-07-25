import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PlaceDetailsPage extends StatelessWidget {
  final PlaceEntity place;

  const PlaceDetailsPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: ListView(
        children: [
          if (place.photos.isNotEmpty)
            Image.memory(
              ImageHelper.base64ToBytes(place.photos.first),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 240,
            )
          else
            Container(
              height: 240,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_outlined,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text("Nenhuma foto cadastrada"),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 12),

                Text(place.description),

                const SizedBox(height: 24),

                const Text(
                  "Endereço",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(place.address.fullAddress),

                if (place.instagram.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  const Text(
                    "Instagram",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(place.instagram),
                ],

                if (place.phone.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  const Text(
                    "Telefone",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(place.phone),
                ],

                if (place.website.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  const Text(
                    "Website",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(place.website),
                ],

                if (place.musicGenres.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  const Text(
                    "Gêneros musicais",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

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
                      Modular.to.pushNamed('/places/events', arguments: place);
                    },
                    icon: const Icon(Icons.event),
                    label: const Text('Ver próximos eventos'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
