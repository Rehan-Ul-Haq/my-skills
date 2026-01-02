# Creator B Process Log - Scenario 2

## User Prompt
"Create a skill for building GraphQL APIs"

---

## Phase 1: Skill Metadata

**Questions Asked**:
1. "What type of skill?" → **Builder** (creates API artifacts)
2. "What domain?" → **GraphQL API development**

---

## Phase 2: Domain Discovery (Automatic)

**Research conducted**:

| Discover | Findings |
|----------|----------|
| Core concepts | Schema (SDL), Types, Resolvers, Queries, Mutations, Subscriptions |
| Standards | GraphQL spec, SDL syntax, naming conventions |
| Best practices | Schema-first design, DataLoader for N+1, input types, pagination |
| Anti-patterns | N+1 queries, over-fetching, deeply nested queries, unbounded lists |
| Security | Query depth limiting, rate limiting, auth in context, field-level auth |
| Ecosystem | Apollo, graphql-yoga, Prisma, DataLoader, GraphQL Shield |

**Sources**: graphql.org, Apollo docs, Prisma docs, community best practices

---

## Phase 3: Knowledge Sufficiency Check

- [x] Core concepts understood
- [x] Best practices identified (schema-first, DataLoader, pagination)
- [x] Anti-patterns known (N+1, nested queries)
- [x] Security considerations covered (depth limiting, auth)
- [x] Official sources found

**Result**: Sufficient - proceed to requirements

---

## Phase 4: User Requirements

**Questions Asked**:
3. "What's YOUR use case?" → Blog API (posts, authors, comments)
4. "What's YOUR tech stack?" → Node.js, Apollo Server, PostgreSQL
5. "Existing resources?" → None
6. "Constraints?" → JWT auth, need pagination

---

## Phase 5: Analyze Knowledge

**Procedural (HOW)**:
- Schema design workflow
- Resolver implementation pattern
- Auth integration
- Database connection

**Domain (WHAT)**:
- GraphQL SDL syntax
- Type definitions
- Pagination patterns (cursor vs offset)
- N+1 prevention with DataLoader
- Error handling

---

## Phase 6: Embed Knowledge

Put in `references/`:
- `references/schema-patterns.md` - SDL patterns, naming conventions
- `references/resolver-patterns.md` - Resolver implementation, DataLoader
- `references/security.md` - Auth, rate limiting, query depth
- `references/anti-patterns.md` - Common mistakes to avoid

---

## Metrics

**Questions asked**: 5
**Domain research**: Comprehensive automatic discovery
**Focus**: Reusable patterns, embedded expertise, handles variations
