---
name: context7-efficient
description: Token-efficient library documentation fetcher using Context7 REST API with 86.8% token savings through intelligent shell pipeline filtering. Fetches code examples, API references, and best practices for JavaScript, Python, Go, Rust, and other libraries. Use when users ask about library documentation, need code examples, want API usage patterns, are learning a new framework, need syntax reference, or troubleshooting with library-specific information. Triggers include questions like "Show me React hooks", "How do I use Prisma", "What's the Next.js routing syntax", or any request for library/framework documentation.
---

# Context7 Efficient Documentation Fetcher

Fetch library documentation with automatic 86.8% token reduction via HTTP API + shell pipeline.

## Setup

### 1. Get API Key

1. Visit [context7.com/dashboard](https://context7.com/dashboard)
2. Sign up or log in
3. Copy your API key

### 2. Configure Environment

Create `.env` file in the skill directory (copy from `.env.example`):

```bash
cp .env.example .env
```

Edit `.env` and add your API key:

```env
CONTEXT7_API_KEY=your_actual_api_key_here
```

Or set as environment variable:

```bash
export CONTEXT7_API_KEY=your_api_key_here
```

## Quick Start

**Always use the token-efficient shell pipeline:**

```bash
# Automatic library resolution + filtering
bash scripts/fetch-docs.sh --library <library-name> --topic <topic>

# Examples:
bash scripts/fetch-docs.sh --library react --topic useState
bash scripts/fetch-docs.sh --library nextjs --topic routing
bash scripts/fetch-docs.sh --library prisma --topic queries
```

**Result:** Returns ~350 tokens instead of ~2,600 tokens (86.8% savings).

## Standard Workflow

For any documentation request, follow this workflow:

### 1. Identify Library and Topic

Extract from user query:
- **Library:** React, Next.js, Prisma, Express, etc.
- **Topic:** Specific feature (hooks, routing, queries, etc.)

### 2. Fetch with Shell Pipeline

```bash
bash scripts/fetch-docs.sh --library <library> --topic <topic> --verbose
```

The `--verbose` flag shows token savings statistics.

### 3. Use Filtered Output

The script automatically:
- Fetches full documentation via HTTP API (stays in subprocess)
- Filters to code examples + API signatures + key notes
- Returns only essential content (~350 tokens to Claude)

## Parameters

### Basic Usage

```bash
bash scripts/fetch-docs.sh [OPTIONS]
```

**Required (pick one):**
- `--library <name>` - Library name (e.g., "react", "nextjs")
- `--library-id <id>` - Direct Context7 ID (faster, skips resolution)

**Also required:**
- `--topic <topic>` - Specific feature to focus on

**Optional:**
- `--mode <code|info>` - code for examples (default), info for concepts
- `--tokens <num>` - Max tokens from API (default: 5000)
- `--verbose` - Show token savings statistics

### Mode Selection

**Code Mode (default):** Returns code examples + API signatures
```bash
--mode code
```

**Info Mode:** Returns conceptual explanations + fewer examples
```bash
--mode info
```

## Direct Python API

For advanced use, call the HTTP API directly:

```bash
# Resolve library name to ID
python3 scripts/context7-api.py resolve react

# Query documentation by library ID
python3 scripts/context7-api.py query /vercel/next.js routing --tokens 3000

# Fetch (resolve + query in one step)
python3 scripts/context7-api.py fetch prisma queries --tokens 5000
```

## Common Library IDs

Use `--library-id` for faster lookup (skips resolution):

```
React:      /reactjs/react.dev
Next.js:    /vercel/next.js
Express:    /expressjs/express
Prisma:     /prisma/docs
MongoDB:    /mongodb/docs
Fastify:    /fastify/fastify
NestJS:     /nestjs/docs
Vue.js:     /vuejs/docs
Svelte:     /sveltejs/site
TypeScript: /microsoft/typescript
```

## Workflow Patterns

### Pattern 1: Quick Code Examples

User asks: "Show me React useState examples"

```bash
bash scripts/fetch-docs.sh --library react --topic useState --verbose
```

Returns: 5 code examples + API signatures + notes (~350 tokens)

### Pattern 2: Learning New Library

User asks: "How do I get started with Prisma?"

```bash
# Step 1: Get overview
bash scripts/fetch-docs.sh --library prisma --topic "getting started" --mode info

# Step 2: Get code examples
bash scripts/fetch-docs.sh --library prisma --topic queries --mode code
```

### Pattern 3: Specific Feature Lookup

User asks: "How does Next.js routing work?"

```bash
bash scripts/fetch-docs.sh --library-id /vercel/next.js --topic routing
```

Using `--library-id` is faster when you know the exact ID.

### Pattern 4: Deep Exploration

User needs comprehensive information:

```bash
# Get more tokens for detailed response
bash scripts/fetch-docs.sh --library react --topic hooks --tokens 8000

# Get conceptual overview
bash scripts/fetch-docs.sh --library react --topic hooks --mode info
```

## Token Efficiency

**How it works:**

1. `fetch-docs.sh` calls `context7-api.py` (HTTP API with Bearer auth)
2. Full response (~2,600 tokens) stays in subprocess memory
3. Shell filters (awk/grep/sed) extract essentials (0 LLM tokens used)
4. Returns filtered output (~350 tokens) to Claude

**Savings:**
- Direct API: ~2,600 tokens per query
- This approach: ~350 tokens per query
- **86.8% reduction**

## HTTP API Reference

### Endpoints

```
Base URL: https://context7.com/api/v2

GET /libraries/search?query=<name>&limit=5
GET /docs/code/{org}/{project}?topic=<topic>&tokens=<num>
```

### Authentication

All requests require Bearer token:
```
Authorization: Bearer <CONTEXT7_API_KEY>
```

### Python API Client

```python
# scripts/context7-api.py provides three commands:

# 1. Resolve library name to ID
python3 context7-api.py resolve <library-name>

# 2. Query docs by library ID
python3 context7-api.py query <library-id> <topic> [--tokens N] [--mode full|code|json]

# 3. Fetch (resolve + query combined)
python3 context7-api.py fetch <library-name> <topic> [--tokens N]
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| API key not set | Set `CONTEXT7_API_KEY` in `.env` or environment |
| 401 Unauthorized | Check API key is valid at context7.com/dashboard |
| 429 Rate Limited | Wait and retry, or reduce request frequency |
| Library not found | Try name variations or use broader search term |
| No results | Use `--mode info` or broader topic |
| Want full context | Use `--mode info` for explanations |

## Implementation Notes

**Components:**
- `context7-api.py` - HTTP API client (core)
- `fetch-docs.sh` - **Main orchestrator (ALWAYS USE THIS)**
- `extract-code-blocks.sh` - Code example filter (awk)
- `extract-signatures.sh` - API signature filter (awk)
- `extract-notes.sh` - Important notes filter (grep)

**Architecture:**
HTTP API fetches documentation, shell pipeline processes in subprocess, keeping full response out of Claude's context. Only filtered essentials enter the LLM context, achieving 86.8% token savings with 100% functionality preserved.

**Advantages over MCP approach:**
- No npx/Node.js dependency
- Simpler authentication (API key)
- Direct HTTP calls (faster)
- Works in any environment with Python 3
- Easy to debug and test
