# Scenario 6 Comparison: Authentication Builder

## Skill Structure Comparison

| Metric | Creator A | Creator B |
|--------|-----------|-----------|
| SKILL.md lines | 48 | 98 |
| Security checklist | No | Yes (7 items) |
| Password guidance | "hash password" | Specific algorithms, cost factors |
| Token strategy | Not detailed | Access + refresh, expiration |
| CSRF awareness | No | Yes |
| Scope boundaries | No | Yes (excludes authZ, MFA) |

## Security Knowledge Comparison

| Security Concern | Creator A | Creator B |
|------------------|-----------|-----------|
| Password hashing algorithm | Not specified | bcrypt/argon2, cost ≥ 10 |
| Never use | Not mentioned | MD5/SHA1 explicitly warned |
| Token expiration | Not mentioned | 15 min access, 7 day refresh |
| Cookie security | Not mentioned | httpOnly requirement |
| CSRF protection | Not mentioned | Required if using cookies |
| Rate limiting | Not mentioned | Required on auth endpoints |
| JWT payload | Not mentioned | No sensitive data |

## Criterion Scores

| Criterion | Weight | A Score | B Score | A Weighted | B Weighted |
|-----------|--------|---------|---------|------------|------------|
| Token Efficiency | 15% | 4 | 2 | 0.60 | 0.30 |
| Over-Engineering | 15% | 3 | 4 | 0.45 | 0.60 |
| Effectiveness | 20% | 2 | 5 | 0.40 | 1.00 |
| Efficiency | 10% | 4 | 3 | 0.40 | 0.30 |
| Reusability | 15% | 2 | 4 | 0.30 | 0.60 |
| Adaptability | 10% | 2 | 4 | 0.20 | 0.40 |
| User Interaction | 5% | 3 | 5 | 0.15 | 0.25 |
| Embedded Knowledge | 10% | 1 | 5 | 0.10 | 0.50 |
| **TOTAL** | 100% | | | **2.60** | **3.95** |

## Critical Gap: Security

**Creator A skill would produce auth that**:
- May use weak hashing (unspecified algorithm)
- Has no token expiration strategy
- Missing CSRF protection
- No rate limiting

**Creator B skill would produce auth that**:
- Uses proper hashing (bcrypt/argon2)
- Has defined token lifecycle
- Considers CSRF
- Includes security checklist

For **security-critical domains**, Creator A's approach is dangerous.

**Winner for Scenario 6**: Creator B (3.95 vs 2.60)
