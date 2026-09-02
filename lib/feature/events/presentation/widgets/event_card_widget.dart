import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/widgets/login_widget.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_actions_widget.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_genres_widget.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_header_widget.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_info_widget.dart';
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
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.event, required this.place});

  final EventEntity event;
  final PlaceEntity? place;
  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
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
    return SingleChildScrollView(
      child: Observer(
        builder: (_) {
          final event = vm.event;

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
                EventHeader(
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
                      EventInfo(event: event),

                      const SizedBox(height: 14),

                      EventGenres(genres: event.musicGenres),

                      const SizedBox(height: 14),

                      Text(
                        event.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: DsTextStyles.publicBody,
                      ),

                      const SizedBox(height: 20),
                      if (event.createdBy.isPartner) ...[
                        Column(
                          children: [
                            const Text("Organizador:"),

                            if (event.createdBy.photoUrl?.isNotEmpty ?? false)
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                  event.createdBy.photoUrl!,
                                ),
                              )
                            else
                              const CircleAvatar(
                                radius: 28,
                                child: Icon(Icons.person),
                              ),

                            const SizedBox(height: 8),

                            Text(
                              event.createdBy.name.isNotEmpty
                                  ? event.createdBy.name
                                  : "Organizador",
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      EventActions(
                        vm: vm,
                        onLogin: () async {
                          final logged = await _ensureLogged(context);

                          if (!logged) return;

                          await vm.toggleBora();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  Future<bool> _ensureLogged(BuildContext context) async {
    if (vm.isLogged) {
      return true;
    }

    return await LoginDialog.show(context);
  }
}
