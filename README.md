# My Skills Collection

A curated collection of production-grade skills for Claude Code and AI agents.

## Skills Overview

| # | Skill | Description | Version |
|---|-------|-------------|---------|
| 1 | [fetch-library-docs](1-%20fetch-library-docs/) | Fetch library documentation with 86.8% token savings | v1.0.0 |
| 2 | [skill-validator](2-%20skill-validator/) | Validate skills against production-level quality criteria | v1.0.0 |
| 3 | [chatgpt-widget-creator](3-%20chatgpt-appsdk-widget-creator/) | Create production-grade widgets for ChatGPT Apps | v1.0.0 |
| 4 | [skill-creator-pro](4-%20skill-creator-pro/) | Create skills that score 96/100 on skill-validator | v2.1.0 |

---

## Skill Details

### 1. fetch-library-docs

**Purpose**: Fetch library and framework documentation with intelligent filtering.

**Key Features**:
- 86.8% token savings through shell pipeline filtering
- Supports JavaScript, Python, Go, Rust, and other libraries
- Cross-platform (Windows, macOS, Linux)
- Context7 MCP integration

**Use When**: You need code examples, API references, or documentation for any library.

```
"Show me React useState examples"
"How do I use Prisma queries?"
"Get Next.js routing docs"
```

[View Documentation](1-%20fetch-library-docs/README.md) | [Changelog](1-%20fetch-library-docs/CHANGELOG.md)

---

### 2. skill-validator

**Purpose**: Validate any skill against production-level quality criteria.

**Key Features**:
- 7 validation criteria with weighted scoring (0-100)
- Actionable recommendations (High/Medium/Low priority)
- Based on real production best practices

**Use When**: You want to assess skill quality before publishing.

```
"Validate the my-skill skill"
```

[View Documentation](2-%20skill-validator/README.md) | [Changelog](2-%20skill-validator/CHANGELOG.md)

---

### 3. chatgpt-widget-creator

**Purpose**: Create production-grade widgets for ChatGPT Apps using OpenAI Apps SDK.

**Key Features**:
- Zero-shot widget creation from descriptions
- Multiple widget types (progress, quiz, forms, charts, etc.)
- Theme support (light/dark)
- WCAG AA accessibility

**Use When**: You're building ChatGPT custom apps with visual widgets.

```
"Create a widget for progress tracking"
"Build a quiz interface widget"
```

[View Documentation](3-%20chatgpt-appsdk-widget-creator/README.md) | [Changelog](3-%20chatgpt-appsdk-widget-creator/CHANGELOG.md)

---

### 4. skill-creator-pro

**Purpose**: Production-grade skill creation that scores 96/100 on skill-validator.

**Key Features**:
- Required Clarifications pattern
- Scope Clarity (Does / Does NOT do)
- Enforcement Checklists
- Output quality gates

**Use When**: You want to create high-quality skills.

```
"Create a skill for [your domain]"
```

[View Documentation](4-%20skill-creator-pro/README.md) | [Changelog](4-%20skill-creator-pro/CHANGELOG.md)

---

## Installation

### For Claude Code

Copy the skill folder to your Claude Code skills directory:

```bash
# macOS/Linux
cp -r <skill-folder>/<skill-name> ~/.claude/skills/

# Windows
xcopy /E /I <skill-folder>\<skill-name> %USERPROFILE%\.claude\skills\<skill-name>
```

### Verify Installation

The skill should appear when Claude Code starts and will be automatically triggered based on its description.

---

## Repository Structure

```
my-skills/
├── README.md                          # This file
├── .claude/skills/                    # Local skills (gitignored)
├── 1- fetch-library-docs/
│   ├── README.md
│   ├── CHANGELOG.md
│   ├── fetch-library-docs/            # Skill files
│   └── skill-evaluation/              # QA evaluation
├── 2- skill-validator/
│   ├── README.md
│   ├── CHANGELOG.md
│   └── skill-validator/               # Skill files
├── 3- chatgpt-appsdk-widget-creator/
│   ├── README.md
│   ├── CHANGELOG.md
│   └── chatgpt-widget-creator/        # Skill files
└── 4- skill-creator-pro/
    ├── README.md
    ├── CHANGELOG.md
    └── skill-creator-pro/             # Skill files
```

---

## Versioning

All skills follow [Semantic Versioning](https://semver.org/):

- **Major**: Breaking changes
- **Minor**: New features (backward compatible)
- **Patch**: Bug fixes

See individual `CHANGELOG.md` files for version history.

---

## Contributing

1. Fork this repository
2. Create your skill following the patterns in `skill-creator-pro`
3. Validate with `skill-validator` (aim for 90+ score)
4. Submit a pull request

---

## License

MIT License - See individual skill folders for details.

---

## Related Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io/)
- [OpenAI Apps SDK](https://platform.openai.com/docs/apps)
