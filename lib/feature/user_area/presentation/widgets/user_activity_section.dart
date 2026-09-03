import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserActivitySection extends StatelessWidget {
  const UserActivitySection({super.key, required this.events});

  final List<EventEntity> events;

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Atividade recente',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: DsColors.publicText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: DsSpacing.md),
          if (events.isEmpty)
            const Text(
              'Suas atividades pessoais aparecem aqui conforme voce marca Bora ou faz check-in.',
              style: DsTextStyles.publicBody,
            )
          else
            ...events.map((event) => _ActivityItem(event: event)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM', 'pt_BR').format(event.startDate);
    final label = event.hasCheckedIn ? 'Check-in realizado' : 'Bora marcado';

    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: DsColors.accent.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(DsRadius.pill),
            ),
            child: Icon(
              event.hasCheckedIn ? Icons.how_to_reg : Icons.bolt,
              color: event.hasCheckedIn ? Colors.greenAccent : DsColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: DsSpacing.sm),
          Expanded(
            child: Text(
              '$label em ${event.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: DsColors.publicText),
            ),
          ),
          const SizedBox(width: DsSpacing.sm),
          Text(
            date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: DsColors.publicTextSubtle),
          ),
        ],
      ),
    );
  }
}
