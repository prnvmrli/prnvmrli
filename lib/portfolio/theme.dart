import 'package:flutter/material.dart';

/// Design tokens matching the Light Modern Tech Blue theme from Stitch screen
/// `16cdd95310ac44b7b421c716cb32c927` in project 6482246001992465397.
class Palette {
  // Light Canvas & Surface Hierarchy
  static const canvasBase = Color(0xFFF9F9FF);
  static const surface = Color(0xFFF9F9FF);
  static const surfaceDim = Color(0xFFD7DAE3);
  static const surfaceContainerLow = Color(0xFFF1F3FC);
  static const surfaceContainer = Color(0xFFEBEDF7);
  static const surfaceContainerHigh = Color(0xFFE6E8F1);
  static const surfaceVariant = Color(0xFFE0E2EB);

  // Modern Tech Blue Accent
  static const primary = Color(0xFF005CB8);
  static const accent = Color(0xFF005CB8); // #005cb8 Signature Tech Blue
  static const accentInteractive = Color(0xFF1275E2);
  static const accentDim = Color(0x14005CB8);

  // Typography Neutrals
  static const textPrimary = Color(0xFF181C22); // Deep dark crisp text
  static const textSecondary = Color(0xFF414753); // Neutral readable slate
  static const textMuted = Color(0xFF717785); // Secondary metadata
  static const outline = Color(0xFF717785); // Hairline tags & structural specs

  // Structural Borders
  static const border = Color(0xFFE0E2EB);
  static const borderLight = Color(0xFFECEEF5);
  static const borderFocus = Color(0xFF005CB8);

  // Semantic Status (Apple-style available green)
  static const statusAvailable = Color(0xFF28CD41);
  static const bg = canvasBase;
}

ThemeData portfolioTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Palette.canvasBase,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.light(
      primary: Palette.primary,
      surface: Palette.canvasBase,
      onSurface: Palette.textPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 38,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.8,
        color: Palette.textPrimary,
        height: 1.15,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
        color: Palette.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: Palette.textSecondary,
        height: 1.65,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Palette.textSecondary,
        height: 1.55,
      ),
      labelSmall: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 11,
        letterSpacing: 0.8,
        color: Palette.outline,
      ),
    ),
  );
}

/// Minimal Editorial Section Header matching Stitch screen 16cdd95310ac44b7b421c716cb32c927:
/// Subtle bottom border, uppercase section title on the left, index tag on the right.
class SectionHeader extends StatelessWidget {
  final String title;
  final String indexTag;

  const SectionHeader({super.key, required this.title, required this.indexTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Palette.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Palette.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            indexTag,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              letterSpacing: 0.8,
              color: Palette.outline,
            ),
          ),
        ],
      ),
    );
  }
}

/// Monospace badge or tag matching Stitch light design
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
        horizontal: isSmall ? 6 : 8,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: background ?? Palette.surfaceContainer,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Palette.borderLight),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: isSmall ? 10 : 11,
          color: color ?? Palette.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Subtle Hairline Divider
class Hairline extends StatelessWidget {
  final Color color;
  const Hairline({super.key, this.color = Palette.border});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}

/// Animated Pulse Dot indicator
class StatusPulseDot extends StatefulWidget {
  final Color color;
  final double size;

  const StatusPulseDot({
    super.key,
    this.color = Palette.statusAvailable,
    this.size = 6.0,
  });

  @override
  State<StatusPulseDot> createState() => _StatusPulseDotState();
}

class _StatusPulseDotState extends State<StatusPulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withValues(
              alpha: 0.7 + 0.3 * _controller.value,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4 * _controller.value),
                blurRadius: 5,
                spreadRadius: 1.2 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
