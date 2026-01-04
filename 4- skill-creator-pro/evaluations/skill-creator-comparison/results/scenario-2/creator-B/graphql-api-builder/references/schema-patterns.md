# Schema Patterns

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Types | PascalCase | `User`, `BlogPost` |
| Fields | camelCase | `firstName`, `createdAt` |
| Enums | SCREAMING_SNAKE | `ACTIVE`, `PENDING` |
| Input types | PascalCase + Input | `CreateUserInput` |

## Type Definitions

```graphql
type User {
  id: ID!
  email: String!
  name: String
  posts: [Post!]!      # Non-null array of non-null items
  createdAt: DateTime!
}
```

## Queries

```graphql
type Query {
  user(id: ID!): User
  users(first: Int, after: String): UserConnection!  # Paginated
}
```

## Mutations

```graphql
type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
}

input CreateUserInput {
  email: String!
  name: String
}
```

## Pagination (Cursor-based)

```graphql
type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
}

type UserEdge {
  node: User!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  endCursor: String
}
```

## Relationships

```graphql
type Post {
  id: ID!
  title: String!
  author: User!        # Resolved via DataLoader
  comments: [Comment!]!
}
```
