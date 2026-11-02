import 'package:flutter/material.dart';

const name = 'Pranav Murali';
const role = 'Mobile Systems Engineer — Flutter';
const location = 'Kerala, India';
const yearsExperience = 'Nearly 5 Years Production Experience';

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
    'Mobile systems engineer with nearly 5 years of experience building production software, specialising in Flutter, mobile architecture, SDK engineering, and performance-critical systems. Experienced in developing reusable mobile foundations and real-time systems for financial platforms, with a focus on reliability, maintainability, and scalability. Integrates AI-assisted SDLC workflows to improve engineering productivity and accelerate delivery.';

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
    category: 'Flutter Desktop / macOS',
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
    link: 'https://github.com/prnvmrli/fl-studio/tree/main/apps/fcleaner',
  ),
  ProjectItem(
    title: 'android_system_chrome — System Bar Management Plugin',
    category: 'Flutter Plugin / Android Native',
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
    link: 'https://github.com/prnvmrli/fl-studio/tree/main/packages/android_system_chrome',
    isInProgress: true,
  ),
  ProjectItem(
    title: 'flutter_notification_icons — Dynamic Notification Icon Utility',
    category: 'Flutter Package / Android Native',
    description: 'Lightweight utility package for resolving, customizing, and styling Android notification icons, small drawables, and badge accents in Flutter applications.',
    technicalDetails: 'Provides clean declarative APIs for dynamic asset resolution, resource tinting, and consistent notification icon presentation across diverse OEM Android distributions.',
    techStack: [
      'Flutter',
      'Dart',
      'Android Native',
      'Package Engineering',
      'Asset Pipeline',
    ],
    link: 'https://github.com/prnvmrli/fl-studio/tree/main/packages/flutter_notification_icons',
    isInProgress: true,
  ),
  ProjectItem(
    title: 'aviary — Private Dart Pub Server',
    category: 'Open-Source Infrastructure',
    description: 'Self-hosted private Dart package registry with token-based access control and caching for enterprise Flutter and Dart package distribution.',
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
  final String? summary;
  final List<String> bulletPoints;
  final List<ProductionPlatform> platforms;
  final bool isCurrent;

  const Job({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    this.summary,
    required this.bulletPoints,
    this.platforms = const [],
    this.isCurrent = false,
  });
}

const jobs = [
  Job(
    role: 'Software Engineer',
    company: 'IOURING Private Limited',
    period: 'Oct 2022 — Present',
    location: 'Chennai, India',
    isCurrent: true,
    bulletPoints: [
      'Guided architectural decisions and implementation practices across the Flutter team, providing technical guidance and conducting code reviews to maintain code quality and consistency.',
      'Developed and maintained 3+ cross-platform Flutter applications for financial products, supporting multi-client integrations and white-label deployments.',
      'Developed Flutter SDKs and maintained shared Dart/Flutter libraries, enabling code reuse and consistent implementations across applications.',
      'Applied BLoC and Clean Architecture principles to build modular, maintainable, and testable application codebases.',
      'Integrated REST APIs, WebSockets, and Firebase services for backend communication, real-time market data, and push notifications.',
      'Profiled and optimized Flutter application performance, addressing rendering, gesture handling, and responsiveness challenges in complex interfaces.',
      'Integrated native Android SDK components into Flutter applications to support platform-specific functionality.',
      'Contributed to automated testing and CI/CD workflows, using Azure Pipelines and GitHub Actions for Flutter builds, signing, and application releases.',
    ],
    platforms: [
      ProductionPlatform(
        name: 'NeoCharts',
        subtitle: 'Precision Charting Infrastructure & SDK',
        description: 'Flutter charting SDK for financial trading platforms, featuring 60fps canvas rendering, technical indicators, interactive charts, and real-time market data streaming.',
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
        description: 'Options trading platform with real-time option-chain data, strategy analysis, interactive trading workflows, and a client trading SDK with deterministic WebSocket reconnection.',
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
  Job(
    role: 'Software Engineering Intern',
    company: 'IOURING Private Limited',
    period: 'Jan 2022 — Sep 2022',
    location: 'Chennai, India',
    isCurrent: false,
    bulletPoints: [
      'Developed and maintained 2+ web applications using React, Redux, and Material UI.',
      'Helped build Flutter UI components and integrate backend REST APIs.',
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
    title: 'Architecture & Mobile Systems',
    bullets: [
      'Clean Architecture',
      'BLoC',
      'Modularization',
      'Monorepos (Melos)',
      'SDK Development',
    ],
    accentColor: Color(0xFF5856D6), // Apple Indigo
  ),
  CapabilityGroup(
    index: '03',
    title: 'Networking & Integration',
    bullets: ['REST APIs', 'WebSockets', 'Firebase'],
    accentColor: Color(0xFF28CD41), // Apple Emerald
  ),
  CapabilityGroup(
    index: '04',
    title: 'AI Tooling & Workflows',
    bullets: ['AI-assisted SDLC', 'Local LLMs', 'Ollama', 'MCP', 'Agent Skills'],
    accentColor: Color(0xFFFF9500), // Apple Amber
  ),
  CapabilityGroup(
    index: '05',
    title: 'Testing & Delivery',
    bullets: [
      'Git',
      'Integration Testing',
      'Patrol',
      'Azure Pipelines',
      'GitHub Actions',
      'Build Automation',
      'App Store Releases',
    ],
    accentColor: Color(0xFF30B0C7), // Apple Teal
  ),
];

const email = 'prnvmrli@gmail.com';
const githubUrl = 'https://github.com/prnvmrli';
const linkedinUrl = 'https://linkedin.com/in/prnvmrli/';
const resumeUrl = 'resume.pdf';
