// Scenario B: Prisma Unique Constraint Violation
// This file simulates a database error developers struggle with

import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function createUser(email: string, name: string) {
  // ❌ ERROR: Unique constraint failed on the fields: (`email`)
  // PrismaClientKnownRequestError:
  //   Invalid `prisma.user.create()` invocation:
  //   Unique constraint failed on the fields: (`email`)

  const user = await prisma.user.create({
    data: {
      email,  // This email already exists in the database
      name,
    },
  })

  return user
}

// Developer doesn't know how to handle this error properly
// Claude Code should auto-detect this is a Prisma error
// and invoke fetch-library-docs with:
//   --library-id /prisma/docs
//   --topic "unique constraint error handling upsert"
//   --content-type troubleshooting,examples
