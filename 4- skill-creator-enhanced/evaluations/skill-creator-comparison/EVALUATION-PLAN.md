# Skill Creator Comparison: Evaluation Plan

## Overview

**Subjects**:
- A: `skill-creator` (basic)
- B: `skill-creator-enhanced`

**Objective**: Evaluate which skill creator produces better skills across multiple dimensions.

---

## Test Scenarios

### Scenario 1: Simple Builder Skill
**User Prompt**: "Create a skill that helps me generate README files for my projects"

**Use Case for Testing**: After creation, use both generated skills to create a README for a Python CLI tool that processes CSV files.

**Why This Tests**:
- Minimal domain complexity
- Clear output artifact
- Tests if creators over-engineer simple tasks

---

### Scenario 2: Technical Domain Skill
**User Prompt**: "Create a skill for building GraphQL APIs"

**Use Case for Testing**: Use both generated skills to create a GraphQL API for a blog (posts, authors, comments).

**Why This Tests**:
- Requires domain knowledge (GraphQL concepts, best practices)
- Multiple valid approaches exist
- Tests domain research vs asking user for domain knowledge

---

### Scenario 3: Automation Skill
**User Prompt**: "Create a skill that automates Docker container deployment"

**Use Case for Testing**: Use both generated skills to containerize and deploy a Node.js Express app.

**Why This Tests**:
- Requires executable scripts
- Error handling is critical
- Security considerations matter

---

### Scenario 4: Vague/Ambiguous Request
**User Prompt**: "Create a skill for data stuff"

**Use Case for Testing**: See how each handles ambiguity, then use result for analyzing sales data CSV.

**Why This Tests**:
- Clarification quality
- Assumption handling
- Scope definition

---

### Scenario 5: Niche Domain Skill
**User Prompt**: "Create a skill for generating OpenAPI specifications from code"

**Use Case for Testing**: Use both to generate OpenAPI spec from a Flask REST API.

**Why This Tests**:
- Specialized domain knowledge
- Standards compliance (OpenAPI 3.x)
- Integration with existing code

---

### Scenario 6: Cross-Cutting Concerns Skill
**User Prompt**: "Create a skill for adding authentication to web apps"

**Use Case for Testing**: Use both to add JWT auth to a Next.js application.

**Why This Tests**:
- Security-sensitive domain
- Multiple valid patterns (JWT, OAuth, sessions)
- Framework-specific considerations

---

## Evaluation Criteria

### 1. Token Efficiency (Weight: 15%)
**Measures**: Resource consumption during creation and usage

| Metric | Description | Scoring |
|--------|-------------|---------|
| Creation tokens | Tokens consumed creating the skill | Lower = Better |
| Skill size | Total tokens in generated SKILL.md | Optimal range preferred |
| Usage tokens | Tokens consumed when using generated skill | Lower = Better |
| Progressive disclosure | Uses references/ vs cramming in SKILL.md | Yes = Better |

**Token Burning Red Flags**:
- Excessive explanations that Claude already knows
- Redundant information across files
- Verbose where concise suffices

---

### 2. Verbosity vs Clarity (Weight: 10%)
**Measures**: Information density and readability

| Metric | Description | Scoring |
|--------|-------------|---------|
| Signal-to-noise ratio | Useful instructions vs filler text | Higher = Better |
| Actionable content | % of content that's directly actionable | Higher = Better |
| Redundancy | Same information repeated | Lower = Better |
| Jargon appropriateness | Technical terms used correctly | Appropriate = Better |

**Assessment**: Count lines, identify filler, measure instruction density.

---

### 3. Over-Engineering (Weight: 15%)
**Measures**: Complexity relative to task requirements

| Metric | Description | Scoring |
|--------|-------------|---------|
| Scope creep | Features beyond what was asked | Lower = Better |
| Abstraction level | Unnecessary abstractions | Appropriate = Better |
| File count | Number of files generated | Appropriate = Better |
| Configuration overhead | Params/options for simple tasks | Lower = Better |

**Red Flags**:
- 10 reference files for a simple skill
- Complex workflow for straightforward task
- Anticipating requirements user didn't mention

---

### 4. Effectiveness (Weight: 20%)
**Measures**: Does the generated skill accomplish its goal?

| Metric | Description | Scoring |
|--------|-------------|---------|
| Task completion | Did it complete the use case? | Yes/Partial/No |
| Output quality | Quality of the artifact produced | 1-5 scale |
| Correctness | No bugs, follows best practices | 1-5 scale |
| Edge case handling | Handles non-happy-path scenarios | 1-5 scale |

**Test**: Execute use case with each generated skill, compare outputs.

---

### 5. Efficiency (Weight: 10%)
**Measures**: Resource usage during skill execution

