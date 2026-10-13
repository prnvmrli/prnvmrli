import 'package:flutter/material.dart';

import '../theme.dart';

/// Footer section and Back to Top button.
class FooterSection extends StatelessWidget {
  final VoidCallback onScrollToTop;
  final ValueChanged<String> onOpenUrl;

  const FooterSection({
    super.key,
    required this.onScrollToTop,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Hairline(color: Palette.border),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '© 2026 Pranav Murali. All rights reserved.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Palette.textMuted,
              ),
            ),
            BackToTopButton(onTap: onScrollToTop),
          ],
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Built with Flutter Web · Hosted on GitHub Pages',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 10,
              color: Palette.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class BackToTopButton extends StatelessWidget {
  final VoidCallback onTap;

  const BackToTopButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Palette.textMuted,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_upward, size: 12),
      label: const Text(
        'Back to top',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );
  }
}
