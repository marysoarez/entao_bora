import 'dart:convert';

import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EventHeader extends StatelessWidget {
  const EventHeader({super.key, required this.event, this.onShare});

  final EventEntity event;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return DsPublicHero(
      title: event.title,
      onShare: onShare,
      onBack: () => Modular.to.navigate('/'),
      image: _EventHeroImage(coverImage: event.coverImage),
    );
  }
}

class _EventHeroImage extends StatelessWidget {
  final String coverImage;

  const _EventHeroImage({required this.coverImage});

  @override
  Widget build(BuildContext context) {
    if (coverImage.isEmpty) {
      return Container(
        color: Colors.grey.shade900,
        child: const Icon(Icons.image, color: Colors.white, size: 48),
      );
    }

    return Image.memory(
      base64Decode(coverImage),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade900,
          child: const Icon(Icons.broken_image, color: Colors.white, size: 48),
        );
      },
    );
  }
}
