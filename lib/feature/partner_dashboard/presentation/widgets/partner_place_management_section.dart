import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class PartnerPlaceManagementSection extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback onOpenPlace;
  final VoidCallback onEditPlace;
  final VoidCallback onManageMenu;
  final VoidCallback onCreateEvent;

  const PartnerPlaceManagementSection({
    super.key,
    required this.place,
    required this.onOpenPlace,
    required this.onEditPlace,
    required this.onManageMenu,
    required this.onCreateEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestão do estabelecimento',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Atualize o perfil público, organize o cardápio e publique a programação de ${place.name}.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900
                ? 4
                : constraints.maxWidth >= 560
                ? 2
                : 1;
            const gap = DsSpacing.md;
            final width =
                (constraints.maxWidth - (gap * (columns - 1))) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                _ManagementAction(
                  width: width,
                  icon: Icons.edit_outlined,
                  title: 'Informações',
                  description: 'Dados, contatos, horários e fotos',
                  actionLabel: 'Editar local',
                  onTap: onEditPlace,
                ),
                _ManagementAction(
                  width: width,
                  icon: Icons.restaurant_menu_outlined,
                  title: 'Cardápio',
                  description:
                      '${place.menuItems.length} item(ns) publicado(s)',
                  actionLabel: 'Gerenciar',
                  onTap: onManageMenu,
                ),
                _ManagementAction(
                  width: width,
                  icon: Icons.event_outlined,
                  title: 'Programação',
                  description: 'Crie um evento vinculado a este local',
                  actionLabel: 'Criar evento',
                  onTap: onCreateEvent,
                ),
                _ManagementAction(
                  width: width,
                  icon: Icons.open_in_new,
                  title: 'Página pública',
                  description: 'Confira como o público vê o local',
                  actionLabel: 'Visualizar',
                  onTap: onOpenPlace,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ManagementAction extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onTap;

  const _ManagementAction({
    required this.width,
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 200,
      child: Material(
        color: DsColors.publicSurface,
        borderRadius: BorderRadius.circular(DsRadius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DsRadius.sm),
          child: Container(
            padding: const EdgeInsets.all(DsSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF333333)),
              borderRadius: BorderRadius.circular(DsRadius.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: DsColors.accent, size: 28),
                const SizedBox(height: 20),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      actionLabel,
                      style: const TextStyle(
                        color: DsColors.publicText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
