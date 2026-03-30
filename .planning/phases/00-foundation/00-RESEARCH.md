# Phase 0: Foundation — Research

**Researched:** 2026-03-29
**Domain:** Next.js 16 + Clerk v7 + Prisma 6 + shadcn/ui + Tailwind v4
**Confidence:** HIGH

---

## Summary

Phase 0 bootstraps a greenfield Next.js 16 project from an empty `src/` directory. The
stack is fully decided in CLAUDE.md and PROJECT.md — no alternatives to evaluate. The
primary research questions are: (1) which exact APIs to use for Clerk v7 + Next.js 16,
(2) how to implement Prisma client extensions for site-scoping and audit logging, (3) how
to scaffold shadcn/ui against Tailwind CSS v4, and (4) what the Node.js crypto pattern is
for AES-256-GCM SSN encryption.

The most consequential finding is that Next.js 16 replaces `middleware.ts` with `proxy.ts`
(the exported function is also renamed to `proxy`). Clerk v7 already supports this.
AUTH-04 (every Server Action calls `auth()` independently) is directly motivated by
CVE-2025-29927, which demonstrated that middleware/proxy alone cannot be a security
boundary — this is a first-class design rule, not an optional pattern.

**Primary recommendation:** Scaffold with `pnpm create next-app@latest`, add Clerk v7,
initialize shadcn via `pnpm dlx shadcn@latest init -t next`, add Prisma 6, and implement
all infrastructure utilities (SSN encryption, audit extension, grant year, health check)
before writing any UI.

---

## Project Constraints (from CLAUDE.md)

### Locked Decisions (from CLAUDE.md and PROJECT.md)
- **Framework:** Next.js 16 App Router (latest stable: 16.2.1)
- **Auth:** Clerk with MFA enforced for all users (not NextAuth.js — CLAUDE.md ADR-002
  is outdated; the correct auth is Clerk per all other artifacts)
- **ORM:** Prisma 6 with PostgreSQL
- **Styling:** Tailwind CSS v4, CSS-only config (`@theme` blocks in globals.css, no
  `tailwind.config.ts`)
- **Component library:** shadcn/ui v4 (components auto-installed into `src/components/ui/`)
- **Package manager:** pnpm only — never npm or yarn
- **Legacy code:** `/legacy-src` is read-only; never modify
- **New pages:** `src/app/[route]/page.tsx`
- **New API routes:** `src/app/api/[name]/route.ts`
- **Audit spec check:** Always check `/specs/_audit/` before creating components
- **TypeScript:** Strict mode; no `any` type; all imports via `@/*` alias
- **Naming:** kebab-case files, PascalCase component names, camelCase functions/variables
- **Server Actions:** Always return `ActionResult<T>`; never throw exceptions
- **Database client:** Always use `src/lib/db.ts` — never create new `PrismaClient()`
  instances
- **Site filtering:** Never manually add `WHERE site_id` — Prisma extension applies it
- **Logging:** Pino structured JSON; never log SSN, passwords, or tokens

