# Scenario 5 Comparison: OpenAPI Generator

## Skill Structure Comparison

| Metric | Creator A | Creator B |
|--------|-----------|-----------|
| SKILL.md lines | 42 | 85 |
| Framework-specific guidance | No | Yes (Flask/FastAPI/Express patterns) |
| OpenAPI version awareness | Mentioned 3.0 | 3.0 vs 3.1 differences |
| Validation guidance | "Ensure valid" | Specific checks listed |
| Schema extraction | Generic | Framework-specific patterns |

## Knowledge Comparison

| Topic | Creator A | Creator B |
|-------|-----------|-----------|
| Route discovery by framework | Not covered | Table with decorators |
| Component reuse | Not mentioned | "Extract to components" |
| Security schemes | Not mentioned | Covered |
| $ref resolution | Not mentioned | In validation checklist |

## Criterion Scores

| Criterion | Weight | A Score | B Score | A Weighted | B Weighted |
|-----------|--------|---------|---------|------------|------------|
| Token Efficiency | 15% | 4 | 3 | 0.60 | 0.45 |
| Over-Engineering | 15% | 3 | 4 | 0.45 | 0.60 |
| Effectiveness | 20% | 3 | 4 | 0.60 | 0.80 |
| Efficiency | 10% | 3 | 4 | 0.30 | 0.40 |
| Reusability | 15% | 2 | 4 | 0.30 | 0.60 |
| Adaptability | 10% | 2 | 4 | 0.20 | 0.40 |
| User Interaction | 5% | 3 | 4 | 0.15 | 0.20 |
| Embedded Knowledge | 10% | 2 | 4 | 0.20 | 0.40 |
| **TOTAL** | 100% | | | **2.80** | **3.85** |

## Key Differentiator: Standards Compliance

OpenAPI is a standards-based domain. Creator B:
- Knows OpenAPI 3.0 vs 3.1 differences
- Provides framework-specific extraction patterns
- Includes validation checklist for spec compliance

**Winner for Scenario 5**: Creator B (3.85 vs 2.80)
