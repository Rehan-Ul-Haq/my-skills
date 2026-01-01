# fetch-library-docs v2.0.0 Test Scenarios

## Test Categories

1. **Content-Type Filtering** - All 8 content types
2. **Auto-Invocation Detection** - Context-based triggering
3. **Error Recovery** - Validation and retry logic
4. **Token Efficiency** - Skill vs Direct MCP comparison
5. **Edge Cases** - Unusual inputs and boundary conditions

---

## Test Suite 1: Content-Type Filtering

### Test 1.1: Examples Only
```bash
bash scripts/fetch-docs.sh --library react --topic useState --content-type examples --verbose
```
**Expected**: Code blocks only, 60-70% token savings

### Test 1.2: API Reference Only
```bash
bash scripts/fetch-docs.sh --library-id /vercel/next.js --topic "app router" --content-type api-ref --verbose
```
**Expected**: Function signatures, parameters, 70-80% savings

### Test 1.3: Setup/Installation
```bash
bash scripts/fetch-docs.sh --library tailwind --topic "installation next.js" --content-type setup --verbose
```
**Expected**: Terminal commands, config snippets, 80-90% savings

### Test 1.4: Troubleshooting
```bash
bash scripts/fetch-docs.sh --library-id /prisma/docs --topic "unique constraint error" --content-type troubleshooting --verbose
```
**Expected**: Error fixes, workarounds

### Test 1.5: Migration
```bash
bash scripts/fetch-docs.sh --library nextjs --topic "upgrade 14 to 15" --content-type migration --verbose
```
**Expected**: Breaking changes, before/after code

### Test 1.6: Concepts
```bash
bash scripts/fetch-docs.sh --library-id /reactjs/react.dev --topic "server components" --content-type concepts --verbose
```
**Expected**: Explanatory prose, no code

### Test 1.7: Patterns/Best Practices
```bash
bash scripts/fetch-docs.sh --library-id /vercel/next.js --topic "data fetching" --content-type patterns --verbose
```
**Expected**: Recommendations, best practices

### Test 1.8: Combined Types
```bash
bash scripts/fetch-docs.sh --library react --topic useEffect --content-type examples,api-ref --verbose
```
**Expected**: Both code examples AND signatures

### Test 1.9: All (No Filtering)
```bash
bash scripts/fetch-docs.sh --library fastapi --topic "dependency injection" --content-type all --verbose
```
**Expected**: Full output, 0% savings

---

## Test Suite 2: Error Recovery

### Test 2.1: Library Not Found
```bash
bash scripts/fetch-docs.sh --library "nonexistent-library-xyz" --topic test --verbose
```
**Expected**: `[LIBRARY_NOT_FOUND]` with suggestions

### Test 2.2: Library Mismatch Detection
```bash
bash scripts/fetch-docs.sh --library "anthropic" --topic "api" --verbose
```
**Expected**: `[LIBRARY_MISMATCH]` if resolves to wrong library

### Test 2.3: Invalid Library ID Format
```bash
bash scripts/fetch-docs.sh --library-id "react" --topic hooks --verbose
```
**Expected**: `[INVALID_LIBRARY_ID]` (missing /org/project format)

### Test 2.4: Valid Library ID (Direct)
```bash
bash scripts/fetch-docs.sh --library-id /reactjs/react.dev --topic useState --verbose
```
**Expected**: Success, "saves 1 API call" message

### Test 2.5: Empty Results
```bash
bash scripts/fetch-docs.sh --library react --topic "xyznonexistent123" --verbose
```
**Expected**: `[EMPTY_RESULTS]` or fallback content

---

## Test Suite 3: Token Efficiency Comparison

### Methodology
For each test, compare:
1. **Direct MCP call** (via mcp-client.py)
2. **Skill with content-type filtering**

Measure:
- Raw token count (words × 1.3)
- Filtered token count
- Token savings percentage
- Content quality (relevant vs noise)

