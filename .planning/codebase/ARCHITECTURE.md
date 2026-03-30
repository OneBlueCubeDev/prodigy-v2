# Architecture

**Analysis Date:** 2026-03-29

## Pattern Overview

**Overall:** Strangler Fig pattern migration from ASP.NET WebForms to Next.js 14+ App Router with staged feature adoption. The legacy monolith (`/legacy-src`) remains intact and operational while new features are built in Next.js (`/src`). Traffic switches feature-by-feature as replacements pass parity testing.

**Key Characteristics:**
- Spec-driven development using BMAD (Business Model Architecture Design) + GSD (Get Shit Done) hybrid methodology
- Legacy WebForms app is read-only reference; never modified during migration
- Architecture documented before implementation; all decisions recorded as ADRs in `/specs/decisions/`
- Full-stack TypeScript/Next.js with Server Components/Actions, Prisma ORM, Clerk auth, Metabase OSS reporting
- Site-scoped authorization enforced at middleware + database layer
- Column-level SSN encryption with audit logging for compliance

---

## Layers

**Presentation (Next.js App Router):**
- Purpose: Server-rendered pages via React Server Components, client interactivity via islands pattern
- Location: `/src/app/`
- Contains: Route handlers (page.tsx), layouts, loading/error boundaries, API routes
- Depends on: Clerk auth middleware, Server Actions in `/src/actions/`
- Used by: End users via HTTP/HTTPS

**Authentication & Authorization (Middleware):**
- Purpose: Enforce Clerk session, extract user role/site context, inject into request context
- Location: `/src/middleware.ts`
- Contains: Clerk middleware composition, role/site extraction from JWT
- Depends on: Clerk SDK, Prisma for role lookup
- Used by: All routes automatically; optionally extended via Prisma client extension

**Data Access (Prisma ORM + Extensions):**
- Purpose: Type-safe database queries with automatic site-scoping and audit middleware
- Location: `/src/lib/db.ts` (client instance + extensions), `prisma/schema.prisma` (schema)
- Contains: Prisma client singleton, site-scoping extension (`where` clause injection), audit middleware
- Depends on: PostgreSQL on Supabase, Node.js crypto for SSN encryption
- Used by: Server Actions, Server Components, Route Handlers

**Business Logic (Server Actions):**
- Purpose: Handle data mutations (CREATE, UPDATE, DELETE) with validation, authorization checks, and audit logging
- Location: `/src/actions/{domain}.ts` (e.g., `youth.ts`, `enrollment.ts`)
- Contains: Exported `async` functions marked `'use server'`, Zod validation, Prisma calls, error handling
- Depends on: Zod schemas (`/src/schemas/`), Prisma client, libraries in `/src/lib/`
- Used by: Client components via form submission or direct calls, never called from other Server Actions

**Validation (Zod Schemas):**
- Purpose: Single source of truth for form validation and API input validation
- Location: `/src/schemas/{domain}.ts` (e.g., `youth.ts`, `enrollment.ts`)
- Contains: Zod schema objects with `.parse()` and `.safeParse()` methods, reusable across client and server
- Depends on: Zod library only
- Used by: Server Actions for input validation, React Hook Form for form-level validation, route handlers

**UI Components (React + shadcn/ui):**
- Purpose: Render interfaces, handle client-side state (forms, loading, errors), wire actions to data
- Location: `/src/components/{domain}/` for domain-specific, `/src/components/shared/` for reusable, `/src/components/ui/` for primitives
- Contains: React functional components, some marked `'use client'` for interactivity
- Depends on: shadcn/ui primitives, Tailwind CSS, React Hook Form
- Used by: Route handlers (page.tsx files)

**Utilities & Shared Code (Library):**
- Purpose: Cross-cutting concerns and reusable helpers
- Location: `/src/lib/` and `/src/config/`
- Contains: SSN encryption, audit logging, Metabase JWT, grant year logic, Pino logger, auth helpers, env validation
- Depends on: Standard libraries (Node.js crypto, pino, zod)
- Used by: Server Actions, middleware, other library modules

**Reporting Integration (Metabase):**
- Purpose: Embed signed Metabase dashboards/questions in app with site-scoped data
- Location: `/src/app/reports/` (pages), `/src/api/metabase-embed/` (JWT signing), `/src/components/reports/metabase-embed.tsx`
- Contains: Report listing pages, JWT Route Handler, reusable Metabase iframe component
- Depends on: Metabase OSS instance (port 3001), PostgreSQL read-only connection
- Used by: Central Team users for dashboards (census, billing, attendance)

