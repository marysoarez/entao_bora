import 'dart:convert';

import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';
import 'package:flutter/material.dart';

class EventMiniHeader extends StatelessWidget {
  const EventMiniHeader({super.key, required this.event, this.onShare});

  final EventEntity event;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return DsPublicHero(
      height: 150,
      title: event.title,
      titleFontSize: 15,
      onShare: onShare,
      image: _EventMiniHeroImage(coverImage: event.coverImage),
    );
  }
}

class _EventMiniHeroImage extends StatelessWidget {
  final String coverImage;

  const _EventMiniHeroImage({required this.coverImage});

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
