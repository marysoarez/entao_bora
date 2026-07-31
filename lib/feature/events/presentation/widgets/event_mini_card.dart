import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_info_widget.dart';
import 'package:entao_bora/feature/events/presentation/widgets/evevnt_mini_header.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
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
          color: const Color(0xff161616),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.red.withOpacity(.15)),
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
  padding: const EdgeInsets.all(16),
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

                  await Share.share('🤘 $title\n\n$url');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _ensureLogged(BuildContext context) async {
    if (vm.isLogged) {
      return true;
    }

    return await LoginDialog.show(context);
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.count,
    required this.countIcon,
    required this.countColor,
  });

  final IconData icon;
  final IconData countIcon;
  final String title;
  final String value;
  final Color countColor;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(.35)),
              ),
              child: Icon(icon, color: Colors.redAccent, size: 22),
            ),

            const SizedBox(width: 14),

            Column(
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
          ],
        ),
        const SizedBox(width: 14),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                // color: countColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: countColor),
              ),
              child: Icon(countIcon, color: countColor, size: 22),
            ),
            const SizedBox(width: 14),

            Text(
              count,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.redAccent,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}class _StatChip extends StatelessWidget {
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
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            "$value",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}