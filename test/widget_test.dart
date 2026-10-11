import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio renders hero', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.textContaining('Pranav Murali'), findsWidgets);
  });
}
