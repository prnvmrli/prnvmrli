import 'package:flutter/material.dart';

import '../theme.dart';

/// Circular portrait with gentle hover scale and accent halo.
class InteractiveAvatar extends StatefulWidget {
  const InteractiveAvatar({super.key});

  @override
  State<InteractiveAvatar> createState() => _InteractiveAvatarState();
}

class _InteractiveAvatarState extends State<InteractiveAvatar> {
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
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, isHovered, _) {
          return AnimatedScale(
            scale: isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: SizedBox(
              width: 68,
              height: 68,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.surfaceSecondary,
                      border: Border.all(
                        color: isHovered ? Palette.accent : Palette.border,
                        width: isHovered ? 1.5 : 1.0,
                      ),
                      boxShadow: isHovered
                          ? [
                              BoxShadow(
                                color: Palette.accent.withValues(alpha: 0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/avatar.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 32,
                        color: Palette.textMuted,
                      ),
                    ),
                  ),

                  // Live Green Status Badge
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Tooltip(
                      message: 'Available for Opportunities',
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.surface,
                          border: Border.all(
                            color: Palette.canvasBase,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: StatusPulseDot(
                            size: 9,
                            color: Color(0xFF28CD41),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