---

## Data Flow

**Read Flow (Server Component → Database):**
```
User navigates to /youth
  → Next.js Router calls page.tsx (Server Component)
  → page.tsx calls Prisma query via src/lib/db.ts
  → Middleware-injected user context available via getAuth() helper
  → Prisma extension automatically filters query by user's assigned site
  → Data returned to Server Component
  → Server Component renders via React, sends HTML to browser
  → Client receives hydrated page
```

**Write Flow (Client Action → Server Action → Database):**
```
User submits form (youth registration)
  → Client component calls Server Action: createYouth()
  → Server Action validates input with Zod schema
  → Server Action checks authorization (role-based rules in /src/lib/auth.ts)
  → Server Action calls Prisma.youth.create()
  → Prisma audit middleware intercepts write
  → Audit middleware logs { userId, action: 'CREATE', before: null, after: {...} } to audit_log table
  → PostgreSQL executes INSERT
  → Server Action returns ActionResult<Youth> — either { success: true, data: youth } or { success: false, error: '...' }
  → Client component receives result and updates UI accordingly
```

**State Management:**
- Server state: URL search params for filters, session data in Clerk/Middleware context
- Client state: Local React state in components (form inputs, loading flags, errors)
- Shared state: None — no global Redux/Zustand needed at this scale (< 50 users)
- Cache: Next.js built-in caching on Server Components; no Redis needed yet

---

## Key Abstractions

**ActionResult<T>:**
- Purpose: Standardize Server Action return values across the app
- Examples: `src/types/action-result.ts`
- Pattern: Every Server Action returns `{ success: true; data: T } | { success: false; error: string }` instead of throwing exceptions
- Usage: Enables client components to handle errors gracefully without try/catch; type-safe data extraction

**Prisma Site-Scoping Extension:**
- Purpose: Automatically inject `WHERE` clauses to enforce site-scoped access on every query
- Examples: Used by all routes serving Site Team/Instructor roles
- Pattern: Registered in `src/lib/db.ts` as a Prisma client extension; transparently filters queries
- Usage: Impossible to accidentally fetch cross-site data; authorization burden shifts from developer to ORM

**Audit Middleware:**
- Purpose: Log all CUD operations on core entities (Youth, Enrollment, Attendance, etc.)
- Examples: Implemented in `src/lib/audit.ts`
- Pattern: Prisma middleware intercepts $executeRaw and model operations, captures before/after snapshots
- Usage: Compliance requirement; every user action is traceable to a Clerk user + timestamp + before-after diff

**SSN Encryption:**
- Purpose: Encrypt SSN at application level while maintaining search-by-last-4 capability
- Examples: `src/lib/ssn-encryption.ts` exports `encryptSSN()`, `decryptSSN()`, `extractLast4()`
- Pattern: Column-level encryption via Node.js crypto; plaintext `ssn_last4` column for indexed search
- Usage: Metabase connection excludes `ssn` column; UI masks full SSN, shows only last 4

**Grant Year Computation:**
- Purpose: Derive grant year from enrollment/attendance dates; consistent between app and Metabase
- Examples: `src/lib/grant-year.ts`
- Pattern: Standalone function `computeGrantYear(date: Date): number` — grant year runs July 1 through June 30
- Usage: Called during enrollment/attendance operations and exposed to Metabase via view or stored procedure

---

## Entry Points

**Root Layout (Server Component):**
- Location: `src/app/layout.tsx`
- Triggers: Every HTTP request
- Responsibilities: Wrap app in ClerkProvider, set up global Pino logger, apply Tailwind CSS, render root error boundary

**Middleware:**
- Location: `src/middleware.ts`
- Triggers: Before every route handler
- Responsibilities: Verify Clerk session, extract user role/site, make available to route context via `getAuth()` helper

**Home/Dashboard Page:**
- Location: `src/app/page.tsx`
- Triggers: User navigates to `/`
- Responsibilities: Redirect to appropriate section (youth, enrollments, reports) based on user role

**Youth Management Routes:**
- Location: `src/app/youth/page.tsx` (list), `src/app/youth/new/page.tsx` (create), `src/app/youth/[youthId]/page.tsx` (detail)
- Triggers: User navigates to `/youth`, `/youth/new`, `/youth/:id`
- Responsibilities: Query youth data, render search/list/form components, wire createYouth/updateYouth actions