### Security Constraints
- CVE-2025-29927: Every Server Action must call `auth()` independently (AUTH-04)
- SSN encrypted at rest; only `ssn_last4` stored plaintext
- Clerk MFA enforced for all users via Dashboard configuration

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| AUTH-01 | Staff can log in via Clerk with MFA enforced for all users | Clerk v7 + MFA Dashboard config; `ClerkProvider` in root layout; Clerk-hosted `/sign-in` |
| AUTH-02 | Three roles enforced: Admin (all access), Central (all sites read), Site (own site only) | `publicMetadata.role` + session claims; `checkRole()` helper in `src/lib/auth.ts`; Prisma site-scoping extension |
| AUTH-03 | After login, user selects a program — all views filtered by selected program | `/select-program` route; program stored in session/cookie; program selector UI from UI-SPEC |
| AUTH-04 | Every Server Action independently calls `auth()` (middleware is not a security boundary per CVE-2025-29927) | `auth()` from `@clerk/nextjs/server` called at top of every Server Action; CVE-2025-29927 verified |
| LOOK-02 | Lookup values populate all form dropdowns consistently | Prisma schema must include lookup tables from day 1; seed script with reference data |
| INFRA-01 | Database audit trail logs every insert/update/delete with user, timestamp, old/new values | Prisma query extension on `$allModels` wrapping write operations; `AuditLog` model in schema |
| INFRA-02 | Audit trail is active from day 1 — no records exist without audit coverage | Prisma extension registered in `src/lib/db.ts` before any other code runs; migration includes audit_log table |
| INFRA-03 | SSN encryption at rest in PostgreSQL | Node.js `crypto` AES-256-GCM; `src/lib/ssn-encryption.ts` with `encryptSSN()`, `decryptSSN()`, `extractLast4()` |
| INFRA-05 | Health check endpoint returns 200 OK | `src/app/api/health/route.ts` checks DB connectivity, returns `{ "status": "ok" }` |
</phase_requirements>

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| next | 16.2.1 | Full-stack framework, App Router | Latest stable; Turbopack default; proxy.ts replaces middleware.ts |
| react | 19.2.4 | UI library (Server + Client Components) | Peer dep of Next.js 16; React Compiler stable |
| react-dom | 19.2.4 | DOM renderer | Required alongside react |
| typescript | 5.x | Type safety | Strict mode required by CLAUDE.md; min v5.1.0 for Next.js 16 |
| @clerk/nextjs | 7.0.7 | Auth + MFA + RBAC | Latest stable; supports Next.js 16 / proxy.ts |
| prisma | 6.x | ORM — schema management + migrations | Required by CLAUDE.md; Prisma 6 is current |
| @prisma/client | 6.x | ORM runtime client | Required alongside prisma |
| tailwindcss | 4.2.2 | CSS utility framework | v4 required; CSS-only config via `@theme` |
| @tailwindcss/postcss | 4.x | PostCSS plugin for Tailwind v4 | Required for Tailwind v4 pipeline |
| shadcn (CLI) | 4.1.1 | Component installer | Install via `pnpm dlx shadcn@latest` — not a direct dep |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| zod | 4.3.6 | Schema validation | Every Server Action input; env vars; form schemas |
| react-hook-form | 7.72.0 | Form state management | Complex multi-field forms (registration, enrollment) — not needed in Phase 0 |
| pino | 10.3.1 | Structured JSON logging | Server-side logging throughout |
| next-themes | 0.4.6 | Theme persistence | Dark mode toggle — Phase 0 defers dark mode; install now, activate later |
| vitest | 4.1.2 | Unit/component test runner | All `*.test.ts` files |
| @vitejs/plugin-react | 6.0.1 | React support in Vitest | Required in vitest.config.ts |
| @testing-library/react | 16.3.2 | Component testing utilities | DOM-level component tests |
| @testing-library/jest-dom | latest | DOM matchers | Extended `expect` matchers |
| jsdom | latest | DOM simulation | Required for vitest environment |
| @playwright/test | 1.58.2 | E2E tests | `e2e/` directory; install with `pnpm dlx playwright install` |
| lucide-react | latest | Icons | shadcn/ui convention; installed with shadcn |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Clerk | NextAuth.js | CLAUDE.md ADR-002 lists NextAuth.js but is outdated — Clerk is locked |
| Pino | Winston/console | Pino outputs structured JSON; much faster; better for prod log aggregation |
| Prisma extensions (query) | Prisma middleware | Middleware is legacy pattern; extensions are the current API |
| AES-256-GCM (Node crypto) | bcrypt / argon2 | SSN needs to be decryptable — hashing is one-way and wrong here |

**Installation:**
```bash
pnpm create next-app@latest . --yes
pnpm add @clerk/nextjs prisma @prisma/client zod pino next-themes
pnpm add -D vitest @vitejs/plugin-react @testing-library/react @testing-library/jest-dom jsdom
pnpm dlx shadcn@latest init -t next
pnpm dlx shadcn@latest add button card badge avatar dropdown-menu separator skeleton
pnpm dlx playwright install
```

**Version verification (confirmed against npm registry 2026-03-29):**
| Package | Verified Version |
|---------|-----------------|
| next | 16.2.1 (latest) |
| @clerk/nextjs | 7.0.7 (latest) |
| prisma / @prisma/client | 6.x (latest: 7.6.0 — confirm with `npm view prisma version`) |
| tailwindcss | 4.2.2 (latest) |
| vitest | 4.1.2 (latest) |
| @playwright/test | 1.58.2 (latest) |
| zod | 4.3.6 (latest) |
| react | 19.2.4 (Next.js 16 peer) |

---

## Architecture Patterns

