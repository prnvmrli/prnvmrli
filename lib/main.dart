import 'package:flutter/material.dart';
import 'portfolio/portfolio_page.dart';
import 'portfolio/theme.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pranav Murali — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: portfolioTheme(),
      home: const PortfolioPage(),
    );
  }
}
