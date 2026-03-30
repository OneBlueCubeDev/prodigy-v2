# Coding Conventions

**Analysis Date:** 2026-03-29

This document establishes the coding conventions for the Prodigy Next.js 14 migration project. All code follows these patterns with no exceptions.

## Naming Patterns

**Files:**
- React components: kebab-case (e.g., `youth-registration-form.tsx`, `theme-toggle.tsx`)
- Utilities: kebab-case (e.g., `ssn-encryption.ts`, `auth.ts`, `utils.ts`)
- Page routes: `page.tsx` (Next.js App Router convention)
- API routes: kebab-case nested in `route.ts` (e.g., `/api/metabase-embed/route.ts`)

**React Components:**
- PascalCase component names (e.g., `YouthRegistrationForm`, `AttendanceRoster`, `ThemeToggle`)
- Must be exported as default or named export

**Functions & Variables:**
- camelCase for all functions and variables
- Server Actions: verb-first camelCase (e.g., `createYouth`, `submitAttendance`, `enrollInProgram`, `updateClass`)
- Utility functions: descriptive camelCase (e.g., `getYouthById`, `formatSSN`, `calculateTardy`)

**Database & Prisma:**
- Prisma models: PascalCase, singular (e.g., `Youth`, `Enrollment`, `AuditLog`)
- Database tables: snake_case, plural (e.g., `youth`, `enrollments`, `audit_logs`)
- Database columns: snake_case (e.g., `first_name`, `site_id`, `created_at`)
- Foreign keys: `{referenced_table_singular}_id` (e.g., `youth_id`, `program_id`, `site_id`)

**Types & Interfaces:**
- PascalCase, singular, no prefix (e.g., `Youth`, `Enrollment`, `ActionResult` — NO `I` or `T` prefix)
- Reusable types in `src/types/`
- Component-local types co-located with component

**Zod Schemas:**
- camelCase + `Schema` suffix (e.g., `createYouthSchema`, `attendanceSubmissionSchema`, `enrollmentFormSchema`)
- Located in `src/schemas/{domain}.ts`
- Exported as named exports

**Environment Variables:**
- SCREAMING_SNAKE_CASE (e.g., `DATABASE_URL`, `CLERK_SECRET_KEY`, `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`)
- Validated in `src/config/env.ts` via Zod

**Constants:**
- SCREAMING_SNAKE_CASE for true constants (e.g., `DEFAULT_PAGE_SIZE`, `MAX_FILE_UPLOAD_SIZE`)
- camelCase for enumerated values mapped from constants (e.g., `enrollmentStatuses`, `userRoles`)

## Code Style

**Formatting:**
- ESLint configured via Next.js defaults with TypeScript support
- Prettier for consistent formatting (installed, configuration applied)
- Line length: 80 characters (soft limit for readability, hard at 100)
- Indentation: 2 spaces
- Semicolons: Required at end of statements

**Linting:**
- ESLint enforces TypeScript strict mode
- No `any` type — use `unknown` and narrow with Zod or type guards
- All imports must be resolvable via `@/*` alias (never relative paths beyond single directory)

**Type Strictness:**
- `tsconfig.json` strict mode enabled
- No implicit `any` types
- Exhaustive checks on discriminated unions
- Null/undefined handling explicit

## Import Organization

**Order:**
1. React and Next.js modules (e.g., `import { useState } from 'react'`, `import Image from 'next/image'`)
2. Third-party libraries (e.g., `import { clsx } from 'clsx'`, `import { z } from 'zod'`)
3. Internal imports using `@/*` alias
   - Config and utils (e.g., `import { env } from '@/config/env'`)
   - Schemas (e.g., `import { createYouthSchema } from '@/schemas/youth'`)
   - Types (e.g., `import { ActionResult } from '@/types/action-result'`)
   - Components (e.g., `import { Button } from '@/components/ui/button'`)
   - Actions/lib (e.g., `import { createYouth } from '@/actions/youth'`)

**Path Aliases:**
- `@/*` → `src/*` (configured in `tsconfig.json` and `next.config.ts`)
- Always use alias, never relative paths like `../../`

**Grouped with blank lines** between each category for visual clarity.

## Error Handling

**Server Actions Pattern:**
All Server Actions return `ActionResult<T>` type. Never throw exceptions.

