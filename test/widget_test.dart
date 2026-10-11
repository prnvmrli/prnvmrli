import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio renders hero and personal identity',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.textContaining('Pranav Murali'), findsWidgets);
    expect(find.textContaining('MOBILE SYSTEMS ENGINEER — FLUTTER'), findsWidgets);
    expect(find.textContaining('Flutter'), findsWidgets);
    expect(find.textContaining('Architecture'), findsWidgets);
    expect(find.textContaining('SDK Engineering'), findsWidgets);
    expect(find.textContaining('Real-time Systems'), findsWidgets);
    expect(find.textContaining('Performance'), findsWidgets);
  });

  testWidgets('Portfolio renders major content sections and authentic items',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());

    // 01: Projects & Systems Work (Open Source & Monorepo Tools)
    expect(find.textContaining('Projects & Systems Work'), findsWidgets);
    expect(find.textContaining('f-cleaner'), findsWidgets);
    expect(find.textContaining('fclean'), findsWidgets);
    expect(find.textContaining('android_system_chrome'), findsWidgets);
    expect(find.textContaining('flutter_notification_icons'), findsWidgets);
    expect(find.textContaining('aviary'), findsWidgets);

    // 02: Experience (IOURING & Minimal Timeline with Green Highlight)
    expect(find.textContaining('Professional Experience'), findsWidgets);
    expect(find.textContaining('IOURING Private Limited'), findsWidgets);
    expect(find.text('Present'), findsWidgets);
    expect(find.textContaining('PRODUCTION SYSTEMS DELIVERED'), findsWidgets);
    expect(find.textContaining('NeoCharts'), findsWidgets);
    expect(find.textContaining('Precision Charting Infrastructure & SDK'), findsWidgets);
    expect(find.textContaining('NxtOption'), findsWidgets);
    expect(find.textContaining('Options Trading Platform & SDK'), findsWidgets);
    expect(find.textContaining('NxTrad'), findsWidgets);
    expect(find.textContaining('Full Market Access Trading Platform'), findsWidgets);

    // 03: Engineering Capabilities
    expect(find.textContaining('Engineering Capabilities'), findsWidgets);
    expect(
        find.textContaining('Architecture & SDK Engineering'), findsWidgets);
    expect(find.textContaining('Real-time Systems'), findsWidgets);
    expect(find.textContaining('Security & Reliability'), findsWidgets);
    expect(find.textContaining('Testing & Delivery'), findsWidgets);
    expect(find.textContaining('Languages & Frameworks'), findsWidgets);
    expect(find.text('Modularization'), findsWidgets);
    expect(find.text('WebSockets'), findsWidgets);
    expect(find.text('SSL Pinning'), findsWidgets);
    expect(find.text('Patrol'), findsWidgets);
    expect(find.text('Dart'), findsWidgets);
    expect(find.text('TypeScript'), findsWidgets);

    // 04: Education
    expect(find.textContaining('Education'), findsWidgets);
    expect(
        find.textContaining('Government Engineering College, Idukki'),
        findsWidgets);

    // 05: Contact
    expect(find.textContaining('Contact'), findsWidgets);
    expect(find.textContaining('prnvmrli@gmail.com'), findsWidgets);
  });

  testWidgets('Header navigation links render and navigate cleanly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());

    // Navigation links are present in header
    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Experience'), findsWidgets);
    expect(find.text('Capabilities'), findsWidgets);
    expect(find.text('Education'), findsWidgets);
    expect(find.text('Resume'), findsWidgets);
    expect(find.text('Contact →'), findsWidgets);

    // Tapping header link triggers navigation without errors
    await tester.tap(find.text('Capabilities').first);
    await tester.pumpAndSettle();
    expect(find.text('Engineering Capabilities'), findsWidgets);
  });

  testWidgets('Header only displays name when hero name is scrolled out of view',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Find AnimatedAlign in header controlling name visibility
    final animatedAligns = tester.widgetList<AnimatedAlign>(find.byType(AnimatedAlign));
    expect(animatedAligns.isNotEmpty, isTrue);
    // At top of page, widthFactor is 0.0 (name hidden in header)
    expect(animatedAligns.first.widthFactor, equals(0.0));

    // Scroll down past the hero name (~200px)
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -250));
    await tester.pumpAndSettle();

    // After scrolling past hero name, widthFactor becomes 1.0 (name visible in header)
    final updatedAligns = tester.widgetList<AnimatedAlign>(find.byType(AnimatedAlign));
    expect(updatedAligns.first.widthFactor, equals(1.0));
  });
}
