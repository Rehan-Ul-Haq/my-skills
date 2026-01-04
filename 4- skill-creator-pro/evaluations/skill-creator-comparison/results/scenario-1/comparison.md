# Scenario 1 Comparison: README Generator

## Skill Structure Comparison

| Metric | Creator A | Creator B |
|--------|-----------|-----------|
| SKILL.md lines | 47 | 78 |
| Reference files | 0 | 2 |
| Asset files | 1 (template) | 0 |
| Total files | 2 | 3 |
| Has "What it does NOT do" | No | Yes |
| Has clarification checklist | No | Yes |
| Has output specification | No | Yes |

## Process Comparison

| Aspect | Creator A | Creator B |
|--------|-----------|-----------|
| Questions asked | 3 (all about user examples) | 5 (2 metadata + 3 requirements) |
| Domain research | None | Automatic discovery |
| Focus | Concrete examples | Domain expertise + reusability |
| Asks domain knowledge | Yes (implicitly) | No (discovers it) |

## Output Comparison (Generated README)

| Metric | Output A | Output B |
|--------|----------|----------|
| Lines | 31 | 55 |
| Sections | 4 | 6 |
| Has install from source | No | Yes |
| Has command reference | No | Yes (detailed) |
| Has requirements section | No | Yes |
| Shows expected output | No | Yes |
| Real-world example | No | Yes (sales data) |

## Criterion Scores

| Criterion | Weight | A Score | B Score | A Weighted | B Weighted |
|-----------|--------|---------|---------|------------|------------|
| Token Efficiency | 15% | 4 | 3 | 0.60 | 0.45 |
| Over-Engineering | 15% | 4 | 4 | 0.60 | 0.60 |
| Effectiveness | 20% | 3 | 4 | 0.60 | 0.80 |
| Efficiency | 10% | 4 | 3 | 0.40 | 0.30 |
| Reusability | 15% | 3 | 4 | 0.45 | 0.60 |
| Adaptability | 10% | 2 | 4 | 0.20 | 0.40 |
| User Interaction | 5% | 3 | 4 | 0.15 | 0.20 |
| Embedded Knowledge | 10% | 2 | 4 | 0.20 | 0.40 |
| **TOTAL** | 100% | | | **3.20** | **3.75** |

## Detailed Scoring Rationale

### Token Efficiency (A: 4, B: 3)
- **A**: Smaller skill, minimal overhead
- **B**: More content, but progressive disclosure with references

### Over-Engineering (A: 4, B: 4)
- **A**: Simple, appropriate for task
- **B**: More structure but justified for reusability

### Effectiveness (A: 3, B: 4)
- **A**: Produces functional README but basic
- **B**: Produces comprehensive README with proper sections

### Efficiency (A: 4, B: 3)
- **A**: Direct path, fewer steps
- **B**: More thorough, slightly more steps

### Reusability (A: 3, B: 4)
- **A**: Template-based, limited adaptation
- **B**: Section patterns for different project types

### Adaptability (A: 2, B: 4)
- **A**: Single template approach
- **B**: Decision guidance per project type in references

### User Interaction (A: 3, B: 4)
- **A**: Generic questions about examples
- **B**: Structured metadata + requirements separation

### Embedded Knowledge (A: 2, B: 4)
- **A**: Relies on Claude's general knowledge
- **B**: Embeds best practices, anti-patterns, section patterns

## Variation Test

**Test**: Use skill to generate README for a Rust library (not Python CLI)

| Aspect | Skill A | Skill B |
|--------|---------|---------|
| Handled variation | Partially | Yes |
| Quality maintained | Degraded (Python-focused template) | Maintained (has library pattern) |
| Adaptation needed | Modify template | None (built-in) |

## Summary

**Creator A** produces a simpler, more token-efficient skill that works for basic cases but lacks domain expertise and adaptability.

**Creator B** produces a more comprehensive skill with embedded best practices, project-type awareness, and better reusability—at the cost of slightly higher token usage.

**Winner for Scenario 1**: Creator B (3.75 vs 3.20)

**Key Differentiators**:
1. B embeds domain knowledge (best practices, anti-patterns)
2. B handles project type variations
3. B includes clarification checklist
4. A is leaner but less capable
