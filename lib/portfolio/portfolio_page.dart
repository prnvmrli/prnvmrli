import 'package:flutter/material.dart';
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
    'Work': GlobalKey(),
    'Experience': GlobalKey(),
    'Contact': GlobalKey(),
  };

  void _scrollTo(String section) {
    final ctx = _keys[section]?.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero).dy + _scroll.offset - 80;
    _scroll.animateTo(
      offset.clamp(0.0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 600),
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
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(child: _Hero(onContact: () => _scrollTo('Contact'))),
              SliverToBoxAdapter(child: _About(key: _keys['About'])),
              SliverToBoxAdapter(child: _Work(key: _keys['Work'])),
              SliverToBoxAdapter(child: _Experience(key: _keys['Experience'])),
              SliverToBoxAdapter(child: _Contact(key: _keys['Contact'])),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: Palette.bg.withValues(alpha: 0.8),
        border: const Border(bottom: BorderSide(color: Palette.border)),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Palette.textPrimary,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          for (final s in ['About', 'Work', 'Experience', 'Contact'])
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextButton(
                onPressed: () => onTap(s),
                style: TextButton.styleFrom(foregroundColor: Palette.textSecondary),
                child: Text(s, style: const TextStyle(fontSize: 14)),
              ),
            ),
        ],
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 72),
          child: child,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final VoidCallback onContact;
  const _Hero({required this.onContact});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonoChip(role, color: Palette.accent),
            const SizedBox(height: 24),
            Text(
              'Hi, I\'m $name.\nI build apps with Flutter.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(tagline, style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: onContact,
              style: FilledButton.styleFrom(
                backgroundColor: Palette.accent,
                foregroundColor: Palette.bg,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Get in touch', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
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
          const SectionTitle('A bit about me'),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(about, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(height: 24),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final s in stack) MonoChip(s)]),
        ],
      ),
    );
  }
}

class _Work extends StatelessWidget {
  const _Work({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Selected work'),
          const SizedBox(height: 12),
          const SectionTitle('Projects'),
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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _hover ? const Color(0xFF131318) : Palette.surface,
          border: Border.all(color: _hover ? const Color(0x2E54C5F8) : Palette.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(p.name,
                    style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Palette.textPrimary)),
                const Spacer(),
                Text(p.year,
                    style: const TextStyle(
                        fontFamily: 'IBM Plex Mono', fontSize: 12, color: Palette.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Text(p.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final t in p.tags) MonoChip(t)]),
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
          for (final j in jobs) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(j.title,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600, color: Palette.textPrimary)),
                      const SizedBox(height: 2),
                      Text(j.company,
                          style: const TextStyle(color: Palette.accent, fontSize: 14)),
                      const SizedBox(height: 6),
                      Text(j.blurb, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Text(j.period,
                    style: const TextStyle(
                        fontFamily: 'IBM Plex Mono', fontSize: 12, color: Palette.textSecondary)),
              ],
            ),
            const SizedBox(height: 22),
            if (j != jobs.last) const Hairline(),
            if (j != jobs.last) const SizedBox(height: 22),
          ],
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
          const SectionTitle('Let\'s build something'),
          const SizedBox(height: 16),
          Text('I\'m open to new opportunities and interesting projects.',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          _ContactRow('Email', email),
          _ContactRow('GitHub', github),
          _ContactRow('LinkedIn', linkedin),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String value;
  const _ContactRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label.toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 12,
                    letterSpacing: 1.5,
                    color: Palette.textSecondary)),
          ),
          SelectableText(value,
              style: const TextStyle(color: Palette.textPrimary, fontSize: 16)),
        ],
      ),
    );
  }
}
