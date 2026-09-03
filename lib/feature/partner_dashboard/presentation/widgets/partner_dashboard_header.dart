import 'package:flutter/material.dart';

class PartnerDashboardHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onCreateEvent;
  final VoidCallback onCreatePlace;

  const PartnerDashboardHeader({
    super.key,
    required this.userName,
    required this.onCreateEvent,
    required this.onCreatePlace,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ola, $userName',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Acompanhe os eventos que voce criou e veja os resultados publicados.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: onCreateEvent,
          icon: const Icon(Icons.add),
          label: const Text('Criar evento'),
        ),
        OutlinedButton.icon(
          onPressed: onCreatePlace,
          icon: const Icon(Icons.add_business_outlined),
          label: const Text('Novo local'),
        ),
      ],
    );
  }
}
