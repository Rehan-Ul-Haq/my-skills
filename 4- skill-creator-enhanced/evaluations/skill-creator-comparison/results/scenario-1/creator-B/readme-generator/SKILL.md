---
name: readme-generator
description: |
  Generates professional README.md files for software projects.
  This skill should be used when users want to create, update, or improve
  README documentation for any project type (CLI, library, web app, API).
---

# README Generator

Generate professional README files adapted to project type and conventions.

## What This Skill Does

- Analyzes project structure to extract key information
- Generates README with appropriate sections for project type
- Follows markdown best practices and GitHub conventions
- Adapts to existing codebase patterns

## What This Skill Does NOT Do

- Generate API documentation (use dedicated API doc tools)
- Create full documentation sites (use Sphinx, MkDocs, etc.)
- Manage documentation versions

---

## Before Implementation

| Source | Gather |
|--------|--------|
| **Codebase** | Entry points, package config, existing docs, directory structure |
| **Conversation** | Project description, key features, target audience |
| **Skill References** | Section patterns from `references/` |
| **User Guidelines** | Team conventions, required sections |

---

## Required Clarifications

Before generating, clarify:

| Clarification | Why |
|---------------|-----|
| Project type | CLI vs library vs web app affects sections |
| Target audience | Developers vs end-users affects tone |
| Key features | What to highlight |
| Required sections | Any mandatory inclusions |

---

## Generation Workflow

```
1. Analyze → 2. Clarify → 3. Generate → 4. Review
```

### 1. Analyze Project

Examine:
- Package config (`package.json`, `pyproject.toml`, `Cargo.toml`)
- Entry points (`main.py`, `index.js`, `src/lib.rs`)
- Existing README (if updating)
- Test files (for usage examples)

### 2. Clarify Requirements

Ask only what cannot be inferred from codebase.

### 3. Generate README

Select sections based on project type (see `references/section-patterns.md`).

### 4. Review Checklist

Before delivery:
- [ ] Title matches project name
- [ ] Description is one clear sentence
- [ ] Installation steps tested/accurate
- [ ] Usage examples are runnable
- [ ] No credentials or secrets exposed
- [ ] Links are valid

---

## Output Specification

| Element | Requirement |
|---------|-------------|
| Format | GitHub Flavored Markdown |
| Location | Project root as `README.md` |
| Length | Concise; details in separate docs |
| Examples | Runnable code blocks with language tags |

---

## Reference Files

| File | Use When |
|------|----------|
| `references/section-patterns.md` | Choosing sections for project type |
| `references/best-practices.md` | Quality guidelines and anti-patterns |
