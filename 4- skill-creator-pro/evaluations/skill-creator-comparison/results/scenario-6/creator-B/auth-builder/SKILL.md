---
name: auth-builder
description: |
  Implements secure authentication for web applications.
  This skill should be used when users want to add login/signup,
  protect routes, or integrate auth providers into their applications.
---

# Auth Builder

Implement secure authentication adapted to framework and requirements.

## What This Skill Does

- Implements authentication flows (signup, login, logout, refresh)
- Configures session or token-based auth
- Protects routes with middleware
- Integrates OAuth providers (optional)

## What This Skill Does NOT Do

- Authorization (role-based access control) - separate concern
- Identity management (user profiles, settings)
- Multi-factor authentication setup
- Security auditing

---

## Before Implementation

| Source | Gather |
|--------|--------|
| **Codebase** | Framework, existing user model, database |
| **Conversation** | Auth method, token storage, providers needed |
| **Skill References** | Security patterns from `references/` |

---

## Required Clarifications

| Clarification | Options | Security Implications |
|---------------|---------|----------------------|
| Auth method | JWT / Session / OAuth | Token storage, CSRF needs |
| Token storage | Cookie / localStorage | XSS vs CSRF tradeoffs |
| Refresh strategy | Refresh tokens / Sliding session | Token lifetime |
| Password requirements | Min length, complexity | Brute force resistance |

---

## Implementation Workflow

```
1. User Model → 2. Password Handling → 3. Auth Routes → 4. Middleware → 5. Token Management
```

### 1. User Model

Store only what's needed for auth:
- Email (unique, indexed)
- Password hash (NEVER plaintext)
- Created/updated timestamps

### 2. Password Handling

See `references/security-patterns.md`.

**Requirements**:
- Use bcrypt/argon2 (NOT MD5/SHA1)
- Cost factor ≥ 10
- Never log passwords

### 3. Auth Routes

| Route | Purpose | Returns |
|-------|---------|---------|
| POST /signup | Create account | User + tokens |
| POST /login | Authenticate | Tokens |
| POST /logout | Invalidate session | Success |
| POST /refresh | Get new access token | New tokens |

### 4. Middleware

Protect routes requiring authentication.

### 5. Token Management

**JWT Strategy**:
- Short-lived access token (15 min)
- Long-lived refresh token (7 days)
- Store refresh token securely (httpOnly cookie)

---

## Security Checklist

- [ ] Passwords hashed with bcrypt/argon2
- [ ] Tokens have expiration
- [ ] Refresh tokens stored in httpOnly cookies
- [ ] CSRF protection if using cookies
- [ ] Rate limiting on auth endpoints
- [ ] No sensitive data in JWT payload
- [ ] Secure password reset flow

---

## Reference Files

| File | Use When |
|------|----------|
| `references/security-patterns.md` | Password hashing, token security |
| `references/oauth-integration.md` | Adding social login |
| `references/common-vulnerabilities.md` | Avoiding auth pitfalls |
