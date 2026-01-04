---
name: openapi-generator
description: Guide for generating OpenAPI specifications. This skill should be used when users want to create OpenAPI/Swagger documentation for their APIs.
---

# OpenAPI Generator

Generate OpenAPI specifications from code.

## When to Use

Use when a user asks to:
- Generate OpenAPI spec
- Create Swagger documentation
- Document an API

## How to Generate

### Step 1: Analyze Endpoints

Examine the codebase for API routes and handlers.

### Step 2: Extract Information

For each endpoint, identify:
- HTTP method
- Path
- Parameters
- Request body
- Response format

### Step 3: Generate Spec

Create OpenAPI 3.0 YAML:

```yaml
openapi: 3.0.0
info:
  title: API Name
  version: 1.0.0
paths:
  /endpoint:
    get:
      summary: Description
      responses:
        '200':
          description: Success
```

### Step 4: Validate

Ensure spec is valid OpenAPI format.

## Output

- `openapi.yaml` - Complete OpenAPI specification
