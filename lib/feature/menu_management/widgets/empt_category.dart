import 'package:flutter/material.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';

class EmptyCategory extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyCategory({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 500;

            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: DsColors.adminTextMuted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Categoria sem itens.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar item'),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: DsColors.adminTextMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Categoria sem itens.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar item'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}