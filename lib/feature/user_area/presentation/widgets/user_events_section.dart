import 'dart:convert';

import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class UserEventsSection extends StatelessWidget {
  const UserEventsSection({
    super.key,
    required this.title,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.icon,
    required this.events,
  });

  final String title;
  final String emptyTitle;
  final String emptyMessage;
  final IconData icon;
  final List<EventEntity> events;

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      padding: const EdgeInsets.all(DsSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: DsColors.accent),
              const SizedBox(width: DsSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: DsColors.publicText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DsSpacing.md),
          if (events.isEmpty)
            _EmptyPanel(title: emptyTitle, message: emptyMessage)
          else
            Column(
              children: events
                  .map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: DsSpacing.sm),
                      child: _UserEventTile(event: event),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _UserEventTile extends StatelessWidget {
  const _UserEventTile({required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final start = DateFormat('dd MMM - HH:mm', 'pt_BR').format(event.startDate);

    return Material(
      color: DsColors.publicText.withValues(alpha: .05),
      borderRadius: BorderRadius.circular(DsRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(DsRadius.md),
        onTap: () => Modular.to.pushNamed(
          '/events/${event.slug.isNotEmpty ? event.slug : event.id}',
        ),
        child: Padding(
          padding: const EdgeInsets.all(DsSpacing.sm),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(DsRadius.xs),
                child: _EventThumb(coverImage: event.coverImage),
              ),
              const SizedBox(width: DsSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: DsColors.publicText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: DsSpacing.xxs),
                    Text(
                      event.locationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: DsColors.publicTextMuted),
                    ),
                    const SizedBox(height: DsSpacing.xxs),
                    Text(
                      start,
                      style: const TextStyle(color: DsColors.publicTextSubtle),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: DsColors.publicTextSubtle),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventThumb extends StatelessWidget {
  const _EventThumb({required this.coverImage});

  final String coverImage;

  @override
  Widget build(BuildContext context) {
    if (coverImage.isEmpty) {
      return Container(
        width: 72,
        height: 72,
        color: DsColors.publicBackground,
        child: const Icon(Icons.event, color: DsColors.publicTextSubtle),
      );
    }

    return Image.memory(
      base64Decode(coverImage),
      width: 72,
      height: 72,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 72,
          height: 72,
          color: DsColors.publicBackground,
          child: const Icon(
            Icons.broken_image,
            color: DsColors.publicTextSubtle,
          ),
        );
      },
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DsSpacing.lg),
      decoration: BoxDecoration(
        color: DsColors.publicText.withValues(alpha: .04),
        borderRadius: BorderRadius.circular(DsRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: DsColors.publicText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: DsSpacing.xs),
          Text(message, style: DsTextStyles.publicBody),
        ],
      ),
    );
  }
}
