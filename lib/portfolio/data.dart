const name = 'Pranav Murali';
const role = 'Flutter Engineer · SDK Builder';
const tagline =
    'Building high-performance mobile experiences, developer tools & real-time trading systems.';

const about =
    'Front-end & Flutter engineer with over 3 years of hands-on experience specializing in '
    'building responsive, scalable web and mobile applications. I develop and maintain '
    'production Flutter and React codebases, architecting custom SDKs, financial charting tools, '
    'and high-throughput WebSocket data streams. Passionate about Clean Architecture, '
    'pixel-perfect UI, and shipping robust software worth keeping.';

const location = 'Kerala, India';
const statusText = 'Open to new opportunities';
const motto = 'Build · Learn · Iterate — Building things worth keeping';

class SkillCategory {
  final String title;
  final List<String> skills;
  const SkillCategory(this.title, this.skills);
}

const skillCategories = [
  SkillCategory('Frameworks & Mobile', [
    'Flutter',
    'Dart',
    'ReactJS',
    'JavaScript',
    'HTML & CSS',
  ]),
  SkillCategory('State & Architecture', [
    'BLoC Pattern',
    'Clean Architecture',
    'Riverpod',
    'Redux',
    'GetX',
  ]),
  SkillCategory('Real-Time & Data', [
    'WebSockets',
    'RESTful APIs',
    'SQLite & Drift',
    'Firebase (Push / Auth)',
  ]),
  SkillCategory('Tooling & Systems', [
    'Trading SDKs',
    'White-Label Solutions',
    'FVM',
    'Android Studio',
    'Git & GitHub',
    'Figma to UI',
    'Python',
  ]),
];

const stack = [
  'Flutter',
  'Dart',
  'ReactJS',
  'BLoC',
  'Clean Architecture',
  'WebSockets',
  'Trading SDKs',
  'SQLite / Drift',
  'Firebase',
  'Redux',
  'FVM',
  'Figma',
  'Python',
];

class FocusArea {
  final String icon;
  final String title;
  final String description;
  const FocusArea(this.icon, this.title, this.description);
}

const focusAreas = [
  FocusArea(
    '📱',
    'Cross-Platform Mobile & Web',
    'Crafting polished 60fps Flutter applications across iOS, Android, and web with responsive layouts and fluid interactions.',
  ),
  FocusArea(
    '📦',
    'SDK & Library Development',
    'Engineering modular financial SDKs and reusable libraries tailored to client integrations and white-label platforms.',
  ),
  FocusArea(
    '📊',
    'Financial Charting & Analytics',
    'Developing interactive options Strategy Builders, Open Interest (OI), and Put-Call Ratio (PCR) analytics charts.',
  ),
  FocusArea(
    '⚡',
    'Real-Time WebSockets',
    'Architecting high-frequency streaming channels, quote tickers, and live trading socket updates with resilient reconnections.',
  ),
  FocusArea(
    '🏗️',
    'Clean Architecture & BLoC',
    'Designing decoupled presentation, domain, and data layers for robust unit testing and painless multi-client branding.',
  ),
  FocusArea(
    '💾',
    'Optimized Local Storage',
    'High-efficiency local database caching and offline synchronization powered by SQLite and Drift.',
  ),
];

class Project {
  final String name;
  final String subtitle;
  final String year;
  final String description;
  final List<String> highlights;
  final List<String> tags;
  final String link;
  const Project({
    required this.name,
    required this.subtitle,
    required this.year,
    required this.description,
    required this.highlights,
    required this.tags,
    required this.link,
  });
}

const projects = [
  Project(
    name: 'NxtOption',
    subtitle: 'Dedicated Options Trading Platform & SDK',
    year: '2023 — Present',
    description:
        'A dedicated options trading platform developed for its ReactJS web and Flutter mobile applications. Features an interactive Strategy Builder, Open Interest (OI) and Put-Call Ratio (PCR) analytics charts, and a client-tailored trading SDK.',
    highlights: [
      'Interactive Strategy Builder for complex options combinations and payoff diagrams',
      'Real-time OI and PCR charts fed by low-latency WebSockets',
      'Custom reusable trading SDK tailored for multi-client integrations',
      'Unified design parity across ReactJS Web and Flutter Mobile',
    ],
    tags: ['Flutter', 'ReactJS', 'Trading SDK', 'WebSockets', 'OI & PCR Charts', 'BLoC', 'Redux'],
    link: 'https://github.com/prnvmrli',
  ),
  Project(
    name: 'NxTrad',
    subtitle: 'Comprehensive Trading Platform & Web Admin Console',
    year: '2022 — 2024',
    description:
        'A full-suite trading application supporting IPO workflows, automated deep-link URL navigation on screenshot detection, and payment gateway integration. Also built and maintained the NxTrad admin console in Flutter Web.',
    highlights: [
      'IPO discovery, bidding flows, and payment gateway integration',
      'Screenshot detection engine triggering instant deep-link routing',
      'Admin management and monitoring console built with Flutter Web',
      'High-performance offline caching with SQLite and Drift',
    ],
    tags: ['Flutter', 'Flutter Web', 'Clean Architecture', 'Deep Linking', 'Payment Gateways', 'SQLite / Drift'],
    link: 'https://github.com/prnvmrli',
  ),
];

class Job {
  final String company;
  final String title;
  final String period;
  final String location;
  final String summary;
  final List<String> achievements;
  const Job({
    required this.company,
    required this.title,
    required this.period,
    required this.location,
    required this.summary,
    required this.achievements,
  });
}

const jobs = [
  Job(
    company: 'IOURING Private Limited',
    title: 'Software Developer',
    period: 'Jan 2022 — Present',
    location: 'Chennai, TN, India',
    summary:
        'Building and maintaining 3+ Flutter mobile and web applications and 2+ React web apps, focusing on trading systems, custom SDKs, and real-time streaming architectures.',
    achievements: [
      'Developed and maintained 3+ Flutter mobile and web applications, including advanced SDKs and libraries for trading integrations.',
      'Built and maintained 2+ web applications using React, Redux, and Material UI, ensuring responsive and modern user experiences.',
      'Applied BLoC pattern and Clean Architecture principles to build scalable, testable, and modular Flutter codebases.',
      'Implemented RESTful APIs and WebSocket connections for high-frequency financial data exchange and real-time updates.',
      'Utilized SQLite with Drift to optimize local data storage and retrieval across web and mobile platforms.',
      'Integrated Firebase for real-time push notifications, improving engagement and responsiveness.',
      'Delivered white-label solutions from a single codebase, enabling distinct branding for multiple clients.',
      'Translated Figma designs into functional, pixel-perfect UIs in close collaboration with UI/UX teams.',
    ],
  ),
];

class Education {
  final String degree;
  final String institution;
  final String location;
  final String period;
  const Education({
    required this.degree,
    required this.institution,
    required this.location,
    required this.period,
  });
}

const education = Education(
  degree: 'B.Tech in Mechanical Engineering',
  institution: 'Government Engineering College, Idukki',
  location: 'Kerala, India',
  period: '2016 — 2020',
);

const spokenLanguages = [
  'English (Professional)',
  'Malayalam (Native)',
  'Hindi (Basic Proficiency)',
  'Tamil (Conversational)',
];

const interests = [
  'Music Production',
  'Fitness',
  'Developer Tooling',
  'AI & Backend Systems',
];

const email = 'hello@pranavmurali.dev';
const github = 'github.com/prnvmrli';
const githubUrl = 'https://github.com/prnvmrli';
const linkedin = 'linkedin.com/in/pranavmurali';
const linkedinUrl = 'https://linkedin.com/in/pranavmurali';
