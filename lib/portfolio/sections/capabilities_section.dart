import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';

/// 03: Engineering Capabilities section.
class EngineeringCapabilitiesSection extends StatelessWidget {
  final bool isMobile;

  const EngineeringCapabilitiesSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Engineering Capabilities',
          indexTag: '03 / Core Competencies',
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = !isMobile && constraints.maxWidth >= 580;

            return Column(
              children: [
                for (int i = 0; i < capabilityGroups.length; i++) ...[
                  SpecMatrixRow(
                    group: capabilityGroups[i],
                    isWide: isWide,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Palette.border,
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class SpecMatrixRow extends StatelessWidget {
  final CapabilityGroup group;
  final bool isWide;

  const SpecMatrixRow({
    super.key,
    required this.group,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: group.accentColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: group.accentColor.withValues(alpha: 0.28),
              width: 1.0,
            ),
          ),
          child: Text(
            group.index,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: group.accentColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            group.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: Palette.textPrimary,
              height: 1.25,
            ),
          ),
        ),
      ],
    );

    final pills = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final bullet in group.bullets)
          MonoChip(
            bullet,
            color: group.accentColor,
            background: group.accentColor.withValues(alpha: 0.08),
          ),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 22,
        horizontal: isWide ? 8 : 2,
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 250, child: header),
                const SizedBox(width: 20),
                Expanded(child: pills),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: 14),
                pills,
              ],
            ),
    );
  }
}
