import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'theme.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _keys = <String, GlobalKey>{
    'About': GlobalKey(),
    'Focus': GlobalKey(),
    'Experience': GlobalKey(),
    'Projects': GlobalKey(),
    'Skills': GlobalKey(),
    'Education': GlobalKey(),
    'Contact': GlobalKey(),
  };

  void _scrollTo(String section) {
    final ctx = _keys[section]?.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero).dy + _scroll.offset - 76;
    _scroll.animateTo(
      offset.clamp(0.0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(
                child: _Hero(
                  onProjects: () => _scrollTo('Projects'),
                  onContact: () => _scrollTo('Contact'),
                ),
              ),
              SliverToBoxAdapter(child: _About(key: _keys['About'])),
              SliverToBoxAdapter(child: _FocusAreas(key: _keys['Focus'])),
              SliverToBoxAdapter(child: _Experience(key: _keys['Experience'])),
              SliverToBoxAdapter(child: _Projects(key: _keys['Projects'])),
              SliverToBoxAdapter(child: _Skills(key: _keys['Skills'])),
              SliverToBoxAdapter(child: _Education(key: _keys['Education'])),
              SliverToBoxAdapter(child: _Contact(key: _keys['Contact'])),
              const SliverToBoxAdapter(child: _Footer()),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _NavBar(onTap: _scrollTo),
          ),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final void Function(String) onTap;
  const _NavBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 820;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 18 : 32,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Palette.bg.withValues(alpha: 0.9),
            border: const Border(bottom: BorderSide(color: Palette.border)),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Palette.accent, Color(0xFF0288D1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'PM',
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Palette.bg,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Palette.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final s in [
                          'About',
                          'Experience',
                          'Projects',
                          'Skills',
                          'Contact',
                        ])
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: TextButton(
                              onPressed: () => onTap(s),
                              style: TextButton.styleFrom(
                                foregroundColor: Palette.textSecondary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                              ),
                              child: Text(
                                s,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Palette.textSecondary, size: 22),
                      onPressed: () => onTap('Projects'),
                      tooltip: 'Menu',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Shell extends StatelessWidget {
  final Widget child;
  final double verticalPadding;
  const _Shell({required this.child, this.verticalPadding = 64});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1040),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
          child: child,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final VoidCallback onProjects;
  final VoidCallback onContact;
  const _Hero({required this.onProjects, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 720;

    return _Shell(
      verticalPadding: 0,
      child: Padding(
        padding: EdgeInsets.only(top: isMobile ? 100 : 124, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Palette.surface,
                border: Border.all(color: Palette.border),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Palette.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    role,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Crafting high-performance\nmobile apps & real-time\ntrading systems.',
              style: isMobile
                  ? Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 34)
                  : Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 22),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                'Hi, I\'m $name. Over 3 years of hands-on experience building '
                'responsive, scalable applications with Flutter & React JS — specializing in trading platforms, '
                'financial charting, custom SDKs, and low-latency WebSocket streaming.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 17),
              ),
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onProjects,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('View Projects', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: FilledButton.styleFrom(
                    backgroundColor: Palette.accent,
                    foregroundColor: Palette.bg,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onContact,
                  icon: const Icon(Icons.mail_outline_rounded, size: 16),
                  label: const Text('Get in Touch', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Palette.textPrimary,
                    side: const BorderSide(color: Palette.border),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            const Hairline(),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 640;
                return Wrap(
                  spacing: isNarrow ? 20 : 36,
                  runSpacing: 20,
                  children: const [
                    _StatCard(value: '3+ Years', label: 'Hands-on Experience'),
                    _StatCard(value: '5+ Apps', label: 'Production Flutter & React'),
                    _StatCard(value: 'Trading SDKs', label: 'Tailored Client Modules'),
                    _StatCard(value: 'Real-Time', label: 'WebSockets & Clean Arch'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Palette.accent,
            fontFamily: 'Space Grotesk',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Palette.textSecondary,
            fontFamily: 'IBM Plex Mono',
          ),
        ),
      ],
    );
  }
}

class _About extends StatelessWidget {
  const _About({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('About'),
          const SizedBox(height: 12),
          const SectionTitle('Engineered for performance & polish'),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(about, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Palette.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Palette.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 3,
                    color: Palette.accent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded, size: 18, color: Palette.accent),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            motto,
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 13,
                              color: Palette.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusAreas extends StatelessWidget {
  const _FocusAreas({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      verticalPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Core Capabilities'),
          const SizedBox(height: 12),
          const SectionTitle('What I do'),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 640 ? 1 : 2;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final item in focusAreas)
                    SizedBox(
                      width: crossAxisCount == 1
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                      child: _FocusCard(item: item),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatefulWidget {
  final FocusArea item;
  const _FocusCard({required this.item});

  @override
  State<_FocusCard> createState() => _FocusCardState();
}

class _FocusCardState extends State<_FocusCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _hover ? Palette.surfaceHover : Palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover ? Palette.borderHover : Palette.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.item.icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 12),
            Text(
              widget.item.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Experience extends StatelessWidget {
  const _Experience({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Experience'),
          const SizedBox(height: 12),
          const SectionTitle('Where I\'ve worked'),
          const SizedBox(height: 28),
          for (final job in jobs) _JobCard(job: job),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;
  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 580;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.company,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Palette.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${job.location} • ${job.period}',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 12,
                        color: Palette.textSecondary,
                      ),
                    ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Palette.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          job.location,
                          style: const TextStyle(
                            fontFamily: 'IBM Plex Mono',
                            fontSize: 12,
                            color: Palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Palette.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Palette.border),
                    ),
                    child: Text(
                      job.period,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(job.summary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          const Hairline(),
          const SizedBox(height: 20),
          const Text(
            'KEY RESPONSIBILITIES & CONTRIBUTIONS',
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: Palette.accent,
            ),
          ),
          const SizedBox(height: 14),
          for (final bullet in job.achievements)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7, right: 12),
                    child: Icon(Icons.circle, size: 6, color: Palette.accent),
                  ),
                  Expanded(
                    child: Text(
                      bullet,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Palette.textPrimary,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Projects extends StatelessWidget {
  const _Projects({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Selected Work'),
          const SizedBox(height: 12),
          const SectionTitle('Featured Projects & Platforms'),
          const SizedBox(height: 28),
          for (final p in projects) _ProjectCard(p),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  const _ProjectCard(this.project);

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hover ? Palette.surfaceHover : Palette.surface,
          border: Border.all(color: _hover ? Palette.borderHover : Palette.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Palette.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  p.year,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 12,
                    color: Palette.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(p.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Palette.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Palette.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in p.highlights)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6, right: 10),
                            child: Icon(Icons.check_circle_outline_rounded,
                                size: 14, color: Palette.accent),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Palette.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in p.tags)
                  MonoChip(
                    t,
                    isSmall: true,
                    background: Palette.cardBg,
                    color: Palette.textPrimary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Skills extends StatelessWidget {
  const _Skills({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Skills & Tooling'),
          const SizedBox(height: 12),
          const SectionTitle('Technical Stack'),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 640;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final cat in skillCategories)
                    SizedBox(
                      width: isNarrow
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 16) / 2,
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Palette.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Palette.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Palette.accent,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final s in cat.skills)
                                  MonoChip(
                                    s,
                                    background: Palette.cardBg,
                                    color: Palette.textPrimary,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Education extends StatelessWidget {
  const _Education({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Background'),
          const SizedBox(height: 12),
          const SectionTitle('Education & Extras'),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 640;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: isNarrow
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 16) / 2,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Palette.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Palette.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.school_rounded, color: Palette.accent, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'EDUCATION',
                                style: TextStyle(
                                  fontFamily: 'IBM Plex Mono',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            education.degree,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            education.institution,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${education.location} • ${education.period}',
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 12,
                              color: Palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: isNarrow
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 16) / 2,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Palette.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Palette.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.translate_rounded, color: Palette.accent, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'LANGUAGES & INTERESTS',
                                style: TextStyle(
                                  fontFamily: 'IBM Plex Mono',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Spoken Languages',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Palette.textSecondary,
                              fontFamily: 'IBM Plex Mono',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final lang in spokenLanguages)
                                MonoChip(lang, isSmall: true, background: Palette.cardBg),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Personal Interests',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Palette.textSecondary,
                              fontFamily: 'IBM Plex Mono',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final intItem in interests)
                                MonoChip(intItem, isSmall: true, background: Palette.cardBg),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Contact'),
          const SizedBox(height: 12),
          const SectionTitle('Let\'s build something together'),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              'I\'m open to new full-time opportunities, high-impact projects, '
              'and collaborations in mobile engineering and developer SDKs.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Palette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.border),
            ),
            child: Column(
              children: [
                _ContactRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: email,
                  onCopy: () {
                    Clipboard.setData(const ClipboardData(text: email));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Hairline(),
                const SizedBox(height: 12),
                const _ContactRow(
                  icon: Icons.code_rounded,
                  label: 'GitHub',
                  value: github,
                ),
                const SizedBox(height: 12),
                const Hairline(),
                const SizedBox(height: 12),
                const _ContactRow(
                  icon: Icons.link_rounded,
                  label: 'LinkedIn',
                  value: linkedin,
                ),
                const SizedBox(height: 12),
                const Hairline(),
                const SizedBox(height: 12),
                const _ContactRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: location,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Palette.accent),
        const SizedBox(width: 14),
        SizedBox(
          width: 90,
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 12,
              letterSpacing: 1.5,
              color: Palette.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(
              color: Palette.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (onCopy != null)
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 16, color: Palette.textSecondary),
            onPressed: onCopy,
            tooltip: 'Copy',
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '© ${DateTime.now().year} $name. Built with Flutter Web.',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 12,
                        color: Palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Build • Learn • Iterate',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 12,
                        color: Palette.accent,
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      '© ${DateTime.now().year} $name. Built with Flutter Web.',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Mono',
                        fontSize: 12,
                        color: Palette.textSecondary,
                      ),
                    ),
                  ),
                  const Text(
                    'Build • Learn • Iterate',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 12,
                      color: Palette.accent,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
