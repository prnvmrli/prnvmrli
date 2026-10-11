import 'package:flutter/material.dart';

class Palette {
  static const bg = Color(0xFF09090B);
  static const surface = Color(0xFF101014);
  static const border = Color(0x14FFFFFF);
  static const textPrimary = Color(0xFFEDEDEF);
  static const textSecondary = Color(0xFF8B8B95);
  static const accent = Color(0xFF54C5F8);
  static const accentDim = Color(0x1F54C5F8);
}

ThemeData portfolioTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Palette.bg,
    fontFamily: 'Space Grotesk',
    colorScheme: const ColorScheme.dark(
      primary: Palette.accent,
      surface: Palette.surface,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: Palette.textPrimary,
        height: 1.05,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        color: Palette.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        color: Palette.textSecondary,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        color: Palette.textSecondary,
        height: 1.55,
      ),
    ),
  );
}

class MonoChip extends StatelessWidget {
  final String label;
  final Color? color;
  const MonoChip(this.label, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Palette.surface,
        border: Border.all(color: Palette.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 12,
          color: color ?? Palette.textSecondary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'IBM Plex Mono',
        fontSize: 12,
        letterSpacing: 2.5,
        color: Palette.accent,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class Hairline extends StatelessWidget {
  const Hairline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Palette.border);
  }
}
