import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/interactive_avatar.dart';

/// Hero & Introduction section.
class HeroSection extends StatelessWidget {
  final bool isMobile;
  final GlobalKey? heroNameKey;
  final VoidCallback onScrollToProjects;
  final VoidCallback onScrollToContact;
  final VoidCallback onDownloadResume;
  final VoidCallback onOpenGitHub;
  final VoidCallback onOpenLinkedIn;

  const HeroSection({
    super.key,
    required this.isMobile,
    this.heroNameKey,
    required this.onScrollToProjects,
    required this.onScrollToContact,
    required this.onDownloadResume,
    required this.onOpenGitHub,
    required this.onOpenLinkedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Avatar & Title Spec
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const InteractiveAvatar(),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: Palette.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    key: heroNameKey,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 28 : 34,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8,
                      color: Palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Specialization line
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              color: Palette.textPrimary,
              height: 1.5,
            ),
            children: [
              for (int i = 0; i < specializationPillars.length; i++) ...[
                if (i > 0)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Palette.accent,
                      ),
                    ),
                  ),
                TextSpan(
                  text: specializationPillars[i],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Technical Introduction
        Text(
          aboutBio,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Palette.textSecondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        // Location, Experience & Live Availability tags
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusPulseDot(size: 7, color: Color(0xFF28CD41)),
                SizedBox(width: 6),
                Text(
                  'Available for Opportunities',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Palette.textSecondary,
                  ),
                ),
              ],
            ),
            Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Palette.border)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Palette.textMuted),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Palette.textSecondary,
                  ),
                ),
              ],
            ),
            Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Palette.border)),
            Text(
              yearsExperience,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Palette.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Interactive Callouts with hover scale animations
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton(
              onPressed: onScrollToContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.accent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Get in Touch',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: onScrollToProjects,
              style: OutlinedButton.styleFrom(
                foregroundColor: Palette.accent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                side: BorderSide(
                    color: Palette.accent.withValues(alpha: 0.35),
                    width: 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Work ↓',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onDownloadResume,
              style: OutlinedButton.styleFrom(
                foregroundColor: Palette.textPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                side: const BorderSide(
                  color: Palette.border,
                  width: 1.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.download_rounded, size: 15, color: Palette.accent),
              label: const Text(
                'Resume ↓',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onOpenGitHub,
              style: TextButton.styleFrom(
                foregroundColor: Palette.textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              icon: const Icon(Icons.code, size: 16),
              label: const Text(
                'GitHub',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onOpenLinkedIn,
              style: TextButton.styleFrom(
                foregroundColor: Palette.textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              icon: const Icon(Icons.link, size: 16),
              label: const Text(
                'LinkedIn',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
