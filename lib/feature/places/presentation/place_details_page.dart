import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/widgets/event_mini_card.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    final currentUser = authRepository.currentUser;
    return Scaffold(
      backgroundColor: Colors.black,

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
                      child: Material(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Modular.to.navigate('/');
                            debugPrint("popopopp");
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
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
                          Text(
                            place.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

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
                  _InfoChip(
                    icon: Icons.call_outlined,
                    label: "Telefone",
                    onTap: () async {
                      await launchUrl(Uri.parse("tel:${place.phone}"));
                    },
                  ),

                if (place.instagram.isNotEmpty)
                  _InfoChip(
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
                  _InfoChip(
                    icon: Icons.language,
                    label: "Site",
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(place.website),
                        mode: LaunchMode.externalApplication,
                      );
                    },
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
                        color: Colors.red.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.withOpacity(.30)),
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
                separatorBuilder: (_, __) => const SizedBox(height: 12),
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
              Text(
                "Responsável:",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              Text(place.ownerName),
              if (currentUser?.id == place.ownerId)
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: color ?? Colors.white70)),
          ),
        ],
      ),
    );

    if (onTap == null) return row;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: row,
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.08),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color ?? Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
