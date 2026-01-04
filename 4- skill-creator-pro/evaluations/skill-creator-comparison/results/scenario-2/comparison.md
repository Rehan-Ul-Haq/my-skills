# Scenario 2 Comparison: GraphQL API Builder

## Skill Structure Comparison

| Metric | Creator A | Creator B |
|--------|-----------|-----------|
| SKILL.md lines | 58 | 95 |
| Reference files | 0 | 4 |
| Asset files | 2 (templates) | 0 |
| Total files | 3 | 5 |
| Has "What it does NOT do" | No | Yes |
| Has clarification table | No | Yes |
| Has pre-delivery checklist | No | Yes |
| Domain expertise embedded | Minimal | Extensive |

## Process Comparison

| Aspect | Creator A | Creator B |
|--------|-----------|-----------|
| Questions asked | 3 (framework preference) | 5 (structured) |
| Domain research | None | Comprehensive (N+1, DataLoader, security) |
| Knows anti-patterns | No | Yes (4 documented) |
| Security guidance | Basic JWT snippet | Depth limiting, rate limiting, field-level auth |

## Knowledge Depth Comparison

| Topic | Creator A | Creator B |
|-------|-----------|-----------|
| N+1 problem | Not mentioned | Explained + DataLoader solution |
| Pagination | Not mentioned | Cursor-based with code |
| Query depth attacks | Not mentioned | Limiting configured |
| Input validation | Not mentioned | Zod example provided |
| Error handling | Not mentioned | GraphQL error codes |
| Naming conventions | Not mentioned | Documented with examples |

## Criterion Scores

| Criterion | Weight | A Score | B Score | A Weighted | B Weighted |
|-----------|--------|---------|---------|------------|------------|
| Token Efficiency | 15% | 4 | 2 | 0.60 | 0.30 |
| Over-Engineering | 15% | 3 | 3 | 0.45 | 0.45 |
| Effectiveness | 20% | 2 | 5 | 0.40 | 1.00 |
| Efficiency | 10% | 4 | 3 | 0.40 | 0.30 |
| Reusability | 15% | 2 | 5 | 0.30 | 0.75 |
| Adaptability | 10% | 2 | 4 | 0.20 | 0.40 |
| User Interaction | 5% | 3 | 4 | 0.15 | 0.20 |
| Embedded Knowledge | 10% | 1 | 5 | 0.10 | 0.50 |
| **TOTAL** | 100% | | | **2.60** | **3.90** |

## Detailed Scoring Rationale

### Token Efficiency (A: 4, B: 2)
- **A**: Minimal, but at cost of usefulness
- **B**: Heavy references, but justified by domain complexity

### Over-Engineering (A: 3, B: 3)
- **A**: Underbuilt for domain complexity
- **B**: Appropriate for GraphQL's complexity

### Effectiveness (A: 2, B: 5)
- **A**: Would produce working but vulnerable API (N+1, no pagination)
- **B**: Would produce production-grade API with proper patterns

### Efficiency (A: 4, B: 3)
- **A**: Quick but incomplete
- **B**: Thorough, more steps but better result

### Reusability (A: 2, B: 5)
- **A**: Apollo-specific templates
- **B**: Patterns work for any GraphQL server

### Adaptability (A: 2, B: 4)
- **A**: Fixed templates
- **B**: Decision guidance (pagination style, auth method)

### User Interaction (A: 3, B: 4)
- **A**: Asked about framework (domain knowledge user may not have)
- **B**: Asked about requirements, discovered domain itself

### Embedded Knowledge (A: 1, B: 5)
- **A**: Relies entirely on Claude's general knowledge
- **B**: DataLoader, pagination, security, anti-patterns all embedded

## Critical Difference: Domain Expertise

**Creator A** skill would produce a GraphQL API with:
- Basic schema
- Simple resolvers
- JWT snippet
- **Missing**: N+1 prevention, pagination, depth limiting, error handling

**Creator B** skill would produce a GraphQL API with:
- Proper schema patterns
- DataLoader for N+1 prevention
- Cursor-based pagination
- Security measures
- Error handling patterns

## Variation Test

**Test**: Build GraphQL API for e-commerce (products, orders, users) instead of blog

| Aspect | Skill A | Skill B |
|--------|---------|---------|
| Handled variation | Partially | Yes |
| Would prevent N+1 | No | Yes (DataLoader pattern applies) |
| Pagination ready | No | Yes (pattern transfers) |

## Summary

For **technical domains** like GraphQL, the gap between creators widens significantly:

- Creator A produces a **functional but problematic** skill (missing critical patterns)
- Creator B produces a **production-ready** skill (embedded expertise prevents common mistakes)

**Winner for Scenario 2**: Creator B (3.90 vs 2.60)

**Key Insight**: For domains with non-obvious best practices (N+1, pagination, security), domain discovery is critical. Creator A's reliance on user examples fails when users aren't domain experts.
