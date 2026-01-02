# Edge Case Scenarios

Additional scenarios to stress-test the creators.

---

## Scenario 7: Overly Specific Request
**User Prompt**: "Create a skill that generates a React dashboard with TailwindCSS showing user metrics from a PostgreSQL database using Prisma ORM, deployed on Vercel with GitHub Actions CI/CD"

**Use Case for Testing**: Execute exactly as specified.

**Why This Tests**:
- Does creator build requirement-specific vs reusable skill?
- Does it lock to these exact technologies or allow adaptation?
- Over-engineering vs appropriate specificity

**Variation Test**: Same skill for Vue.js + Supabase + Netlify

---

## Scenario 8: Minimal Request
**User Prompt**: "json validator skill"

**Use Case for Testing**: Validate a complex nested JSON file.

**Why This Tests**:
- Handling of extremely minimal input
- Assumption quality
- Scope inflation risk

---

## Scenario 9: Conflicting Requirements
**User Prompt**: "Create a skill for fast, secure, feature-rich file uploads with minimal dependencies"

**Use Case for Testing**: Implement file upload for a web app.

**Why This Tests**:
- Trade-off handling
- Clarification of conflicting needs
- Decision-making guidance in generated skill

---

## Scenario 10: Existing Domain Expertise
**User Prompt**: "Create a skill for working with Kubernetes manifests" (well-documented domain)

**Use Case for Testing**: Generate K8s deployment + service + ingress for a web app.

**Why This Tests**:
- Does creator research domain or ask user?
- Token efficiency on well-known topics
- Quality of embedded domain knowledge

---

## Scenario 11: Niche/Emerging Tech
**User Prompt**: "Create a skill for building with Bun runtime"

**Use Case for Testing**: Create a Bun-based HTTP server with SQLite.

**Why This Tests**:
- Handling of less-documented domains
- Source quality (official vs outdated)
- Graceful degradation when info scarce

---

## Scenario 12: Process/Workflow Skill (Non-Code)
**User Prompt**: "Create a skill for conducting code reviews"

**Use Case for Testing**: Review a PR with 5 files changed.

**Why This Tests**:
- Non-artifact skills
- Procedural knowledge encoding
- Checklist/criteria quality

---

## Scenario 13: Integration-Heavy Skill
**User Prompt**: "Create a skill for setting up monitoring with Prometheus + Grafana + AlertManager"

**Use Case for Testing**: Set up monitoring for a microservices app.

**Why This Tests**:
- Multi-tool coordination
- Complex configuration handling
- Dependency management

---

## Anti-Pattern Detection Scenarios

### Scenario A: Token Burning Test
**Signal**: Creator explains basic concepts Claude already knows
**Measure**: Count explanatory content vs actionable instructions

### Scenario B: Over-Abstraction Test
**Signal**: Creates generic framework instead of focused skill
**Measure**: Layers of abstraction, configuration complexity

### Scenario C: Assumption Explosion
**Signal**: Assumes requirements user didn't specify
**Measure**: Features in output not requested in input

---

## Scoring Adjustments for Edge Cases

| Scenario | Primary Criteria Tested |
|----------|------------------------|
| 7 (Overly Specific) | Reusability, Adaptability |
| 8 (Minimal) | User Interaction, Over-Engineering |
| 9 (Conflicting) | User Interaction, Effectiveness |
| 10 (Well-Known) | Token Efficiency, Verbosity |
| 11 (Niche) | Effectiveness, Adaptability |
| 12 (Non-Code) | Effectiveness, Reusability |
| 13 (Integration) | Efficiency, Over-Engineering |
