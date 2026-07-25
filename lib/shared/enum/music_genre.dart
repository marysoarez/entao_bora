enum MusicGenre {
  classicRock,
  hardRock,
  heavyMetal,
  thrashMetal,
  deathMetal,
  blackMetal,
  powerMetal,
  doomMetal,
  punk,
  hardcore,
  grunge,
  indie,
  alternative,
  blues,
  jazz,
  popRock,
  nacional,
  coverBand,
  autoral,
  other;

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

  String get slug => name;

  static MusicGenre fromSlug(String slug) {
    return MusicGenre.values.firstWhere(
      (e) => e.name == slug,
      orElse: () => MusicGenre.other,
    );
  }
}