---
name: auth-builder
description: Guide for adding authentication to web applications. This skill should be used when users want to implement login, signup, or access control.
---

# Auth Builder

Add authentication to web applications.

## When to Use

Use when a user asks to:
- Add login/signup
- Implement authentication
- Secure an application

## How to Add Authentication

### Step 1: Choose Method

- JWT tokens
- Session-based
- OAuth providers

### Step 2: Create User Model

```javascript
const userSchema = {
  email: String,
  password: String, // hashed
};
```

### Step 3: Implement Signup

Hash password and store user.

### Step 4: Implement Login

Verify credentials and issue token/session.

### Step 5: Protect Routes

Add middleware to check authentication.

```javascript
const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization;
  if (!token) return res.status(401).send('Unauthorized');
  // verify token
  next();
};
```

## Output

- User model
- Auth routes (signup, login, logout)
- Auth middleware