```typescript
// src/types/action-result.ts
export type ActionResult<T> =
  | { success: true; data: T }
  | { success: false; error: string }

// Usage in src/actions/youth.ts
export async function createYouth(
  input: unknown
): Promise<ActionResult<Youth>> {
  try {
    const parsed = createYouthSchema.parse(input)
    const youth = await db.youth.create({ data: parsed })
    return { success: true, data: youth }
  } catch (err) {
    const message = err instanceof Error ? err.message : "Unknown error"
    return { success: false, error: message }
  }
}
```

**Route Handlers Pattern:**
Return appropriate HTTP status codes and JSON responses.

```typescript
// src/app/api/health/route.ts
export async function GET() {
  return Response.json(
    { status: "ok", timestamp: new Date().toISOString() },
    { status: 200 }
  )
}
```

**Client Component Error Handling:**
Display user-facing errors via toast notifications (shadcn/ui Toast).

```typescript
const result = await createYouth(formData)
if (!result.success) {
  toast.error(result.error)
  return
}
```

**Validation Errors:**
Handled by Zod in Server Actions. Client-side form errors displayed via React Hook Form's `errors` object.

## Logging

**Framework:** Pino (structured JSON logger)

Instance created in `src/lib/logger.ts` and imported where needed:

```typescript
import { logger } from '@/lib/logger'

logger.info({ youth_id: '123', action: 'create' }, 'Youth created')
logger.warn({ enrollment_id: '456' }, 'Transfer pending approval')
logger.error({ error: err.message }, 'Database write failed')
```

**Log Levels:**
- `info` — Normal operations (record created, page rendered)
- `warn` — Recoverable issues (duplicate detected, retry attempted)
- `error` — Failures (validation failed, database error)
- `debug` — Development only (request/response bodies, query timing) — NOT in production

**When to Log:**
- Server Action entry/exit with relevant IDs
- Database operation failures
- Authentication/authorization decisions (role checks, site scoping)
- External API calls (Metabase JWT generation, Clerk webhook receipt)
- Never log sensitive data: SSN, passwords, auth tokens

## Comments

**When to Comment:**
- Complex business logic (e.g., grant year calculation, tardy detection)
- Non-obvious algorithmic choices
- Workarounds or temporary solutions
- Links to tracking issues (e.g., `// TODO: optimize query per issue #42`)

**JSDoc/TSDoc:**
Required for:
- Public functions in utilities and libraries
- Server Actions
- Complex components with multiple props

```typescript
/**
 * Encrypts an SSN and extracts the last 4 digits for indexing.
 * @param ssn - 9-digit SSN as string, no hyphens
 * @returns Encrypted SSN and plaintext last 4
 */
export function encryptSSN(ssn: string) {
  // implementation
}

/**
 * Creates a new youth record with demographics and SSN.
 * Checks for potential duplicates by name and DOB.
 * @param input - Validated youth creation input
 * @returns ActionResult with created Youth or error message
 */
export async function createYouth(input: unknown): Promise<ActionResult<Youth>> {
  // implementation
}
```

**No over-commenting:** Self-documenting code with clear names is preferred over verbose comments.

## Function Design

**Size:** Functions should be concise, single-purpose. A function in a Server Action should fit on ~1 screen (60 lines max).

**Parameters:**
- Prefer objects over positional parameters when > 2 args
- Leverage destructuring for clarity

```typescript
// Good
export async function enrollYouth({
  youthId,
  programId,
  siteId,
}: {
  youthId: string
  programId: string
  siteId: string
}): Promise<ActionResult<Enrollment>> {
  // ...
}

// Avoid
export async function enrollYouth(
  youthId: string,
  programId: string,
  siteId: string
): Promise<ActionResult<Enrollment>> {
  // ...
}
```

**Return Values:**
- Server Actions: Always `ActionResult<T>`
- Regular utilities: Explicit return type (no implicit any)
- Async functions: Always return Promise

```typescript
// Good
async function getYouthById(id: string): Promise<Youth | null> {
  return db.youth.findUnique({ where: { id } })
}

// Type annotations required
function formatDate(date: Date): string {
  return date.toLocaleDateString()
}
```

## Module Design

**Exports:**
- Default export only for React components when single export
- Named exports for everything else (actions, types, utilities, schemas)

```typescript
// src/components/youth/youth-registration-form.tsx
export default function YouthRegistrationForm() {
  // ...
}

// src/actions/youth.ts (named exports)
export async function createYouth(input: unknown): Promise<ActionResult<Youth>> {
  // ...
}

export async function searchYouth(query: string): Promise<Youth[]> {
  // ...
}
```

