---
name: skill-creator-pro
description: |
  Creates production-grade, reusable skills that extend Claude's capabilities.
  This skill should be used when users want to create a new skill, improve an
  existing skill, or build domain-specific intelligence. Gathers context from
  codebase, conversation, and authentic sources before creating adaptable skills.
---

# Skill Creator Pro

Create production-grade skills that extend Claude's capabilities.

## How This Skill Works

```
User: "Create a skill for X"
       ↓
Claude Code uses this meta-skill as guidance
       ↓
Follow Domain Discovery → Ask user clarifying questions → Create skill
       ↓
Generated skill with embedded domain expertise
```

This skill provides **guidance and structure** for creating skills. Claude Code:
1. Uses this skill's framework to discover domain knowledge
2. Asks user for clarifications about THEIR specific requirements
3. Decides how to structure the generated skill based on domain needs

## What This Skill Does

- Guides creation of new skills from scratch
- Helps improve existing skills to production quality
- Provides patterns for 5 skill types (Builder, Guide, Automation, Analyzer, Validator)
- Ensures skills encode procedural knowledge + domain expertise

## What This Skill Does NOT Do

- Test skills in production environments
- Deploy or distribute skills
- Handle skill versioning/updates after creation
- Create requirement-specific skills (always create reusable intelligence)

---

## Domain Discovery Framework

**Key Principle**: Users want domain expertise IN the skill. They may not BE domain experts.

### Phase 1: Automatic Discovery (No User Input)

Proactively research the domain before asking anything:

| Discover | How | Example: "Kafka integration" |
|----------|-----|------------------------------|
| Core concepts | Official docs, Context7 | Producers, consumers, topics, partitions |
| Standards/compliance | Search "[domain] standards" | Kafka security, exactly-once semantics |
| Best practices | Search "[domain] best practices 2025" | Partitioning strategies, consumer groups |
| Anti-patterns | Search "[domain] common mistakes" | Too many partitions, no monitoring |
| Security | Search "[domain] security" | SASL, SSL, ACLs, encryption |
| Ecosystem | Search "[domain] ecosystem tools" | Confluent, Schema Registry, Connect |

**Sources priority**: Official docs → Library docs (Context7) → GitHub → Community → WebSearch

### Phase 2: Knowledge Sufficiency Check

Before asking user anything, verify internally:

```
- [ ] Core concepts understood?
- [ ] Best practices identified?
- [ ] Anti-patterns known?
- [ ] Security considerations covered?
- [ ] Official sources found?

If ANY gap → Research more (don't ask user for domain knowledge)
Only if CANNOT discover (proprietary/internal) → Ask user
```

### Phase 3: User Requirements (NOT Domain Knowledge)

Only ask about user's SPECIFIC context:

| Ask | Don't Ask |
|-----|-----------|
| "What's YOUR use case?" | "What is Kafka?" |
| "What's YOUR tech stack?" | "What options exist?" |
| "Any existing resources?" | "How does it work?" |
| "Specific constraints?" | "What are best practices?" |

The skill contains domain expertise. User provides requirements.

---

## ⚠️ MANDATORY Before Writing SKILL.md

**STOP. DO NOT write SKILL.md until ALL boxes are checked:**

```
- [ ] Fetched official library/framework documentation (Context7 or WebFetch)
- [ ] WebSearched "[domain] official documentation" for authoritative sources
- [ ] WebSearched "[domain] best practices [current year]" for industry standards
- [ ] Listed ALL variations the skill should handle (not just the user's specific case)
- [ ] Verified description covers ALL trigger scenarios (not just primary use case)
- [ ] Confirmed no knowledge gaps remain (Phase 2 complete)
```

**Why this matters**: Training knowledge may be outdated or incomplete. Skills that skip discovery produce narrow, requirement-specific tools instead of reusable intelligence.

**Common failures when skipped**:
- Narrow description that misses auto-invoke triggers
- Missing test types, patterns, or variations
- Outdated best practices from training data
- No source citations in references/

---

## Required Clarifications

Ask about SKILL METADATA and USER REQUIREMENTS (not domain knowledge):

### Skill Metadata

**1. Skill Type** - "What type of skill?"

| Type | Purpose | Example |
|------|---------|---------|
| **Builder** | Create artifacts | Widgets, code, documents |
| **Guide** | Provide instructions | How-to, tutorials |
| **Automation** | Execute workflows | File processing, deployments |
| **Analyzer** | Extract insights | Code review, data analysis |
| **Validator** | Enforce quality | Compliance checks, scoring |

**2. Domain** - "What domain or technology?"

### User Requirements (After Domain Discovery)

**3. Use Case** - "What's YOUR specific use case?"
- Not "what can it do" but "what do YOU need"

**4. Tech Stack** - "What's YOUR environment?"
- Languages, frameworks, existing infrastructure

**5. Existing Resources** - "Any scripts, templates, configs to include?"

**6. Constraints** - "Any specific requirements or limitations?"
- Performance, security, compliance specific to user's context

