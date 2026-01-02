# Anti-Patterns to Avoid

## N+1 Queries

**Problem**: Fetching a list of posts, then making a separate query for each author.

```graphql
# This query causes N+1 if not using DataLoader
{
  posts {
    title
    author { name }  # One query per post!
  }
}
```

**Solution**: Use DataLoader to batch author fetches.

---

## Unbounded Lists

**Problem**: Allowing unlimited results.

```graphql
# Bad: No limit
type Query {
  posts: [Post!]!
}
```

**Solution**: Always require pagination.

```graphql
# Good: Paginated
type Query {
  posts(first: Int!, after: String): PostConnection!
}
```

---

## Deeply Nested Queries

**Problem**: Allowing infinite nesting.

```graphql
# Could be exploited
{
  user {
    posts {
      comments {
        author {
          posts {
            comments { ... }
          }
        }
      }
    }
  }
}
```

**Solution**: Use query depth limiting.

---

## Exposing Internal IDs

**Problem**: Using database IDs directly.

**Solution**: Use opaque, base64-encoded IDs:

```javascript
const toGlobalId = (type, id) => Buffer.from(`${type}:${id}`).toString('base64');
const fromGlobalId = (globalId) => {
  const [type, id] = Buffer.from(globalId, 'base64').toString().split(':');
  return { type, id };
};
```

---

## Missing Error Handling

**Problem**: Letting database errors bubble up.

**Solution**: Catch and return proper GraphQL errors:

```javascript
try {
  return await prisma.user.create({ data: input });
} catch (e) {
  if (e.code === 'P2002') {
    throw new GraphQLError('Email already exists', {
      extensions: { code: 'BAD_USER_INPUT' },
    });
  }
  throw e;
}
```
