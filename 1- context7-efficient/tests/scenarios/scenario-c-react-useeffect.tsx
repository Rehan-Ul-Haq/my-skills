// Scenario C: React useEffect Dependency Warning
// This file simulates a common React warning developers encounter

import { useState, useEffect } from 'react'

interface User {
  id: string
  name: string
}

function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null)

  // ⚠️ WARNING: React Hook useEffect has a missing dependency: 'userId'
  // Either include it or remove the dependency array

  useEffect(() => {
    async function fetchUser() {
      const response = await fetch(`/api/users/${userId}`)
      const data = await response.json()
      setUser(data)
    }
    fetchUser()
  }, [])  // ❌ Missing userId in dependency array

  if (!user) return <div>Loading...</div>

  return <div>{user.name}</div>
}

// Developer is unsure about the correct useEffect pattern
// Claude Code should auto-detect this is a React hooks issue
// and invoke fetch-library-docs with:
//   --library-id /reactjs/react.dev
//   --topic "useEffect dependencies fetch data"
//   --content-type examples,patterns
