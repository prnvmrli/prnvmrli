import 'package:flutter/material.dart';

const name = 'Pranav Murali';
const role = 'Mobile Systems Engineer — Flutter';
const location = 'Kerala, India';
const yearsExperience = '5 Years Production Experience';

const specializationPillars = [
  'Flutter',
  'Architecture',
  'SDK Engineering',
  'Real-time Systems',
  'Performance',
];

const specialization =
    'Flutter · Architecture · SDK Engineering · Real-time Systems · Performance';

const aboutBio =
    'Software engineer with 5 years of experience building production software. Focused on application architecture, developer SDKs, reactive state management, real-time streaming, rendering performance, and maintainable APIs. At IOURING Private Limited, I work on production trading applications, charting SDKs, and modular multi-tenant systems designed for performance, stability, and maintainability.';

class ProjectItem {
  final String title;
  final String category;
  final String description;
  final String technicalDetails;
  final List<String> techStack;
  final String? link;
  final bool isInProgress;
  final String? statusLabel;

  const ProjectItem({
    required this.title,
    required this.category,
    required this.description,
    required this.technicalDetails,
    required this.techStack,
    this.link,
    this.isInProgress = false,
    this.statusLabel,
  });
}

const projects = [
  ProjectItem(
    title: 'f-cleaner — Desktop Disk Cleanup App',
    category: 'Flutter Desktop / macOS · fl-studio',
    description: 'An app built on top of fclean (core Dart CLI cleanup engine). A native macOS desktop disk cleanup utility and cache visualizer that reclaims gigabytes of disk space from stale Flutter build artifacts, derived data, and Gradle/Xcode caches.',
    technicalDetails: 'Engineered on top of fclean with stream-based asynchronous file system traversal, reactive disk scan state, and native Swift/WidgetKit desktop extensions for glanceable storage telemetry.',
    techStack: [
      'Flutter Desktop',
      'Dart',
      'fclean CLI',
      'macOS / WidgetKit',
      'Swift',
      'Melos Monorepo',
    ],
    link: 'https://github.com/prnvmrli/fl-studio',
  ),
  ProjectItem(
    title: 'android_system_chrome — System Bar Management Plugin',
    category: 'Flutter Plugin / Android Native · fl-studio',
    description: 'Open-source Flutter plugin providing fine-grained runtime control over Android system UI elements, enabling modern translucent edge-to-edge styling, dynamic status bar tinting, and adaptive navigation bar contrast.',
    technicalDetails: 'Implemented native Android platform channel bindings in Kotlin interfacing with modern WindowInsets and WindowInsetsControllerCompat APIs across Android SDK versions.',
    techStack: [
      'Flutter',
      'Dart',
      'Android Native',
      'Kotlin',
      'Platform Channels',
      'WindowInsets',
    ],
    link: 'https://github.com/prnvmrli/fl-studio',
    isInProgress: true,
  ),
  ProjectItem(
    title: 'flutter_notification_icons — Dynamic Notification Icon Utility',
    category: 'Flutter Package / Android Native · fl-studio',
    description: 'Lightweight utility package for resolving, customizing, and styling Android notification icons, small drawables, and badge accents in Flutter applications.',
    technicalDetails: 'Provides clean declarative APIs for dynamic asset resolution, resource tinting, and consistent notification icon presentation across diverse OEM Android distributions.',
    techStack: [
      'Flutter',
      'Dart',
      'Android Native',
      'Package Engineering',
      'Asset Pipeline',
    ],
    link: 'https://github.com/prnvmrli/fl-studio',
    isInProgress: true,
  ),
  ProjectItem(
    title: 'aviary — Private Dart Pub Server',
    category: 'Open-Source Infrastructure',
    description: 'Self-hosted private Dart Pub server designed for enterprise package distribution, internal dependency hosting, and team-wide package governance.',
    technicalDetails: 'Provides a private package registry and local caching layer to support modular Dart and Flutter library distribution across enterprise teams with token-based access control.',
    techStack: [
      'Dart',
      'Pub Server',
      'Package Management',
      'HTTP Server',
      'CLI Tooling',
    ],
    link: 'https://github.com/prnvmrli/aviary',
    isInProgress: true,
  ),
];

class ProductionPlatform {
  final String name;
  final String subtitle;
  final String description;
  final List<String> techStack;

  const ProductionPlatform({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.techStack,
  });
}

class Job {
  final String role;
  final String company;
  final String period;
  final String location;
  final String summary;
  final List<String> bulletPoints;
  final List<ProductionPlatform> platforms;
  final bool isCurrent;

  const Job({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.summary,
    required this.bulletPoints,
    this.platforms = const [],
    this.isCurrent = false,
  });
}

