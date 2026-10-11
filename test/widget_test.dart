import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_exp3/main.dart';

void main() {
  testWidgets('Responsive dashboard displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ResponsiveApp());

    expect(find.text('Responsive Dashboard'), findsOneWidget);
    expect(find.text('Dashboard Overview'), findsOneWidget);
    expect(find.text('Current Screen Information'), findsOneWidget);
  });
}
