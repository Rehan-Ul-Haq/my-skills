# Security Patterns

## Authentication in Context

```javascript
const { ApolloServer } = require('@apollo/server');
const jwt = require('jsonwebtoken');

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

// Context function
const context = async ({ req }) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  let user = null;

  if (token) {
    try {
      user = jwt.verify(token, process.env.JWT_SECRET);
    } catch {
      // Invalid token - user stays null
    }
  }

  return { user, prisma, loaders: createLoaders(prisma) };
};
```

## Field-Level Authorization

```javascript
const resolvers = {
  User: {
    email: (user, _, { user: currentUser }) => {
      // Only show email to the user themselves or admins
      if (currentUser?.id === user.id || currentUser?.role === 'ADMIN') {
        return user.email;
      }
      return null;
    },
  },
};
```

## Query Depth Limiting

```javascript
const depthLimit = require('graphql-depth-limit');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [depthLimit(5)], // Max 5 levels deep
});
```

## Rate Limiting

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
});

app.use('/graphql', limiter);
```

## Input Validation

Validate in mutations before database operations:

```javascript
const { z } = require('zod');

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100).optional(),
});

const resolvers = {
  Mutation: {
    createUser: async (_, { input }, { prisma }) => {
      const validated = CreateUserSchema.parse(input);
      return prisma.user.create({ data: validated });
    },
  },
};
```
