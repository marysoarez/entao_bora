class SlugHelper {
  const SlugHelper._();

  static String fromTitle(String value) {
    final normalized = _removeDiacritics(value.trim().toLowerCase());

    return normalized
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  static String _removeDiacritics(String value) {
    const replacements = {
      '\u00e1': 'a',
      '\u00e0': 'a',
      '\u00e2': 'a',
      '\u00e3': 'a',
      '\u00e4': 'a',
      '\u00e9': 'e',
      '\u00e8': 'e',
      '\u00ea': 'e',
      '\u00eb': 'e',
      '\u00ed': 'i',
      '\u00ec': 'i',
      '\u00ee': 'i',
      '\u00ef': 'i',
      '\u00f3': 'o',
      '\u00f2': 'o',
      '\u00f4': 'o',
      '\u00f5': 'o',
      '\u00f6': 'o',
      '\u00fa': 'u',
      '\u00f9': 'u',
      '\u00fb': 'u',
      '\u00fc': 'u',
      '\u00e7': 'c',
      '\u00f1': 'n',
    };

    final buffer = StringBuffer();

    for (final rune in value.runes) {
      final character = String.fromCharCode(rune);
      buffer.write(replacements[character] ?? character);
    }

    return buffer.toString();
  }
}