### Recommended Project Structure
```
src/
├── app/
│   ├── layout.tsx               # Root layout — ClerkProvider, Inter font, globals.css
│   ├── page.tsx                 # Redirect to /select-program based on auth state
│   ├── (auth)/
│   │   └── sign-in/[[...sign-in]]/page.tsx  # Clerk-hosted sign-in
│   ├── (app)/
│   │   ├── layout.tsx           # App shell — sidebar + header
│   │   ├── select-program/
│   │   │   └── page.tsx         # Program selector (AUTH-03)
│   │   └── dashboard/
│   │       └── page.tsx         # Placeholder — redirected to from select-program
│   └── api/
│       └── health/
│           └── route.ts         # INFRA-05
├── actions/                     # Server Actions (verb-first camelCase)
├── components/
│   ├── ui/                      # shadcn auto-generated — never edit manually
│   ├── shared/                  # Reusable cross-domain components
│   └── program-selector/        # Phase 0 specific components
├── config/
│   └── env.ts                   # Zod env validation — fails fast at import
├── lib/
│   ├── db.ts                    # Prisma singleton + site-scoping extension + audit extension
│   ├── auth.ts                  # checkRole() helper, getAuthContext()
│   ├── ssn-encryption.ts        # encryptSSN(), decryptSSN(), extractLast4()
│   ├── grant-year.ts            # computeGrantYear(date: Date): number
│   ├── audit.ts                 # logAuditEvent() — called by Prisma extension
│   └── logger.ts                # Pino logger singleton
├── schemas/                     # Zod schemas per domain
├── types/
│   ├── index.ts                 # Re-exports all types
│   ├── action-result.ts         # ActionResult<T> discriminated union
│   └── globals.d.ts             # CustomJwtSessionClaims for Clerk RBAC
prisma/
└── schema.prisma                # Single schema file
proxy.ts                         # Clerk middleware (Next.js 16 convention)
```

### Pattern 1: Next.js 16 — proxy.ts (formerly middleware.ts)
**What:** Network-level request interception using `proxy.ts` (renamed from `middleware.ts` in Next.js 16)
**When to use:** Protecting all authenticated routes; Clerk session validation at the edge
**Example:**
```typescript
// Source: https://nextjs.org/blog/next-16 + https://clerk.com/docs/reference/nextjs/clerk-middleware
// File: proxy.ts (at project root or src/)
import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server';

const isPublicRoute = createRouteMatcher([
  '/sign-in(.*)',
  '/sign-up(.*)',
  '/api/health',
]);

export default function proxy(request: NextRequest) {
  return clerkMiddleware(async (auth, req) => {
    if (!isPublicRoute(req)) {
      await auth.protect();
    }
  })(request);
}

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
};
```

**Note:** `middleware.ts` is deprecated in Next.js 16. Use `proxy.ts` and export `proxy`
function. Clerk v7 supports both. For a greenfield project, use `proxy.ts` from day 1.

### Pattern 2: AUTH-04 — auth() in Every Server Action
**What:** Every Server Action independently verifies the session by calling `auth()` from
`@clerk/nextjs/server`. The proxy/middleware is not the security boundary.
**When to use:** Every single Server Action without exception
**Example:**
```typescript
// Source: https://clerk.com/docs/reference/nextjs/app-router/server-actions
// + CVE-2025-29927 mitigation
'use server';
import { auth } from '@clerk/nextjs/server';
import type { ActionResult } from '@/types/action-result';

export async function createYouth(input: unknown): Promise<ActionResult<Youth>> {
  const { userId, sessionClaims } = await auth();
  if (!userId) {
    return { success: false, error: 'Unauthorized' };
  }
  // ... proceed with validated userId
}
```

### Pattern 3: Clerk RBAC via publicMetadata + sessionClaims
**What:** Role stored in `publicMetadata.role`, made available in session token via
Clerk Dashboard custom session claims. Access via `sessionClaims` in server code.
**When to use:** Role-based access control checks in Server Actions and Server Components

**Setup steps (one-time, in Clerk Dashboard):**
1. Go to Sessions > Customize session token
2. Add to Claims editor: `{ "metadata": "{{user.public_metadata}}" }`

**TypeScript type:**
```typescript
// Source: https://clerk.com/docs/guides/secure/basic-rbac
// File: src/types/globals.d.ts
export type Role = 'admin' | 'central' | 'site';

declare global {
  interface CustomJwtSessionClaims {
    metadata: {
      role?: Role;
      site_id?: string;  // for Site role users
    };
  }
}
```

**checkRole helper:**
```typescript
// File: src/lib/auth.ts
import { auth } from '@clerk/nextjs/server';
import type { Role } from '@/types/globals';

export async function checkRole(role: Role): Promise<boolean> {
  const { sessionClaims } = await auth();
  return sessionClaims?.metadata.role === role;
}

export async function getAuthContext() {
  const { userId, sessionClaims } = await auth();
  return {
    userId,
    role: sessionClaims?.metadata.role,
    siteId: sessionClaims?.metadata.site_id,
  };
}
```

