import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:flutter/material.dart';

class EventGenres extends StatelessWidget {
  const EventGenres({
    super.key,
    required this.genres,
  });

  final List<MusicGenre> genres;

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres
          .map(
            (genre) => _GenreBadge(
              genre: genre.name,
            ),
          )
          .toList(),
    );
  }
}

class _GenreBadge extends StatelessWidget {
  const _GenreBadge({
    required this.genre,
  });

  final String genre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _genreColor(genre),
          width: 1.3,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _genreIcon(genre),
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(width: 6),

          Text(
            genre.toUpperCase(),
            style: TextStyle(
              color: _genreColor(genre),
              fontWeight: FontWeight.bold,
              letterSpacing: .8,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _genreColor(String genre) {
    switch (genre.toLowerCase()) {
      case "rock":
        return Colors.redAccent;

      case "hard rock":
        return Colors.deepOrangeAccent;

      case "metal":
        return Colors.grey;

      case "heavy metal":
        return Colors.blueGrey;

      case "death metal":
        return Colors.red;

      case "black metal":
        return Colors.deepPurpleAccent;

      case "thrash metal":
        return Colors.orange;

      case "punk":
        return Colors.amber;

      case "grunge":
        return Colors.tealAccent;

      case "indie":
        return Colors.lightBlueAccent;

      default:
        return Colors.white70;
    }
  }

  String _genreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case "rock":
      case "hard rock":
        return "🎸";

      case "metal":
      case "heavy metal":
        return "🤘";

      case "death metal":
        return "💀";

      case "black metal":
        return "☠";

      case "thrash metal":
        return "⚡";

      case "punk":
        return "🧷";

      case "grunge":
        return "🎤";

      default:
        return "🎵";
    }
  }
}