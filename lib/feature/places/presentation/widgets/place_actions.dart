import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceActions extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback onOpenMenu;

  const PlaceActions({
    super.key,
    required this.place,
    required this.onOpenMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              onTap: onOpenMenu,
            ),
        ],
      ),
    );
  }
}