### Test 3.1: React useState (Simple Query)

**Direct MCP:**
```bash
python scripts/mcp-client.py call \
  -s "npx -y @upstash/context7-mcp@latest" \
  -t query-docs \
  -p '{"libraryId": "/reactjs/react.dev", "query": "useState examples"}'
```

**Skill (examples only):**
```bash
bash scripts/fetch-docs.sh --library-id /reactjs/react.dev --topic useState --content-type examples --verbose
```

### Test 3.2: Next.js Routing (Medium Complexity)

**Direct MCP:**
```bash
python scripts/mcp-client.py call \
  -s "npx -y @upstash/context7-mcp@latest" \
  -t query-docs \
  -p '{"libraryId": "/vercel/next.js", "query": "app router routing"}'
```

**Skill (examples + api-ref):**
```bash
bash scripts/fetch-docs.sh --library-id /vercel/next.js --topic "app router routing" --content-type examples,api-ref --verbose
```

### Test 3.3: Prisma Errors (Troubleshooting)

**Direct MCP:**
```bash
python scripts/mcp-client.py call \
  -s "npx -y @upstash/context7-mcp@latest" \
  -t query-docs \
  -p '{"libraryId": "/prisma/docs", "query": "PrismaClientKnownRequestError unique constraint"}'
```

**Skill (troubleshooting):**
```bash
bash scripts/fetch-docs.sh --library-id /prisma/docs --topic "unique constraint error" --content-type troubleshooting --verbose
```

### Test 3.4: FastAPI Setup (Installation)

**Direct MCP:**
```bash
python scripts/mcp-client.py call \
  -s "npx -y @upstash/context7-mcp@latest" \
  -t query-docs \
  -p '{"libraryId": "/tiangolo/fastapi", "query": "getting started installation"}'
```

**Skill (setup):**
```bash
bash scripts/fetch-docs.sh --library-id /tiangolo/fastapi --topic "getting started" --content-type setup --verbose
```

---

## Test Suite 4: Call Budget Management

### Test 4.1: Using --library (2 calls)
```bash
bash scripts/fetch-docs.sh --library react --topic hooks --verbose
```
**Expected**: Resolution call + query call = 2 total

### Test 4.2: Using --library-id (1 call)
```bash
bash scripts/fetch-docs.sh --library-id /reactjs/react.dev --topic hooks --verbose
```
**Expected**: Query call only = 1 total, "saves 1 API call"

---

## Test Suite 5: Edge Cases

### Test 5.1: Special Characters in Topic
```bash
bash scripts/fetch-docs.sh --library react --topic "useState<T>" --content-type examples --verbose
```

### Test 5.2: Very Long Topic
```bash
bash scripts/fetch-docs.sh --library nextjs --topic "how to implement server-side rendering with dynamic routes and middleware authentication" --content-type examples --verbose
```

### Test 5.3: Empty Topic
```bash
bash scripts/fetch-docs.sh --library react --topic "" --verbose
```

### Test 5.4: Multiple Content Types (Max)
```bash
bash scripts/fetch-docs.sh --library react --topic hooks --content-type examples,api-ref,concepts,patterns --verbose
```

---

## Metrics to Collect

| Metric | Description |
|--------|-------------|
| Raw Tokens | Word count × 1.3 from direct MCP |
| Filtered Tokens | Word count × 1.3 from skill output |
| Token Savings % | (Raw - Filtered) / Raw × 100 |
| Quality Score | 1-5 rating of content relevance |
| Noise Ratio | % of irrelevant content |
| Response Time | Seconds to complete |
| API Calls Used | 1 or 2 depending on strategy |

---

## Success Criteria

| Category | Target |
|----------|--------|
| Token Savings (examples) | 60-70% |
| Token Savings (api-ref) | 70-80% |
| Token Savings (setup) | 80-90% |
| Quality Score | ≥ 4/5 |
| Error Recovery | 100% graceful |
| Call Budget | ≤ 2 per question |
