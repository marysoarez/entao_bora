import 'dart:convert';

import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';

class EventMiniHeader extends StatelessWidget {
  const EventMiniHeader({super.key, required this.event, this.onShare});

  final EventEntity event;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (event.coverImage.isNotEmpty)
            Image.memory(
              base64Decode(event.coverImage),
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: Colors.grey.shade900,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 48,
                  ),
                );
              },
            )
          else
            Container(
              color: Colors.grey.shade900,
              child: const Icon(Icons.image, color: Colors.white, size: 48),
            ),

          // Gradiente
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.15),
                    Colors.black.withOpacity(.35),
                    Colors.black.withOpacity(.92),
                  ],
                  stops: const [.15, .55, 1],
                ),
              ),
            ),
          ),

          // Compartilhar
          Positioned(
            top: 16,
            right: 16,
            child: Material(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onShare,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.share, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),

          // Título
          Positioned(
            left: 20,
            right: 20,
            bottom: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
