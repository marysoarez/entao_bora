import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventInfo extends StatelessWidget {
  const EventInfo({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final start = DateFormat('dd MMM - HH:mm', 'pt_BR').format(event.startDate);
    final end = DateFormat('HH:mm', 'pt_BR').format(event.endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoTile(
          icon: Icons.calendar_month_rounded,
          title: 'Quando',
          value: '$start ate $end',
        ),
        const SizedBox(height: DsSpacing.sm),
        _InfoTile(
          icon: Icons.location_on_rounded,
          title: 'Onde',
          value: event.locationName,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: DsColors.accent.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(DsRadius.sm),
            border: Border.all(color: DsColors.accent.withValues(alpha: .35)),
          ),
          child: Icon(icon, color: DsColors.accent, size: 22),
        ),
        const SizedBox(width: DsSpacing.md - 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: DsColors.publicTextSubtle,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DsSpacing.xxs - 1),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: DsColors.publicText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