### Note
- Questions 1-2: Ask immediately
- Domain Discovery: Research automatically after knowing domain
- Questions 3-6: Ask after discovery, informed by domain knowledge
- **Question pacing**: Avoid asking too many questions in a single message. Start with most important, follow up as needed.

---

## Core Principles

### Reusable Intelligence, Not Requirement-Specific

Skills must handle VARIATIONS, not single requirements:

```
❌ Bad: "Create bar chart with sales data using Recharts"
✅ Good: "Create visualizations - adaptable to data shape, chart type, library"

❌ Bad: "Deploy to AWS EKS with Helm"
✅ Good: "Deploy applications - adaptable to platform, orchestration, environment"
```

Identify what VARIES vs what's CONSTANT in the domain. See `references/reusability-patterns.md`.

### Concise is Key

Context window is a public good (~1,500+ tokens per skill activation). Challenge each piece:
- "Does Claude really need this explanation?"
- "Does this paragraph justify its token cost?"

Prefer concise examples over verbose explanations.

### Appropriate Freedom

Match specificity to task fragility:

| Freedom Level | When to Use | Example |
|---------------|-------------|---------|
| **High** | Multiple approaches valid | "Choose your preferred style" |
| **Medium** | Preferred pattern exists | Pseudocode with parameters |
| **Low** | Operations are fragile | Exact scripts, few parameters |

### Progressive Disclosure

Three-level loading system:

1. **Metadata** (~100 tokens) - Always in context (description ≤1024 chars)
2. **SKILL.md body** (<500 lines) - When skill triggers
3. **References** (unlimited) - Loaded as needed by Claude

---

## Anatomy of a Skill

Generated skills are **zero-shot domain experts** with embedded knowledge.

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description, allowed-tools?, model?)
│   └── Procedural knowledge (workflows, steps, decision trees)
└── Bundled Resources
    ├── references/   - Domain expertise (structure based on domain needs)
    ├── scripts/      - Executable code (tested, reliable)
    └── assets/       - Templates, boilerplate, images
