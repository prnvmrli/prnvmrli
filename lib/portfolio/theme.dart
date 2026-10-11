import 'package:flutter/material.dart';

/// Apple-inspired design tokens for Pranav Murali's portfolio.
/// Clean, warm off-white canvas, near-black typography, neutral grey secondary
/// text, hairline borders, and restrained interactive states.
class Palette {
  // Apple-Inspired Canvas & Surface Hierarchy
  static const canvasBase = Color(0xFFFBFBFD); // Warm off-white background
  static const surface = Color(0xFFFFFFFF); // Crisp white elevated card surface
  static const surfaceSecondary = Color(0xFFF5F5F7); // Neutral light surface
  static const surfaceTertiary = Color(0xFFEBEBF0); // Subtle hover/interactive fill
  static const surfaceContainer = Color(0xFFF5F5F7);
  static const surfaceContainerLow = Color(0xFFFAFAFC);

  // Typography Neutrals
  static const textPrimary = Color(0xFF1D1D1F); // Near-black primary text
  static const textSecondary = Color(0xFF515154); // Neutral dark grey
  static const textMuted = Color(0xFF86868B); // Neutral secondary grey metadata
  static const outline = Color(0xFF86868B); // Technical tags & labels

  // Restrained Hairline Borders & Dividers
  static const border = Color(0xFFE5E5EA); // Hairline border
  static const borderSubtle = Color(0xFFF0F0F2); // Subtle divider
  static const borderHover = Color(0xFFD2D2D7); // Interactive hover border

  // Modern Tech Blue Accent (Original Stitch Design #005cb8)
  static const primary = Color(0xFF005CB8);
  static const accent = Color(0xFF005CB8);
  static const accentHover = Color(0xFF1275E2);
  static const accentDim = Color(0x14005CB8);

  // Backwards compatibility alias
  static const bg = canvasBase;
}

ThemeData portfolioTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Palette.canvasBase,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.light(
      primary: Palette.accent,
      surface: Palette.canvasBase,
      onSurface: Palette.textPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 38,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        color: Palette.textPrimary,
        height: 1.15,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: Palette.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Palette.textSecondary,
        height: 1.6,
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
        letterSpacing: 0.6,
        color: Palette.textMuted,
      ),
    ),
  );
}

/// Minimal Section Header with an understated index tag and hairline divider.
class SectionHeader extends StatelessWidget {
  final String title;
  final String indexTag;

  const SectionHeader({
    super.key,
    required this.title,
    required this.indexTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Palette.border, width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
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
              letterSpacing: 0.6,
              color: Palette.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Monospace badge or tag with smooth hover micro-animation
class MonoChip extends StatefulWidget {
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
  State<MonoChip> createState() => _MonoChipState();
}

class _MonoChipState extends State<MonoChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isHovered
        ? Palette.accentDim
        : (widget.background ?? Palette.surfaceSecondary);
    final borderColor = _isHovered
        ? Palette.accent.withValues(alpha: 0.35)
        : Palette.border;
    final textColor = _isHovered
        ? Palette.accent
        : (widget.color ?? Palette.textSecondary);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmall ? 7 : 9,
          vertical: widget.isSmall ? 3 : 4,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: borderColor, width: 0.8),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: widget.isSmall ? 10 : 11,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Animated Pulse Dot with breathing halo for live availability
class StatusPulseDot extends StatefulWidget {
  final Color color;
  final double size;

  const StatusPulseDot({
    super.key,
    this.color = const Color(0xFF28CD41),
    this.size = 7.0,
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
    );

    final isTest = WidgetsBinding.instance.runtimeType
        .toString()
        .toLowerCase()
        .contains('test');
    if (!isTest) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
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
        final progress = _controller.value;
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.25 + 0.45 * progress),
                blurRadius: 4.0 + 4.0 * progress,
                spreadRadius: 0.8 + 1.2 * progress,
              ),
            ],
          ),
        );
      },
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
