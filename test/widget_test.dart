import 'package:entao_bora/app/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App widget can be created', (tester) async {
    expect(const AppWidget(), isA<AppWidget>());
  });
}
