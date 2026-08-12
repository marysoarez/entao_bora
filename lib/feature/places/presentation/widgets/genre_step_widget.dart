import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class GenreStep extends StatelessWidget {
  const GenreStep({super.key, required this.vm,
  });

  final CreatePlaceViewModel vm;

  @override
  Widget build(BuildContext context) {

    return Observer(
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              "Estilos musicais",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              "Selecione todos os estilos que normalmente tocam neste estabelecimento.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: MusicGenre.values.map((genre) {
                final selected = vm.musicGenres.contains(genre);

                return FilterChip(
                  label: Text(genre.label),
                  selected: selected,
                  showCheckmark: false,
                  avatar: selected
                      ? const Icon(
                          Icons.check,
                          size: 18,
                        )
                      : null,
                  onSelected: (_) {
                    vm.toggleGenre(genre);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            if (vm.musicGenres.isNotEmpty) ...[
              Text(
                "Selecionados",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: vm.musicGenres.map((genre) {
                      return Chip(
                        label: Text(genre.label),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          vm.toggleGenre(genre);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ] else ...[
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.music_note_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Selecione pelo menos um estilo musical para ajudar os usuários a encontrarem o estabelecimento.",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}