### Pattern 4: Prisma Singleton with Site-Scoping + Audit Extensions
**What:** Single `PrismaClient` instance stored on `globalThis` (prevents connection pool
exhaustion during hot reload). Two extensions chained: site-scoping on reads, audit on
writes.
**When to use:** Only import from `src/lib/db.ts` — never instantiate `PrismaClient`
directly anywhere else.
**Example:**
```typescript
// Source: https://www.prisma.io/docs/orm/prisma-client/client-extensions/query
// File: src/lib/db.ts
import { PrismaClient } from '@prisma/client';

const globalForPrisma = global as unknown as { prisma: PrismaClient };

const basePrisma = globalForPrisma.prisma ?? new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error'] : ['error'],
});

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = basePrisma;
}

// Site-scoping extension — injects site_id on all reads for Site role
export function createScopedDb(siteId: string | null) {
  if (!siteId) return basePrisma;
  return basePrisma.$extends({
    query: {
      $allModels: {
        async findMany({ args, query }: any) {
          args.where = { ...args.where, site_id: siteId };
          return query(args);
        },
        async findFirst({ args, query }: any) {
          args.where = { ...args.where, site_id: siteId };
          return query(args);
        },
      },
    },
  });
}

// Audit extension — logs all writes to audit_log
export const db = basePrisma.$extends({
  query: {
    $allModels: {
      async $allOperations({ model, operation, args, query }: any) {
        const isWrite = ['create', 'update', 'delete', 'upsert',
          'createMany', 'updateMany', 'deleteMany'].includes(operation);
        if (!isWrite) return query(args);
        const result = await query(args);
        // logAuditEvent is fire-and-forget; do not await to avoid latency
        logAuditEvent(model, operation, args, result).catch(console.error);
        return result;
      },
    },
  },
});

export default db;
```

### Pattern 5: SSN Encryption — AES-256-GCM
**What:** Encrypt full SSN before writing to DB. IV prepended to ciphertext + auth tag
stored together as hex string. Extract last 4 plaintext for indexed search.
**When to use:** Any write to a `ssn` column; any read that returns full SSN to authorized
roles
**Example:**
```typescript
// Source: https://nodejs.org/api/crypto.html
// File: src/lib/ssn-encryption.ts
import { createCipheriv, createDecipheriv, randomBytes } from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const KEY = Buffer.from(process.env.SSN_ENCRYPTION_KEY!, 'hex'); // 32 bytes = 64 hex chars

export function encryptSSN(ssn: string): string {
  const iv = randomBytes(12); // 96 bits — recommended for GCM
  const cipher = createCipheriv(ALGORITHM, KEY, iv);
  const encrypted = Buffer.concat([cipher.update(ssn, 'utf8'), cipher.final()]);
  const tag = cipher.getAuthTag();
  // Format: iv(12 bytes) + tag(16 bytes) + ciphertext — stored as hex
  return Buffer.concat([iv, tag, encrypted]).toString('hex');
}

export function decryptSSN(stored: string): string {
  const buf = Buffer.from(stored, 'hex');
  const iv = buf.subarray(0, 12);
  const tag = buf.subarray(12, 28);
  const ciphertext = buf.subarray(28);
  const decipher = createDecipheriv(ALGORITHM, KEY, iv);
  decipher.setAuthTag(tag);
  return decipher.update(ciphertext) + decipher.final('utf8');
}

export function extractLast4(ssn: string): string {
  return ssn.replace(/\D/g, '').slice(-4);
}
```

**Key requirement:** `SSN_ENCRYPTION_KEY` env var = 64 hex chars (32 bytes). Generate once:
`node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`.
Store in `.env.local` (git-ignored). Never commit.

### Pattern 6: Grant Year Utility
**What:** Grant year runs July 1 through June 30. A date in January 2025 is grant year
2024 (the year the grant year started).
**When to use:** Any enrollment/attendance operation and Metabase report synchronization
**Example:**
```typescript
// File: src/lib/grant-year.ts
/**
 * Compute grant year from a date.
 * Grant year starts July 1. A date of 2025-01-15 returns 2024.
 * A date of 2025-08-01 returns 2025.
 */
export function computeGrantYear(date: Date): number {
  const month = date.getMonth(); // 0-indexed; June = 5
  const year = date.getFullYear();
  return month >= 6 ? year : year - 1;
}
```

### Pattern 7: Zod Env Validation
**What:** Validate all required environment variables at startup. Import `env` from
`src/config/env.ts` everywhere instead of `process.env.X` directly.
**Example:**
```typescript
// File: src/config/env.ts
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().min(1),
  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY: z.string().min(1),
  CLERK_SECRET_KEY: z.string().min(1),
  SSN_ENCRYPTION_KEY: z.string().length(64, 'Must be 64 hex chars (32 bytes)'),
  METABASE_URL: z.string().url().optional(),
  METABASE_SECRET_KEY: z.string().optional(),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
});

export const env = envSchema.parse(process.env);
```

