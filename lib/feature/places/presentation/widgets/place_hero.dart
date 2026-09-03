import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:flutter/material.dart';

class PlaceHero extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback onBack;
  final VoidCallback onShare;

  const PlaceHero({
    super.key,
    required this.place,
    required this.onBack,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  onTap: onBack,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: DsHeroIconButton(
                  icon: Icons.share_outlined,
                  tooltip: 'Compartilhar',
                  onTap: onShare,
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
                              if (place.address.number?.isNotEmpty ?? false)
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
    );
  }
}
