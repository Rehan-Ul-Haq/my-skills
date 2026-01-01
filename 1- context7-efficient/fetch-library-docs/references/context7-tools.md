# Context7 MCP Tools

*2 tools available*

## `resolve-library-id`

Resolves a package/product name to a Context7-compatible library ID and returns a list of matching libraries.

You MUST call this function before 'query-docs' to obtain a valid Context7-compatible library ID UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.

### Selection Process

1. Analyze the query to understand what library/package the user is looking for
2. Return the most relevant match based on:
   - Name similarity to the query (exact matches prioritized)
   - Description relevance to the query's intent
   - Documentation coverage (prioritize libraries with higher Code Snippet counts)
   - Source reputation (consider libraries with High or Medium reputation more authoritative)
   - Benchmark Score: Quality indicator (100 is the highest score)

### Parameters

- **`query`** (`string`) *(required)*: The user's original question or task. Used to rank library results by relevance.

- **`libraryName`** (`string`) *(required)*: Library name to search for and retrieve a Context7-compatible library ID.

### Response Format

Returns a list of matching libraries with:
- Title
- Context7-compatible library ID (e.g., `/reactjs/react.dev`)
- Code Snippets count
- Source Reputation (High/Medium/Low)
- Benchmark Score
- Description

### Examples

```bash
# Find React library
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t resolve-library-id \
  -p '{"query": "useState hooks", "libraryName": "react"}'

# Find Next.js library
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t resolve-library-id \
  -p '{"query": "routing", "libraryName": "next.js"}'
```

<details>
<summary>Full Schema</summary>

```json
{
  "type": "object",
  "properties": {
    "query": {
      "type": "string",
      "description": "The user's original question or task. Used to rank library results by relevance."
    },
    "libraryName": {
      "type": "string",
      "description": "Library name to search for and retrieve a Context7-compatible library ID."
    }
  },
  "required": ["query", "libraryName"]
}
```
</details>

## `query-docs`

Retrieves and queries up-to-date documentation and code examples from Context7 for any programming library or framework.

You must call 'resolve-library-id' first to obtain the exact Context7-compatible library ID required to use this tool, UNLESS the user explicitly provides a library ID in the format '/org/project' or '/org/project/version' in their query.

### Parameters

- **`libraryId`** (`string`) *(required)*: Exact Context7-compatible library ID (e.g., '/mongodb/docs', '/vercel/next.js') retrieved from 'resolve-library-id' or directly from user query.

- **`query`** (`string`) *(required)*: The question or task you need help with. Be specific and include relevant details. Good: 'How to set up authentication with JWT in Express.js'. Bad: 'auth'.

### Examples

```bash
# Get React hooks documentation
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t query-docs \
  -p '{"libraryId": "/reactjs/react.dev", "query": "useState hooks examples"}'

# Get Next.js routing information
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t query-docs \
  -p '{"libraryId": "/vercel/next.js", "query": "how does routing work"}'

# Get MongoDB aggregation examples
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t query-docs \
  -p '{"libraryId": "/mongodb/docs", "query": "aggregation pipeline examples"}'
```

<details>
<summary>Full Schema</summary>

```json
{
  "type": "object",
  "properties": {
    "libraryId": {
      "type": "string",
      "description": "Exact Context7-compatible library ID (e.g., '/mongodb/docs', '/vercel/next.js') retrieved from 'resolve-library-id' or directly from user query."
    },
    "query": {
      "type": "string",
      "description": "The question or task you need help with. Be specific and include relevant details."
    }
  },
  "required": ["libraryId", "query"]
}
```
</details>

## Usage Patterns

### Pattern 1: Unknown Library

When you don't know the exact library ID:

```bash
# Step 1: Resolve library name
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t resolve-library-id -p '{"query": "middleware", "libraryName": "express"}'

# Step 2: Use returned ID to fetch docs
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t query-docs \
  -p '{"libraryId": "/expressjs/express", "query": "how to use middleware"}'
```

### Pattern 2: Known Library ID

When you know the library ID:

```bash
# Direct fetch (skip resolve step)
python scripts/mcp-client.py call -s "npx -y @upstash/context7-mcp" \
  -t query-docs \
  -p '{"libraryId": "/reactjs/react.dev", "query": "useState examples"}'
```

### Pattern 3: Using the Shell Pipeline (Recommended)

For token-efficient documentation fetching:

```bash
# Automatic resolution + filtering (77% token savings)
bash scripts/fetch-docs.sh --library react --topic useState

# With verbose output
bash scripts/fetch-docs.sh --library react --topic useState --verbose
```

## Common Library IDs

Quick reference for popular libraries:

| Library | Context7 ID |
|---------|-------------|
| React | `/reactjs/react.dev` or `/websites/react_dev` |
| Next.js | `/vercel/next.js` |
| Express | `/expressjs/express` |
| MongoDB | `/mongodb/docs` |
| Prisma | `/prisma/docs` |
| Vue | `/vuejs/docs` |
| Svelte | `/sveltejs/svelte.dev` |
| FastAPI | `/tiangolo/fastapi` |
| Django | `/django/docs` |

## Tips

1. **Library Resolution**: Always use `resolve-library-id` first unless you have the exact ID
2. **Specific Queries**: More specific queries yield better results
3. **Use Shell Pipeline**: `fetch-docs.sh` provides 77% token savings through filtering
4. **Fallback**: If no results, try broader queries or different library name variations
