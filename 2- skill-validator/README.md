# skill-validator

[![Version](https://img.shields.io/badge/Version-1.0.0-blue)](CHANGELOG.md)

Validate any skill against production-level quality criteria.

## Why Use This?

- **Objective Assessment** - 7 criteria, weighted scoring, 0-100 scale
- **Actionable Feedback** - Prioritized recommendations (High/Medium/Low)
- **Industry Standards** - Based on real production best practices
- **Honest Evaluation** - Even official skills get honest scores

## 7 Validation Criteria

| Category | Weight | What It Checks |
|----------|--------|----------------|
| Structure & Anatomy | 15% | SKILL.md <500 lines, frontmatter, no README |
| Content Quality | 20% | Conciseness, imperative form, scope clarity |
| User Interaction | 15% | Clarification questions, context awareness |
| Documentation | 15% | Official links, fetch guidance, examples |
| Domain Standards | 15% | Must Follow/Avoid, quality gates |
| Technical Robustness | 10% | Error handling, security, dependencies |
| Maintainability | 10% | Modularity, update path, organization |

## Rating Scale

| Score | Rating | Meaning |
|-------|--------|---------|
| 90-100 | Production | Ready for wide use |
| 75-89 | Good | Minor improvements needed |
| 60-74 | Adequate | Functional but needs work |
| 40-59 | Developing | Significant gaps |
| 0-39 | Incomplete | Major rework required |

## Quick Start

```
Validate the [skill-name] skill
```

Returns:
- Overall score and rating
- Category breakdown
- Critical issues
- Prioritized recommendations
- Strengths

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

## Critical Issues
- Missing clarification questions for builder skill

## Recommendations
1. **High**: Add Required Clarifications section
2. **Medium**: Add official documentation links
3. **Low**: Add "What this skill does NOT do"
```
