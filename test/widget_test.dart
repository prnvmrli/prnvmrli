import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio renders hero', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.textContaining('Pranav Murali'), findsWidgets);
  });

  testWidgets('Portfolio renders IOURING experience and production platforms', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.textContaining('IOURING Private Limited'), findsWidgets);
    expect(find.textContaining('NxtOption'), findsWidgets);
    expect(find.textContaining('NxTrad'), findsWidgets);
  });
}
