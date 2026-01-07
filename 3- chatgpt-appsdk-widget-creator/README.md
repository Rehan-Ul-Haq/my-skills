# creating-chatgpt-widgets

[![Version](https://img.shields.io/badge/Version-1.1.0-blue)](CHANGELOG.md)

Create production-grade widgets for ChatGPT Apps using OpenAI Apps SDK.

## Why Use This?

- **Zero-Shot Creation** - Describe your widget, get production code
- **Official Guidelines** - Follows OpenAI UX/UI principles
- **Any Widget Type** - Progress trackers, quizzes, viewers, forms, custom
- **Theme Support** - Light/dark mode built-in
- **Accessibility** - WCAG AA compliant output

## Key Features

| Feature | Benefit |
|---------|---------|
| Clarification Questions | Prevents wrong assumptions |
| 8 Official Doc Links | Always current patterns |
| UX Enforcement | Must Follow / Must Avoid checklists |
| Display Modes | Inline, fullscreen, pip support |
| State Management | Widget state, tool calls, follow-ups |
| Templates | Vanilla JS + React TypeScript |

## Quick Start

```
Create a widget for [your use case]
```

The skill will ask:
1. **Data shape** - What will `toolOutput` contain?
2. **Read vs Write** - Display only or interactive?
3. **Single vs Multi-turn** - One exchange or persistent?
4. **Display mode** - Inline, fullscreen, or pip?
5. **MCP Tool** - What tool for actions? (if interactive)

## Supported Widget Types

- Progress Trackers
- Quiz Interfaces
- Content Viewers
- Data Cards
- Carousels
- Forms
- Charts
- Maps
- Video Players
- Custom Interactive Elements

## Structure

```
creating-chatgpt-widgets/
├── SKILL.md (262 lines)
├── references/
│   ├── window-openai-api.md   # API reference + CSP
│   ├── state-management.md    # 3 state categories
│   ├── authentication.md      # OAuth 2.1 patterns
│   ├── display-modes.md       # Inline/fullscreen/pip
│   ├── ux-principles.md       # OpenAI UX guidelines
│   └── react-hooks.md         # Custom hooks
└── assets/templates/
    ├── vanilla-widget/        # HTML/CSS/JS template
    └── react-widget/          # TypeScript + hooks
```

## Official Documentation Links

| Resource | Purpose |
|----------|---------|
| UX Principles | Design decisions |
| UI Guidelines | Visual design rules |
| Component Types | List, Map, Album, Carousel, Shop |
| Build ChatGPT UI | Implementation, CSP |
| State Management | Widget state patterns |
| Authentication | OAuth 2.1 (advanced) |

## Output Includes

- Theme-aware styles (light/dark)
- `window.openai` integration with null checks
- Loading, error, empty states
- Keyboard navigation
- WCAG AA contrast
- Responsive layout
