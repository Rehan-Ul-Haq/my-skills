---
name: graphql-api-builder
description: Guide for building GraphQL APIs. This skill should be used when users want to create a GraphQL API, design schemas, or implement resolvers.
---

# GraphQL API Builder

This skill helps build GraphQL APIs.

## When to Use

Use this skill when a user asks to:
- Create a GraphQL API
- Design a GraphQL schema
- Implement resolvers

## How to Build a GraphQL API

### Step 1: Design the Schema

Define types, queries, and mutations. Use `assets/schema-template.graphql` as a starting point.

Key elements:
- Types define data structures
- Queries fetch data
- Mutations modify data

### Step 2: Implement Resolvers

Create resolver functions for each query and mutation. Use `assets/resolver-template.js` as a starting point.

### Step 3: Set Up the Server

For Apollo Server:

```javascript
const { ApolloServer } = require('apollo-server');

const server = new ApolloServer({ typeDefs, resolvers });

server.listen().then(({ url }) => {
  console.log(`Server ready at ${url}`);
});
```

### Step 4: Add Authentication

Implement JWT authentication in the context:

```javascript
const server = new ApolloServer({
  typeDefs,
  resolvers,
  context: ({ req }) => {
    const token = req.headers.authorization || '';
    const user = verifyToken(token);
    return { user };
  }
});
```

### Step 5: Connect Database

Use an ORM like Prisma or Sequelize to connect to PostgreSQL.

## Output

Generate the following files:
- `schema.graphql` - GraphQL schema
- `resolvers.js` - Resolver implementations
- `server.js` - Server setup
