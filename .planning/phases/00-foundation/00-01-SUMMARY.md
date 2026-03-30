---
phase: 00-foundation
plan: 01
subsystem: infrastructure
tags: [scaffold, prisma, clerk, typescript, next.js]
dependency_graph:
  requires: []
  provides:
    - Next.js 16 project scaffold
    - Prisma 7 schema with all Phase 0-4 models
    - Prisma db singleton with site-scoping and audit extensions
    - Clerk proxy.ts middleware
    - SSN encryption utilities (AES-256-GCM)
    - Grant year computation utility
    - Zod env validation
    - Health check endpoint
  affects:
    - All subsequent plans (00-02, 00-03, 00-04)
    - Phase 1 (Youth), Phase 2 (Programs), Phase 3 (Enrollment), Phase 4 (Attendance)
tech_stack:
  added:
    - Next.js 16.2.1 (App Router)
    - Prisma 7.6.0 (ORM, PostgreSQL)
    - @clerk/nextjs 7.0.7 (Auth + MFA)
    - Zod 4.3.6 (validation)
    - Pino 10.3.1 (structured logging)
    - Tailwind CSS 4.2.2 (styling)
    - Vitest 4.1.2 + @playwright/test 1.58.2 (testing)
    - clsx + tailwind-merge (class utilities)
  patterns:
    - Prisma singleton on globalThis (hot-reload safe)
    - Prisma $extends for site-scoping and audit logging
    - Lazy import in audit.ts to break circular dependency with db.ts
    - AES-256-GCM with prepended IV+tag for SSN encryption
    - Zod v4 env validation (fails fast at import)
    - Prisma 7 datasource URL in prisma.config.ts (not schema.prisma)
key_files:
  created:
    - package.json
    - pnpm-lock.yaml
    - next.config.ts
    - tsconfig.json
    - prisma/schema.prisma
    - prisma.config.ts
    - proxy.ts
    - .env.example
    - src/app/layout.tsx
    - src/app/page.tsx
    - src/app/api/health/route.ts
    - src/config/env.ts
    - src/lib/db.ts
    - src/lib/auth.ts
    - src/lib/audit.ts
    - src/lib/ssn-encryption.ts
    - src/lib/grant-year.ts
    - src/lib/logger.ts
    - src/lib/utils.ts
    - src/types/action-result.ts
    - src/types/globals.d.ts
    - src/types/index.ts
  modified:
    - .gitignore (added Next.js, env file, and Prisma entries)
decisions:
  - "Prisma 7 (not 6 as documented in research) was installed — url moved to prisma.config.ts per new Prisma 7 API"
  - "proxy.ts exports clerkMiddleware directly rather than wrapper function (type-safe, simpler)"
  - "audit.ts uses Prisma.JsonNull instead of null for Json fields (Prisma 7 strict typing)"
  - "Lazy import in audit.ts for basePrisma breaks db.ts <-> audit.ts circular dependency"
metrics:
  duration_minutes: 10
  completed_date: "2026-03-30"
  tasks_completed: 3
  files_created: 34
---

# Phase 00 Plan 01: Foundation Scaffold Summary

Next.js 16 project scaffolded with Prisma 7, Clerk v7 auth, AES-256-GCM SSN encryption, and all core infrastructure utilities (db singleton with audit extension, env validation, grant year, health check endpoint, proxy middleware).

## What Was Built

### Task 1 — Next.js 16 Scaffold
- Created Next.js 16.2.1 project with TypeScript strict mode, Tailwind v4, App Router, `src/` directory
- Installed all production deps: `@clerk/nextjs`, `prisma`, `@prisma/client`, `zod`, `pino`, `next-themes`, `lucide-react`, `clsx`, `tailwind-merge`
- Installed all dev deps: `vitest`, `@playwright/test`, `@testing-library/*`, `dotenv`
- Configured `next.config.ts` with `output: 'standalone'` for IIS reverse proxy deployment
- Updated `src/app/layout.tsx` to wrap app with `ClerkProvider` and Inter font
- Updated `src/app/page.tsx` to redirect to `/select-program`
- Created `.env.example` documenting all required env vars
- Updated `.gitignore` with Next.js, env file, and Prisma entries

### Task 2 — Prisma Schema
- Created full schema with 15 models spanning all 4 application phases
- Phase 0: `AuditLog`, `UserSite`
- Lookup tables (LOOK-02): `Site`, `Race`, `Ethnicity`, `Gender`, `EnrollmentType`, `EnrollmentStatus`
- Phase 2 (Programs): `Program`, `ProgramSite`, `Course`, `CourseInstance`, `ClassSession`
- Phase 1 (Youth): `Youth` with encrypted `ssn` and plaintext `ssn_last4` fields
- Phase 3 (Enrollment): `Enrollment` with status tracking and grant year
- Phase 4 (Attendance): `AttendanceRecord` with sign-in/out times
- Schema validates cleanly with Prisma 7 (`pnpm prisma validate`)
- Prisma client generated to `@prisma/client`

