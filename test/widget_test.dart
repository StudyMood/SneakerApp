import 'package:flutter_test/flutter_test.dart';
import 'package:sneakr_app/main.dart';
import 'package:sneakr_app/widgets/sneakr_logo.dart';

void main() {
  testWidgets('SneakrApp basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SneakrApp());
    expect(find.byType(SneakrLogo), findsOneWidget);
    // Advance animations and timer
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 1500));
  });
}
