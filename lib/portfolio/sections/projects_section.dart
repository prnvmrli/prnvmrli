import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/hover_interactive_card.dart';

/// 01: Projects & Systems Work section.
class ProjectsSection extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onOpenUrl;

  const ProjectsSection({
    super.key,
    required this.isMobile,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Projects & Systems Work',
          indexTag: '01 / Systems & Open-Source',
        ),
        const SizedBox(height: 16),
        const Text(
          'Developer tooling, publishable Flutter packages, and open-source infrastructure.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Palette.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 28),
        for (final item in projects)
          ProjectCard(
            item: item,
            isMobile: isMobile,
            onOpenUrl: onOpenUrl,
          ),
      ],
    );
  }
}

class InProgressBadge extends StatelessWidget {
  final String label;

  const InProgressBadge({
    super.key,
    this.label = 'In Progress',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9500).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: const Color(0xFFFF9500).withValues(alpha: 0.45),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StatusPulseDot(
            size: 5.5,
            color: Color(0xFFFF9500),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: Color(0xFFB25000),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectItem item;
  final bool isMobile;
  final ValueChanged<String> onOpenUrl;

  const ProjectCard({
    super.key,
    required this.item,
    required this.isMobile,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: HoverInteractiveCard(
        borderRadius: BorderRadius.circular(12),
        liftDistance: 3.0,
        onTap: item.link != null ? () => onOpenUrl(item.link!) : null,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Category tag, in-progress badge, and external link indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        Text(
                          item.category.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: Palette.accent,
                          ),
                        ),
                        if (item.isInProgress)
                          InProgressBadge(
                            label: item.statusLabel ?? 'In Progress',
                          ),
                      ],
                    ),
                  ),
                  if (item.link != null) ...[
                    const SizedBox(width: 8),
                    ProjectSourceLink(
                      url: item.link!,
                      onTap: () => onOpenUrl(item.link!),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 10),

              // Title
              Text(
                item.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: Palette.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                item.description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Palette.textSecondary,
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 14),

              // Technical Architecture Callout
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Palette.border, width: 2.0),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Palette.textSecondary,
                      height: 1.55,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Architecture & Contributions: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Palette.textPrimary,
                        ),
                      ),
                      TextSpan(text: item.technicalDetails),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tech Stack Badges
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final tech in item.techStack)
                    MonoChip(tech, isSmall: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// External source link with interactive arrow slide.
class ProjectSourceLink extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const ProjectSourceLink({
    super.key,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Palette.accent,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_outward, size: 13),
      label: const Text(
        'Source',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
