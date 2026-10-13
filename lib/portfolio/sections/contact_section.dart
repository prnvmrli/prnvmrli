import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/hover_interactive_card.dart';

/// 05: Contact & Reach Out section.
class ContactSection extends StatefulWidget {
  final bool isMobile;
  final VoidCallback onCopyEmail;
  final ValueChanged<String> onOpenUrl;
  final VoidCallback onDownloadResume;

  const ContactSection({
    super.key,
    required this.isMobile,
    required this.onCopyEmail,
    required this.onOpenUrl,
    required this.onDownloadResume,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final ValueNotifier<bool> _copied = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _copied.dispose();
    super.dispose();
  }

  void _handleCopy() {
    widget.onCopyEmail();
    _copied.value = true;
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        _copied.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Contact',
          indexTag: '05 / Direct Channels',
        ),
        const SizedBox(height: 24),
        const Text(
          "Let's connect.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: Palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Open to discussing mobile architecture, real-time trading pipelines, Flutter engineering challenges, and developer tooling.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Palette.textSecondary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 24),

        // Primary Email Interaction Card
        HoverInteractiveCard(
          borderRadius: BorderRadius.circular(10),
          liftDistance: 2.5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DIRECT EMAIL',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: Palette.accent,
                  ),
                ),
                const SizedBox(height: 10),
                SelectableText(
                  email,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => widget.onOpenUrl('mailto:$email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: const Icon(Icons.email_outlined, size: 15),
                      label: const Text(
                        'Compose Email',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _copied,
                      builder: (context, copied, _) {
                        return OutlinedButton.icon(
                          onPressed: _handleCopy,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: copied ? Palette.accent : Palette.textPrimary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            side: BorderSide(
                              color: copied ? Palette.accent : Palette.border,
                              width: 1.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              copied ? Icons.check : Icons.copy_outlined,
                              key: ValueKey<bool>(copied),
                              size: 14,
                              color: copied ? Palette.accent : null,
                            ),
                          ),
                          label: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              copied ? 'Address Copied!' : 'Copy Address',
                              key: ValueKey<bool>(copied),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: copied ? Palette.accent : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // External Channels
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            ChannelLink(
              label: 'GitHub',
              onTap: () => widget.onOpenUrl(githubUrl),
            ),
            ChannelLink(
              label: 'LinkedIn',
              onTap: () => widget.onOpenUrl(linkedinUrl),
            ),
            ChannelLink(
              label: 'Resume (PDF)',
              onTap: widget.onDownloadResume,
            ),
          ],
        ),
      ],
    );
  }
}

class ChannelLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ChannelLink({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.textPrimary,
        backgroundColor: Palette.surface,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        side: const BorderSide(color: Palette.border, width: 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_outward, size: 13, color: Palette.accent),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
