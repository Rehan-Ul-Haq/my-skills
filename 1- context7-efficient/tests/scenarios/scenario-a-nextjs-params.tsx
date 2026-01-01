// Scenario A: Next.js 15 Dynamic Route - Async Params Error
// This file simulates a real error developers encounter when upgrading to Next.js 15

// ERROR: "params should be awaited before using its properties"
// This happens because Next.js 15 changed params to be a Promise

interface PageProps {
  params: { id: string }  // ❌ Wrong in Next.js 15
}

export default function ProductPage({ params }: PageProps) {
  // ❌ ERROR: Property 'id' does not exist on type 'Promise<{ id: string }>'
  const productId = params.id

  return (
    <div>
      <h1>Product {productId}</h1>
    </div>
  )
}

// The developer is confused - this worked in Next.js 14
// Claude Code should auto-detect this is a Next.js migration issue
// and invoke fetch-library-docs with:
//   --library-id /vercel/next.js
//   --topic "async params dynamic routes"
//   --content-type examples,migration