**Enrollment Routes:**
- Location: `src/app/enrollments/page.tsx`
- Triggers: User navigates to `/enrollments`
- Responsibilities: List enrollments filtered by site, render enrollment forms and actions

**Attendance Routes:**
- Location: `src/app/attendance/page.tsx` (class picker), `src/app/attendance/[classId]/page.tsx` (roster)
- Triggers: Instructor navigates to attendance section
- Responsibilities: Query class roster, render attendance sign-in UI, submit attendance via Server Action

**Reporting Routes:**
- Location: `src/app/reports/[name]/page.tsx` (e.g., census, billing, attendance)
- Triggers: User navigates to `/reports/*`
- Responsibilities: Generate Metabase JWT token, render signed iframe for dashboard

**Health Check Endpoint:**
- Location: `src/app/api/health/route.ts`
- Triggers: External monitoring tools poll `/api/health`
- Responsibilities: Check database connectivity, return JSON status

**Metabase JWT Endpoint:**
- Location: `src/app/api/metabase-embed/route.ts`
- Triggers: Report page requests signed token
- Responsibilities: Verify user auth, generate JWT signed with Metabase secret, return token and embed URL

---

## Error Handling

**Strategy:** Errors are caught at the Server Action boundary and returned as `ActionResult<T>` instead of thrown. Client components display errors via toast notifications or inline form validation feedback.

**Patterns:**

- **Validation Errors:** Zod schema `.safeParse()` returns `{ success: false; error: ZodError }` — caught by Server Action, returned to client as `{ success: false; error: 'Validation failed' }`
- **Authorization Errors:** Middleware and `getAuth()` helper check role/site; return 403 Forbidden at route level or throw from Server Action, caught and returned to client
- **Database Errors:** Prisma throws on constraint violations, connection errors, etc. — caught in Server Action, logged via Pino, returned as generic error message to client
- **Route Errors:** Next.js `error.tsx` boundary per route segment catches unhandled errors and renders error page
- **Global Errors:** Root `error.tsx` catches critical errors; displays fallback UI

---

## Cross-Cutting Concerns

**Logging:**
- Implementation: Pino logger in `src/lib/logger.ts`
- Pattern: Import logger, call `logger.info()`, `logger.warn()`, `logger.error()` at decision points in Server Actions and route handlers
- Output: Structured JSON to stdout, can be redirected to file or Windows Event Log on server

**Validation:**
- Implementation: Zod schemas in `src/schemas/{domain}.ts`
- Pattern: Define schema once, use in Server Action input validation and React Hook Form for client-side feedback
- Coverage: Every Server Action input validated; forms validated in real-time

**Authentication:**
- Implementation: Clerk middleware + getAuth() helper in `src/lib/auth.ts`
- Pattern: Middleware runs first, user context available to all routes; explicit public route allowlist in middleware
- Default: All routes require authentication; public routes (login page, health check) explicitly allowed

**Authorization:**
- Implementation: Role/site checks in Server Actions and route handlers
- Pattern: Extract user role/site from Clerk via getAuth(), check against required role, filter data via Prisma extension
- Enforcement: Middleware + Prisma extension ensures no forgotten checks; anti-pattern to manually filter in queries

**Audit:**
- Implementation: Prisma middleware in `src/lib/audit.ts`
- Pattern: Middleware automatically captures CREATE/UPDATE/DELETE on core models; stores in `audit_log` table with user/timestamp/before-after
- No manual calls needed; transparent to business logic

---

## Migration Sequence (Strangler Fig)

1. **Phase 0 — Bootstrap:** Repo structure, tooling, Repomix codebase packing (complete)
2. **Phase 1 — Analyst:** Repomix output analyzed to produce page/service/report inventories (complete)
3. **Phase 2 — PM:** Inventories analyzed to produce prioritized migration backlog (complete)
4. **Phase 3 — Architect:** Full Next.js architecture documented (this document, complete)
5. **Phase 4 — Stories:** Each feature converted to implementation stories with acceptance criteria
6. **Phase 5 — GSD Execution:** Stories implemented one at a time; each produces a git commit
7. **Phase 6 — Verify + Route:** After all stories for a feature pass Playwright parity tests, traffic is switched via middleware redirect

**Traffic Switching:**
Once a feature passes parity testing against both legacy and new apps:
```typescript
// src/middleware.ts
const migratedRoutes = [
  '/youth',          // ✓ verified
  '/enrollments',    // ✓ verified
  '/attendance',     // ✓ verified
  // add routes here after parity confirmed
]
```

---

*Architecture analysis: 2026-03-29*
