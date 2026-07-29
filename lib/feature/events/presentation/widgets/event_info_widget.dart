import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventInfo extends StatelessWidget {
  const EventInfo({
    super.key,
    required this.event,
  });

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final start = DateFormat(
      "dd MMM • HH:mm",
      "pt_BR",
    ).format(event.startDate);

    final end = DateFormat(
      "HH:mm",
      "pt_BR",
    ).format(event.endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
        ),

        const SizedBox(height: 18),

        _InfoTile(
          icon: Icons.calendar_month_rounded,
          title: "Quando",
          value: "$start até $end",
        ),

        const SizedBox(height: 14),

        _InfoTile(
          icon: Icons.location_on_rounded,
          title: "Onde",
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
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.red.withOpacity(.35),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.redAccent,
            size: 22,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white54,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
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
