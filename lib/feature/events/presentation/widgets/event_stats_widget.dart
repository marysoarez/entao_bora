import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_stat_widget.dart';
import 'package:flutter/material.dart';

class EventStats extends StatelessWidget {
  const EventStats({super.key, required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EventStat(
            icon: Icons.visibility_outlined,
            label: "Views",
            value: event.views,
          ),
        ),
        Expanded(
          child: EventStat(
            icon: Icons.favorite,
            label: "Bora",
            value: event.boraCount,
            color: Colors.redAccent,
          ),
        ),
        Expanded(
          child: EventStat(
            icon: Icons.location_on,
            label: "Check-in",
            value: event.checkinCount,
            color: Colors.greenAccent,
          ),
        ),
        Expanded(
          child: EventStat(
            icon: Icons.share_outlined,
            label: "Compart.",
            value: event.shares,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
