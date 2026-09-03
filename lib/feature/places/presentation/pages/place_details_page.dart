import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/presentation/viewmodels/place_details_viewmodel.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_about.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_actions.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_events_section.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_hero.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_menu_sheet.dart';
import 'package:entao_bora/feature/places/presentation/widgets/place_owner_section.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/public_url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsByIdPage extends StatefulWidget {
  final String id;

  const PlaceDetailsByIdPage({super.key, required this.id});

  @override
  State<PlaceDetailsByIdPage> createState() => _PlaceDetailsByIdPageState();
}

class _PlaceDetailsByIdPageState extends State<PlaceDetailsByIdPage> {
  final vm = Modular.get<PlaceDetailsViewModel>();

  @override
  void initState() {
    super.initState();
    vm.load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (vm.loading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final place = vm.place;

        if (place == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  vm.error ?? 'Estabelecimento nao encontrado.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          );
        }

        return PlaceDetailsPage(place: place);
      },
    );
  }
}

class PlaceDetailsPage extends StatefulWidget {
  final PlaceEntity place;

  const PlaceDetailsPage({super.key, required this.place});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  final vm = Modular.get<PlaceDetailsViewModel>();
  final eventsVm = Modular.get<PlaceEventsViewModel>();
  final authRepository = Modular.get<IAuthRepository>();

  @override
  void initState() {
    super.initState();
    vm.setPlace(widget.place);
    eventsVm.load(widget.place.id);
  }

  String get shareUrl {
    final place = vm.place ?? widget.place;
    return PublicUrlHelper.placeUrl(slug: place.slug, id: place.id);
  }

  Future<void> showSharePlaceDialog(PlaceEntity place) async {
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

                  final text = Uri.encodeComponent(
                    'Confira ${place.name}\n\n$shareUrl',
                  );

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

                  await Clipboard.setData(ClipboardData(text: shareUrl));

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copiado!')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Mais opcoes'),
                onTap: () async {
                  Navigator.pop(context);

                  await SharePlus.instance.share(
                    ShareParams(text: 'Confira ${place.name}\n\n$shareUrl'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showMenu(PlaceEntity place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: DsColors.publicSheet,
      builder: (_) => PlaceMenuSheet(place: place),
    );
  }

  Future<void> openEditPlace(PlaceEntity place) async {
    final updated = await Modular.to.pushNamed(
      '/places/create',
      arguments: place,
    );

    if (updated == true) {
      await vm.reload();

      final updatedPlace = vm.place;
      if (updatedPlace != null) {
        await eventsVm.load(updatedPlace.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authRepository.currentUser;

    return Observer(
      builder: (_) {
        final place = vm.place ?? widget.place;

        return Scaffold(
          backgroundColor: DsColors.publicBackground,
          body: ListView(
            children: [
              PlaceHero(
                place: place,
                onBack: () {
                  Modular.to.navigate('/');
                },
                onShare: () => showSharePlaceDialog(place),
              ),
              PlaceAbout(place: place),
              PlaceActions(place: place, onOpenMenu: () => showMenu(place)),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: place.musicGenres
                      .map(
                        (genre) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: DsColors.accent.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: DsColors.accent.withValues(alpha: .30),
                            ),
                          ),
                          child: Text(
                            genre.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              PlaceEventsSection(place: place, vm: eventsVm),
              PlaceOwnerSection(
                place: place,
                currentUserId: currentUser?.id,
                onEdit: () => openEditPlace(place),
              ),
            ],
          ),
        );
      },
    );
  }
}
