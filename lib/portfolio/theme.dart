import 'package:flutter/material.dart';

class Palette {
  static const bg = Color(0xFF09090B);
  static const surface = Color(0xFF111115);
  static const surfaceHover = Color(0xFF16161D);
  static const cardBg = Color(0xFF0D0D11);
  static const border = Color(0x1AFFFFFF);
  static const borderHover = Color(0x3D54C5F8);
  static const textPrimary = Color(0xFFEDEDEF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF6B7280);
  static const accent = Color(0xFF54C5F8);
  static const accentDim = Color(0x1F54C5F8);
  static const success = Color(0xFF22C55E);
  static const successDim = Color(0x1F22C55E);
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
        fontSize: 54,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: Palette.textPrimary,
        height: 1.08,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        color: Palette.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Palette.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        color: Palette.textSecondary,
        height: 1.65,
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
  final Color? background;
  final bool isSmall;
  const MonoChip(
    this.label, {
    super.key,
    this.color,
    this.background,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background ?? Palette.surface,
        border: Border.all(color: Palette.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: isSmall ? 11 : 12,
          color: color ?? Palette.textSecondary,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w500,
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Palette.accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'IBM Plex Mono',
            fontSize: 12,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w600,
            color: Palette.accent,
          ),
        ),
      ],
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
