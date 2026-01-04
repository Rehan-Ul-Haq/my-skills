# Skill Creator Comparison Evaluation

## Quick Reference

```
evaluations/skill-creator-comparison/
├── README.md                    ← You are here
├── EVALUATION-PLAN.md           ← Full evaluation methodology
├── CRITERIA-DEFINITIONS.md      ← 8 criteria with scoring guides
├── EDGE-CASE-SCENARIOS.md       ← Additional stress-test scenarios
├── METRICS-TEMPLATE.md          ← Per-test data collection template
└── results/                     ← Test outputs (created during execution)
    └── scenario-N/
        ├── creator-A/           ← Generated skill from basic
        ├── creator-B/           ← Generated skill from enhanced
        ├── output-A/            ← Use case output from skill A
        ├── output-B/            ← Use case output from skill B
        ├── metrics-A.md         ← Metrics for creator A
        ├── metrics-B.md         ← Metrics for creator B
        └── comparison.md        ← Side-by-side analysis
```

---

## Evaluation Criteria Summary

| # | Criterion | Weight | Measures |
|---|-----------|--------|----------|
| 1 | Token Efficiency | 15% | Token waste, verbosity, information density |
| 2 | Over-Engineering | 15% | Scope creep, unnecessary complexity |
| 3 | Effectiveness | 20% | Does it accomplish the goal? |
| 4 | Efficiency | 10% | Execution speed, directness |
| 5 | Reusability | 15% | Works for variations |
| 6 | Adaptability | 10% | Teaches patterns, enables decisions |
| 7 | User Interaction | 5% | Question quality during creation |
| 8 | Embedded Knowledge | 10% | Domain expertise quality |

---

## Test Scenarios

### Core Scenarios (Required)

| # | Prompt | Tests |
|---|--------|-------|
| 1 | "Create a skill for generating README files" | Simple task handling |
| 2 | "Create a skill for building GraphQL APIs" | Domain knowledge |
| 3 | "Create a skill for Docker deployment automation" | Scripts, error handling |
| 4 | "Create a skill for data stuff" | Ambiguity handling |
| 5 | "Create a skill for generating OpenAPI specs" | Standards compliance |
| 6 | "Create a skill for adding authentication" | Security, options |

### Edge Cases (Optional)

| # | Prompt | Tests |
|---|--------|-------|
| 7 | Overly specific React+Tailwind+PostgreSQL request | Over-engineering |
| 8 | "json validator skill" | Minimal input |
| 9 | "fast, secure, feature-rich with minimal deps" | Conflicts |
| 10 | "Kubernetes manifests" | Well-known domain |
| 11 | "Bun runtime" | Emerging tech |
| 12 | "code reviews" | Non-code skill |

---

## Execution Checklist

### Per Scenario

- [ ] **Prepare**: Fresh session, clear context
- [ ] **Create A**: Run basic creator with scenario prompt
- [ ] **Record A**: Fill metrics template for creation
- [ ] **Create B**: Run enhanced creator with same prompt
- [ ] **Record B**: Fill metrics template for creation
- [ ] **Use A**: Execute use case with generated skill A
- [ ] **Record A**: Fill metrics template for usage
- [ ] **Use B**: Execute use case with generated skill B
- [ ] **Record B**: Fill metrics template for usage
- [ ] **Vary A**: Run variation test with skill A
- [ ] **Vary B**: Run variation test with skill B
- [ ] **Score**: Complete scoring matrix
- [ ] **Compare**: Write comparison analysis

### Final

- [ ] Aggregate scores across all scenarios
- [ ] Identify patterns and insights
- [ ] Write recommendation

---

## Key Questions to Answer

1. **Which creator produces more effective skills?**
2. **Which creator is more token-efficient?**
3. **Which creator over-engineers more?**
4. **Which creator produces more reusable skills?**
5. **When should you use each creator?**
6. **What are the trade-offs?**

---

## Start Here

```bash
# 1. Create results directory
mkdir -p results/scenario-1

# 2. Copy metrics template
cp METRICS-TEMPLATE.md results/scenario-1/metrics-A.md
cp METRICS-TEMPLATE.md results/scenario-1/metrics-B.md

# 3. Run first scenario with creator A
# [Use skill-creator with: "Create a skill for generating README files"]

# 4. Record metrics and output

# 5. Repeat with creator B

# 6. Compare and score
```