```

### SKILL.md Requirements

| Component | Requirement |
|-----------|-------------|
| Line count | <500 lines (extract to references/) |
| Frontmatter | See `references/skill-patterns.md` for complete spec |
| `name` | Gerund form (verb-ing); lowercase, hyphens; ≤64 chars; no "anthropic"/"claude" |
| `description` | [What] + [When]; ≤1024 chars (≤200 for claude.ai); third-person |
| `allowed-tools` | Optional; CLI only (not SDK or claude.ai) |
| Form | Imperative ("Do X" not "You should X") |
| Scope | What it does AND does not do |
| Paths | Always use forward slashes (`/`), even on Windows |

### What Goes in references/

Embed domain knowledge gathered during discovery:

| Gathered Knowledge | Purpose in Skill |
|--------------------|------------------|
| Library/API documentation | Enable correct implementation |
| Best practices | Guide quality decisions |
| Code examples | Provide reference patterns |
| Anti-patterns | Prevent common mistakes |
| Domain-specific details | Support edge cases |

**Structure references/ based on what the domain needs.**

**Reference file rules**:
- Keep references **one level deep** (no nested references)
- Files >100 lines should include a **table of contents** at top
- If >10k words total, include **grep search patterns** in SKILL.md

### When to Generate scripts/

Generate scripts when domain requires **deterministic, executable procedures**:

| Domain Need | Example Scripts |
|-------------|-----------------|
| Setup/installation | Install dependencies, initialize project |
| Processing | Transform data, process files |
| Validation | Check compliance, verify output |
| Deployment | Deploy services, configure infrastructure |

**Decision**: If procedure is complex, error-prone, or needs to be exactly repeatable → create script. Otherwise → document in SKILL.md or references/.

### When to Generate assets/

Generate assets when domain requires **exact templates or boilerplate**:

| Domain Need | Example Assets |
|-------------|----------------|
| Starting templates | HTML boilerplate, component scaffolds |
| Configuration files | Config templates, schema definitions |
| Code boilerplate | Base classes, starter code |

### What NOT to Include

- README.md (SKILL.md IS the readme)
- CHANGELOG.md
- LICENSE (inherited from repo)
- Duplicate information

### Platform Constraints

**Cross-platform sync**: Skills do NOT sync across surfaces—upload separately to each platform.

| Platform | Network | Packages | `allowed-tools` |
|----------|---------|----------|-----------------|
| Claude Code CLI | Full | Discouraged | ✅ Works |
| Claude.ai | Varies | Yes | ❌ Ignored |
| Claude API | None | No | ❌ Ignored |

### What Generated Skill Does at Runtime

```
User invokes skill → Gather context from:
  1. Codebase (if existing project)
  2. Conversation (user's requirements)
  3. Own references/ (embedded domain expertise)
  4. User-specific guidelines
→ Ensure all information gathered → Implement ZERO-SHOT
```

### Include in Generated Skills

Every generated skill should include:

```markdown
## Before Implementation

Gather context to ensure successful implementation:

| Source | Gather |
|--------|--------|
| **Codebase** | Existing structure, patterns, conventions to integrate with |
| **Conversation** | User's specific requirements, constraints, preferences |
| **Skill References** | Domain patterns from `references/` (library docs, best practices, examples) |
| **User Guidelines** | Project-specific conventions, team standards |

Ensure all required context is gathered before implementing.
Only ask user for THEIR specific requirements (domain expertise is in this skill).
```

---

## Type-Aware Creation

After determining skill type, follow type-specific patterns:

| Type | Key Sections | Reference |
|------|--------------|-----------|
| **Builder** | Clarifications → Output Spec → Standards → Checklist | `skill-patterns.md#builder` |
| **Guide** | Workflow → Examples → Official Docs | `skill-patterns.md#guide` |
| **Automation** | Scripts → Dependencies → Error Handling | `skill-patterns.md#automation` |
| **Analyzer** | Scope → Criteria → Output Format | `skill-patterns.md#analyzer` |
| **Validator** | Criteria → Scoring → Thresholds → Remediation | `skill-patterns.md#validator` |

---

## Skill Creation Process

```
Metadata → Discovery → Requirements → Analyze → Embed → Structure → Implement → Validate
```

See `references/creation-workflow.md` for detailed steps.

### Quick Steps

1. **Metadata**: Ask skill type + domain (Questions 1-2)
2. **Discovery**: Research domain automatically (Phase 1-2 above)
3. **⚠️ CHECKPOINT**: Verify MANDATORY checklist is complete (see above)
4. **Requirements**: Ask user's specific needs (Questions 3-6)
5. **Analyze**: Identify procedural (HOW) + domain (WHAT) knowledge
6. **Embed**: Put gathered domain expertise into `references/`
7. **Structure**: Initialize skill directory
8. **Implement**: Write SKILL.md + resources following type patterns
9. **Validate**: Run `scripts/package_skill.py` and test

### SKILL.md Template

```yaml
---
name: processing-something          # gerund form, lowercase, hyphens, ≤64 chars
                                    # Cannot contain "anthropic" or "claude"
description: |                      # ≤1024 chars (≤200 for claude.ai)
  [What] Capability statement (third-person).
  [When] This skill should be used when users ask to <triggers>.
allowed-tools: Read, Grep, Glob     # optional: restrict tools (CLI only)
---
```

See `references/skill-patterns.md` for complete frontmatter spec and body patterns.

---

## Output Checklist

Before delivering a skill, verify:

### Domain Discovery Complete
- [ ] Core concepts discovered and understood
- [ ] Best practices identified from authentic sources
- [ ] Anti-patterns documented
- [ ] Security considerations covered
- [ ] Official documentation linked
- [ ] User was NOT asked for domain knowledge

### Frontmatter
- [ ] `name`: gerund form, lowercase, hyphens, ≤64 chars, matches directory
- [ ] `name`: Does NOT contain "anthropic" or "claude"
- [ ] `description`: [What]+[When], ≤1024 chars (≤200 for claude.ai), third-person
- [ ] `allowed-tools`: Set if restricted (CLI only—ignored on other platforms)

### Structure
- [ ] SKILL.md <500 lines
- [ ] Progressive disclosure (details in references/)
- [ ] References one level deep, TOC if >100 lines
- [ ] Forward slashes in all paths

### Knowledge Coverage
- [ ] **Procedural** (HOW): Workflows, decision trees, error handling
- [ ] **Domain** (WHAT): Concepts, best practices, anti-patterns

### Zero-Shot Implementation (in generated skill)
- [ ] Includes "Before Implementation" section
- [ ] Gathers runtime context (codebase, conversation, user guidelines)
- [ ] Domain expertise embedded in `references/` (structured per domain needs)
- [ ] Only asks user for THEIR requirements (not domain knowledge)

### Reusability
- [ ] Handles variations (not requirement-specific)
- [ ] Clarifications capture variable elements (user's context)
- [ ] Constants encoded (domain patterns, best practices)

### Type-Specific (see `references/skill-patterns.md`)
- [ ] Builder: Clarifications, output spec, standards, checklist
- [ ] Guide: Workflow, examples, official docs
- [ ] Automation: Scripts, dependencies, error handling
- [ ] Analyzer: Scope, criteria, output format
- [ ] Validator: Criteria, scoring, thresholds, remediation

---

## Reference Files
| File | When to Read |
|------|--------------|
| `references/creation-workflow.md` | Detailed step-by-step creation process |
| `references/skill-patterns.md` | Frontmatter spec, naming, type-specific patterns, assets |
| `references/reusability-patterns.md` | Procedural+domain knowledge, varies vs constant |
| `references/quality-patterns.md` | Clarifications, checklists, testing methodology |
| `references/technical-patterns.md` | Error handling, security, dependencies, anti-patterns |
| `references/workflows.md` | Sequential and conditional workflow patterns |
| `references/output-patterns.md` | Template and example patterns |
