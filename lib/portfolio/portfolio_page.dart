import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';
import 'theme.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyIdentity = false;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _workKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final show = _scrollController.offset > 110;
    if (show != _showStickyIdentity) {
      setState(() {
        _showStickyIdentity = show;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _openUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyEmail(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Palette.accent, size: 16),
            SizedBox(width: 8),
            Text(
              'Email copied to clipboard: $email',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: Palette.textPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: Palette.canvasBase,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Palette.border),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 640;

    return Scaffold(
      backgroundColor: Palette.canvasBase,
      body: Stack(
        children: [
          // Main Scrollable Page
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Spacer for sticky header
                const SizedBox(height: 72),

                // Editorial Centered Body
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 768),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Hero Section with Memoji Avatar
                          _HeroSection(
                            key: _heroKey,
                            isMobile: isMobile,
                            onScrollToWork: () => _scrollTo(_workKey),
                            onScrollToContact: () => _scrollTo(_contactKey),
                            onOpenGitHub: () => _openUrl(githubUrl),
                            onEmail: () => _openUrl('mailto:$email'),
                          ),

                          const SizedBox(height: 80),

                          // 01: Selected Systems Work
                          _SelectedWorkSection(
                            key: _workKey,
                            isMobile: isMobile,
                            onOpenUrl: _openUrl,
                          ),

                          const SizedBox(height: 80),

                          // 02: Experience
                          _ExperienceSection(
                            key: _experienceKey,
                            isMobile: isMobile,
                          ),

                          const SizedBox(height: 80),

                          // 03: Contact & Closing
                          _ContactSection(
                            key: _contactKey,
                            onCopyEmail: () => _copyEmail(context),
                            onOpenUrl: _openUrl,
                          ),

                          const SizedBox(height: 80),

                          // Footer
                          const _Footer(),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sticky Top Navigation Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _StickyHeader(
              showIdentity: _showStickyIdentity,
              onScrollToTop: () => _scrollTo(_heroKey),
              onScrollToWork: () => _scrollTo(_workKey),
              onScrollToExperience: () => _scrollTo(_experienceKey),
              onScrollToContact: () => _scrollTo(_contactKey),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky Header
// ---------------------------------------------------------------------------
class _StickyHeader extends StatelessWidget {
  final bool showIdentity;
  final VoidCallback onScrollToTop;
  final VoidCallback onScrollToWork;
  final VoidCallback onScrollToExperience;
  final VoidCallback onScrollToContact;

  const _StickyHeader({
    required this.showIdentity,
    required this.onScrollToTop,
    required this.onScrollToWork,
    required this.onScrollToExperience,
    required this.onScrollToContact,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Palette.canvasBase.withValues(alpha: 0.88),
            border: const Border(
              bottom: BorderSide(color: Palette.borderLight),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 768),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final showSubtitle = constraints.maxWidth >= 760;
                    final showExperience = constraints.maxWidth >= 480;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar + Name + Subtitle (Reveals smoothly when scrolled past hero name)
                        AnimatedOpacity(
                          opacity: showIdentity ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          child: AnimatedSlide(
                            offset: showIdentity
                                ? Offset.zero
                                : const Offset(0, -0.2),
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            child: IgnorePointer(
                              ignoring: !showIdentity,
                              child: InkWell(
                                onTap: onScrollToTop,
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const _AvatarImage(size: 28),
                                      const SizedBox(width: 10),
                                      const Text(
                                        name,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.2,
                                          color: Palette.textPrimary,
                                        ),
                                      ),
                                      if (showSubtitle) ...[
                                        Container(
                                          height: 12,
                                          width: 1,
                                          color: Palette.border,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                        const Text(
                                          'Mobile Systems Engineer',
                                          style: TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 11,
                                            color: Palette.outline,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Navigation Links
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _NavLink('Work', onTap: onScrollToWork),
                            const SizedBox(width: 14),
                            if (showExperience) ...[
                              _NavLink('Experience',
                                  onTap: onScrollToExperience),
                              const SizedBox(width: 14),
                            ],
                            _NavLink('Contact →',
                                onTap: onScrollToContact, isPrimary: true),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _NavLink(this.label, {required this.onTap, this.isPrimary = false});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final defaultColor =
        widget.isPrimary ? Palette.accent : Palette.textSecondary;
    final hoverColor =
        widget.isPrimary ? Palette.accentInteractive : Palette.textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            fontWeight: widget.isPrimary ? FontWeight.w600 : FontWeight.w500,
            color: _hovered ? hoverColor : defaultColor,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero Section with Memoji Avatar
// ---------------------------------------------------------------------------
class _HeroSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onScrollToWork;
  final VoidCallback onScrollToContact;
  final VoidCallback onOpenGitHub;
  final VoidCallback onEmail;

  const _HeroSection({
    super.key,
    required this.isMobile,
    required this.onScrollToWork,
    required this.onScrollToContact,
    required this.onOpenGitHub,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Profile Header with Avatar, Name, Title, and Availability
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                _AvatarImage(size: isMobile ? 74 : 88),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: isMobile ? 14 : 16,
                    height: isMobile ? 14 : 16,
                    decoration: BoxDecoration(
                      color: Palette.statusAvailable,
                      shape: BoxShape.circle,
                      border: Border.all(color: Palette.canvasBase, width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: isMobile ? 14 : 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: isMobile ? 22 : 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                          color: Palette.textPrimary,
                        ),
                      ),
                      if (!isMobile) ...[
                        Container(
                          height: 14,
                          width: 1,
                          color: Palette.border,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                        ),
                        const Text(
                          'Mobile Systems Engineer',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            color: Palette.outline,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isMobile) ...[
                    const SizedBox(height: 2),
                    const Text(
                      'Mobile Systems Engineer',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        color: Palette.outline,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Palette.surfaceContainer,
                      border: Border.all(color: Palette.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatusPulseDot(
                            color: Palette.statusAvailable, size: 6.0),
                        SizedBox(width: 6),
                        Text(
                          'Available for select engineering contracts',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Flutter & Mobile Infrastructure',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 11,
                      color: Palette.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Eyebrow
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: const [
            Text(
              location,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: Palette.textSecondary,
              ),
            ),
            Text(
              '·',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: Palette.outline,
              ),
            ),
            Text(
              yearsExperience,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: Palette.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Large Editorial Headline with Tech Blue Accent
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 30 : 42,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.0,
              height: 1.15,
              color: Palette.textPrimary,
            ),
            children: const [
              TextSpan(text: 'I build software that goes '),
              TextSpan(
                text: 'beyond',
                style: TextStyle(
                  color: Palette.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: ' the interface.'),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Bio paragraph
        Text(
          aboutBio,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 15 : 17,
            fontWeight: FontWeight.w300,
            color: Palette.textSecondary,
            height: 1.65,
          ),
        ),

        const SizedBox(height: 14),

        // Focus subtitle
        Text(
          focusSummary,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            color: Palette.outline,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        // Action links
        Wrap(
          spacing: 24,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _TextLink(
              label: 'View Selected Work ↓',
              highlight: true,
              onTap: onScrollToWork,
            ),
            _TextLink(
              label: 'Get in touch →',
              onTap: onScrollToContact,
            ),
            _TextLink(
              label: 'GitHub ↗',
              onTap: onOpenGitHub,
            ),
            _TextLink(
              label: 'Email ↗',
              onTap: onEmail,
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 01: Selected Systems Work
// ---------------------------------------------------------------------------
class _SelectedWorkSection extends StatelessWidget {
  final bool isMobile;
  final void Function(String url) onOpenUrl;

  const _SelectedWorkSection({
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
          title: 'Selected Systems Work',
          indexTag: '01 / Production',
        ),
        const SizedBox(height: 36),
        for (int i = 0; i < projects.length; i++) ...[
          _ProjectArticle(
            project: projects[i],
            isMobile: isMobile,
            onOpenUrl: onOpenUrl,
          ),
          if (i < projects.length - 1) const SizedBox(height: 52),
        ],
      ],
    );
  }
}

class _ProjectArticle extends StatelessWidget {
  final Project project;
  final bool isMobile;
  final void Function(String url) onOpenUrl;

  const _ProjectArticle({
    required this.project,
    required this.isMobile,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Metric Tag
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                project.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: Palette.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              project.tag,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: Palette.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Description
        Text(
          project.description,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Palette.textSecondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 14),

        // Challenge & Architecture side-border block
        Container(
          padding: const EdgeInsets.only(left: 14),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Palette.border, width: 2.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Palette.outline,
                    height: 1.55,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Challenge: ',
                      style: TextStyle(
                        color: Palette.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: project.challenge),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Palette.outline,
                    height: 1.55,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Architecture: ',
                      style: TextStyle(
                        color: Palette.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: project.architecture),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Stack & Link Footer
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            Text(
              project.techStack.join(' · '),
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 11,
                color: Palette.outline,
              ),
            ),
            _TextLink(
              label: 'View on GitHub ↗',
              onTap: () => onOpenUrl(project.link),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 02: Experience
// ---------------------------------------------------------------------------
class _ExperienceSection extends StatelessWidget {
  final bool isMobile;

  const _ExperienceSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Experience',
          indexTag: '02 / Trajectory',
        ),
        const SizedBox(height: 32),
        for (final job in jobs) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Role & Period
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.role,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          job.company,
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            color: Palette.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    job.period,
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: Palette.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Deliverables
              for (final point in job.bulletPoints) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Palette.accent,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Palette.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 03: Contact & Closing
// ---------------------------------------------------------------------------
class _ContactSection extends StatelessWidget {
  final VoidCallback onCopyEmail;
  final void Function(String url) onOpenUrl;

  const _ContactSection({
    super.key,
    required this.onCopyEmail,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Have an interesting engineering problem?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: Palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Looking for a mobile systems engineer who cares deeply about performance, clean architecture, and real-time streaming? Let\'s connect.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Palette.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Direct: ',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: Palette.outline,
              ),
            ),
            _TextLink(
              label: email,
              underline: true,
              highlight: true,
              onTap: onCopyEmail,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _TextLink(
              label: 'GitHub ↗',
              onTap: () => onOpenUrl(githubUrl),
            ),
            _TextLink(
              label: 'LinkedIn ↗',
              onTap: () => onOpenUrl(linkedinUrl),
            ),
            const Text(
              '·',
              style: TextStyle(color: Palette.outline),
            ),
            const Text(
              'Kerala, India (UTC +05:30)',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: Palette.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Minimal Footer
// ---------------------------------------------------------------------------
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 28),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Palette.borderLight),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: const [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusPulseDot(color: Palette.accent, size: 6.0),
              SizedBox(width: 8),
              Text(
                '$name · Systems & Mobile',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  color: Palette.outline,
                ),
              ),
            ],
          ),
          Text(
            '© 2026 · Built with Flutter Web',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              color: Palette.outline,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar Image Widget
// ---------------------------------------------------------------------------
class _AvatarImage extends StatelessWidget {
  final double size;

  const _AvatarImage({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Palette.border, width: 1.5),
        color: Palette.surfaceContainer,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/avatar.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Palette.surfaceContainerHigh,
              child: Center(
                child: Text(
                  'PM',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: size * 0.38,
                    fontWeight: FontWeight.w600,
                    color: Palette.accent,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hoverable Interactive Link
// ---------------------------------------------------------------------------
class _TextLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool underline;
  final bool highlight;

  const _TextLink({
    required this.label,
    required this.onTap,
    this.underline = false,
    this.highlight = false,
  });

  @override
  State<_TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<_TextLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovered
        ? Palette.accentInteractive
        : (widget.highlight ? Palette.textPrimary : Palette.textSecondary);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            fontWeight: widget.highlight ? FontWeight.w600 : FontWeight.w500,
            color: color,
            decoration: widget.underline
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: Palette.border,
          ),
        ),
      ),
    );
  }
}
