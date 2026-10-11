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
  bool _isProgrammaticScrolling = false;
  String? _activeSection;

  double? _cachedProjectsY;
  double? _cachedExperienceY;
  double? _cachedCapabilitiesY;
  double? _cachedEducationY;
  double? _cachedContactY;
  double? _cachedHeroNameBottomY;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _heroNameKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _capabilitiesKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateSectionPositions();
        _updateActiveSection();
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final nameBox =
        _heroNameKey.currentContext?.findRenderObject() as RenderBox?;
    final bool show;
    if (nameBox != null && nameBox.hasSize) {
      // Screen Y coordinate of the bottom of the name text in the hero.
      // Sticky header has height 60.
      final nameBottomScreenY =
          nameBox.localToGlobal(Offset.zero).dy + nameBox.size.height;
      show = nameBottomScreenY <= 60;
    } else if (_cachedHeroNameBottomY != null) {
      show = _scrollController.offset >= (_cachedHeroNameBottomY! - 60);
    } else {
      show = _scrollController.offset > 110;
    }

    if (show != _showStickyIdentity) {
      setState(() {
        _showStickyIdentity = show;
      });
    }

    if (_isProgrammaticScrolling) return;

    _updateActiveSection();
  }

  double? _getSectionAbsoluteY(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero).dy + _scrollController.offset;
  }

  void _updateSectionPositions() {
    final nameCtx = _heroNameKey.currentContext;
    if (nameCtx != null) {
      final box = nameCtx.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        _cachedHeroNameBottomY = box.localToGlobal(Offset.zero).dy +
            _scrollController.offset +
            box.size.height;
      }
    }

    final pY = _getSectionAbsoluteY(_projectsKey);
    if (pY != null) _cachedProjectsY = pY;

    final eY = _getSectionAbsoluteY(_experienceKey);
    if (eY != null) _cachedExperienceY = eY;

    final capY = _getSectionAbsoluteY(_capabilitiesKey);
    if (capY != null) _cachedCapabilitiesY = capY;

    final edY = _getSectionAbsoluteY(_educationKey);
    if (edY != null) _cachedEducationY = edY;

    final cY = _getSectionAbsoluteY(_contactKey);
    if (cY != null) _cachedContactY = cY;
  }

  void _updateActiveSection() {
    if (!_scrollController.hasClients) return;

    _updateSectionPositions();

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    // 1. Reached bottom of page
    if (maxScroll > 0 && currentScroll >= maxScroll - 60) {
      if (_activeSection != 'contact') {
        setState(() => _activeSection = 'contact');
      }
      return;
    }

    // Focus line ~220px below top of viewport
    final currentY = currentScroll + 220.0;

    final pY = _cachedProjectsY;
    final eY = _cachedExperienceY;
    final capY = _cachedCapabilitiesY;
    final edY = _cachedEducationY;
    final cY = _cachedContactY;

    String? newSection;

    if (cY != null && currentY >= cY) {
      newSection = 'contact';
    } else if (edY != null && currentY >= edY) {
      newSection = 'education';
    } else if (capY != null && currentY >= capY) {
      newSection = 'capabilities';
    } else if (eY != null && currentY >= eY) {
      newSection = 'experience';
    } else if (pY != null && currentY >= pY) {
      newSection = 'projects';
    } else {
      newSection = null;
    }

    if (newSection != _activeSection) {
      setState(() {
        _activeSection = newSection;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key, {String? section}) {
    if (section != null) {
      setState(() => _activeSection = section);
    } else if (key == _heroKey) {
      setState(() => _activeSection = null);
    }

    final ctx = key.currentContext;
    if (ctx != null) {
      final box = ctx.findRenderObject() as RenderBox?;
      if (box != null && _scrollController.hasClients) {
        final position = box.localToGlobal(Offset.zero);
        final targetOffset = (_scrollController.offset + position.dy - 76)
            .clamp(0.0, _scrollController.position.maxScrollExtent);

        _isProgrammaticScrolling = true;
        _scrollController
            .animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeInOutCubic,
            )
            .whenComplete(() {
              if (mounted) {
                _isProgrammaticScrolling = false;
                _updateActiveSection();
              }
            });
        return;
      }
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
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

  Future<void> _downloadResume() async {
    final uri = Uri.base.resolve(resumeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
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
        backgroundColor: Palette.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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
          // Main Scrollable Body
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Top spacer for sticky header
                const SizedBox(height: 72),

                // Centered Editorial Body
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 780),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          // Hero Section
                          FadeSlideReveal(
                            delayMs: 0,
                            child: _HeroSection(
                              key: _heroKey,
                              heroNameKey: _heroNameKey,
                              isMobile: isMobile,
                              onScrollToProjects: () =>
                                  _scrollTo(_projectsKey, section: 'projects'),
                              onScrollToContact: () =>
                                  _scrollTo(_contactKey, section: 'contact'),
                              onDownloadResume: _downloadResume,
                              onOpenGitHub: () => _openUrl(githubUrl),
                              onOpenLinkedIn: () => _openUrl(linkedinUrl),
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 01: Projects & Systems Work
                          FadeSlideReveal(
                            delayMs: 90,
                            child: _ProjectsSection(
                              key: _projectsKey,
                              isMobile: isMobile,
                              onOpenUrl: _openUrl,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 02: Professional Experience
                          FadeSlideReveal(
                            delayMs: 180,
                            child: _ExperienceSection(
                              key: _experienceKey,
                              isMobile: isMobile,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 03: Engineering Capabilities
                          FadeSlideReveal(
                            delayMs: 230,
                            child: _EngineeringCapabilitiesSection(
                              key: _capabilitiesKey,
                              isMobile: isMobile,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 04: Education
                          FadeSlideReveal(
                            delayMs: 280,
                            child: _EducationSection(
                              key: _educationKey,
                              isMobile: isMobile,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 05: Contact & Channels
                          FadeSlideReveal(
                            delayMs: 340,
                            child: _ContactSection(
                              key: _contactKey,
                              isMobile: isMobile,
                              onCopyEmail: () => _copyEmail(context),
                              onOpenUrl: _openUrl,
                              onDownloadResume: _downloadResume,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // Footer
                          FadeSlideReveal(
                            delayMs: 400,
                            child: _Footer(
                              onScrollToTop: () => _scrollTo(_heroKey),
                              onOpenUrl: _openUrl,
                            ),
                          ),

                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sticky Apple Frosted Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _StickyHeader(
              isMobile: isMobile,
              showIdentity: _showStickyIdentity,
              activeSection: _activeSection,
              onScrollToHero: () => _scrollTo(_heroKey),
              onScrollToProjects: () =>
                  _scrollTo(_projectsKey, section: 'projects'),
              onScrollToExperience: () =>
                  _scrollTo(_experienceKey, section: 'experience'),
              onScrollToCapabilities: () =>
                  _scrollTo(_capabilitiesKey, section: 'capabilities'),
              onScrollToEducation: () =>
                  _scrollTo(_educationKey, section: 'education'),
              onScrollToContact: () =>
                  _scrollTo(_contactKey, section: 'contact'),
              onDownloadResume: _downloadResume,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky Frosted Navigation Header
// ---------------------------------------------------------------------------
class _StickyHeader extends StatelessWidget {
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

  const _StickyHeader({
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
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Palette.surfaceSecondary,
                                border: Border.all(
                                    color: Palette.border, width: 1.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/avatar.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Palette.textMuted,
                                ),
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
                              _HeaderLink(
                                label: 'Projects',
                                isSelected: activeSection == 'projects',
                                onTap: onScrollToProjects,
                              ),
                              _HeaderLink(
                                label: 'Experience',
                                isSelected: activeSection == 'experience',
                                onTap: onScrollToExperience,
                              ),
                              _HeaderLink(
                                label: 'Capabilities',
                                isSelected: activeSection == 'capabilities',
                                onTap: onScrollToCapabilities,
                              ),
                              _HeaderLink(
                                label: 'Education',
                                isSelected: activeSection == 'education',
                                onTap: onScrollToEducation,
                              ),
                              const SizedBox(width: 6),
                              _HeaderResumeButton(
                                onTap: onDownloadResume,
                              ),
                              const SizedBox(width: 6),
                              _HeaderContactButton(
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
                          _HeaderMobileResumeButton(
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

class _HeaderLink extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _HeaderLink({
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<_HeaderLink> createState() => _HeaderLinkState();
}

class _HeaderLinkState extends State<_HeaderLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    final textColor = active
        ? Palette.accent
        : (_hovered ? Palette.textPrimary : Palette.textSecondary);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderResumeButton extends StatefulWidget {
  final VoidCallback onTap;

  const _HeaderResumeButton({required this.onTap});

  @override
  State<_HeaderResumeButton> createState() => _HeaderResumeButtonState();
}

class _HeaderResumeButtonState extends State<_HeaderResumeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor = _hovered ? Palette.accent : Palette.textPrimary;
    final iconColor = _hovered ? Palette.accent : Palette.accent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 13,
                color: iconColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Resume',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 3),
              Icon(
                Icons.arrow_downward,
                size: 11,
                color: _hovered ? Palette.accent : Palette.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderMobileResumeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderMobileResumeButton({required this.onTap});

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
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderContactButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _HeaderContactButton({
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<_HeaderContactButton> createState() => _HeaderContactButtonState();
}

class _HeaderContactButtonState extends State<_HeaderContactButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    final color = active
        ? Palette.accent
        : (_hovered ? Palette.accentHover : Palette.accent);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            'Contact →',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animation Primitives & Interactive Hover Helpers
// ---------------------------------------------------------------------------

/// Staggered entrance fade & vertical slide reveal
class FadeSlideReveal extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final Duration duration;
  final double yOffset;

  const FadeSlideReveal({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.duration = const Duration(milliseconds: 550),
    this.yOffset = 18.0,
  });

  @override
  State<FadeSlideReveal> createState() => _FadeSlideRevealState();
}

class _FadeSlideRevealState extends State<FadeSlideReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.yOffset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    final isTest = WidgetsBinding.instance.runtimeType
        .toString()
        .toLowerCase()
        .contains('test');

    if (isTest || widget.delayMs == 0) {
      _controller.forward();
    } else {
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Interactive card wrapper that gently lifts and accents its border on hover
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(12);
    final borderColor = _isHovered
        ? (widget.hoverBorderColor ?? Palette.accent.withValues(alpha: 0.35))
        : (widget.normalBorderColor ?? Palette.border);
    final bgColor = _isHovered
        ? (widget.hoverBackgroundColor ?? Palette.surface)
        : (widget.normalBackgroundColor ?? Palette.surface);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            0,
            _isHovered ? -widget.liftDistance : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: br,
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: _isHovered
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
          child: widget.child,
        ),
      ),
    );
  }
}

/// Subtle spring button scale on hover
class _HoverScaleButton extends StatefulWidget {
  final Widget child;

  const _HoverScaleButton({required this.child});

  @override
  State<_HoverScaleButton> createState() => _HoverScaleButtonState();
}

class _HoverScaleButtonState extends State<_HoverScaleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Circular portrait with gentle hover scale and accent halo
class _InteractiveAvatar extends StatefulWidget {
  const _InteractiveAvatar();

  @override
  State<_InteractiveAvatar> createState() => _InteractiveAvatarState();
}

class _InteractiveAvatarState extends State<_InteractiveAvatar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
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
                    color: _isHovered ? Palette.accent : Palette.border,
                    width: _isHovered ? 1.5 : 1.0,
                  ),
                  boxShadow: _isHovered
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
      ),
    );
  }
}

/// External source link with interactive arrow slide
class _ProjectSourceLink extends StatefulWidget {
  final String url;
  final VoidCallback onTap;

  const _ProjectSourceLink({
    required this.url,
    required this.onTap,
  });

  @override
  State<_ProjectSourceLink> createState() => _ProjectSourceLinkState();
}

class _ProjectSourceLinkState extends State<_ProjectSourceLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Source',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _isHovered ? Palette.accentHover : Palette.accent,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedSlide(
                offset: _isHovered ? const Offset(0.15, -0.15) : Offset.zero,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                child: Icon(
                  Icons.arrow_outward,
                  size: 13,
                  color: _isHovered ? Palette.accentHover : Palette.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 00: Hero & Introduction
// ---------------------------------------------------------------------------
class _HeroSection extends StatelessWidget {
  final bool isMobile;
  final GlobalKey? heroNameKey;
  final VoidCallback onScrollToProjects;
  final VoidCallback onScrollToContact;
  final VoidCallback onDownloadResume;
  final VoidCallback onOpenGitHub;
  final VoidCallback onOpenLinkedIn;

  const _HeroSection({
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
            const _InteractiveAvatar(),
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
            _HoverScaleButton(
              child: ElevatedButton(
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
            ),
            _HoverScaleButton(
              child: OutlinedButton(
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
            ),
            _HoverScaleButton(
              child: OutlinedButton.icon(
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
            ),
            _HoverScaleButton(
              child: TextButton.icon(
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
            ),
            _HoverScaleButton(
              child: TextButton.icon(
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
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 01: Projects & Systems Work
// ---------------------------------------------------------------------------
class _ProjectsSection extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<String> onOpenUrl;

  const _ProjectsSection({
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
          _ProjectCard(
            item: item,
            isMobile: isMobile,
            onOpenUrl: onOpenUrl,
          ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectItem item;
  final bool isMobile;
  final ValueChanged<String> onOpenUrl;

  const _ProjectCard({
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
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Header: Category tag and external link indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  item.category.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: Palette.accent,
                  ),
                ),
              ),
              if (item.link != null)
                _ProjectSourceLink(
                  url: item.link!,
                  onTap: () => onOpenUrl(item.link!),
                ),
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
              for (final tech in item.techStack) MonoChip(tech, isSmall: true),
            ],
          ),
        ],
      ),
    )));
  }
}

// ---------------------------------------------------------------------------
// 02: Professional Experience
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
          title: 'Professional Experience',
          indexTag: '02 / Production Timeline',
        ),
        const SizedBox(height: 28),
        for (int i = 0; i < jobs.length; i++)
          _TimelineItem(
            job: jobs[i],
            isLast: i == jobs.length - 1,
            isMobile: isMobile,
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Job job;
  final bool isLast;
  final bool isMobile;

  const _TimelineItem({
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
                  child: _TimelineNode(isCurrent: job.isCurrent),
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
                    if (isMobile)
                      _buildMobileHeader(context)
                    else
                      _buildDesktopHeader(context),

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
                                    child: _ProductionPlatformCard(
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
                                    child: _ProductionPlatformCard(
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

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      job.role,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Palette.textPrimary,
                      ),
                    ),
                  ),
                  if (job.isCurrent) ...[
                    const SizedBox(width: 10),
                    const _CurrentBadge(),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${job.company} · ${job.location}',
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Palette.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Palette.surfaceSecondary,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Palette.border, width: 1.0),
          ),
          child: Text(
            job.period,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Palette.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                job.role,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: Palette.textPrimary,
                ),
              ),
            ),
            if (job.isCurrent) ...[
              const SizedBox(width: 8),
              const _CurrentBadge(),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${job.company} · ${job.location}',
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Palette.accent,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Palette.surfaceSecondary,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Palette.border, width: 1.0),
          ),
          child: Text(
            job.period,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Palette.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final bool isCurrent;

  const _TimelineNode({required this.isCurrent});

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

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge();

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

class _ProductionPlatformCard extends StatelessWidget {
  final ProductionPlatform platform;
  final bool isDesktop;

  const _ProductionPlatformCard({
    required this.platform,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
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
            if (isDesktop)
              Expanded(
                child: Text(
                  platform.description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Palette.textSecondary,
                    height: 1.5,
                  ),
                ),
              )
            else
              Text(
                platform.description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Palette.textSecondary,
                  height: 1.5,
                ),
              ),
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

// ---------------------------------------------------------------------------
// 03: Engineering Capabilities
// ---------------------------------------------------------------------------
class _EngineeringCapabilitiesSection extends StatelessWidget {
  final bool isMobile;

  const _EngineeringCapabilitiesSection({
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
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Palette.border,
                ),
                for (int i = 0; i < capabilityGroups.length; i++) ...[
                  _SpecMatrixRow(
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

class _SpecMatrixRow extends StatelessWidget {
  final CapabilityGroup group;
  final bool isWide;

  const _SpecMatrixRow({
    required this.group,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 22,
        horizontal: isWide ? 8 : 2,
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Column: Index Badge + Title
                SizedBox(
                  width: 250,
                  child: Row(
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
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                            color: Palette.textPrimary,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Right Column: Interactive Token Pills
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final bullet in group.bullets)
                        _SpecTokenPill(
                          label: bullet,
                          accentColor: group.accentColor,
                        ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          color: Palette.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final bullet in group.bullets)
                      _SpecTokenPill(
                        label: bullet,
                        accentColor: group.accentColor,
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _SpecTokenPill extends StatefulWidget {
  final String label;
  final Color accentColor;

  const _SpecTokenPill({
    required this.label,
    required this.accentColor,
  });

  @override
  State<_SpecTokenPill> createState() => _SpecTokenPillState();
}

class _SpecTokenPillState extends State<_SpecTokenPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = _hovered
        ? widget.accentColor.withValues(alpha: 0.12)
        : Palette.surfaceSecondary;

    final borderColor = _hovered
        ? widget.accentColor.withValues(alpha: 0.45)
        : Palette.border;

    final textColor = _hovered
        ? widget.accentColor
        : Palette.textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              width: _hovered ? 5 : 4.5,
              height: _hovered ? 5 : 4.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.accentColor,
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: widget.accentColor.withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: _hovered ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: -0.2,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 04: Education
// ---------------------------------------------------------------------------
class _EducationSection extends StatelessWidget {
  final bool isMobile;

  const _EducationSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Education',
          indexTag: '04 / Academic Background',
        ),
        const SizedBox(height: 24),

        // Education Card
        HoverInteractiveCard(
          borderRadius: BorderRadius.circular(10),
          liftDistance: 2.5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FORMAL EDUCATION',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: Palette.accent,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        education.degree,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Palette.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      education.period,
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                        color: Palette.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${education.institution} · ${education.location}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 04: Contact & Reach Out
// ---------------------------------------------------------------------------
class _ContactSection extends StatefulWidget {
  final bool isMobile;
  final VoidCallback onCopyEmail;
  final ValueChanged<String> onOpenUrl;
  final VoidCallback onDownloadResume;

  const _ContactSection({
    super.key,
    required this.isMobile,
    required this.onCopyEmail,
    required this.onOpenUrl,
    required this.onDownloadResume,
  });

  @override
  State<_ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<_ContactSection> {
  bool _copied = false;

  void _handleCopy() {
    widget.onCopyEmail();
    setState(() => _copied = true);
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() => _copied = false);
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
                    _HoverScaleButton(
                      child: ElevatedButton.icon(
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
                    ),
                    _HoverScaleButton(
                      child: OutlinedButton.icon(
                        onPressed: _handleCopy,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _copied ? Palette.accent : Palette.textPrimary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          side: BorderSide(
                            color: _copied ? Palette.accent : Palette.border,
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
                            _copied ? Icons.check : Icons.copy_outlined,
                            key: ValueKey<bool>(_copied),
                            size: 14,
                            color: _copied ? Palette.accent : null,
                          ),
                        ),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _copied ? 'Address Copied!' : 'Copy Address',
                            key: ValueKey<bool>(_copied),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _copied ? Palette.accent : null,
                            ),
                          ),
                        ),
                      ),
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
            _ChannelLink(
              label: 'GitHub',
              handle: 'prnvmrli',
              onTap: () => widget.onOpenUrl(githubUrl),
            ),
            _ChannelLink(
              label: 'LinkedIn',
              handle: 'prnvmrli',
              onTap: () => widget.onOpenUrl(linkedinUrl),
            ),
            _ChannelLink(
              label: 'Resume',
              handle: 'PDF Download',
              onTap: widget.onDownloadResume,
            ),
          ],
        ),
      ],
    );
  }
}

class _ChannelLink extends StatefulWidget {
  final String label;
  final String handle;
  final VoidCallback onTap;

  const _ChannelLink({
    required this.label,
    required this.handle,
    required this.onTap,
  });

  @override
  State<_ChannelLink> createState() => _ChannelLinkState();
}

class _ChannelLinkState extends State<_ChannelLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -2.0 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Palette.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered
                  ? Palette.accent.withValues(alpha: 0.4)
                  : Palette.border,
              width: 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Palette.accent.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _isHovered ? Palette.accent : Palette.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                offset: _isHovered ? const Offset(0.12, -0.12) : Offset.zero,
                child: const Icon(
                  Icons.arrow_outward,
                  size: 13,
                  color: Palette.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------
class _Footer extends StatelessWidget {
  final VoidCallback onScrollToTop;
  final ValueChanged<String> onOpenUrl;

  const _Footer({
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
            _BackToTopButton(onTap: onScrollToTop),
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

class _BackToTopButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackToTopButton({required this.onTap});

  @override
  State<_BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<_BackToTopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Back to top',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: _isHovered ? Palette.accent : Palette.textMuted,
                  fontWeight: _isHovered ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                offset: _isHovered ? const Offset(0, -0.2) : Offset.zero,
                child: Icon(
                  Icons.arrow_upward,
                  size: 12,
                  color: _isHovered ? Palette.accent : Palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
