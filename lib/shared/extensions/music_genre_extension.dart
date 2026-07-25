import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:flutter/material.dart';

extension MusicGenreExtension on MusicGenre {
  String get label {
    switch (this) {
      case MusicGenre.classicRock:
        return 'Classic Rock';

      case MusicGenre.hardRock:
        return 'Hard Rock';

      case MusicGenre.heavyMetal:
        return 'Heavy Metal';

      case MusicGenre.thrashMetal:
        return 'Thrash Metal';

      case MusicGenre.deathMetal:
        return 'Death Metal';

      case MusicGenre.blackMetal:
        return 'Black Metal';

      case MusicGenre.powerMetal:
        return 'Power Metal';

      case MusicGenre.doomMetal:
        return 'Doom Metal';

      case MusicGenre.punk:
        return 'Punk';

      case MusicGenre.hardcore:
        return 'Hardcore';

      case MusicGenre.grunge:
        return 'Grunge';

      case MusicGenre.indie:
        return 'Indie';

      case MusicGenre.alternative:
        return 'Alternative Rock';

      case MusicGenre.blues:
        return 'Blues';

      case MusicGenre.jazz:
        return 'Jazz';

      case MusicGenre.popRock:
        return 'Pop Rock';

      case MusicGenre.nacional:
        return 'Rock Nacional';

      case MusicGenre.coverBand:
        return 'Cover';

      case MusicGenre.autoral:
        return 'Autoral';

      case MusicGenre.other:
        return 'Outro';
    }
  }

  String get emoji {
    switch (this) {
      case MusicGenre.classicRock:
        return '🎸';

      case MusicGenre.hardRock:
        return '🤘';

      case MusicGenre.heavyMetal:
        return '🤘';

      case MusicGenre.thrashMetal:
        return '💀';

      case MusicGenre.deathMetal:
        return '☠️';

      case MusicGenre.blackMetal:
        return '🖤';

      case MusicGenre.powerMetal:
        return '⚔️';

      case MusicGenre.doomMetal:
        return '🌑';

      case MusicGenre.punk:
        return '🧷';

      case MusicGenre.hardcore:
        return '🔥';

      case MusicGenre.grunge:
        return '🎤';

      case MusicGenre.indie:
        return '🌿';

      case MusicGenre.alternative:
        return '🎶';

      case MusicGenre.blues:
        return '🎷';

      case MusicGenre.jazz:
        return '🎺';

      case MusicGenre.popRock:
        return '🎵';

      case MusicGenre.nacional:
        return '🇧🇷';

      case MusicGenre.coverBand:
        return '🎙️';

      case MusicGenre.autoral:
        return '✨';

      case MusicGenre.other:
        return '🎼';
    }
  }

  IconData get icon {
    switch (this) {
      case MusicGenre.classicRock:
      case MusicGenre.hardRock:
      case MusicGenre.heavyMetal:
      case MusicGenre.thrashMetal:
      case MusicGenre.deathMetal:
      case MusicGenre.blackMetal:
      case MusicGenre.powerMetal:
      case MusicGenre.doomMetal:
      case MusicGenre.coverBand:
      case MusicGenre.autoral:
        return Icons.music_note;

      case MusicGenre.punk:
        return Icons.bolt;

      case MusicGenre.hardcore:
        return Icons.local_fire_department;

      case MusicGenre.grunge:
        return Icons.mic;

      case MusicGenre.indie:
        return Icons.forest;

      case MusicGenre.alternative:
        return Icons.album;

      case MusicGenre.blues:
        return Icons.piano;

      case MusicGenre.jazz:
        return Icons.queue_music;

      case MusicGenre.popRock:
        return Icons.library_music;

      case MusicGenre.nacional:
        return Icons.flag;

      case MusicGenre.other:
        return Icons.music_video;
    }
  }

  Color get color {
    switch (this) {
      case MusicGenre.classicRock:
        return Colors.brown;

      case MusicGenre.hardRock:
        return Colors.deepOrange;

      case MusicGenre.heavyMetal:
        return Colors.black87;

      case MusicGenre.thrashMetal:
        return Colors.red;

      case MusicGenre.deathMetal:
        return Colors.redAccent;

      case MusicGenre.blackMetal:
        return Colors.black;

      case MusicGenre.powerMetal:
        return Colors.amber;

      case MusicGenre.doomMetal:
        return Colors.blueGrey;

      case MusicGenre.punk:
        return Colors.pink;

      case MusicGenre.hardcore:
        return Colors.deepPurple;

      case MusicGenre.grunge:
        return Colors.teal;

      case MusicGenre.indie:
        return Colors.green;

      case MusicGenre.alternative:
        return Colors.indigo;

      case MusicGenre.blues:
        return Colors.blue;

      case MusicGenre.jazz:
        return Colors.purple;

      case MusicGenre.popRock:
        return Colors.orange;

      case MusicGenre.nacional:
        return Colors.green;

      case MusicGenre.coverBand:
        return Colors.cyan;

      case MusicGenre.autoral:
        return Colors.lime;

      case MusicGenre.other:
        return Colors.grey;
    }
  }

  String get slug {
    return name;
  }

  static MusicGenre fromSlug(String slug) {
    return MusicGenre.values.firstWhere(
      (e) => e.name == slug,
      orElse: () => MusicGenre.other,
    );
  }
}