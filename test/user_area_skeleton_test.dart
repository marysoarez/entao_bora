import 'package:entao_bora/feature/user_area/presentation/widgets/user_area_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [320.0, 390.0, 840.0]) {
    testWidgets('Minha área skeleton renders without overflow at $width px', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 640);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserAreaSkeleton())),
      );

      expect(tester.takeException(), isNull);
    });
  }
}
