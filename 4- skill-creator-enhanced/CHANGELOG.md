# Changelog

All notable changes to the `skill-creator-enhanced` skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-02

### Added
- **Domain Discovery Framework** - Automatic research before asking user
  - Phase 1: Automatic discovery (core concepts, best practices, anti-patterns, security)
  - Phase 2: Knowledge sufficiency check
  - Phase 3: User requirements only (never ask domain knowledge)
- **Reusability Patterns** - Skills handle variations, not single requirements
  - Identifies VARIES vs CONSTANT in domain
  - `references/reusability-patterns.md` guidance
- **Zero-Shot Implementation** pattern for generated skills
  - "Before Implementation" section template
  - Context gathering from codebase, conversation, skill references
- **2 new skill types**:
  - Analyzer skills (extract insights)
  - Validator skills (enforce quality)
- **New reference files**:
  - `creation-workflow.md` - Detailed step-by-step process
  - `reusability-patterns.md` - Varies vs constant patterns
- **Helper scripts**:
  - `scripts/init_skill.py` - Initialize new skill
  - `scripts/package_skill.py` - Package for distribution
  - `scripts/quick_validate.py` - Quick validation check
- **Comparative evaluation** vs official Anthropic skill-creator
  - 6 test scenarios
  - 8 evaluation criteria
  - Results: +41% improvement over official

### Changed
- Creation process expanded from 7 to 8 steps
- SKILL.md expanded from 265 to 389 lines (with progressive disclosure)
- Clarification questions now split: Metadata (1-2) → Discovery → Requirements (3-6)
- Question pacing guidance added

### Improved
- Skill types expanded from 3 to 5
- Reference files expanded from 5 to 7
- Type-specific patterns now include Analyzer and Validator
- Output checklist now includes zero-shot and reusability checks

## [1.0.0] - 2024-12-29

### Added
- Initial release
- Production-grade skill creation (scores 96/100 on skill-validator)
- Required Clarifications pattern to prevent wrong assumptions
- Scope Clarity with "Does / Does NOT do" sections
- Enforcement Checklists (Must Follow / Must Avoid)
- Output Checklist quality gate
- Support for 3 skill types:
  - Builder skills
  - Guide skills
  - Automation skills
- 7-step creation process
- Reference documentation:
  - `skill-patterns.md` - SKILL.md structure
  - `quality-patterns.md` - Clarifications, enforcement
  - `technical-patterns.md` - Errors, security, deps
  - `workflows.md` - Workflow patterns
  - `output-patterns.md` - Templates, examples

### Improved (vs original skill-creator)
- Reduced SKILL.md from 356 to 265 lines
- Added clarification pattern
- Added enforcement checklist
- Added output checklist
- Added error handling guide
- Improved validator score from 64/100 to 96/100
