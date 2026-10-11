const name = 'Pranav Murali';
const role = 'Flutter & Mobile Systems Engineer';
const location = 'Kerala, India';
const yearsExperience = '3+ Years Production Systems';
const statusText = 'Available';

const aboutBio =
    "I'm a software engineer specializing in Flutter, client architecture, real-time streaming, and high-performance mobile systems. Currently building robust trading experiences and cross-platform infrastructure.";

const focusSummary =
    'Focus: Clean Architecture · BLoC & State Orchestration · Low-Latency WebSockets · Offline-First Caching';

class PlatformProject {
  final String title;
  final String tag;
  final String description;
  final String challenge;
  final String architecture;
  final List<String> techStack;

  const PlatformProject({
    required this.title,
    required this.tag,
    required this.description,
    required this.challenge,
    required this.architecture,
    required this.techStack,
  });
}

class Job {
  final String role;
  final String company;
  final String period;
  final List<String> bulletPoints;
  final List<PlatformProject> platforms;

  const Job({
    required this.role,
    required this.company,
    required this.period,
    required this.bulletPoints,
    this.platforms = const [],
  });
}

const jobs = [
  Job(
    role: 'Software Developer (Flutter & React)',
    company: 'IOURING Private Limited · Fintech & Trading Systems',
    period: 'Jan 2022 — Present',
    bulletPoints: [
      'Developed and maintained 3+ production Flutter mobile/web applications and 2+ React web apps, focusing on trading systems and custom SDKs.',
      'Architected resilient WebSocket streaming pipelines and RESTful integrations for real-time market quotes and live order execution.',
      'Applied BLoC pattern and Clean Architecture principles to construct scalable, modular, and easily testable Flutter codebases.',
      'Integrated SQLite with Drift for high-efficiency local data caching, enabling seamless offline resumption and sub-10ms queries.',
      'Delivered white-label solutions from a unified codebase, supporting distinct branding and multi-client deployments.',
    ],
    platforms: [
      PlatformProject(
        title: 'NxtOption — Options Trading Platform',
        tag: 'Low-Latency WebSockets',
        description: 'A dedicated options trading platform developed at IOURING for ReactJS web and Flutter mobile applications. Features an interactive Strategy Builder, Open Interest (OI) and Put-Call Ratio (PCR) analytics charts, and a client-tailored trading SDK.',
        challenge: 'Handling high-frequency market tick feeds and real-time options payoff diagram recalculations without dropping UI frames.',
        architecture: 'Implemented Clean Architecture with BLoC state orchestration across React web & Flutter mobile. Engineered resilient WebSocket streaming pipelines with deterministic reconnection lifecycles.',
        techStack: [
          'Flutter',
          'ReactJS',
          'Trading SDK',
          'WebSockets',
          'BLoC',
          'Redux',
        ],
      ),
      PlatformProject(
        title: 'NxTrad — Equity Trading Client & Admin',
        tag: 'Clean Architecture & Offline First',
        description: 'A full-suite equity trading application developed at IOURING supporting IPO workflows, automated deep-link URL navigation on screenshot detection, and payment gateway integration, alongside an admin console built with Flutter Web.',
        challenge: 'Ensuring zero-latency portfolio lookups and instant view resumption under unstable mobile network conditions.',
        architecture: 'Designed SQLite / Drift offline caching pipeline delivering instantaneous load times. Built automated screenshot detection routing and white-labeling capability from a single shared codebase.',
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

const email = 'prnvmrli@gmail.com';
const githubUrl = 'https://github.com/prnvmrli';
const linkedinUrl = 'https://linkedin.com/in/prnvmrli/';
