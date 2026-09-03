import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';

class PartnerEventTile extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onTransfer;

  const PartnerEventTile({
    super.key,
    required this.event,
    required this.onOpen,
    required this.onEdit,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EventCover(coverImage: event.coverImage),
              const SizedBox(width: 16),
              Expanded(child: _EventSummary(event: event)),
              Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    tooltip: 'Ver evento',
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new),
                  ),
                  IconButton(
                    tooltip: 'Editar evento',
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Transferir evento',
                    onPressed: onTransfer,
                    icon: const Icon(Icons.swap_horiz),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _EventDetails(event: event),
          if (event.musicGenres.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: event.musicGenres
                  .map((genre) => Chip(label: Text(genre.label)))
                  .toList(),
            ),
          ],
          if (event.attractions.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Atracoes: ${event.attractions.map((e) => e.name).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          _EventMetrics(event: event),
        ],
      ),
    );
  }
}

class _EventSummary extends StatelessWidget {
  final EventEntity event;

  const _EventSummary({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        Text(
          event.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(icon: Icons.flag_outlined, label: event.status.label),
            _InfoChip(icon: Icons.person_outline, label: event.createdBy.name),
            if (event.instagram != null)
              _InfoChip(icon: Icons.alternate_email, label: event.instagram!),
          ],
        ),
      ],
    );
  }
}

class _EventDetails extends StatelessWidget {
  final EventEntity event;

  const _EventDetails({required this.event});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        _Detail(icon: Icons.place_outlined, text: event.locationName),
        _Detail(icon: Icons.map_outlined, text: event.address.fullAddress),
        _Detail(
          icon: Icons.schedule,
          text:
              '${_formatEventDate(event.startDate)} ate ${_formatEventDate(event.endDate)}',
        ),
        _Detail(icon: Icons.confirmation_number_outlined, text: _ticket),
        _Detail(
          icon: Icons.photo_library_outlined,
          text: '${event.gallery.length} foto(s) na galeria',
        ),
      ],
    );
  }

  String get _ticket {
    if (event.ticket.isFree) return 'Gratuito';
    return event.ticket.ticketUrl?.isNotEmpty == true
        ? event.ticket.ticketUrl!
        : 'Ingresso externo';
  }

  String _formatEventDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} - $hour:$minute';
  }
}

class _EventCover extends StatelessWidget {
  final String coverImage;

  const _EventCover({required this.coverImage});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 112,
        height: 112,
        color: DsColors.adminBackground,
        child: coverImage.isEmpty
            ? const Icon(Icons.music_note)
            : Image.memory(
                ImageHelper.base64ToBytes(coverImage),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Detail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: DsColors.adminTextMuted),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text.isEmpty ? 'Nao informado' : text,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetrics extends StatelessWidget {
  final EventEntity event;

  const _EventMetrics({required this.event});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        _EventMetric(icon: Icons.visibility_outlined, value: event.views),
        _EventMetric(
          icon: Icons.local_fire_department_outlined,
          value: event.boraCount,
        ),
        _EventMetric(
          icon: Icons.how_to_reg_outlined,
          value: event.checkinCount,
        ),
        _EventMetric(icon: Icons.share_outlined, value: event.shares),
      ],
    );
  }
}

class _EventMetric extends StatelessWidget {
  final IconData icon;
  final int value;

  const _EventMetric({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: DsColors.adminTextMuted),
        const SizedBox(width: 5),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