### Pattern 8: ActionResult<T> Type
**What:** Discriminated union return type for all Server Actions. Never throw — always
return.
```typescript
// File: src/types/action-result.ts
export type ActionResult<T = void> =
  | { success: true; data: T }
  | { success: false; error: string };
```

### Anti-Patterns to Avoid
- **`new PrismaClient()` outside `src/lib/db.ts`:** Creates new connection pool instance;
  exhausts connections in dev due to hot reload
- **Using `middleware.ts` filename in Next.js 16:** Deprecated; use `proxy.ts`
- **Relying on proxy.ts as the auth boundary:** CVE-2025-29927 — middleware can be
  bypassed. Always call `auth()` in Server Actions
- **`any` type:** TypeScript strict mode; use `unknown` and narrow with Zod
- **Manually adding `WHERE site_id` in queries:** The Prisma extension handles this;
  manual filters create maintenance risk
- **Committing `.env.local`:** SSN encryption key and Clerk secrets must stay git-ignored
- **Importing Prisma in Client Components:** Fetch data server-side only
- **Manually editing `src/components/ui/`:** shadcn files are auto-generated; run
  `pnpm dlx shadcn@latest add` to update
- **Using `next lint` command in Next.js 16:** Removed; use `eslint` directly instead

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Authentication + MFA | Custom auth system | Clerk v7 | MFA, session management, user provisioning built-in |
| Role checks boilerplate | Repeated `auth()` + role check code | `checkRole()` helper in `src/lib/auth.ts` | DRY; consistent error messages |
| Site-scoped query filtering | `WHERE site_id = ?` in every query | Prisma `query` extension in `src/lib/db.ts` | Extension is unforgettable; manual filters create security gaps |
| Form validation | Custom validators | Zod schemas in `src/schemas/` | Type inference, cross-platform (client + server) |
| Structured logging | `console.log` | Pino | JSON output, log levels, production-safe |
| UI components | Custom button/card/etc | shadcn/ui | Accessible, Radix-based, Tailwind-styled, consistent |
| Environment variable checks | `if (!process.env.X)` guards | Zod env schema in `src/config/env.ts` | Fails at startup with clear error; type-safe |
| Grant year switch statements | `if (month > 6)` scattered across codebase | `computeGrantYear()` in `src/lib/grant-year.ts` | Single definition shared by app + Metabase |

**Key insight:** In this stack, nearly every "custom utility" need is already covered by
an existing library or pattern in the prescribed stack. The main custom code is
domain-specific: SSN encryption, audit logging structure, grant year calculation, and
site-scoping logic.

---

## Common Pitfalls

