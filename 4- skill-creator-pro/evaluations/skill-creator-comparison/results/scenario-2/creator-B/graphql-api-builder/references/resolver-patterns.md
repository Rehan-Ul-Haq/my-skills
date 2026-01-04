# Resolver Patterns

## Basic Resolver

```javascript
const resolvers = {
  Query: {
    user: (_, { id }, { prisma }) => prisma.user.findUnique({ where: { id } }),
  },
};
```

## DataLoader for N+1 Prevention

**Problem**: Fetching posts with authors makes N+1 queries.

**Solution**: Batch with DataLoader.

```javascript
// dataloaders/userLoader.js
const DataLoader = require('dataloader');

const createUserLoader = (prisma) => new DataLoader(async (ids) => {
  const users = await prisma.user.findMany({ where: { id: { in: ids } } });
  const userMap = new Map(users.map(u => [u.id, u]));
  return ids.map(id => userMap.get(id));
});

// In resolver
const resolvers = {
  Post: {
    author: (post, _, { loaders }) => loaders.user.load(post.authorId),
  },
};
```

## Pagination Resolver

```javascript
const resolvers = {
  Query: {
    users: async (_, { first = 10, after }, { prisma }) => {
      const cursor = after ? { id: after } : undefined;
      const users = await prisma.user.findMany({
        take: first + 1,
        skip: cursor ? 1 : 0,
        cursor,
        orderBy: { id: 'asc' },
      });

      const hasNextPage = users.length > first;
      const edges = users.slice(0, first).map(user => ({
        node: user,
        cursor: user.id,
      }));

      return {
        edges,
        pageInfo: {
          hasNextPage,
          endCursor: edges[edges.length - 1]?.cursor,
        },
      };
    },
  },
};
```

## Error Handling

```javascript
const { GraphQLError } = require('graphql');

const resolvers = {
  Mutation: {
    deleteUser: async (_, { id }, { prisma, user }) => {
      if (!user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      await prisma.user.delete({ where: { id } });
      return true;
    },
  },
};
```
