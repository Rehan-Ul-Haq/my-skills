# Changelog

All notable changes to the `skill-validator` skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
