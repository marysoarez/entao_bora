import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_mini_card.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/feature/places/presentation/widgets/user_avatar_widget.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
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
  final placeRepository = Modular.get<IPlaceRepository>();

  bool loading = true;
  String? error;
  PlaceEntity? place;

  @override
  void initState() {
    super.initState();
    loadPlace();
  }

  Future<void> loadPlace() async {
    setState(() {
      loading = true;
      error = null;
    });

    final result = await placeRepository.getPlaceById(widget.id);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          loading = false;
          error = failure.message;
        });
      },
      (loadedPlace) {
        setState(() {
          loading = false;
          place = loadedPlace;
          error = loadedPlace == null
              ? 'Estabelecimento nao encontrado.'
              : null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final loadedPlace = place;

    if (loadedPlace == null) {
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
              error ?? 'Estabelecimento nao encontrado.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      );
    }

    return PlaceDetailsPage(place: loadedPlace);
  }
}

class PlaceDetailsPage extends StatefulWidget {
  final PlaceEntity place;

  const PlaceDetailsPage({super.key, required this.place});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  late PlaceEntity place;
  final placeRepository = Modular.get<IPlaceRepository>();
  final vm = Modular.get<PlaceEventsViewModel>();
  final authRepository = Modular.get<IAuthRepository>();
  @override
  void initState() {
    super.initState();
    place = widget.place;
    vm.load(place.id);
  }

  String get shareUrl => 'https://entaobora.com.br/#/places/${place.id}';

  Future<void> showSharePlaceDialog() async {
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

  void showMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: DsColors.publicSheet,
      builder: (_) => _PlaceMenuSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authRepository.currentUser;
    return Scaffold(
      backgroundColor: DsColors.publicBackground,

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 320,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (place.photos.isNotEmpty)
                      Image.memory(
                        ImageHelper.base64ToBytes(place.photos.first),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    else
                      Container(
                        color: Colors.grey.shade900,
                        child: const Icon(
                          Icons.photo_outlined,
                          color: Colors.white54,
                          size: 80,
                        ),
                      ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: DsHeroIconButton(
                        icon: Icons.arrow_back,
                        tooltip: 'Voltar',
                        onTap: () {
                          Modular.to.navigate('/');
                        },
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: DsHeroIconButton(
                        icon: Icons.share_outlined,
                        tooltip: 'Compartilhar',
                        onTap: showSharePlaceDialog,
                      ),
                    ),
                    IgnorePointer(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Color.fromARGB(150, 0, 0, 0),
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.name, style: DsTextStyles.publicTitle),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  [
                                    if (place.address.street != null)
                                      place.address.street!,
                                    if (widget
                                            .place
                                            .address
                                            .number
                                            ?.isNotEmpty ??
                                        false)
                                      place.address.number!,
                                    if (place.address.neighborhood != null)
                                      place.address.neighborhood!,
                                    if (place.address.city != null)
                                      place.address.city!,
                                  ].join(', '),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sobre",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  place.description,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),

                const Divider(height: 32),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (place.phone.isNotEmpty)
                  DsActionChip(
                    icon: Icons.call_outlined,
                    label: "Telefone",
                    onTap: () async {
                      await launchUrl(Uri.parse("tel:${place.phone}"));
                    },
                  ),

                if (place.instagram.isNotEmpty)
                  DsActionChip(
                    icon: Icons.camera_alt_outlined,
                    label: "Instagram",
                    color: Colors.pinkAccent,
                    onTap: () async {
                      final username = place.instagram.replaceAll("@", "");

                      await launchUrl(
                        Uri.parse("https://instagram.com/$username"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),

                if (place.website.isNotEmpty)
                  DsActionChip(
                    icon: Icons.language,
                    label: "Site",
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(place.website),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),

                if (place.menuItems.isNotEmpty)
                  DsActionChip(
                    icon: Icons.restaurant_menu_outlined,
                    label: "Cardapio",
                    color: DsColors.warning,
                    onTap: showMenu,
                  ),
              ],
            ),
          ),
          SizedBox(height: 12),
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
          SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.local_activity, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  "Próximos eventos",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Observer(
            builder: (_) {
              if (vm.loading) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (vm.error != null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(vm.error!),
                );
              }

              if (vm.events.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Nenhum evento encontrado.",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.events.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final event = vm.events[index];

                  return GestureDetector(
                    onTap: () {
                      Modular.to.pushNamed('/events/${event.id}');
                    },
                    child: EventMiniCard(event: event, place: place),
                  );
                },
              );
            },
          ),
          Column(
            children: [
              if (place.ownerId.isPartner) ...[
                Row(
                  children: [
                    UserAvatar(photoUrl: place.ownerId.photoUrl, radius: 22),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Responsável',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        Text(
                          place.ownerId.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],

              if (currentUser?.id == place.ownerId.id)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: FilledButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Editar estabelecimento"),
                    onPressed: () async {
                      final updated = await Modular.to.pushNamed(
                        '/places/create',
                        arguments: place,
                      );

                      if (updated == true) {
                        final result = await placeRepository.getPlaceById(
                          place.id,
                        );

                        result.fold((_) {}, (newPlace) {
                          if (newPlace == null) return;

                          setState(() {
                            place = newPlace;
                          });

                          vm.load(place.id);
                        });
                      }
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceMenuSheet extends StatelessWidget {
  final PlaceEntity place;

  const _PlaceMenuSheet({required this.place});

  @override
  Widget build(BuildContext context) {
    final groupedItems = _itemsByCategory(place.menuItems);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.42,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return SafeArea(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text(
                'Cardapio',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(place.name, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
              for (final entry in groupedItems.entries) ...[
                Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                for (final item in entry.value) ...[
                  _PublicMenuItemTile(item: item),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }

  Map<String, List<MenuItemEntity>> _itemsByCategory(
    List<MenuItemEntity> items,
  ) {
    final grouped = <String, List<MenuItemEntity>>{};

    for (final item in items) {
      final category = item.category.trim().isEmpty ? 'Geral' : item.category;
      grouped.putIfAbsent(category, () => []).add(item);
    }

    return grouped;
  }
}

class _PublicMenuItemTile extends StatelessWidget {
  final MenuItemEntity item;

  const _PublicMenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return DsPublicCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 86,
              height: 86,
              color: Colors.white.withValues(alpha: .06),
              child: item.photo.isEmpty
                  ? const Icon(
                      Icons.restaurant_menu_outlined,
                      color: Colors.white54,
                    )
                  : Image.memory(
                      ImageHelper.base64ToBytes(item.photo),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.white54),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 8),
                Text(
                  DsFormatters.brl(item.price),
                  style: DsTextStyles.publicPrice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