const jobs = [
  Job(
    role: 'Software Developer (Flutter & React)',
    company: 'IOURING Private Limited',
    period: 'Jan 2022 — Present',
    location: 'Chennai, TN, India',
    summary: 'Developing and maintaining production Flutter mobile/web applications and React web apps, focusing on financial trading terminals, charting tools (NeoCharts), and client SDKs.',
    isCurrent: true,
    bulletPoints: [
      'Developed and maintained 3+ production Flutter mobile/web applications and 2+ React web apps, focusing on trading systems and custom SDKs.',
      'Architected resilient WebSocket streaming pipelines and RESTful integrations for real-time market quotes and live order execution.',
      'Applied BLoC pattern and Clean Architecture principles to construct scalable, modular, and easily testable Flutter codebases.',
      'Integrated SQLite with Drift for high-efficiency local data caching, enabling seamless offline resumption and sub-10ms queries.',
      'Delivered white-label solutions from a unified codebase, supporting distinct branding and multi-client deployments.',
      'Collaborated closely with product and UI/UX designers to translate Figma designs into pixel-perfect, 60fps Flutter user experiences.',
    ],
    platforms: [
      ProductionPlatform(
        name: 'NeoCharts',
        subtitle: 'Precision Charting Infrastructure & SDK',
        description: 'Mobile-native, white-label precision charting platform and SDK for stockbrokers. Features 60fps canvas rendering, one-click order placement from charts, visual stop-loss/target, and real-time streaming P&L across Android, iOS, and Web.',
        techStack: [
          'Flutter',
          'Canvas Rendering',
          'Charting SDK',
          'Real-time Streaming',
          'WebSockets',
        ],
      ),
      ProductionPlatform(
        name: 'NxtOption',
        subtitle: 'Options Trading Platform & SDK',
        description: 'Dedicated options trading platform developed for React web and Flutter mobile. Features interactive Strategy Builder, real-time OI/PCR analytics charts, and a client trading SDK with deterministic WebSocket reconnection.',
        techStack: [
          'Flutter',
          'ReactJS',
          'Trading SDK',
          'WebSockets',
          'BLoC',
          'Redux',
        ],
      ),
      ProductionPlatform(
        name: 'NxTrad',
        subtitle: 'Full Market Access Trading Platform',
        description: 'Full-market access trading solution across mobile and web with Flutter Web admin console. Features low-latency order routing, scalper mode, automated screenshot detection deep-linking, and Drift/SQLite offline caching.',
        techStack: [
          'Flutter',
          'Flutter Web',
          'Clean Architecture',
          'BLoC',
          'SQLite / Drift',
          'Deep Linking',
        ],
      ),
    ],
  ),
];

class Education {
  final String degree;
  final String institution;
  final String period;
  final String location;

  const Education({
    required this.degree,
    required this.institution,
    required this.period,
    required this.location,
  });
}

const education = Education(
  degree: 'B.Tech in Mechanical Engineering',
  institution: 'Government Engineering College, Idukki',
  period: '2016 — 2020',
  location: 'Kerala, India',
);

class CapabilityGroup {
  final String index;
  final String title;
  final List<String> bullets;
  final Color accentColor;

  const CapabilityGroup({
    required this.index,
    required this.title,
    required this.bullets,
    required this.accentColor,
  });
}

const capabilityGroups = [
  CapabilityGroup(
    index: '01',
    title: 'Languages & Frameworks',
    bullets: [
      'Dart',
      'Flutter',
      'React',
      'JavaScript',
      'TypeScript',
      'Python',
      'HTML & CSS',
    ],
    accentColor: Color(0xFF0071E3), // Apple Tech Blue
  ),
  CapabilityGroup(
    index: '02',
    title: 'Architecture & SDK Engineering',
    bullets: [
      'Clean Architecture',
      'Modularization',
      'Monorepos (Melos)',
      'SDKs',
      'BLoC',
    ],
    accentColor: Color(0xFF5856D6), // Apple Indigo
  ),
  CapabilityGroup(
    index: '03',
    title: 'Real-time Systems',
    bullets: ['Firebase', 'WebSockets', 'REST API'],
    accentColor: Color(0xFF28CD41), // Apple Emerald
  ),
  CapabilityGroup(
    index: '04',
    title: 'Security & Reliability',
    bullets: ['SSL Pinning', 'Secure Storage'],
    accentColor: Color(0xFFFF9500), // Apple Amber
  ),
  CapabilityGroup(
    index: '05',
    title: 'Testing & Delivery',
    bullets: ['Integration Testing', 'Patrol', 'Git', 'Azure DevOps'],
    accentColor: Color(0xFF30B0C7), // Apple Teal
  ),
];

const email = 'prnvmrli@gmail.com';
const githubUrl = 'https://github.com/prnvmrli';
const linkedinUrl = 'https://linkedin.com/in/prnvmrli/';
const resumeUrl = 'resume.pdf';
