# Authentication for ChatGPT Apps

> **Official Source**: https://developers.openai.com/apps-sdk/build/auth
>
> For latest OAuth configuration, fetch from official documentation.

## When Authentication is Required

| Scenario | Auth Required |
|----------|---------------|
| Read-only anonymous content | No |
| User-specific data | **Yes** |
| Write/modify operations | **Yes** |
| Personalized experiences | **Yes** |

---

## OAuth 2.1 Flow Overview

ChatGPT Apps use OAuth 2.1 with MCP authorization specification.

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│    ChatGPT      │────▶│  Authorization   │────▶│   MCP Server    │
│    (Client)     │◀────│     Server       │◀────│(Resource Server)│
└─────────────────┘     └──────────────────┘     └─────────────────┘
        │                       │                        │
        │  1. Get metadata      │                        │
        │  2. Dynamic register  │                        │
        │  3. User auth+consent │                        │
        │  4. Exchange code     │                        │
        │  5. Access token      │────────────────────────▶
```

---

## Required Endpoints

### Protected Resource Metadata
Your MCP server must expose:
```
GET /.well-known/oauth-protected-resource
```

Response:
```json
{
  "resource": "https://your-mcp-server.com"
}
```

### OAuth Authorization Server Metadata
Your identity provider must expose:
```
GET /.well-known/oauth-authorization-server
```
Or OpenID Connect discovery document.

---

## PKCE Requirement (Mandatory)

```json
{
  "code_challenge_methods_supported": ["S256"]
}
```

**S256 is required** - ChatGPT will refuse to proceed without it.

---

## Token Verification (Server-Side)

Your MCP server must validate on every request:

```typescript
function verifyToken(token: string, requiredScopes: string[]) {
  // 1. Verify signature and issuer
  const decoded = jwt.verify(token, publicKey, { issuer: expectedIssuer });

  // 2. Check expiration
  if (decoded.exp < Date.now() / 1000) {
    throw new UnauthorizedError('Token expired');
  }

  // 3. Verify audience
  if (decoded.aud !== 'https://your-mcp-server.com') {
    throw new UnauthorizedError('Invalid audience');
  }

  // 4. Check scopes
  const tokenScopes = decoded.scope?.split(' ') || [];
  if (!requiredScopes.every(s => tokenScopes.includes(s))) {
    throw new ForbiddenError('Insufficient scope');
  }

  return decoded;
}
```

### On Failure
Return `401 Unauthorized` with `WWW-Authenticate` header:
```typescript
res.setHeader('WWW-Authenticate', 'Bearer error="invalid_token"');
res.status(401).json({ error: 'Unauthorized' });
```

---

## Triggering Auth UI in ChatGPT

For ChatGPT to show OAuth linking:

1. **Publish metadata** at well-known URL
2. **Declare security per tool**:
```json
{
  "securitySchemes": {
    "oauth2": {
      "type": "oauth2",
      "scopes": ["read:profile", "write:data"]
    }
  }
}
```

3. **Return auth errors with metadata**:
```typescript
return {
  content: [{ type: 'text', text: 'Please sign in to continue' }],
  _meta: {
    "mcp/www_authenticate": {
      "error": "unauthorized",
      "realm": "your-app"
    }
  }
};
```

---

## Recommended Identity Providers

| Provider | MCP Support |
|----------|-------------|
| Auth0 | Has MCP-specific guide |
| Stytch | Has MCP-specific guide |
| Okta | Standard OAuth 2.1 |
| Cognito | Standard OAuth 2.1 |
| Custom | Must support discovery + PKCE |

---

## Testing Strategy

1. **Development**: Use dev tenants with short-lived tokens
2. **Staging**: Gate access to trusted testers
3. **Production**: Full OAuth flow with proper token lifetimes

Use **MCP Inspector** to debug OAuth flows before ChatGPT integration.

---

## Widget Considerations

For widgets with authentication:

```typescript
// Check if user is authenticated
const isAuthenticated = window.openai?.toolOutput?.authenticated;

if (!isAuthenticated) {
  return <LoginPrompt onLogin={() => {
    window.openai?.sendFollowUpMessage({ prompt: 'Sign me in' });
  }} />;
}

// Render authenticated content
return <AuthenticatedWidget data={data} />;
```

**Note**: The widget itself doesn't handle OAuth - the MCP server does. Widget just reacts to auth state in toolOutput.
