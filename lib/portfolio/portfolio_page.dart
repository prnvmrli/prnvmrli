import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';
import 'sections/capabilities_section.dart';
import 'sections/contact_section.dart';
import 'sections/education_section.dart';
import 'sections/experience_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'sections/sticky_header.dart';
import 'theme.dart';
import 'widgets/fade_slide_reveal.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showStickyIdentity = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _activeSection = ValueNotifier<String?>(null);
  bool _isProgrammaticScrolling = false;

  double? _cachedHeroNameBottomY;

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _heroNameKey = GlobalKey();
  final Map<String, GlobalKey> _sectionKeys = {
    'projects': GlobalKey(),
    'experience': GlobalKey(),
    'capabilities': GlobalKey(),
    'education': GlobalKey(),
    'contact': GlobalKey(),
  };
  final Map<String, double> _cachedSectionY = {};

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
      final nameBottomScreenY =
          nameBox.localToGlobal(Offset.zero).dy + nameBox.size.height;
      show = nameBottomScreenY <= 60;
    } else if (_cachedHeroNameBottomY != null) {
      show = _scrollController.offset >= (_cachedHeroNameBottomY! - 60);
    } else {
      show = _scrollController.offset > 110;
    }

    if (show != _showStickyIdentity.value) {
      _showStickyIdentity.value = show;
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

    for (final entry in _sectionKeys.entries) {
      final y = _getSectionAbsoluteY(entry.value);
      if (y != null) _cachedSectionY[entry.key] = y;
    }
  }

  void _updateActiveSection() {
    if (!_scrollController.hasClients) return;

    _updateSectionPositions();

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if (maxScroll > 0 && currentScroll >= maxScroll - 60) {
      if (_activeSection.value != 'contact') {
        _activeSection.value = 'contact';
      }
      return;
    }

    final currentY = currentScroll + 220.0;
    String? newSection;
    for (final section in _sectionKeys.keys.toList().reversed) {
      final y = _cachedSectionY[section];
      if (y != null && currentY >= y) {
        newSection = section;
        break;
      }
    }

    if (newSection != _activeSection.value) {
      _activeSection.value = newSection;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _showStickyIdentity.dispose();
    _activeSection.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key, {String? section}) {
    if (section != null) {
      _activeSection.value = section;
    } else if (key == _heroKey) {
      _activeSection.value = null;
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
                            child: HeroSection(
                              key: _heroKey,
                              heroNameKey: _heroNameKey,
                              isMobile: isMobile,
                              onScrollToProjects: () =>
                                  _scrollTo(_sectionKeys['projects']!, section: 'projects'),
                              onScrollToContact: () =>
                                  _scrollTo(_sectionKeys['contact']!, section: 'contact'),
                              onDownloadResume: _downloadResume,
                              onOpenGitHub: () => _openUrl(githubUrl),
                              onOpenLinkedIn: () => _openUrl(linkedinUrl),
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 01: Projects & Systems Work
                          FadeSlideReveal(
                            delayMs: 90,
                            child: ProjectsSection(
                              key: _sectionKeys['projects'],
                              isMobile: isMobile,
                              onOpenUrl: _openUrl,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 02: Professional Experience
                          FadeSlideReveal(
                            delayMs: 180,
                            child: ExperienceSection(
                              key: _sectionKeys['experience'],
                              isMobile: isMobile,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 03: Engineering Capabilities
                          FadeSlideReveal(
                            delayMs: 230,
                            child: EngineeringCapabilitiesSection(
                              key: _sectionKeys['capabilities'],
                              isMobile: isMobile,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 04: Education
                          FadeSlideReveal(
                            delayMs: 280,
                            child: EducationSection(
                              key: _sectionKeys['education'],
                              isMobile: isMobile,
                            ),
                          ),

                          const SizedBox(height: 88),

                          // 05: Contact & Channels
                          FadeSlideReveal(
                            delayMs: 340,
                            child: ContactSection(
                              key: _sectionKeys['contact'],
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
                            child: FooterSection(
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
            child: ValueListenableBuilder<bool>(
              valueListenable: _showStickyIdentity,
              builder: (context, showIdentity, _) {
                return ValueListenableBuilder<String?>(
                  valueListenable: _activeSection,
                  builder: (context, activeSection, _) {
                    return StickyHeader(
                      isMobile: isMobile,
                      showIdentity: showIdentity,
                      activeSection: activeSection,
                      onScrollToHero: () => _scrollTo(_heroKey),
                      onScrollToProjects: () =>
                          _scrollTo(_sectionKeys['projects']!, section: 'projects'),
                      onScrollToExperience: () =>
                          _scrollTo(_sectionKeys['experience']!, section: 'experience'),
                      onScrollToCapabilities: () =>
                          _scrollTo(_sectionKeys['capabilities']!, section: 'capabilities'),
                      onScrollToEducation: () =>
                          _scrollTo(_sectionKeys['education']!, section: 'education'),
                      onScrollToContact: () =>
                          _scrollTo(_sectionKeys['contact']!, section: 'contact'),
                      onDownloadResume: _downloadResume,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
