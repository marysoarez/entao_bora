import 'package:flutter/material.dart';

class ManagePlacesHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onCreatePlace;

  const ManagePlacesHeader({
    super.key,
    required this.userName,
    required this.onCreatePlace,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        final text = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ola, $userName',
              style:
                  Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Controle seus estabelecimentos publicados.',
              style:
                  Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );

        final button = FilledButton.icon(
          onPressed: onCreatePlace,
          icon: const Icon(Icons.add),
          label: const Text('Novo local'),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text,
              const SizedBox(height: 16),
              button,
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: text,
            ),
            const SizedBox(width: 16),
            button,
          ],
        );
      },
    );
  }
}