**Barrel Files:**
- `src/components/ui/` — shadcn/ui components imported directly from `@/components/ui/button`, etc.
- `src/types/index.ts` — re-exports all types for convenience
- `src/lib/` — utilities imported individually by function name

No barrel files for components or actions (import directly from subdirectories for clarity and tree-shaking).

## Component Patterns

**Server Components (Default):**
- Fetched data server-side via Prisma
- Direct database access
- No hooks, no event handlers
- Can import from `@/actions/` for mutations

```typescript
// src/app/youth/page.tsx
export default async function YouthListPage() {
  const youth = await db.youth.findMany({
    where: { siteId: userSiteId },
    orderBy: { lastName: 'asc' },
  })
  return <YouthTable data={youth} />
}
```

**Client Components:**
- Marked with `'use client'` at top
- Handle interactivity (click, form submit, search)
- Call Server Actions for mutations
- Never import Prisma or database directly

```typescript
'use client'

import { createYouth } from '@/actions/youth'
import { YouthForm } from '@/components/youth/youth-form'

export default function YouthNewPage() {
  async function handleSubmit(formData: FormData) {
    const result = await createYouth(formData)
    // handle result
  }
  return <YouthForm onSubmit={handleSubmit} />
}
```

## Form Patterns

**Complex Forms (Registration, Enrollment, Class Schedule):**
Use React Hook Form + Zod combination.

```typescript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { createYouthSchema } from '@/schemas/youth'

export default function YouthRegistrationForm() {
  const form = useForm({
    resolver: zodResolver(createYouthSchema),
  })

  async function onSubmit(data: typeof createYouthSchema._input) {
    const result = await createYouth(data)
    if (!result.success) {
      form.setError('root', { message: result.error })
    }
  }

  return (
    <form onSubmit={form.handleSubmit(onSubmit)}>
      {/* form fields with form.register, form.formState.errors */}
    </form>
  )
}
```

**Simple Forms (Search, Filters):**
Use native HTML form elements without React Hook Form.

```typescript
// src/components/youth/youth-search.tsx
export default function YouthSearch() {
  async function handleSearch(formData: FormData) {
    const query = formData.get('q') as string
    const results = await searchYouth(query)
    // display results
  }

  return (
    <form action={handleSearch}>
      <input name="q" type="text" placeholder="Search..." />
      <button type="submit">Search</button>
    </form>
  )
}
```

## Styling

**Tailwind CSS v4:**
- CSS-first configuration via `globals.css`
- No `tailwind.config.js` needed (using CSS `@theme` blocks)
- All styling via utility classes

```tsx
<div className="flex items-center justify-between rounded-lg bg-card p-4 shadow">
  <h1 className="text-xl font-semibold text-foreground">Youth Registry</h1>
  <Button variant="outline">Add Youth</Button>
</div>
```

**shadcn/ui Components:**
- Import from `@/components/ui/`
- Never manually edit components in `src/components/ui/` (auto-generated by shadcn)
- Use `cn()` utility for conditional classes

```typescript
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'

export function YouthCard({ isActive }: { isActive: boolean }) {
  return (
    <div className={cn("p-4", isActive && "bg-primary text-primary-foreground")}>
      <Button>Edit</Button>
    </div>
  )
}
```

**CSS Variables:**
Design tokens defined in `src/app/globals.css` and used via CSS variables.

```css
:root {
  --background: #fafafa;
  --foreground: #171717;
  --primary: #2563eb;
  --primary-foreground: #ffffff;
  --card: #ffffff;
  --card-foreground: #171717;
  /* ... more tokens ... */
}

.dark {
  --background: #0a0a0a;
  --foreground: #fafafa;
  --primary: #3b82f6;
  --primary-foreground: #ffffff;
  --card: #171717;
  --card-foreground: #fafafa;
  /* ... dark mode tokens ... */
}
```

Used in Tailwind via semantic classes (handled by shadcn/ui).

## Authentication & Authorization

**Clerk Session Access:**
Extract in middleware (`src/middleware.ts`) and attach to request context.

```typescript
// src/middleware.ts
export function middleware(request: NextRequest) {
  const { userId, unsafeMetadata, primaryEmailAddress } = auth()
  // Attach role/site to request headers or context
}
```

