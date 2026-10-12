# Design System & Architecture Specification

Portfolio of **Pranav Murali** — Mobile Systems Engineer — Flutter  
Production URL: [https://prnvmrli.github.io/prnvmrli/](https://prnvmrli.github.io/prnvmrli/)

---

## 1. Design Vision & Philosophy

The portfolio follows an **Apple-inspired editorial minimalism** design language. Rather than decorative novelties, intense gradients, or heavy multi-layered shadows, the aesthetic emphasizes:

- **Quiet Restraint**: Ample whitespace and breathing room that directs focus to technical substance and engineering credentials.
- **Warm Light Canvas**: A refined, warm off-white canvas (`#FBFBFD`) replacing stark cool whites or sterile greys.
- **Typographic Precision**: Structured hierarchy with optical sizing, high contrast near-black text (`#1D1D1F`), and balanced neutral greys (`#515154` / `#86868B`).
- **Hairline Separation**: Subtle 1.0px borders (`#E5E5EA`) and dividers instead of heavy card elevation or drop shadows.
- **Authentic Engineering Presentation**: Clear distinction between proprietary production platforms (developed at IOURING Private Limited) and open-source systems work.

---

## 2. Design Tokens & Color Palette

### 2.1 Surfaces & Canvas
| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| `canvasBase` | `#FBFBFD` | Page scaffold background (warm off-white) |
| `surface` | `#FFFFFF` | Primary elevated cards & interactive containers |
| `surfaceSecondary` | `#F5F5F7` | Neutral container backgrounds & pill fills |
| `surfaceTertiary` | `#EBEBF0` | Subtle hover states & active indicators |
| `surfaceContainerLow`| `#FAFAFC` | Sub-level grouped cards |

### 2.2 Typography & Neutrals
| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| `textPrimary` | `#1D1D1F` | Headlines, titles, and high-emphasis body text |
| `textSecondary` | `#515154` | Long-form descriptions, bullets, and body content |
| `textMuted` | `#86868B` | Monospace tags, metadata, dates, and secondary labels |
| `outline` | `#86868B` | Technical badges and structural labels |

### 2.3 Borders & Dividers
| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| `border` | `#E5E5EA` | 1.0px hairline borders on cards and headers |
| `borderSubtle` | `#F0F0F2` | Subtle dividers between grouped list items |
| `borderHover` | `#D2D2D7` | Interactive hover borders on buttons and links |

### 2.4 Interactive & Accents
| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| `accent` | `#005CB8` | Modern Tech Blue from original Stitch design for interactive links |
| `accentHover` | `#1275E2` | Link hover state |
| `accentDim` | `rgba(0, 92, 184, 0.08)` | Subtle tint for active items |

---

## 3. Typography Hierarchy

Primary Font Family: **Inter** (fallback: system sans-serif / SF Pro)  
Monospace Font Family: **JetBrains Mono** (fallback: Menlo, Monaco, monospace)

| Role | Font Family | Size | Weight | Line Height | Tracking |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Hero Name** | Inter | 34px (desktop) / 28px (mobile) | 600 | 1.15 | -0.8px |
| **Section Title** | Inter | 18px | 600 | 1.30 | -0.3px |
| **Section Tag** | JetBrains Mono | 11px | 500 | 1.00 | +0.6px |
| **Item Title** | Inter | 17px | 600 | 1.35 | -0.3px |
| **Body Large** | Inter | 15px - 16px | 400 | 1.60 | 0.0px |
| **Body Text** | Inter | 14px | 400 | 1.55 | 0.0px |
| **Technical Note**| Inter | 13px | 400 | 1.55 | 0.0px |
| **Mono Chips** | JetBrains Mono | 10px - 11px | 500 | 1.20 | +0.4px |

---

## 4. Layout Grid & Breakpoints

- **Max Content Width**: `780px` centered editorial column with `24px` horizontal padding.
- **Navigation Max Width**: `820px` centered with `20px` horizontal padding.
- **Vertical Spacing Scale**:
  - Between major sections: `88px`
  - Between subsections: `28px` – `32px`
  - Card internal padding: `20px` – `22px`
- **Responsive Breakpoints**:
  - **Desktop / Large Tablet (`width >= 640px`)**: Full navigation links in header, side-by-side metadata layouts, standard headings.
  - **Mobile (`width < 640px`)**: Streamlined header with quick action button, stacked button wraps, fluid typography.

---

## 5. Major Section Specifications

### 00 / Hero & Introduction
- **Avatar**: 68px circular portrait (`assets/avatar.png`) with subtle hairline border.
- **Identity / Title**: Clear systems-focused positioning: `Mobile Systems Engineer — Flutter`.
- **Specialization Line**: `Flutter · Architecture · SDK Engineering · Real-time Systems · Performance`.
- **Engineering Summary**: 5 years of production experience focused on application architecture, developer SDKs, reactive state management, real-time streaming, rendering performance, and maintainable APIs at IOURING Private Limited.
- **Interactive Callouts**: "Get in Touch" primary action, "View Work ↓", and direct links to GitHub and LinkedIn.

### 01 / Projects & Systems Work
- **Categorization**: Direct spotlights on developer tooling, publishable packages, and infrastructure:
  - `f-cleaner`: Native macOS desktop disk cleanup utility and cache visualizer built on top of `fclean` (core Dart CLI cleanup engine), with native Swift/WidgetKit extensions.
  - `android_system_chrome`: Flutter plugin for managing Android system bar styling, translucent edge-to-edge UI, and dynamic status bar contrast. `[In Progress]`
  - `flutter_notification_icons`: Utility package for resolving, customizing, and styling Android notification badge icons in Flutter. `[In Progress]`
  - `aviary`: Self-hosted private Dart Pub server for enterprise package distribution and internal dependency hosting. `[In Progress]`
- **In-Progress Status Badge (`_InProgressBadge`)**: Understated amber pill badge (`#FF9500` at 12% alpha, hairline border at 45% alpha, live pulsing amber dot `StatusPulseDot(size: 5.5)`, and `In Progress` monospace text `#B25000`) highlighting active in-development packages and tools.
- **Direct Repositories**: Source links pointing directly to verified GitHub repositories.
- **Tech Stack Badges**: Monospace badges indicating technologies used.

### 02 / Professional Experience
- **Minimal Timeline Track**: Clean vertical stem line with layout-safe `Stack` positioning and bespoke timeline nodes (`_TimelineNode`).
- **Active Role Highlight**:
  - **Present Green Badge (`_CurrentBadge`)**: Pill badge with subtle emerald fill (`#28CD41` at 12% alpha), hairline border, pulsing green dot (`StatusPulseDot(size: 5.5)`), and `Present` label in `JetBrains Mono` (`#1E8E3E`).
  - **Timeline Node (`_TimelineNode`)**: Concentric emerald glowing node with live pulsing status indicator for ongoing roles (`Jan 2022 — Present`), with neutral muted nodes for past milestones.
- **IOURING Private Limited**: Software Developer (Flutter & React), Jan 2022 — Present.
- **Production Deliverables**: Technical summary and bullet points detailing production WebSocket architectures, Drift caching, and BLoC implementations.
- **Key Production Systems (Uniform Architecture Cards)**: Balanced, equal-height card grid on desktop (`IntrinsicHeight` with bottom-pinned tech stacks) highlighting production platforms built for client deployments:
  - `NeoCharts`: Precision Charting Infrastructure & SDK (Flutter, Canvas Rendering, Charting SDK, Real-time Streaming, WebSockets).
  - `NxtOption`: Options Trading Platform & SDK (Flutter, ReactJS, Trading SDK, WebSockets, BLoC, Redux).
  - `NxTrad`: Full Market Access Trading Platform (Flutter, Flutter Web, Clean Architecture, BLoC, SQLite/Drift, Deep Linking).

### 03 / Engineering Capabilities
- **Apple Tech Specs Row Matrix**: Cardless, open editorial matrix layout directly inspired by Apple's technical specification sheets. Eliminates heavy container boxes and nested card clutter, using clean horizontal rows separated by 1.0px hairline dividers (`#E5E5EA`).
- **Hierarchy & Minimal Color**:
  - **Left Column (~35%)**: Color-coded monospace index capsule + bold domain title (`15px` Inter).
  - **Right Column (~65%)**: Interactive one-word capability token pills with subtle micro-dots and gentle hover tint.
  - **Hover Micro-Interactions**: The row itself remains transparent and cardless with zero box pop-in. Hovering over any capability pill smoothly illuminates the token with its category accent tint (`12%` alpha), accent border (`#0071E3`, `#5856D6`, etc.), accent text, and a luminous accent dot glow.
  - **Domains & Palette**:
    - `01 — Languages & Frameworks`: Dart, Flutter, React, TypeScript, Swift, Kotlin (`#0071E3` Tech Blue).
    - `02 — Architecture & SDK Engineering`: Modularization, Monorepos, SDKs, BLoC (`#5856D6` Indigo).
    - `03 — Real-time Systems`: WebSockets, Streaming, State, Lifecycle (`#28CD41` Emerald).
    - `04 — Security & Reliability`: SSL Pinning, Storage, Reliability, Error Handling (`#FF9500` Amber).
    - `05 — Testing & Delivery`: Integration, Patrol, Releases, CI/CD (`#30B0C7` Teal).

### 04 / Education
- **Formal Education**: B.Tech in Mechanical Engineering, Government Engineering College, Idukki (2016 — 2020), Kerala, India. Understated elevation card presenting degree, institution, timeline, and location.

### 05 / Contact & Reach Out
- **Direct Email**: `prnvmrli@gmail.com` with one-click "Compose Email" and "Copy Address" with toast feedback.
- **Direct Channels**: Verified links to GitHub (`prnvmrli`), LinkedIn (`prnvmrli`), and direct Resume download (`PDF Download`).

### Header & Footer
- **Sticky Header**: Frosted glass blur (`sigma: 18`, opacity: 0.88) with avatar reveal and real-time active section tracking.
  - Active navigation links highlight dynamically (`Projects`, `Experience`, `Capabilities`, `Education`, `Contact`) as pure text buttons without elevation or outlines, emphasizing clean typographic hierarchy with tech blue accent coloring (`#005CB8`, semibold weight).
  - **Resume Quick Action**: Sticky header includes a dedicated flat text button `Resume ↓` for instant single-click CV access across desktop and mobile.
  - Smooth animated scroll navigation with header offset compensation (-76px) so sections arrive cleanly below the frosted bar.
- **Footer**: Understated copyright, tech spec note, and back-to-top interaction.

---

## 6. Accessibility & Performance Standards

- **Semantic Web Structure**: Descriptive HTML5 title, meta tags, and Web App manifest in `web/index.html`.
- **Keyboard & Screen Focus**: Contrast ratios exceed WCAG AA standards (`#1D1D1F` on `#FBFBFD` achieves > 14:1 contrast).
- **High Performance**: Native Flutter Web CanvasKit / HTML rendering with zero unnecessary third-party package dependencies.
- **Deterministic Deployments**: Fully automated GitHub Actions workflow (`.github/workflows/deploy.yml`) building with `--base-href "/prnvmrli/"`.
