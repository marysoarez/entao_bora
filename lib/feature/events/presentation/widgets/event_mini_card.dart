import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/presentation/widgets/evevnt_mini_header.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/events_bora_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EventMiniCard extends StatefulWidget {
  const EventMiniCard({super.key, required this.event, required this.place});

  final EventEntity event;
  final PlaceEntity? place;
  @override
  State<EventMiniCard> createState() => _EventMiniCardState();
}

class _EventMiniCardState extends State<EventMiniCard> {
  late final EventActionsViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = EventActionsViewModel(
      Modular.get<IEventRepository>(),
      Modular.get<ILocationRepository>(),
      Modular.get<IAuthRepository>(),
      widget.event,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final event = vm.event;
        final start = DateFormat(
          "dd MMM • HH:mm",
          "pt_BR",
        ).format(event.startDate);

        final end = DateFormat("HH:mm", "pt_BR").format(event.endDate);
        return Card(
          elevation: 0,
          color: DsColors.publicSurface,
          margin: const EdgeInsets.symmetric(
            horizontal: DsSpacing.md,
            vertical: DsSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsRadius.xxl - 2),
            side: BorderSide(color: DsColors.accent.withValues(alpha: .15)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventMiniHeader(
                event: event,
                onShare: () {
                  final baseUrl = 'https://entaobora.com.br';

                  final url = '$baseUrl/#/events/${event.id}';

                  showShareEventDialog(
                    context: context,
                    title: event.title,
                    url: url,
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(DsSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      icon: Icons.calendar_month_rounded,
                      text: "$start até $end",
                    ),

                    const SizedBox(height: 10),

                    _DetailRow(
                      icon: Icons.confirmation_number_outlined,
                      text: event.ticket.type.label,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1),
                    ),

                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.bolt,
                          color: Colors.amber,
                          label: "Bora",
                          value: event.boraCount,
                        ),

                        const SizedBox(width: 20),

                        _StatChip(
                          icon: Icons.how_to_reg,
                          color: Colors.greenAccent,
                          label: "Check-ins",
                          value: event.checkinCount,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showShareEventDialog({
    required BuildContext context,
    required String title,
    required String url,
  }) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.green),
                title: const Text('Compartilhar no WhatsApp'),
                onTap: () async {
                  Navigator.pop(context);

                  final text = Uri.encodeComponent('🤘 $title\n\n$url');

                  final uri = Uri.parse('https://wa.me/?text=$text');

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Copiar link'),
                onTap: () async {
                  Navigator.pop(context);

                  await Clipboard.setData(ClipboardData(text: url));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copiado!')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Mais opções'),
                onTap: () async {
                  Navigator.pop(context);

                  await SharePlus.instance.share(
                    ShareParams(text: '🤘 $title\n\n$url'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: DsColors.accent),
        const SizedBox(width: DsSpacing.sm - 2),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: DsColors.publicText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DsSpacing.sm,
        vertical: DsSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: DsColors.publicText.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(DsRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: DsSpacing.xs - 2),
          Text(
            "$value",
            style: const TextStyle(
              color: DsColors.publicText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: DsSpacing.xxs),
          Text(
            label,
            style: const TextStyle(
              color: DsColors.publicTextMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