**Role & Site Checks:**
- Use Prisma extension in `src/lib/db.ts` for automatic site-scoped filtering
- Never manually add `WHERE` site_id filters — the extension applies them automatically
- Explicit role checks only when business logic requires different UIs (e.g., Admin dashboards)

```typescript
// ✅ Good: Prisma extension applies site filter automatically
const enrollments = await db.enrollment.findMany({
  where: { status: 'active' },
})

// ❌ Bad: Manual site filtering — defeats the extension's purpose
const enrollments = await db.enrollment.findMany({
  where: {
    status: 'active',
    site_id: userSiteId, // Don't do this — extension does it
  },
})
```

## Database Access Patterns

**Single Prisma Client Instance:**
Always import from `src/lib/db.ts`, never create a new `PrismaClient()` instance.

```typescript
import { db } from '@/lib/db'

const youth = await db.youth.findUnique({ where: { id } })
```

**Async Operations:**
All database reads/writes are async. Always use `await`.

```typescript
export async function searchYouth(query: string): Promise<Youth[]> {
  return db.youth.findMany({
    where: {
      OR: [
        { firstName: { contains: query, mode: 'insensitive' } },
        { lastName: { contains: query, mode: 'insensitive' } },
        { ssn_last4: query },
      ],
    },
  })
}
```

**Relationships:**
Load related data via Prisma `include` or `select` (never N+1 queries).

```typescript
const youth = await db.youth.findUnique({
  where: { id },
  include: {
    enrollments: true,
    guardians: true,
  },
})
```

## Data Mutation Patterns

**All mutations via Server Actions:**
- Client components call server actions
- Server actions validate input with Zod
- Server actions return `ActionResult<T>`
- Prisma audit middleware logs mutations automatically

```typescript
// src/actions/youth.ts
'use server'

import { createYouthSchema } from '@/schemas/youth'
import { db } from '@/lib/db'

export async function createYouth(input: unknown): Promise<ActionResult<Youth>> {
  try {
    const validated = createYouthSchema.parse(input)
    const youth = await db.youth.create({
      data: {
        ...validated,
        ssn_encrypted: encryptSSN(validated.ssn).encrypted,
        ssn_last4: encryptSSN(validated.ssn).last4,
      },
    })
    return { success: true, data: youth }
  } catch (err) {
    return { success: false, error: getErrorMessage(err) }
  }
}
```

## Special Patterns

**SSN Handling:**
- Encrypted at rest via `src/lib/ssn-encryption.ts`
- Only `ssn_last4` column stored plaintext (for search via last 4)
- Full SSN never logged, never sent to client except for authorized roles
- Excluded from Metabase connection

```typescript
// src/lib/ssn-encryption.ts
export function encryptSSN(ssn: string): { encrypted: string; last4: string } {
  const last4 = ssn.slice(-4)
  const cipher = createCipheriv('aes-256-gcm', key, iv)
  const encrypted = cipher.update(ssn, 'utf8', 'hex') + cipher.final('hex')
  return { encrypted, last4 }
}
```

**Grant Year Computation:**
Derived from enrollment/attendance dates, never stored. Computed at query time via `src/lib/grant-year.ts`.

```typescript
// src/lib/grant-year.ts
export function getGrantYear(date: Date): number {
  // Grant year: July 1 - June 30
  return date.getMonth() >= 6 ? date.getFullYear() : date.getFullYear() - 1
}
```

**Date Handling:**
- Store as `DateTime` in Prisma (ISO 8601)
- Format for display via `Intl.DateTimeFormat` or date library

```typescript
const formatted = new Intl.DateTimeFormat('en-US', {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
}).format(enrollmentDate)
```

## Anti-Patterns (NEVER Do These)

- ❌ Use `any` type — use `unknown` and narrow
- ❌ Create new `PrismaClient()` instances — always use `src/lib/db.ts`
- ❌ Throw exceptions from Server Actions — return `ActionResult` instead
- ❌ Manually add site filtering in queries — rely on Prisma extension
- ❌ Import from relative paths like `../../` — use `@/*` alias
- ❌ Store secrets in `.env` and commit — use `.env.local` (git-ignored)
- ❌ Import Prisma or database code in Client Components — fetch data server-side
- ❌ Manually edit files in `src/components/ui/` — they're auto-generated by shadcn
- ❌ Put business logic in React components — move to Server Actions or `src/lib/`
- ❌ Log sensitive data (SSN, passwords, tokens)
- ❌ Use npm or yarn — pnpm only

---

*Convention analysis: 2026-03-29*
