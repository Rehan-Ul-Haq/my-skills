# Changelog

All notable changes to the `skill-validator` skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-02

### Added
- **2 new validation categories** (expanded from 7 to 9):
  - **Zero-Shot Implementation** (12%) - Validates embedded expertise
    - "Before Implementation" section check
    - Codebase/conversation/references context gathering
    - User-only questions (not domain knowledge)
  - **Reusability** (13%) - Validates variation handling
    - Handles variations, not single requirements
    - Variable elements in clarifications
    - Constant patterns encoded
- **5 skill type definitions** (was 3):
  - Builder, Guide, Automation (existing)
  - Analyzer (new) - extracts insights
  - Validator (new) - enforces quality
- **Type-specific validation** with -10 deduction for missing requirements
- **Quick Validation Checklist** for rapid assessment

### Changed
- Total criteria categories: 7 → 9
- Weight distribution rebalanced:
  - Structure: 15% → 12%
  - Content: 20% → 15%
  - User Interaction: 15% → 12%
  - Documentation: 15% → 10%
  - Domain Standards: 15% → 10%
  - Technical: 10% → 8%
  - Maintainability: 10% → 8%
  - Zero-Shot: NEW → 12%
  - Reusability: NEW → 13%
- Description expanded to include all 9 categories

### Improved
- SKILL.md now 350 lines (comprehensive criteria)
- Validation workflow more explicit (Phase 1: Gather, Phase 2: Apply)
- Output format includes all 9 categories
- Reference files updated with new criteria guidance

## [1.0.0] - 2024-12-29

### Added
- Initial release
- 7 validation criteria with weighted scoring (0-100 scale)
  - Structure & Anatomy (15%)
  - Content Quality (20%)
  - User Interaction (15%)
  - Documentation (15%)
  - Domain Standards (15%)
  - Technical Robustness (10%)
  - Maintainability (10%)
- Rating scale: Production (90-100), Good (75-89), Adequate (60-74), Developing (40-59), Incomplete (0-39)
- Prioritized recommendations (High/Medium/Low)
- Reference files:
  - `detailed-criteria.md` - Deep scoring guidance
  - `scoring-examples.md` - Calibration examples
  - `improvement-patterns.md` - Common issue fixes
