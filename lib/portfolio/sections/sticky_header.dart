import 'dart:ui';

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';

/// Sticky frosted navigation header adhering to Apple design principles.
class StickyHeader extends StatelessWidget {
  final bool isMobile;
  final bool showIdentity;
  final String? activeSection;
  final VoidCallback onScrollToHero;
  final VoidCallback onScrollToProjects;
  final VoidCallback onScrollToExperience;
  final VoidCallback onScrollToCapabilities;
  final VoidCallback onScrollToEducation;
  final VoidCallback onScrollToContact;
  final VoidCallback onDownloadResume;

  const StickyHeader({
    super.key,
    required this.isMobile,
    required this.showIdentity,
    this.activeSection,
    required this.onScrollToHero,
    required this.onScrollToProjects,
    required this.onScrollToExperience,
    required this.onScrollToCapabilities,
    required this.onScrollToEducation,
    required this.onScrollToContact,
    required this.onDownloadResume,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Palette.canvasBase.withValues(alpha: 0.88),
            border: const Border(
              bottom: BorderSide(color: Palette.border, width: 1.0),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Brand: Avatar + Name
                    InkWell(
                      onTap: onScrollToHero,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/avatar.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.person,
                                          size: 16,
                                          color: Palette.textMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Palette.border,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ClipRect(
                              child: AnimatedAlign(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                alignment: Alignment.centerLeft,
                                widthFactor: showIdentity ? 1.0 : 0.0,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: showIdentity ? 1.0 : 0.0,
                                  curve: Curves.easeInOut,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.2,
                                        color: Palette.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right Navigation Links
                    if (!isMobile)
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HeaderLink(
                                label: 'Projects',
                                isSelected: activeSection == 'projects',
                                onTap: onScrollToProjects,
                              ),
                              HeaderLink(
                                label: 'Experience',
                                isSelected: activeSection == 'experience',
                                onTap: onScrollToExperience,
                              ),
                              HeaderLink(
                                label: 'Capabilities',
                                isSelected: activeSection == 'capabilities',
                                onTap: onScrollToCapabilities,
                              ),
                              HeaderLink(
                                label: 'Education',
                                isSelected: activeSection == 'education',
                                onTap: onScrollToEducation,
                              ),
                              const SizedBox(width: 6),
                              HeaderResumeButton(
                                onTap: onDownloadResume,
                              ),
                              const SizedBox(width: 6),
                              HeaderContactButton(
                                isSelected: activeSection == 'contact',
                                onTap: onScrollToContact,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // Mobile Nav Buttons: Resume + Contact
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HeaderMobileResumeButton(
                            onTap: onDownloadResume,
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: onScrollToContact,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Palette.accent,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Contact →',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: activeSection == 'contact'
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderLink extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const HeaderLink({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (isSelected) return Palette.accent;
          if (states.contains(WidgetState.hovered)) return Palette.textPrimary;
          return Palette.textSecondary;
        }),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

class HeaderResumeButton extends StatelessWidget {
  final VoidCallback onTap;

  const HeaderResumeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return Palette.accent;
          return Palette.textPrimary;
        }),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.description_outlined, size: 13, color: Palette.accent),
          SizedBox(width: 4),
          Text(
            'Resume',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 3),
          Icon(Icons.arrow_downward, size: 11, color: Palette.textMuted),
        ],
      ),
    );
  }
}

class HeaderMobileResumeButton extends StatelessWidget {
  final VoidCallback onTap;

  const HeaderMobileResumeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        foregroundColor: Palette.textPrimary,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.description_outlined, size: 13, color: Palette.accent),
          SizedBox(width: 4),
          Text(
            'Resume',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class HeaderContactButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const HeaderContactButton({
    super.key,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (isSelected) return Palette.accent;
          if (states.contains(WidgetState.hovered)) return Palette.accentHover;
          return Palette.accent;
        }),
      ),
      child: Text(
        'Contact →',
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
