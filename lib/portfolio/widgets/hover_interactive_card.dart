import 'package:flutter/material.dart';

import '../theme.dart';

/// Interactive card wrapper that gently lifts and accents its border on hover.
class HoverInteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? normalBorderColor;
  final Color? hoverBorderColor;
  final Color? normalBackgroundColor;
  final Color? hoverBackgroundColor;
  final double liftDistance;

  const HoverInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.normalBorderColor,
    this.hoverBorderColor,
    this.normalBackgroundColor,
    this.hoverBackgroundColor,
    this.liftDistance = 3.0,
  });

  @override
  State<HoverInteractiveCard> createState() => _HoverInteractiveCardState();
}

class _HoverInteractiveCardState extends State<HoverInteractiveCard> {
  final ValueNotifier<bool> _isHovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: ValueListenableBuilder<bool>(
          valueListenable: _isHovered,
          child: widget.child,
          builder: (context, isHovered, child) {
            final br = widget.borderRadius ?? BorderRadius.circular(12);
            final borderColor = isHovered
                ? (widget.hoverBorderColor ?? Palette.accent.withValues(alpha: 0.35))
                : (widget.normalBorderColor ?? Palette.border);
            final bgColor = isHovered
                ? (widget.hoverBackgroundColor ?? Palette.surface)
                : (widget.normalBackgroundColor ?? Palette.surface);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(
                0,
                isHovered ? -widget.liftDistance : 0,
                0,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: br,
                border: Border.all(color: borderColor, width: 1.0),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: Palette.accent.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.015),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