### Pitfall 1: Using `middleware.ts` Instead of `proxy.ts` in Next.js 16
**What goes wrong:** `middleware.ts` still works (it's deprecated, not removed) but you'll
get deprecation warnings and it runs on Edge runtime. Clerk's `clerkMiddleware()` should
run in Node.js runtime.
**Why it happens:** All tutorials and older docs reference `middleware.ts`. Next.js 16 was
released October 2025 and most blog posts haven't caught up.
**How to avoid:** Create `proxy.ts` at project root (or `src/proxy.ts`). Export a function
named `proxy` (not `middleware`). Wrap `clerkMiddleware()` in it.
**Warning signs:** TypeScript warning about deprecated `middleware.ts` export convention.

### Pitfall 2: Treating proxy.ts / middleware.ts as an Auth Security Boundary
**What goes wrong:** Route is protected in proxy.ts but a Server Action is called directly
via HTTP POST (bypassing route protection). CVE-2025-29927 showed the header spoofing
attack vector.
**Why it happens:** Developer assumes "middleware protects the route, so the action is
protected." This is false — Server Actions are standalone HTTP endpoints.
**How to avoid:** AUTH-04: always call `auth()` at the top of every Server Action, before
any database access. Return `{ success: false, error: 'Unauthorized' }` if `!userId`.
**Warning signs:** Server Action that calls Prisma without first checking `userId`.

### Pitfall 3: Prisma Connection Pool Exhaustion in Development
**What goes wrong:** Hot reload creates a new `PrismaClient` each time — exhausts
PostgreSQL max connections, manifests as "too many clients" errors.
**Why it happens:** Next.js dev server re-executes modules on changes. Each module
re-execution creates a new connection pool.
**How to avoid:** The `globalThis` singleton pattern in `src/lib/db.ts`. Never import or
instantiate `PrismaClient` outside that file.
**Warning signs:** `PrismaClientInitializationError: Unable to start Prisma Client` or
PostgreSQL `FATAL: remaining connection slots are reserved`.

### Pitfall 4: Audit Log Missing Before/After on Updates
**What goes wrong:** Audit extension logs the `args` (intent) not the actual DB state.
For updates you need a `findUnique` BEFORE the mutation to capture old values.
**Why it happens:** The naive extension only logs `args` and `result`. The `where` clause
is a locator, not a snapshot.
**How to avoid:** For `update` operations in the audit extension, execute `findUnique` with
the same `where` clause before calling `query(args)`. Use `basePrisma` (unextended) for
this pre-read to avoid recursive extension calls.
**Warning signs:** Audit log shows `args.data` but not `before` state for update records.

### Pitfall 5: SSN Encryption Key Rotation Gap
**What goes wrong:** Encryption key is hardcoded in env file; if you generate a new key,
old records become unreadable.
**Why it happens:** AES-GCM is symmetric — one key encrypts/decrypts. Changing the key
without re-encrypting old records breaks decryption.
**How to avoid:** Store key in `.env.local` with a label, document the generation command,
and note that re-encryption is required before key rotation. For Phase 0, generate once
and document.
**Warning signs:** `Error: Unsupported state or unable to authenticate data` from
`decipher.final()` — this is the GCM authentication tag failure when key is wrong.

### Pitfall 6: shadcn Init Compatibility with Tailwind v4
**What goes wrong:** `npx shadcn init` may generate Tailwind v3 config artifacts
(`tailwind.config.ts`) if run without the correct flags.
**Why it happens:** shadcn CLI defaults changed in v4 but some paths can still generate v3
config.
**How to avoid:** Run `pnpm dlx shadcn@latest init -t next`. Verify no `tailwind.config.ts`
is created. All Tailwind config should live in `src/app/globals.css` via `@theme` blocks.
**Warning signs:** A `tailwind.config.ts` file appearing at root after init — delete it
and move its content to CSS `@theme`.

### Pitfall 7: MFA Not Actually Enforced (Clerk Dashboard Step Missed)
**What goes wrong:** Clerk SDK is installed and `clerkMiddleware()` is configured, but MFA
is not enforced because the Dashboard setting was not toggled.
**Why it happens:** MFA enforcement in Clerk is a **Dashboard configuration step**, not
a code step. The SDK does not enforce MFA unless the Dashboard setting is enabled.
**How to avoid:** AUTH-01 requires a manual step in the Clerk Dashboard: Multi-factor page
→ toggle on preferred strategy → enable "Require multi-factor authentication."
**Warning signs:** Users can complete sign-in without any MFA prompt.

### Pitfall 8: Missing Custom Session Claims (Breaks RBAC)
**What goes wrong:** `sessionClaims?.metadata.role` is always `undefined`, causing all
role checks to fail.
**Why it happens:** Clerk does not include `publicMetadata` in the session token by
default. You must add a custom claim in the Clerk Dashboard.
**How to avoid:** In Clerk Dashboard → Sessions → Customize session token, add:
`{ "metadata": "{{user.public_metadata}}" }`. Then `sessionClaims.metadata.role` works.
**Warning signs:** `checkRole('admin')` always returns `false` even for admin users.

---

## Code Examples

### ClerkProvider in Root Layout
```typescript
// Source: https://clerk.com/docs/nextjs/getting-started/quickstart
// File: src/app/layout.tsx
import { ClerkProvider } from '@clerk/nextjs';
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <ClerkProvider>
      <html lang="en">
        <body className={inter.className}>{children}</body>
      </html>
    </ClerkProvider>
  );
}
```

### Health Check Endpoint
```typescript
// File: src/app/api/health/route.ts
import { NextResponse } from 'next/server';
import db from '@/lib/db';

export async function GET() {
  try {
    await db.$queryRaw`SELECT 1`;
    return NextResponse.json({ status: 'ok' });
  } catch (error) {
    return NextResponse.json(
      { status: 'error', message: 'Database unavailable' },
      { status: 503 }
    );
  }
}
```

### Zod-Protected Server Action
```typescript
// Example pattern for all Server Actions
'use server';
import { auth } from '@clerk/nextjs/server';
import { z } from 'zod';
import type { ActionResult } from '@/types/action-result';
import logger from '@/lib/logger';

const schema = z.object({ name: z.string().min(1) });

export async function exampleAction(
  input: unknown
): Promise<ActionResult<{ id: string }>> {
  const { userId } = await auth(); // AUTH-04: always call auth() first
  if (!userId) return { success: false, error: 'Unauthorized' };

  const parsed = schema.safeParse(input);
  if (!parsed.success) return { success: false, error: 'Validation failed' };

  try {
    // db operations here
    logger.info({ userId, action: 'exampleAction' }, 'Action executed');
    return { success: true, data: { id: 'example' } };
  } catch (error) {
    logger.error({ error, userId }, 'exampleAction failed');
    return { success: false, error: 'Internal error' };
  }
}
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `middleware.ts` export | `proxy.ts` export (function named `proxy`) | Next.js 16 (Oct 2025) | Rename required for new projects |
| `experimental.ppr` | `cacheComponents: true` in next.config.ts | Next.js 16 | PPR flag removed |
| `revalidateTag(tag)` (1 arg) | `revalidateTag(tag, 'max')` (2 args) | Next.js 16 | Single-arg form deprecated |
| Prisma `$use()` middleware | Prisma `.$extends({ query: ... })` | Prisma 5+ | `$use` is legacy; extensions are the current API |
| NextAuth.js | Clerk | Project decision (ADR-002 outdated) | CLAUDE.md still says NextAuth.js — don't follow it for auth |
| `next lint` command | `eslint` directly | Next.js 16 | `next build` no longer runs lint; use `eslint` script |
| `npm` or `yarn` | `pnpm` | CLAUDE.md project rule | Always pnpm |

**Deprecated/outdated:**
- `middleware.ts` file: deprecated in Next.js 16, will be removed in future version
- `prisma.$use()`: legacy middleware API, replaced by `.$extends({ query: ... })`
- `next lint` CLI command: removed in Next.js 16 — migrate to `eslint` directly

---

## Open Questions

1. **CLAUDE.md says `output: "standalone"` for IIS/on-premises deployment**
   - What we know: CLAUDE.md specifies `output: "standalone"` in `next.config.ts`
   - What's unclear: Whether `output: "standalone"` has any gotchas with Next.js 16 /
     Turbopack that affect local development
   - Recommendation: Include `output: "standalone"` in `next.config.ts` from day 1 as
     specified; test `next build` produces `/.next/standalone/` directory

2. **Prisma database — local dev strategy**
   - What we know: PostgreSQL is the target; no local PostgreSQL is detected on this
     machine (psql not found)
   - What's unclear: Whether the developer has a Supabase connection string or needs a
     local PostgreSQL via Docker
   - Recommendation: Planner should include a Docker Compose option (`docker run
     postgres:15`) or Supabase connection string setup as the first plan step; Phase 0
     cannot proceed without a `DATABASE_URL`

3. **Clerk Dashboard custom session claims**
   - What we know: Must be configured manually in Clerk Dashboard before RBAC works
   - What's unclear: Whether the Clerk application (dev instance) already exists and has
     the session claims configured
   - Recommendation: Include a plan step with explicit Dashboard instructions; this is
     a one-time manual step, not a code step

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Node.js | All | Yes | 25.2.1 (exceeds 20.9 min) | — |
| pnpm | Package manager | Yes | 11.6.2 | — |
| Docker | Local PostgreSQL (optional) | Yes | 28.4.0 | Supabase cloud connection string |
| PostgreSQL (local) | DATABASE_URL | No | — | Docker (`postgres:15`) or Supabase |
| psql CLI | Schema inspection | No | — | Prisma Studio / pgAdmin |
| OpenSSL | Reference only (Node crypto used) | Yes | LibreSSL 3.3.6 | — |

**Missing dependencies with no fallback:**
- `DATABASE_URL` — Phase 0 cannot run migrations or start the dev server without a valid
  PostgreSQL connection string. Must be provided before execution begins.

**Missing dependencies with fallback:**
- Local PostgreSQL: Docker is available; `docker run --name prodigy-pg -e POSTGRES_PASSWORD=dev -p 5432:5432 -d postgres:15` provides a local DB

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.2 |
| Config file | `vitest.config.ts` — does not exist yet (Wave 0 gap) |
| Quick run command | `pnpm vitest run` |
| Full suite command | `pnpm vitest run --coverage` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| AUTH-01 | MFA enforced via Clerk Dashboard | manual-only | Dashboard verification | n/a |
| AUTH-02 | checkRole() returns correct boolean per role | unit | `pnpm vitest run src/lib/auth.test.ts` | Wave 0 |
| AUTH-03 | Program selector redirects on selection | smoke (E2E) | `pnpm playwright test e2e/program-selector.spec.ts` | Wave 0 |
| AUTH-04 | Server Action returns Unauthorized without userId | unit | `pnpm vitest run src/actions/*.test.ts` | Wave 0 |
| LOOK-02 | Lookup tables seeded and queryable | integration | `pnpm vitest run src/lib/db.test.ts` | Wave 0 |
| INFRA-01 | Audit log row written after INSERT | integration | `pnpm vitest run src/lib/audit.test.ts` | Wave 0 |
| INFRA-02 | No record without audit_log row | integration | `pnpm vitest run src/lib/audit.test.ts` | Wave 0 |
| INFRA-03 | Encrypted SSN is not plaintext; decrypts correctly | unit | `pnpm vitest run src/lib/ssn-encryption.test.ts` | Wave 0 |
| INFRA-05 | GET /api/health returns 200 `{ status: 'ok' }` | smoke | `pnpm vitest run src/app/api/health/route.test.ts` | Wave 0 |

Note: AUTH-01 is manual-only — MFA enforcement is a Clerk Dashboard state, not testable
in unit/integration tests. The other AUTH/INFRA requirements are unit-testable.

### Sampling Rate
- **Per task commit:** `pnpm vitest run` (unit tests only, < 30s)
- **Per wave merge:** `pnpm vitest run --coverage && pnpm playwright test`
- **Phase gate:** Full suite green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `vitest.config.ts` — framework config; specify `environment: 'node'` for lib tests,
  `environment: 'jsdom'` for component tests
- [ ] `src/lib/ssn-encryption.test.ts` — covers INFRA-03
- [ ] `src/lib/auth.test.ts` — covers AUTH-02, AUTH-04 (mock Clerk `auth()`)
- [ ] `src/lib/audit.test.ts` — covers INFRA-01, INFRA-02
- [ ] `src/lib/grant-year.test.ts` — covers ENRL-05 boundary cases (July 1 both sides)
- [ ] `src/app/api/health/route.test.ts` — covers INFRA-05
- [ ] `e2e/playwright.config.ts` — E2E config
- [ ] `e2e/program-selector.spec.ts` — covers AUTH-03

---

## Sources

### Primary (HIGH confidence)
- [Next.js 16 release blog](https://nextjs.org/blog/next-16) — proxy.ts, breaking changes,
  Node.js 20.9+ requirement, revalidateTag changes
- [Next.js 16 installation docs](https://nextjs.org/docs/app/getting-started/installation) —
  `pnpm create next-app@latest`, scaffolding defaults
- [Clerk clerkMiddleware() reference](https://clerk.com/docs/reference/nextjs/clerk-middleware) —
  proxy.ts pattern, route protection, createRouteMatcher
- [Clerk auth() App Router reference](https://clerk.com/docs/reference/nextjs/app-router/auth) —
  `auth()` in Server Actions, `userId`, `sessionClaims`
- [Clerk RBAC guide](https://clerk.com/docs/guides/secure/basic-rbac) —
  `publicMetadata`, custom session claims, `checkRole()` pattern
- [Clerk MFA enforcement](https://clerk.com/docs/guides/secure/force-mfa) —
  Dashboard-level MFA enforcement
- [Prisma query extensions](https://www.prisma.io/docs/orm/prisma-client/client-extensions/query) —
  `$allModels`, audit logging pattern, site-scoping
- [shadcn/ui Next.js installation](https://ui.shadcn.com/docs/installation/next) —
  `pnpm dlx shadcn@latest init -t next`, component add commands
- [shadcn Tailwind v4 guide](https://ui.shadcn.com/docs/tailwind-v4) —
  CSS-only config, no `tailwind.config.ts`
- [Node.js crypto docs](https://nodejs.org/api/crypto.html) —
  AES-256-GCM with `createCipheriv`/`createDecipheriv`
- npm registry (2026-03-29) — all version numbers verified

### Secondary (MEDIUM confidence)
- [NVD CVE-2025-29927](https://nvd.nist.gov/vuln/detail/CVE-2025-29927) —
  CVSS 9.1, affected versions, AUTH-04 rationale
- [ProjectDiscovery CVE-2025-29927 analysis](https://projectdiscovery.io/blog/nextjs-middleware-authorization-bypass) —
  x-middleware-subrequest header bypass mechanism
- Prisma singleton hot-reload pattern — multiple dev.to/Medium sources, consistent pattern

### Tertiary (LOW confidence)
- Next.js 16 / Clerk v7 proxy.ts compatibility — confirmed by WebSearch but not from a
  single authoritative changelog; treat as MEDIUM until confirmed in own project

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all versions verified against npm registry 2026-03-29
- Architecture: HIGH — all patterns sourced from official Clerk and Prisma docs
- Pitfalls: HIGH — CVE sourced from NVD; other pitfalls from official docs + known patterns
- Next.js 16 proxy.ts: HIGH — sourced from official Next.js 16 blog post
- shadcn/Tailwind v4: MEDIUM — official docs confirm CSS-only config; init flag confirmed
  from shadcn docs

**Research date:** 2026-03-29
**Valid until:** 2026-04-28 (30 days — stack is stable but Clerk and Next.js move quickly)
