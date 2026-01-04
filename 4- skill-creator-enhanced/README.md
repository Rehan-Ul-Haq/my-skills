# skill-creator-pro

[![Version](https://img.shields.io/badge/Version-2.1.0-blue)](CHANGELOG.md)

Production-grade skill creation with domain discovery and embedded expertise.

## Why Use This Over Official skill-creator?

| Official skill-creator | skill-creator-pro |
|------------------------|------------------------|
| Asks user for domain knowledge | Discovers domain knowledge automatically |
| Template-based approach | Pattern-based with reusability |
| 3 skill types | 5 skill types |
| No embedded expertise | Embeds best practices + anti-patterns |
| Works for simple domains | Works for complex/security domains |

**Evaluation Results**: Outperforms official by +41% across 6 test scenarios. See `evaluations/skill-creator-comparison/`.

## Key Features

### Domain Discovery Framework
- **Automatic research** before asking user anything
- **Knowledge sufficiency check** ensures expertise gathered
- **User requirements only** - never asks for domain knowledge

### Reusable Intelligence
- Skills handle **variations**, not single requirements
- Identifies what VARIES vs what's CONSTANT
- Encodes patterns, not just solutions

### 5 Skill Types
| Type | Purpose | Example |
|------|---------|---------|
| **Builder** | Create artifacts | Widgets, code, documents |
| **Guide** | Provide instructions | How-to, tutorials |
| **Automation** | Execute workflows | Deployments, processing |
| **Analyzer** | Extract insights | Code review, data analysis |
| **Validator** | Enforce quality | Compliance, scoring |

### Zero-Shot Implementation
Generated skills include:
- "Before Implementation" context gathering
- Embedded domain expertise in `references/`
- Only ask users for THEIR requirements

## Quick Start

```
Create a skill for [your domain]
```

The skill will:
1. Ask skill type + domain
2. Research domain automatically
3. Ask YOUR specific requirements
4. Generate skill with embedded expertise

## Structure

```
skill-creator-pro/
├── SKILL.md (389 lines)
├── scripts/
│   ├── init_skill.py          # Initialize new skill
│   ├── package_skill.py       # Package for distribution
│   └── quick_validate.py      # Quick validation check
└── references/
    ├── creation-workflow.md   # Step-by-step process
    ├── skill-patterns.md      # Frontmatter, type patterns
    ├── reusability-patterns.md # Varies vs constant
    ├── quality-patterns.md    # Clarifications, checklists
    ├── technical-patterns.md  # Errors, security, deps
    ├── workflows.md           # Workflow patterns
    └── output-patterns.md     # Templates, examples
```

## 8-Step Creation Process

```
Metadata → Discovery → Requirements → Analyze → Embed → Structure → Implement → Validate
```

1. **Metadata**: Ask skill type + domain
2. **Discovery**: Research domain automatically
3. **Requirements**: Ask user's specific needs
4. **Analyze**: Identify procedural + domain knowledge
5. **Embed**: Put expertise into `references/`
6. **Structure**: Initialize skill directory
7. **Implement**: Write SKILL.md + resources
8. **Validate**: Package and test

## vs Official skill-creator (Anthropic)

| Aspect | Official | Enhanced |
|--------|----------|----------|
| Evaluation Score | 2.76/5 avg | 3.89/5 avg |
| Domain Discovery | No (asks user) | Yes (automatic) |
| Skill Types | 3 | 5 |
| Reusability Focus | No | Yes |
| Zero-Shot Pattern | No | Yes |
| Embedded Expertise | No | Yes |
| Security Awareness | Basic | Comprehensive |
| Reference Files | 0 | 7 |

## Installation

```bash
# Copy to Claude Code skills directory
cp -r skill-creator-pro ~/.claude/skills/
```
