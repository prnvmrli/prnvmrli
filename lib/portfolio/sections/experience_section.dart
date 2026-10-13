import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/hover_interactive_card.dart';

/// 02: Professional Experience section.
class ExperienceSection extends StatelessWidget {
  final bool isMobile;

  const ExperienceSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Professional Experience',
          indexTag: '02 / Production Timeline',
        ),
        const SizedBox(height: 28),
        for (int i = 0; i < jobs.length; i++)
          TimelineItem(
            job: jobs[i],
            isLast: i == jobs.length - 1,
            isMobile: isMobile,
          ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final Job job;
  final bool isLast;
  final bool isMobile;

  const TimelineItem({
    super.key,
    required this.job,
    required this.isLast,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final trackWidth = isMobile ? 20.0 : 24.0;
    final lineLeft = trackWidth / 2 - 0.75;

    return Stack(
      children: [
        // Minimal Timeline Track Line on Left
        Positioned(
          top: 18,
          bottom: isLast ? 24 : 0,
          left: lineLeft,
          child: Container(
            width: 1.5,
            color: isLast
                ? Palette.border.withValues(alpha: 0.35)
                : Palette.border,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Node Dot
            SizedBox(
              width: trackWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Center(
                  child: TimelineNode(isCurrent: job.isCurrent),
                ),
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            // Content Column on Right
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role, Location, Period, and Current Highlight Badge
                    _buildHeader(context),

                    const SizedBox(height: 12),

                    // Summary
                    Text(
                      job.summary,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Palette.textSecondary,
                        height: 1.55,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Bullet points
                    for (final point in job.bulletPoints)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6, right: 10),
                              child: Icon(Icons.circle,
                                  size: 4, color: Palette.textMuted),
                            ),
                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Palette.textSecondary,
                                  height: 1.55,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Production Platforms Subsection
                    if (job.platforms.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      const Text(
                        'PRODUCTION SYSTEMS DELIVERED',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          color: Palette.accent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final shouldStack =
                              isMobile || constraints.maxWidth < 640;
                          if (shouldStack) {
                            return Column(
                              children: [
                                for (final platform in job.platforms)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ProductionPlatformCard(
                                      platform: platform,
                                    ),
                                  ),
                              ],
                            );
                          }
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (int i = 0; i < job.platforms.length; i++) ...[
                                  if (i > 0) const SizedBox(width: 14),
                                  Expanded(
                                    child: ProductionPlatformCard(
                                      platform: job.platforms[i],
                                      isDesktop: true,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                job.role,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: Palette.textPrimary,
                ),
              ),
            ),
            if (job.isCurrent) ...[
              const SizedBox(width: 8),
              const CurrentBadge(),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${job.company} · ${job.location}',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: isMobile ? 11.5 : 12,
            fontWeight: FontWeight.w500,
            color: Palette.accent,
          ),
        ),
      ],
    );

    final period = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 10,
        vertical: isMobile ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: Palette.surfaceSecondary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Palette.border, width: 1.0),
      ),
      child: Text(
        job.period,
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: isMobile ? 11 : 12,
          fontWeight: FontWeight.w500,
          color: isMobile ? Palette.textMuted : Palette.textPrimary,
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 6),
          period,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: title),
        const SizedBox(width: 12),
        period,
      ],
    );
  }
}

class TimelineNode extends StatelessWidget {
  final bool isCurrent;

  const TimelineNode({super.key, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF28CD41).withValues(alpha: 0.16),
          border: Border.all(
            color: const Color(0xFF28CD41).withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: const StatusPulseDot(
          size: 7,
          color: Color(0xFF28CD41),
        ),
      );
    }
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Palette.surface,
        border: Border.all(
          color: Palette.border,
          width: 2.0,
        ),
      ),
    );
  }
}

class CurrentBadge extends StatelessWidget {
  const CurrentBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF28CD41).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: const Color(0xFF28CD41).withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusPulseDot(size: 5.5, color: Color(0xFF28CD41)),
          SizedBox(width: 5),
          Text(
            'Present',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: Color(0xFF1E8E3E),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductionPlatformCard extends StatelessWidget {
  final ProductionPlatform platform;
  final bool isDesktop;

  const ProductionPlatformCard({
    super.key,
    required this.platform,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final desc = Text(
      platform.description,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Palette.textSecondary,
        height: 1.5,
      ),
    );

    return HoverInteractiveCard(
      borderRadius: BorderRadius.circular(10),
      liftDistance: 2.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              platform.name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: Palette.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              platform.subtitle,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Palette.accent,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            if (isDesktop) Expanded(child: desc) else desc,
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tech in platform.techStack)
                  MonoChip(tech, isSmall: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