| Metric | Description | Scoring |
|--------|-------------|---------|
| Steps to complete | Number of tool calls/iterations | Lower = Better |
| Time to complete | Wall clock time | Lower = Better |
| Context reloads | How often references are loaded | Appropriate = Better |
| User interruptions | Questions asked mid-execution | Lower = Better |

---

### 6. Reusability (Weight: 15%)
**Measures**: Can the skill handle variations?

| Metric | Description | Scoring |
|--------|-------------|---------|
| Variation handling | Works for different inputs | 1-5 scale |
| Parameter flexibility | Adapts to different requirements | 1-5 scale |
| Framework agnostic | Not locked to one stack | When appropriate |
| Modification ease | Easy to extend/customize | 1-5 scale |

**Test**: Use generated skill for DIFFERENT but related task:
- README skill: Generate README for a Rust library (not Python CLI)
- GraphQL skill: Create GraphQL for e-commerce (not blog)
- Docker skill: Deploy Python app (not Node.js)

---

### 7. Adaptability Over Variation (Weight: 10%)
**Measures**: Skill encodes patterns, not specific solutions

| Metric | Description | Scoring |
|--------|-------------|---------|
| Pattern vs instance | Teaches fishing, not gives fish | Pattern = Better |
| Decision guidance | Helps choose between options | Present = Better |
| Context awareness | Adapts to user's existing code | Yes = Better |
| Constraint handling | Works within limitations | Yes = Better |

**Distinction from Reusability**: Reusability = same skill works for variations. Adaptability = skill helps Claude DECIDE how to adapt.

---

### 8. User Interaction Quality (Weight: 5%)
**Measures**: Quality of questions and clarifications

| Metric | Description | Scoring |
|--------|-------------|---------|
| Question relevance | Asks useful questions | 1-5 scale |
| Question timing | Asks at right moments | 1-5 scale |
| Assumption transparency | States assumptions clearly | 1-5 scale |
| Question count | Neither too few nor too many | Optimal = Better |

---

## Execution Protocol

### Phase 1: Skill Creation (Per Scenario)

1. **Start fresh session** for each test
2. **Record**:
   - Exact user prompts
   - All questions asked by creator
   - User responses (standardized)
   - Token counts (creation phase)
   - Time to complete
3. **Output**: Generated skill folder

### Phase 2: Skill Usage (Per Generated Skill)

1. **Start fresh session**
2. **Install generated skill**
3. **Execute use case** with standardized prompt
4. **Record**:
   - Token counts (usage phase)
   - Steps/iterations to complete
   - Quality of output
   - Errors encountered

### Phase 3: Variation Test (Per Generated Skill)

1. **Same skill, different requirement**
2. **Record**:
   - Did it work without modification?
   - Quality of adapted output
   - Errors or confusion

---

## Scoring Matrix Template

| Criterion | Weight | Skill A Score | Skill B Score | Notes |
|-----------|--------|---------------|---------------|-------|
| Token Efficiency | 15% | | | |
| Verbosity vs Clarity | 10% | | | |
| Over-Engineering | 15% | | | |
| Effectiveness | 20% | | | |
| Efficiency | 10% | | | |
| Reusability | 15% | | | |
| Adaptability | 10% | | | |
| User Interaction | 5% | | | |
| **TOTAL** | 100% | | | |

---

## Standardized User Responses

To ensure fair comparison, use these responses when creators ask questions:

### For README Skill (Scenario 1)
- Target: Python CLI projects
- Style: Concise, developer-focused
- Sections needed: Installation, Usage, Examples, License

### For GraphQL Skill (Scenario 2)
- Stack: Node.js with Apollo Server
- Database: PostgreSQL
- Auth: JWT tokens

### For Docker Skill (Scenario 3)
- Platform: AWS ECS
- CI/CD: GitHub Actions
- Registry: ECR

### For Vague Request (Scenario 4)
- Clarify: "I want to analyze and visualize data"
- Stack: Python, pandas, matplotlib

### For OpenAPI Skill (Scenario 5)
- Framework: Flask
- OpenAPI version: 3.0
- Output: YAML format

### For Auth Skill (Scenario 6)
- Framework: Next.js 14
- Auth method: JWT with refresh tokens
- Storage: HTTP-only cookies

---

## Output Artifacts

Per scenario, collect:
1. `scenario-N/creator-A/` - Generated skill from basic creator
2. `scenario-N/creator-B/` - Generated skill from enhanced creator
3. `scenario-N/creator-A-output/` - Output from using skill A
4. `scenario-N/creator-B-output/` - Output from using skill B
5. `scenario-N/metrics.md` - Recorded metrics
6. `scenario-N/scoring.md` - Evaluation scores

---

## Final Deliverables

1. **Per-Scenario Reports**: Detailed comparison for each test
2. **Aggregate Scoring**: Weighted total across all scenarios
3. **Qualitative Analysis**: Patterns observed, strengths/weaknesses
4. **Recommendation**: Which creator to use and when