### Task 3 — Core Infrastructure Utilities
- `src/types/action-result.ts` — `ActionResult<T>` discriminated union
- `src/types/globals.d.ts` — `Role` type and `CustomJwtSessionClaims` for Clerk RBAC
- `src/config/env.ts` — Zod v4 env validation, fails fast at import if vars missing
- `src/lib/logger.ts` — Pino structured JSON logger (debug dev, info prod)
- `src/lib/audit.ts` — `logAuditEvent` with type-safe helpers (`extractWhere`, `extractRecordId`), no `any` types
- `src/lib/db.ts` — Prisma singleton on `globalThis`, `createScopedDb(siteId)`, `db` with audit extension
- `src/lib/auth.ts` — `checkRole`, `getAuthContext`, `requireAuth` using Clerk `auth()`
- `src/lib/ssn-encryption.ts` — `encryptSSN`, `decryptSSN`, `extractLast4` (AES-256-GCM)
- `src/lib/grant-year.ts` — `computeGrantYear` (grant year starts July 1)
- `src/lib/utils.ts` — `cn()` with clsx + tailwind-merge
- `src/app/api/health/route.ts` — GET health check, DB connectivity via `SELECT 1`, 200/503
- `proxy.ts` — Clerk middleware protecting all routes except `/sign-in(.*)`, `/sign-up(.*)`, `/api/health`

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Prisma 7 uses prisma.config.ts for datasource URL**
- **Found during:** Task 2
- **Issue:** Research documented Prisma 6.x API where `url = env("DATABASE_URL")` is in `schema.prisma`. Installed version is Prisma 7.6.0 which moved datasource URL to `prisma.config.ts`
- **Fix:** Removed `url = env("DATABASE_URL")` from `schema.prisma` datasource block; `prisma.config.ts` was auto-generated by `prisma init` with the correct Prisma 7 format
- **Files modified:** `prisma/schema.prisma`, `prisma.config.ts`
- **Commit:** 255e37f

**2. [Rule 1 - Bug] proxy.ts clerkMiddleware wrapper caused TypeScript error**
- **Found during:** Task 3 (TypeScript check)
- **Issue:** Research pattern showed `clerkMiddleware(...)(request)` wrapper with only 1 arg but `NextMiddleware` requires `(request, event)` — 2 args
- **Fix:** Export `clerkMiddleware(handler)` directly as the default export — no wrapper function needed. This is the canonical Clerk v7 usage
- **Files modified:** `proxy.ts`
- **Commit:** eec2406

**3. [Rule 1 - Bug] Prisma 7 strict JSON null typing in audit.ts**
- **Found during:** Task 3 (TypeScript check)
- **Issue:** `null` is not assignable to `NullableJsonNullValueInput | InputJsonValue | undefined` in Prisma 7's strict type system
- **Fix:** Use `Prisma.JsonNull` from `@prisma/client` for nullable JSON fields
- **Files modified:** `src/lib/audit.ts`
- **Commit:** eec2406

## Known Stubs

None — this plan is pure infrastructure with no UI or data-rendering components.

## Commits

| Task | Commit | Message |
|------|--------|---------|
| 1 | fc5999f | feat(00-01): scaffold Next.js 16 with all dependencies |
| 2 | 255e37f | feat(00-01): create Prisma schema with all Phase 0-4 models |
| 3 | eec2406 | feat(00-01): implement core infrastructure utilities |

## Requirements Satisfied

| ID | Description | Status |
|----|-------------|--------|
| AUTH-01 | Clerk auth + MFA enforcement | Infrastructure ready — Clerk SDK installed, ClerkProvider in layout, proxy.ts protecting routes |
| AUTH-02 | Three roles: Admin, Central, Site | `checkRole()` and `getAuthContext()` implemented in `src/lib/auth.ts` |
| AUTH-04 | Server Actions call `auth()` independently | `requireAuth()` helper implemented; pattern established |
| INFRA-01 | Database audit trail | Prisma audit extension in `db.ts` calls `logAuditEvent` on all writes |
| INFRA-02 | Audit trail active from day 1 | AuditLog model in schema, extension registered before any code runs |
| INFRA-03 | SSN encryption at rest | AES-256-GCM in `ssn-encryption.ts` |
| INFRA-05 | Health check endpoint | `/api/health` returns `{ status: 'ok' }` with DB check |
| LOOK-02 | Lookup tables | Site, Race, Ethnicity, Gender, EnrollmentType, EnrollmentStatus in schema |

## Self-Check: PASSED

All 10 key files verified to exist on disk. All 3 task commits (fc5999f, 255e37f, eec2406) confirmed in git log.
