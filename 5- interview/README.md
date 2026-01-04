# Interview Skill

Prevent building the wrong thing by discovering user intent before taking action.

## The Problem

AI often builds the wrong thing because it:
- Takes surface requests literally without understanding intent
- Makes hidden assumptions it never validates
- Proceeds without confirming alignment

## The Solution

This skill conducts discovery conversations that uncover the **WHY** behind the **WHAT**, ensuring both problem and solution are agreed upon before implementation.

## Usage

```
/interview
```

Or trigger naturally when:
- Requests are ambiguous or complex
- Recommendations are needed
- Brainstorming is requested
- High-stakes work where mistakes are costly

## The WHY + WHAT Model

```
Surface WHAT → Discover WHY → Surface Assumptions → Informed WHAT → Agree → Proceed
```

| Phase | Purpose | Example |
|-------|---------|---------|
| Surface WHAT | Capture initial request | "Add dark mode" |
| Discover WHY | Uncover intent/problem | "Eye strain for night workers" |
| Surface Assumptions | Expose AI's hidden assumptions | "Assuming web app, not mobile" |
| Informed WHAT | Solution options based on WHY | "Dark mode + auto-brightness + schedule" |
| Agree on Both | Confirm problem AND solution | "Solving eye strain via dark mode with auto-switch" |

## Key Techniques

### Laddering
Dig into abstract goals:
```
"Dark mode" → "Why?" → "Eye strain" → "Why an issue?" → "Night shift workers"
```

### 5 Whys
Uncover root need:
```
"Export feature" → Why? → "Share reports" → Why? → "Stakeholder reviews" → Root need
```

### Surface Assumptions
AI always makes assumptions. Surface them explicitly:
```
"I'm assuming:
- This is for [platform/context]
- Users are [type]
- We need to support [X] but not [Y]

Are these correct?"
```

## Output Format

```markdown
## Understanding

**Problem (WHY)**: [What we're solving and why it matters]
**Solution (WHAT)**: [What we'll build/do]
**Key decisions**: [Important choices made]
**Not included**: [Explicit scope boundaries]

Ready to proceed?
```

## When NOT to Use

- Simple, clear requests that don't need clarification
- Tasks where the intent is obvious
- Follow-up work on already-clarified requests

## Structure

```
interview/
├── SKILL.md                         # Main skill definition
├── README.md                        # This file
└── references/
    ├── question-patterns.md         # Techniques for discovering WHY
    ├── anti-patterns.md             # Common mistakes to avoid
    └── summary-templates.md         # Output formats for different situations
```

## Anti-Patterns to Avoid

| Anti-Pattern | What Happens | Fix |
|--------------|--------------|-----|
| Skip WHY | Build wrong solution | Always ask why before how |
| Hidden assumptions | Surprise misalignment | Surface and validate explicitly |
| Accept surface request | Miss real need | Dig deeper with laddering/5 whys |
| Proceed without confirm | Waste effort | Get explicit "yes, proceed" |
| Over-question simple requests | Annoy user | Match depth to complexity |

## License

MIT
