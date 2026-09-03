import 'package:entao_bora/shared/helpers/slug_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates normalized slugs from titles and names', () {
    expect(SlugHelper.fromTitle('Point dos Trikes'), 'point-dos-trikes');
    expect(SlugHelper.fromTitle('Bar do Jo\u00e3o'), 'bar-do-joao');
    expect(
      SlugHelper.fromTitle('Rock & Beer Festival 2026'),
      'rock-beer-festival-2026',
    );
    expect(
      SlugHelper.fromTitle('  R\u00f3ck 80 Festival - Edi\u00e7\u00e3o 2026  '),
      'rock-80-festival-edicao-2026',
    );
  });
}
