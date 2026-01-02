---
name: openapi-generator
description: |
  Generates OpenAPI 3.x specifications from existing code or API designs.
  This skill should be used when users want to document APIs, generate
  OpenAPI specs from Flask/FastAPI/Express routes, or create API contracts.
---

# OpenAPI Generator

Generate standards-compliant OpenAPI specifications.

## What This Skill Does

- Analyzes code to extract API structure
- Generates OpenAPI 3.0/3.1 compliant specs
- Documents parameters, schemas, responses
- Validates output against OpenAPI spec

## What This Skill Does NOT Do

- Generate code FROM OpenAPI (use openapi-generator-cli)
- Create API mocks
- Deploy documentation (use Swagger UI, Redoc)

---

## Before Implementation

| Source | Gather |
|--------|--------|
| **Codebase** | Route definitions, models, decorators |
| **Conversation** | API description, auth method, versioning |
| **Skill References** | OpenAPI patterns from `references/` |

---

## Required Clarifications

| Clarification | Why |
|---------------|-----|
| Framework | Flask/FastAPI/Express affects extraction |
| OpenAPI version | 3.0 vs 3.1 differences |
| Output format | YAML vs JSON |
| Auth method | Affects security schemes |

---

## Generation Workflow

```
1. Discover Routes → 2. Extract Schemas → 3. Map to OpenAPI → 4. Validate
```

### 1. Discover Routes

| Framework | Look For |
|-----------|----------|
| Flask | `@app.route`, `@blueprint.route` |
| FastAPI | `@app.get/post/etc`, Pydantic models |
| Express | `app.get/post`, `router.*` |

### 2. Extract Schemas

- Request bodies from validation schemas
- Response types from return statements/models
- Path/query params from decorators

### 3. Map to OpenAPI

See `references/openapi-patterns.md` for structure.

**Key components**:
- `info`: API metadata
- `paths`: Endpoints with operations
- `components/schemas`: Reusable models
- `security`: Auth configuration

### 4. Validate

Check against OpenAPI spec:
- Required fields present
- $ref references resolve
- Valid HTTP methods
- Proper schema types

---

## Pre-Delivery Checklist

- [ ] All routes documented
- [ ] Schemas extracted to components
- [ ] Examples provided for complex types
- [ ] Security schemes defined
- [ ] Validates with OpenAPI validator

---

## Reference Files

| File | Use When |
|------|----------|
| `references/openapi-patterns.md` | Structuring the spec |
| `references/schema-mapping.md` | Type mappings by framework |
