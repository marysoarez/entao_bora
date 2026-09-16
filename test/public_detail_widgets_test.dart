import 'package:entao_bora/shared/widgets/public_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpDetail(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PublicDetailView(
            article: SizedBox(height: 100),
            aside: SizedBox(height: 100),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('stacks the aside at the 760 px breakpoint', (tester) async {
    await pumpDetail(tester, 760);
    final article = tester.getTopLeft(
      find.byKey(const ValueKey('public-detail-article')),
    );
    final aside = tester.getTopLeft(
      find.byKey(const ValueKey('public-detail-aside')),
    );
    expect(aside.dy, greaterThan(article.dy));
    expect(aside.dx, article.dx);
  });

  testWidgets('uses article and 320 px aside columns above 760 px', (
    tester,
  ) async {
    await pumpDetail(tester, 761);
    final article = tester.getTopLeft(
      find.byKey(const ValueKey('public-detail-article')),
    );
    final asideFinder = find.byKey(const ValueKey('public-detail-aside'));
    final aside = tester.getTopLeft(asideFinder);
    expect(aside.dy, article.dy);
    expect(aside.dx, greaterThan(article.dx));
    expect(tester.getSize(asideFinder).width, 320);
  });
}
