---
name: graphql-api-builder
description: |
  Builds production-grade GraphQL APIs with proper schema design, resolvers, and security.
  This skill should be used when users want to create GraphQL APIs, design schemas,
  implement resolvers, or add GraphQL to existing applications.
---

# GraphQL API Builder

Build production-grade GraphQL APIs adapted to your stack and requirements.

## What This Skill Does

- Designs GraphQL schemas following best practices
- Implements resolvers with proper data loading
- Adds authentication and authorization
- Handles pagination, errors, and edge cases

## What This Skill Does NOT Do

- Build REST APIs (different paradigm)
- Manage GraphQL subscriptions infrastructure (WebSocket setup)
- Deploy or host the API

---

## Before Implementation

| Source | Gather |
|--------|--------|
| **Codebase** | Existing data models, auth setup, database schema |
| **Conversation** | Entities, relationships, operations needed |
| **Skill References** | Patterns from `references/` |
| **User Guidelines** | Naming conventions, auth requirements |

---

## Required Clarifications

| Clarification | Options | Why |
|---------------|---------|-----|
| Server library | Apollo, graphql-yoga, Mercurius | Affects setup code |
| Database | PostgreSQL, MongoDB, etc. | Affects data layer |
| Auth method | JWT, sessions, API keys | Affects context setup |
| Pagination style | Cursor (Relay) vs Offset | Affects schema design |

---

## Build Workflow

```
1. Schema Design → 2. Resolvers → 3. Data Layer → 4. Auth → 5. Validation
```

### 1. Schema Design

Design schema-first. See `references/schema-patterns.md`.

**Key decisions**:
- Identify entities and relationships
- Define queries (read) and mutations (write)
- Use input types for mutation arguments
- Add pagination to list queries

### 2. Resolvers

Implement resolvers for each field. See `references/resolver-patterns.md`.

**Key patterns**:
- Use DataLoader for N+1 prevention
- Return promises, let GraphQL handle async
- Throw errors with proper codes

### 3. Data Layer

Connect to database via ORM or query builder.

**Decision**: Use Prisma for type-safety, raw SQL for performance-critical.

### 4. Authentication

Add auth to context. See `references/security.md`.

```
Request → Extract token → Verify → Add user to context → Resolver checks
```

### 5. Validation

- Query depth limiting
- Rate limiting
- Input validation in mutations

---

## Output Specification

| Artifact | Contents |
|----------|----------|
| `schema.graphql` | Complete SDL with types, queries, mutations |
| `resolvers/` | Resolver files organized by type |
| `dataloaders/` | DataLoader instances for each entity |
| `context.js` | Context setup with auth |
| `server.js` | Server initialization |

---

## Pre-Delivery Checklist

- [ ] Schema follows naming conventions (PascalCase types, camelCase fields)
- [ ] All list queries have pagination
- [ ] DataLoader used for relationships
- [ ] Auth checked in sensitive resolvers
- [ ] Input types used for mutations
- [ ] Errors use proper GraphQL error format

---

## Reference Files

| File | Use When |
|------|----------|
| `references/schema-patterns.md` | Designing types, queries, mutations |
| `references/resolver-patterns.md` | Implementing resolvers, DataLoader |
| `references/security.md` | Auth, rate limiting, depth limiting |
| `references/anti-patterns.md` | Avoiding common mistakes |
