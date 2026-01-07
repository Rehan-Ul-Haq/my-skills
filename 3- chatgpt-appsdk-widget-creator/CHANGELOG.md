# Changelog

All notable changes to the `creating-chatgpt-widgets` skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-08

### Changed
- **Renamed** from `chatgpt-widget-creator` to `creating-chatgpt-widgets` (gerund naming convention)

## [1.0.0] - 2024-12-29

### Added
- Initial release
- Zero-shot widget creation from natural language descriptions
- Support for multiple widget types:
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
- Clarification questions workflow (data shape, read/write, single/multi-turn, display mode)
- Theme support (light/dark mode)
- WCAG AA accessibility compliance
- Display modes: inline, fullscreen, pip
- Templates:
  - Vanilla JS (HTML/CSS/JS)
  - React TypeScript with hooks
- Reference documentation:
  - `window-openai-api.md` - API reference + CSP
  - `state-management.md` - 3 state categories
  - `authentication.md` - OAuth 2.1 patterns
  - `display-modes.md` - Inline/fullscreen/pip
  - `ux-principles.md` - OpenAI UX guidelines
  - `react-hooks.md` - Custom hooks
- 8 official OpenAI documentation links
- UX enforcement with Must Follow / Must Avoid checklists
