const name = 'Pranav Murali';
const role = 'Flutter Developer';
const tagline =
    'I build fast, polished cross-platform apps with Flutter — from MVPs to production apps on iOS, Android, and web.';

const about =
    'I\'m a Flutter developer focused on crafting smooth, native-feeling experiences. '
    'I care about clean architecture, pixel-perfect UI, and shipping apps users love. '
    'Currently open to new opportunities.';

const stack = [
  'Flutter',
  'Dart',
  'Bloc / Riverpod',
  'Firebase',
  'REST & GraphQL',
  'CI/CD',
  'Figma',
];

class Project {
  final String name;
  final String year;
  final String description;
  final List<String> tags;
  final String link;
  const Project(this.name, this.year, this.description, this.tags, this.link);
}

const projects = [
  Project(
    'Aurora Habits',
    '2025',
    'A habit tracking app with streak analytics, offline-first sync, and custom charting. 40k+ downloads.',
    ['Flutter', 'Riverpod', 'SQLite'],
    '#',
  ),
  Project(
    'Fleetly',
    '2024',
    'Real-time fleet management dashboard for logistics teams. Live driver tracking and route optimization.',
    ['Flutter', 'Firebase', 'Maps'],
    '#',
  ),
  Project(
    'Paper Trail',
    '2024',
    'A receipt scanner that extracts data with on-device OCR and exports clean expense reports.',
    ['Flutter', 'ML Kit', 'Bloc'],
    '#',
  ),
];

class Job {
  final String company;
  final String title;
  final String period;
  final String blurb;
  const Job(this.company, this.title, this.period, this.blurb);
}

const jobs = [
  Job('Nimble Labs', 'Senior Flutter Engineer', '2023 — Present',
      'Leading mobile architecture for a consumer fitness app used by 200k+ people.'),
  Job('Craftline', 'Flutter Developer', '2021 — 2023',
      'Shipped 3 production apps end-to-end across iOS, Android, and web.'),
];

const email = 'hello@pranavmurali.dev';
const github = 'github.com/pranavmurali';
const linkedin = 'linkedin.com/in/pranavmurali';
