import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/partner_dashboard/presentation/widgets/partner_event_tile.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class PartnerEventsSection extends StatelessWidget {
  final List<EventEntity> events;
  final VoidCallback onCreateEvent;
  final ValueChanged<EventEntity> onOpenEvent;
  final ValueChanged<EventEntity> onEditEvent;
  final ValueChanged<EventEntity> onTransferEvent;

  const PartnerEventsSection({
    super.key,
    required this.events,
    required this.onCreateEvent,
    required this.onOpenEvent,
    required this.onEditEvent,
    required this.onTransferEvent,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return DsEmptyState(
        icon: Icons.event_busy_outlined,
        title: 'Nenhum evento futuro',
        message:
            'Publique o proximo evento para acompanhar os resultados por aqui.',
        actionLabel: 'Criar evento',
        onAction: onCreateEvent,
      );
    }

    return Card(
      child: Column(
        children: [
          for (var index = 0; index < events.length; index++) ...[
            PartnerEventTile(
              event: events[index],
              onOpen: () => onOpenEvent(events[index]),
              onEdit: () => onEditEvent(events[index]),
              onTransfer: () => onTransferEvent(events[index]),
            ),
            if (index != events.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
