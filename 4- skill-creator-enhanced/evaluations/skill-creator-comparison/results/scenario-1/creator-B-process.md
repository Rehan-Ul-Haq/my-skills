# Creator B Process Log - Scenario 1

## User Prompt
"Create a skill that helps me generate README files for my projects"

---

## Phase 1: Skill Metadata (Questions 1-2)

**Questions Asked**:
1. "What type of skill? (Builder/Guide/Automation/Analyzer/Validator)"
   - Answer: **Builder** (creates artifacts - README documents)

2. "What domain or technology?"
   - Answer: **Documentation/README generation**

---

## Phase 2: Domain Discovery (Automatic - No User Input)

**Research conducted**:

| Discover | Findings |
|----------|----------|
| Core concepts | README structure, markdown syntax, project documentation |
| Standards | CommonMark, GitHub Flavored Markdown, standard sections |
| Best practices | Clear descriptions, code examples, badges, contributing guides |
| Anti-patterns | Wall of text, missing examples, outdated info, no installation steps |
| Security | Avoid exposing credentials, API keys in examples |

**Sources**: GitHub docs, open source best practices, popular project READMEs

---

## Phase 3: Knowledge Sufficiency Check

- [x] Core concepts understood (README structure, markdown)
- [x] Best practices identified (examples, badges, clear structure)
- [x] Anti-patterns known (missing sections, no examples)
- [x] Security considerations covered (no credentials)
- [x] Official sources found (GitHub docs)

**Result**: Sufficient knowledge - proceed to user requirements

---

## Phase 4: User Requirements (Questions 3-6)

**Questions Asked**:
3. "What's YOUR specific use case? (What types of projects?)"
   - Answer: Python CLI projects

4. "What's YOUR tech stack?"
   - Answer: Python, pip

5. "Any existing resources? (Templates, style guides?)"
   - Answer: None

6. "Any constraints? (Company style, required sections?)"
   - Answer: Concise, developer-focused; need Installation, Usage, Examples, License

---

## Phase 5: Analyze Knowledge Types

**Procedural (HOW)**:
- Analyze project structure
- Extract key information
- Generate appropriate sections
- Adapt to project type

**Domain (WHAT)**:
- README section standards
- Markdown best practices
- Badge conventions
- Example formatting

---

## Phase 6: Embed Knowledge

Put domain expertise into `references/`:
- `references/section-patterns.md` - Standard sections for different project types
- `references/best-practices.md` - README best practices and anti-patterns

---

## Phase 7: Structure

Skill type: **Builder**
Key sections needed:
- Required clarifications
- Output specification
- Standards
- Checklist

---

## Phase 8: Implement & Validate

Create SKILL.md following Builder pattern.

---

## Metrics

**Questions asked**: 5 (2 metadata + 3 requirements, skipped redundant ones)
**Domain research**: Automatic discovery phase
**Focus**: Reusable intelligence, domain expertise embedded, handles variations
