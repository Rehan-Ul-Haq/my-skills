# Evaluation Criteria Definitions

## Criteria Consolidation

User's original list with overlaps merged:

| Original Term | Merged Into | Rationale |
|---------------|-------------|-----------|
| Token-burning | Token Efficiency | Same concept - wasted tokens |
| Verbosity | Token Efficiency | Verbosity causes token waste |
| Effectiveness | Effectiveness | Core criterion |
| Efficiency | Efficiency | Core criterion (execution speed) |
| Efficacy | Effectiveness | Efficacy = effectiveness in practice |
| Over-engineered | Over-Engineering | Core criterion |
| Reusability | Reusability | Core criterion |
| Application over variation | Adaptability | Skill should enable adaptation, not hard-code |

---

## Final 8 Criteria

### 1. Token Efficiency (15%)

**Definition**: Minimizing token consumption during creation AND usage while maintaining quality.

**Subcriteria**:
- **Creation tokens**: Tokens spent generating the skill
- **Skill footprint**: Size of generated SKILL.md + references
- **Usage tokens**: Tokens spent when executing the skill
- **Information density**: Useful content per token

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Minimal tokens, high density, no waste |
| 4 | Lean with minor redundancy |
| 3 | Average, some verbose sections |
| 2 | Notable bloat, explains obvious things |
| 1 | Excessive tokens, low information density |

**Red Flags** (instant -1):
- Explains concepts Claude knows (e.g., "Docker is a containerization platform...")
- Repeats same information in SKILL.md and references
- Uses 50 words where 10 suffice

---

### 2. Over-Engineering (15%)

**Definition**: Adding complexity, features, or abstractions beyond task requirements.

**Subcriteria**:
- **Scope creep**: Features/capabilities beyond request
- **Abstraction depth**: Unnecessary layers
- **Configuration complexity**: Excessive parameters/options
- **File proliferation**: More files than needed

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Minimal viable, exactly what's needed |
| 4 | Slight extras, justified by domain |
| 3 | Some unnecessary additions |
| 2 | Significant over-engineering |
| 1 | Grossly over-complicated |

**Examples**:
- Request: "README generator" → Bad: Creates 5 templates, 3 styles, config system
- Request: "JSON validator" → Bad: Adds schema generation, API mode, CLI wrapper

---

### 3. Effectiveness (20%)

**Definition**: Does the generated skill accomplish its intended goal?

**Subcriteria**:
- **Task completion**: Finished the use case successfully
- **Output quality**: Correctness, best practices, polish
- **Edge handling**: Non-happy-path scenarios
- **Domain accuracy**: Correct domain knowledge applied

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Complete, correct, handles edges |
| 4 | Complete with minor issues |
| 3 | Mostly complete, some gaps |
| 2 | Partial completion, notable issues |
| 1 | Failed to complete or fundamentally wrong |

**Test Method**: Execute use case, evaluate output artifact.

---

### 4. Efficiency (10%)

**Definition**: Resource usage during skill execution (not creation).

**Subcriteria**:
- **Steps to complete**: Tool calls, iterations
- **Time to complete**: Wall clock duration
- **Directness**: Straight path vs meandering
- **Context switches**: Reference file loads

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Direct, minimal steps, fast |
| 4 | Mostly direct, few extra steps |
| 3 | Average execution path |
| 2 | Wandering, multiple attempts |
| 1 | Excessive iteration, slow |

---

### 5. Reusability (15%)

**Definition**: Skill works for variations of the original requirement.

**Subcriteria**:
- **Input variation**: Different inputs, same skill
- **Technology variation**: Different stack, same domain
- **Scale variation**: Small vs large projects
- **Modification ease**: Easy to extend

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Works for wide variation range |
| 4 | Handles most variations |
| 3 | Works for similar variations |
| 2 | Narrow applicability |
| 1 | Single-use, requirement-specific |

**Test Method**: Apply skill to variation use case.

---

### 6. Adaptability (10%)

**Definition**: Skill encodes patterns and decision-making, not just solutions.

**Distinction from Reusability**:
- Reusability: Same skill works for variations
- Adaptability: Skill helps Claude DECIDE how to handle new situations

**Subcriteria**:
- **Decision guidance**: When to use approach A vs B
- **Context awareness**: Reads existing code/conventions
- **Constraint handling**: Adapts to limitations
- **Pattern teaching**: Teaches approach, not just solution

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Rich decision guidance, highly adaptive |
| 4 | Good adaptation support |
| 3 | Some flexibility |
| 2 | Rigid, follows fixed path |
| 1 | Hard-coded single approach |

**Example**:
- Bad: "Use JWT for authentication"
- Good: "Choose auth method based on: stateless needs → JWT, session management → cookies..."

---

### 7. User Interaction Quality (5%)

**Definition**: Quality of questions and clarifications during skill creation.

**Subcriteria**:
- **Question relevance**: Asks useful questions
- **Question timing**: Right moment, not overwhelming
- **Domain vs requirements**: Asks about user context, not domain basics
- **Assumption transparency**: Clear about what's assumed

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Perfect questions, ideal pacing |
| 4 | Good questions, minor issues |
| 3 | Adequate clarification |
| 2 | Missing key questions or asks too much |
| 1 | Poor questions, user does the work |

---

### 8. Quality of Embedded Knowledge (10%)

**Definition**: Quality of domain expertise embedded in the generated skill.

**Subcriteria**:
- **Accuracy**: Correct information
- **Currency**: Up-to-date practices
- **Completeness**: Covers necessary ground
- **Source quality**: From authoritative sources
- **Anti-pattern awareness**: Knows what NOT to do

**Scoring Guide**:
| Score | Description |
|-------|-------------|
| 5 | Accurate, current, comprehensive |
| 4 | Good knowledge, minor gaps |
| 3 | Adequate domain coverage |
| 2 | Notable gaps or outdated info |
| 1 | Incorrect or missing domain knowledge |

---

## Weighting Rationale

| Criterion | Weight | Rationale |
|-----------|--------|-----------|
| Effectiveness | 20% | Primary goal - does it work? |
| Token Efficiency | 15% | Context is precious resource |
| Over-Engineering | 15% | Simplicity is a feature |
| Reusability | 15% | Skills should be reusable |
| Efficiency | 10% | Execution performance |
| Adaptability | 10% | Flexibility in new situations |
| Embedded Knowledge | 10% | Domain expertise quality |
| User Interaction | 5% | Creation experience |

Total: 100%

---

## Composite Scores

### Production Readiness Score
```
= (Effectiveness × 0.4) + (Reusability × 0.3) + (Embedded Knowledge × 0.3)
```

### Resource Efficiency Score
```
= (Token Efficiency × 0.5) + (Efficiency × 0.3) + (Over-Engineering × 0.2)
```

### Flexibility Score
```
= (Reusability × 0.5) + (Adaptability × 0.5)
```
