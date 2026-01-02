# skill-validator

[![Version](https://img.shields.io/badge/Version-2.0.0-blue)](CHANGELOG.md)

Validate any skill against production-level quality criteria with 9-category scoring.

## Why Use This?

- **Objective Assessment** - 9 criteria, weighted scoring, 0-100 scale
- **Actionable Feedback** - Prioritized recommendations (High/Medium/Low)
- **Industry Standards** - Based on production best practices
- **Zero-Shot Focus** - Validates embedded expertise and reusability
- **Honest Evaluation** - Even official skills get honest scores

## 9 Validation Criteria

| Category | Weight | What It Checks |
|----------|--------|----------------|
| Structure & Anatomy | 12% | SKILL.md <500 lines, frontmatter, no README |
| Content Quality | 15% | Conciseness, imperative form, scope clarity |
| User Interaction | 12% | Clarification questions, context awareness |
| Documentation | 10% | Official links, fetch guidance, examples |
| Domain Standards | 10% | Must Follow/Avoid, quality gates |
| Technical Robustness | 8% | Error handling, security, dependencies |
| Maintainability | 8% | Modularity, update path, organization |
| **Zero-Shot Implementation** | 12% | Embedded expertise, context gathering |
| **Reusability** | 13% | Handles variations, not requirement-specific |

### New in v2.0: Zero-Shot & Reusability

**Zero-Shot Implementation** (12%) validates:
- "Before Implementation" context gathering section
- Domain expertise embedded in `references/`
- Only asks users for THEIR requirements (not domain knowledge)

**Reusability** (13%) validates:
- Handles variations, not single requirements
- Variable elements captured in clarifications
- Constant patterns encoded (best practices)

## Rating Scale

| Score | Rating | Meaning |
|-------|--------|---------|
| 90-100 | **Production** | Ready for wide use |
| 75-89 | **Good** | Minor improvements needed |
| 60-74 | **Adequate** | Functional but needs work |
| 40-59 | **Developing** | Significant gaps |
| 0-39 | **Incomplete** | Major rework required |

## Quick Start

```
Validate the [skill-name] skill
```

Returns:
- Overall score and rating
- 9 category breakdown
- Critical issues
- Prioritized recommendations
- Strengths

## Type-Specific Validation

Skills are validated against type-specific requirements:

| Type | Must Have |
|------|-----------|
| **Builder** | Clarifications, Output Spec, Standards, Checklist |
| **Guide** | Workflow, Examples, Official Docs |
| **Automation** | Scripts, Dependencies, Error Handling |
| **Analyzer** | Scope, Criteria, Output Format |
| **Validator** | Criteria, Scoring, Thresholds, Remediation |

Missing type-specific requirements = -10 point deduction.

## Reference Files

| File | Purpose |
|------|---------|
| `detailed-criteria.md` | Deep scoring guidance (0-3 per criterion) |
| `scoring-examples.md` | Calibration examples with real skills |
| `improvement-patterns.md` | How to fix common issues |

## Example Output

```
# Skill Validation Report: my-skill

**Rating**: Good
**Overall Score**: 82/100

## Category Scores

| Category | Score | Weight | Weighted |
|----------|-------|--------|----------|
| Structure & Anatomy | 90 | 12% | 10.8 |
| Content Quality | 85 | 15% | 12.8 |
| User Interaction | 75 | 12% | 9.0 |
| Documentation | 80 | 10% | 8.0 |
| Domain Standards | 70 | 10% | 7.0 |
| Technical Robustness | 85 | 8% | 6.8 |
| Maintainability | 90 | 8% | 7.2 |
| Zero-Shot Implementation | 80 | 12% | 9.6 |
| Reusability | 85 | 13% | 11.1 |

## Critical Issues
- Missing "Before Implementation" section

## Recommendations
1. **High**: Add context gathering section
2. **Medium**: Add official documentation links
3. **Low**: Add "What this skill does NOT do"
```

## Installation

```bash
# Copy to Claude Code skills directory
cp -r skill-validator ~/.claude/skills/
```
