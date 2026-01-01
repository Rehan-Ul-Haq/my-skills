# fetch-library-docs: 60-90% Token Reduction for Library Documentation

**Proactively fetch official library docs with intelligent content-type filtering.**

[![Version](https://img.shields.io/badge/Version-2.0.1-blue)](CHANGELOG.md)
[![MCP Protocol](https://img.shields.io/badge/MCP-Context7-blue)](https://modelcontextprotocol.io/)
[![Token Savings](https://img.shields.io/badge/Token%20Savings-60--90%25-success)](.claude/skills/fetch-library-docs)
[![Architecture](https://img.shields.io/badge/Architecture-Shell%20Pipeline-orange)](https://www.anthropic.com/engineering/code-execution-with-mcp)

---

## What's New in v2.0.0

- **Auto-invocation**: Skill triggers automatically when implementing, debugging, installing, integrating, or upgrading
- **Content-type filtering**: Request exactly what you need (examples, api-ref, setup, troubleshooting, migration, patterns)
- **Call budget awareness**: Respects Context7's 3-call limit per question
- **Progressive disclosure**: Concise SKILL.md with detailed references

---

## The Problem

**Context Bloat:** Fetching documentation consumes excessive tokens. A simple query returns everything when you only need specific content.

**Reactive Approach:** Traditional skills wait for users to ask—but developers often guess at APIs first, then look up docs after errors.

---

## The Solution

**Proactive + Filtered Documentation Fetching:**

1. **Auto-detect** when docs are needed (implementing, debugging, installing)
2. **Fetch** from Context7 MCP (stays in subprocess)
3. **Filter** by content type (examples, api-ref, setup, etc.)
4. **Return** only what's needed (60-90% token savings)

**Core Principle:** "Fetch docs BEFORE writing code, not after guessing wrong."

---

## Token Savings by Content Type

| Content Type | What It Extracts | Typical Savings |
|--------------|------------------|-----------------|
| `examples` | Code blocks | 60-70% |
| `api-ref` | Signatures, parameters | 70-80% |
| `setup` | Terminal commands | 80-90% |
| `troubleshooting` | Fixes, workarounds | 60-70% |
| `migration` | Breaking changes, upgrades | 60-70% |
| `patterns` | Best practices | 60-70% |
| `all` | Everything (no filter) | 0% |

---

## Auto-Invocation

The skill **automatically triggers** based on context—no need to explicitly ask for docs:

| Context | Detection Signal | Content Type |
|---------|------------------|--------------|
| **Implementing** | Writing code using library API | `examples,api-ref` |
| **Debugging** | Error contains library name | `troubleshooting` |
| **Installing** | Adding new package | `setup` |
| **Integrating** | Connecting libraries | `examples,setup` |
| **Upgrading** | Version migration | `migration` |

---

## Quick Start

### 1. Get API Key (Required)

```bash
# Get free key at context7.com/dashboard
echo "CONTEXT7_API_KEY=ctx7sk_your_key" > ~/.context7.env
```

### 2. Usage

**Automatic (Recommended):**

Just work normally—the skill auto-invokes when needed:
- Writing React component → fetches hook examples
- Seeing Prisma error → fetches troubleshooting docs
- Adding Tailwind → fetches setup commands

**Explicit:**

```bash
# Code examples (default)
bash scripts/fetch-docs.sh --library react --topic useState --content-type examples

# API reference
bash scripts/fetch-docs.sh --library-id /vercel/next.js --topic routing --content-type api-ref

# Setup/installation
bash scripts/fetch-docs.sh --library tailwind --topic "installation next.js" --content-type setup

# Troubleshooting
bash scripts/fetch-docs.sh --library prisma --topic "unique constraint error" --content-type troubleshooting

# Version migration
bash scripts/fetch-docs.sh --library nextjs --topic "upgrade 14 to 15" --content-type migration
```

## Call Budget Management

**Context7 has a 3-call limit per question.** This skill is designed to respect that:

| Strategy | Calls Used | Remaining |
|----------|------------|-----------|
| `--library-id` (known ID) | 1 | 2 for retries |
| `--library` (needs resolution) | 2 | 1 for retry |

---

## Error Handling

| Error Code | Meaning | Action |
|------------|---------|--------|
| `[LIBRARY_NOT_FOUND]` | Name didn't resolve | Try spelling variations |
| `[LIBRARY_MISMATCH]` | Resolved to wrong library | Use --library-id directly |
| `[CONTENT_TYPE_EMPTY]` | Filter found no matching content | Auto-fallback to `all` (v2.0.1+) |
| `[EMPTY_RESULTS]` | No docs for topic | Broaden topic or use --content-type all |
| `[RATE_LIMIT_ERROR]` | Context7 limit hit | Check API key |

**Auto-Fallback (v2.0.1+):**
- When content-type filtering returns empty, skill automatically retries with `--content-type all`
- No extra API calls used (fallback uses same raw response)
- Verbose mode shows: `[INFO] No content found for 'migration', auto-retrying with 'all'...`

**Retry Logic:**
- Infrastructure failures (timeout, network): Auto-retries with 2s, 5s, 10s backoff
- API errors (rate limit, auth): No retry (would waste call budget)

---

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│ Auto-Detection: Implementing? Debugging? Installing?     │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────────┐
│ Decision Logic:                                          │
│ ├─ Identify library (from context/imports/errors)       │
│ ├─ Identify topic (from task/error message)             │
│ └─ Select content-type (from task type)                 │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────────┐
│ fetch-docs.sh --library X --topic Y --content-type Z    │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────────┐
│ Context7 MCP (subprocess - tokens stay here)            │
│ ├─ resolve-library-id (if needed)                       │
│ └─ query-docs                                           │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────────┐
│ Content-Type Filtering (shell pipeline - 0 LLM tokens)  │
│ ├─ filter-by-type.sh routes to extractor               │
│ └─ extract-*.sh filters by content type                │
└────────────────────┬─────────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────────┐
│ Return filtered content (60-90% token savings)          │
└──────────────────────────────────────────────────────────┘
```

---

## Documentation

- **[SKILL.md](.claude/skills/fetch-library-docs/SKILL.md)** - Core decision logic (~110 lines)
- **[references/library-ids.md](.claude/skills/fetch-library-docs/references/library-ids.md)** - Complete library ID list
- **[references/patterns.md](.claude/skills/fetch-library-docs/references/patterns.md)** - Usage patterns
- **[references/context7-tools.md](.claude/skills/fetch-library-docs/references/context7-tools.md)** - API details, errors, setup

---

## Bottom Line

| Aspect | Old Approach | fetch-library-docs v2 |
|--------|--------------|----------------------|
| **Triggering** | Wait for user to ask | Auto-detect context |
| **Filtering** | Generic extraction | Content-type specific |
| **Token Savings** | Fixed ~77% | 60-90% (varies by type) |
| **Call Budget** | Not managed | Respects 3-call limit |
| **Error Recovery** | Basic | Validation + exponential backoff |

**Use when:**
- Implementing features with external libraries
- Debugging library-specific errors
- Installing or configuring frameworks
- Integrating libraries together
- Upgrading between versions

---

*Built with the architecture from [Anthropic's "Code Execution with MCP" blog post](https://www.anthropic.com/engineering/code-execution-with-mcp)*
