# Prodigy — WebForms → Next.js Migration

## Project
Migrating an ASP.NET WebForms application to Next.js 14 App Router.

## New Stack
Next.js 15 App Router · TypeScript · Tailwind · shadcn/ui
NextAuth.js · Prisma · PostgreSQL · Metabase OSS

## Agent Rules (IMMUTABLE)
- NEVER modify any file in /legacy-src
- ALWAYS check /specs/_audit/ before creating components
- New pages go in /src/app/[route]/page.tsx
- New API routes go in /src/app/api/[name]/route.ts

## Dev Server Scripts
Always use the scripts in `/scripts/` to start and stop the dev server:
- **macOS/Linux:** `./scripts/dev-server.sh start` / `stop` / `restart` / `status`
- **Windows:** `.\scripts\dev-server.ps1 start` / `stop` / `restart` / `status`
- Add `--background` (or `-b`) to run detached
- Server runs on port 3040
- Logs go to `/logs/dev-server.log` (git-ignored)
- Do NOT use bare `pnpm dev` — always use the scripts

## Architecture Decisions
- ADR-001: Reporting — SSRS → Metabase OSS
- ADR-002: Auth — Clerk (MFA enforced)

## Migration Status
### Complete
Phase 0 — Foundation (auth, schema, audit trail, infrastructure)

### In Progress
Phase 1 — Youth Registration

<!-- GSD:project-start source:PROJECT.md -->
## Project

**Prodigy**

Prodigy is an internal youth program management platform for UACDC staff. It handles youth registration, program enrollment, class/course management, attendance tracking, and grant compliance reporting. This project migrates the existing ASP.NET WebForms monolith to Next.js 15, replacing a broken enrollment-centric data model with a youth-centric model where one youth = one record, always.

**Core Value:** Every youth has exactly one record. Enrollments, attendance, and reports all trace back to that single identity — no duplicates, no paper workarounds, no corrupted grant data.

### Constraints

- **Tech stack:** Next.js 15 App Router, TypeScript, Tailwind CSS v4, shadcn/ui, Prisma, PostgreSQL, Clerk, Metabase OSS
- **Package manager:** pnpm only
- **Legacy code:** /legacy-src is read-only reference — never modify
- **Auth:** Clerk with MFA enforced for all users
- **Reporting:** Metabase OSS replaces SSRS (ADR-001)
- **Cutover:** Legacy stays live until full MVP validated and stakeholders sign off
- **Design principle:** Every decision filtered through "is this simpler than what we have today?"
<!-- GSD:project-end -->

<!-- GSD:stack-start source:codebase/STACK.md -->
## Technology Stack

## Languages
- TypeScript (strict mode) — All source code in `src/`, `scripts/`, and tests
- JavaScript — Build tooling and configuration files
- SQL — PostgreSQL queries via Prisma ORM
## Runtime
- Node.js 18+ (specified implicitly by Next.js 16 requirements)
- Runs standalone (`output: "standalone"`) behind IIS reverse proxy on Windows Server for on-premises deployment; Vercel for cloud deployment
- pnpm — Defined as the only package manager in project rules
- Lockfile: `pnpm-lock.yaml` (committed to repo)
## Frameworks
- Next.js 16.2+ App Router — Full-stack framework; all pages in `/src/app/`, API routes in `/src/app/api/`
- React 19.2 — Server Components default, Client Components for interactivity
- Prisma 5.x — Type-safe ORM for PostgreSQL; single schema file at `prisma/schema.prisma`; automatic site-scoped queries via custom extension in `src/lib/db.ts`
- Tailwind CSS v4 — Utility-first styling; config via CSS `@theme` directives in `src/app/globals.css` (no `tailwind.config.ts` needed)
- shadcn/ui v4 — Headless component library; auto-installed into `src/components/ui/` via CLI; includes Button, Card, Input, Select, Checkbox, Label, Form, Table, Badge, Toast, Alert, Dialog, Alert Dialog, Dropdown Menu, Command, Tabs, Separator, Sheet, Sidebar
- React Hook Form — Complex form management for registration/enrollment; integrates with Zod validation
- Zod — TypeScript-first schema validation; validates environment variables at startup, Server Action inputs, and form submissions
- Clerk — OAuth/OIDC provider, MFA management, user provisioning; managed entirely via Clerk API and `@clerk/nextjs` SDK; role and site metadata stored in Clerk's `publicMetadata` and synced via `user_sites` local table
- Vitest — Unit and component tests; co-located with source in `*.test.ts` files; configured in `vitest.config.ts`
- Playwright — End-to-end behavioral testing; tests in `e2e/` directory; configured in `e2e/playwright.config.ts`
- Turbopack (dev) — Hot reload and development server
- Webpack (prod) — Production bundle generation (managed by Next.js)
- ESLint — Code linting (configured during scaffold)
- Pino — Structured JSON logging to stdout; can be redirected to file or Windows Event Log
- crypto (Node.js built-in) — Application-level SSN encryption before storage in PostgreSQL
- next-themes — Light/dark theme toggle; persists user preference; attributes applied to HTML root
- next/font — Inter typeface loaded via Google Fonts API with `system-ui` fallback
## Key Dependencies
- `@clerk/nextjs` — Authentication SDK; provides middleware, hooks, and server utilities
- `@prisma/client` — ORM client; connects to PostgreSQL, applies site-scoping extension
- `prisma` (dev) — CLI for schema management, migrations, introspection
- `next` — Framework
- `react` — UI library
- `zod` — Validation; used in environment config, Server Actions, forms
- `react-hook-form` — Form state management for complex registration/enrollment forms
- `tailwindcss` — CSS utility framework
- `@tailwindcss/postcss` — PostCSS plugin for Tailwind v4
- `next-themes` — Theme persistence
- `pino` — Structured logging
- `@vitejs/plugin-react` — React support in Vitest
- `vitest` — Test runner
- `@testing-library/react` — Component testing utilities
- `@testing-library/jest-dom` — DOM matchers
- `jsdom` — DOM simulation for unit tests
- `@playwright/test` — E2E test runner
- `typescript` — Type checking
- `eslint` — Code linting
## Configuration
- `.env.local` (git-ignored, dev only) — Local development secrets and configuration
- `.env.production` (on server) — Production configuration
- `.env.example` (committed) — Template documenting all required environment variables
- Zod validation in `src/config/env.ts` — Fails fast at import time if required vars missing
- `DATABASE_URL` — PostgreSQL connection string (required)
- `CLERK_PUBLISHABLE_KEY` — Clerk SDK public key
- `CLERK_SECRET_KEY` — Clerk admin operations key
- `METABASE_URL` — Metabase OSS instance URL (for report embedding)
- `METABASE_SECRET_KEY` — JWT signing key for Metabase embed tokens
- `NODE_ENV` — `development`, `production`, or `test`
- `next.config.ts` — Next.js configuration; specifies `output: "standalone"` for Node.js deployment
- `tsconfig.json` — TypeScript strict mode, path aliases (`@/*` → `src/`)
- `vitest.config.ts` — Unit test runner setup
- `e2e/playwright.config.ts` — E2E test configuration
- `tailwind.config.ts` — May be generated by scaffold; Tailwind v4 prefers CSS-only config
- `components.json` — shadcn/ui configuration (auto-generated); specifies component output to `src/components/ui/`
- `postcss.config.js` (implicit) — PostCSS pipeline for Tailwind processing
## Platform Requirements
- Node.js 18+ with pnpm 8+
- PostgreSQL 12+ for local development (or Supabase cloud connection string)
- Clerk account (free tier supports development)
- Chrome browser for E2E tests (Playwright install via `pnpm dlx playwright install`)
- Visual Studio Code or similar IDE with TypeScript support
- Node.js 18+ runtime
- PostgreSQL 12+ on Supabase (managed cloud) or SQL Server via connection bridge
- Clerk production account
- Metabase OSS instance (runs as Java JAR on Port 3001 of UACDC-POD)
- IIS reverse proxy (on-premises Windows Server) or Vercel (cloud)
- HTTPS/TLS enabled
- **Cloud:** Vercel (recommended for Next.js)
- **On-premises:** Node.js standalone process behind IIS reverse proxy on Windows Server; future containerization via Docker optional
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

## Naming Patterns
- React components: kebab-case (e.g., `youth-registration-form.tsx`, `theme-toggle.tsx`)
- Utilities: kebab-case (e.g., `ssn-encryption.ts`, `auth.ts`, `utils.ts`)
- Page routes: `page.tsx` (Next.js App Router convention)
- API routes: kebab-case nested in `route.ts` (e.g., `/api/metabase-embed/route.ts`)
- PascalCase component names (e.g., `YouthRegistrationForm`, `AttendanceRoster`, `ThemeToggle`)
- Must be exported as default or named export
- camelCase for all functions and variables
- Server Actions: verb-first camelCase (e.g., `createYouth`, `submitAttendance`, `enrollInProgram`, `updateClass`)
- Utility functions: descriptive camelCase (e.g., `getYouthById`, `formatSSN`, `calculateTardy`)
- Prisma models: PascalCase, singular (e.g., `Youth`, `Enrollment`, `AuditLog`)
- Database tables: snake_case, plural (e.g., `youth`, `enrollments`, `audit_logs`)
- Database columns: snake_case (e.g., `first_name`, `site_id`, `created_at`)
- Foreign keys: `{referenced_table_singular}_id` (e.g., `youth_id`, `program_id`, `site_id`)
- PascalCase, singular, no prefix (e.g., `Youth`, `Enrollment`, `ActionResult` — NO `I` or `T` prefix)
- Reusable types in `src/types/`
- Component-local types co-located with component
- camelCase + `Schema` suffix (e.g., `createYouthSchema`, `attendanceSubmissionSchema`, `enrollmentFormSchema`)
- Located in `src/schemas/{domain}.ts`
- Exported as named exports
- SCREAMING_SNAKE_CASE (e.g., `DATABASE_URL`, `CLERK_SECRET_KEY`, `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`)
- Validated in `src/config/env.ts` via Zod
- SCREAMING_SNAKE_CASE for true constants (e.g., `DEFAULT_PAGE_SIZE`, `MAX_FILE_UPLOAD_SIZE`)
- camelCase for enumerated values mapped from constants (e.g., `enrollmentStatuses`, `userRoles`)
## Code Style
- ESLint configured via Next.js defaults with TypeScript support
- Prettier for consistent formatting (installed, configuration applied)
- Line length: 80 characters (soft limit for readability, hard at 100)
- Indentation: 2 spaces
- Semicolons: Required at end of statements
- ESLint enforces TypeScript strict mode
- No `any` type — use `unknown` and narrow with Zod or type guards
- All imports must be resolvable via `@/*` alias (never relative paths beyond single directory)
- `tsconfig.json` strict mode enabled
- No implicit `any` types
- Exhaustive checks on discriminated unions
- Null/undefined handling explicit
## Import Organization
- `@/*` → `src/*` (configured in `tsconfig.json` and `next.config.ts`)
- Always use alias, never relative paths like `../../`
## Error Handling
## Logging
- `info` — Normal operations (record created, page rendered)
- `warn` — Recoverable issues (duplicate detected, retry attempted)
- `error` — Failures (validation failed, database error)
- `debug` — Development only (request/response bodies, query timing) — NOT in production
- Server Action entry/exit with relevant IDs
- Database operation failures
- Authentication/authorization decisions (role checks, site scoping)
- External API calls (Metabase JWT generation, Clerk webhook receipt)
- Never log sensitive data: SSN, passwords, auth tokens
## Comments
- Complex business logic (e.g., grant year calculation, tardy detection)
- Non-obvious algorithmic choices
- Workarounds or temporary solutions
- Links to tracking issues (e.g., `// TODO: optimize query per issue #42`)
- Public functions in utilities and libraries
- Server Actions
- Complex components with multiple props
## Function Design
- Prefer objects over positional parameters when > 2 args
- Leverage destructuring for clarity
- Server Actions: Always `ActionResult<T>`
- Regular utilities: Explicit return type (no implicit any)
- Async functions: Always return Promise
## Module Design
- Default export only for React components when single export
- Named exports for everything else (actions, types, utilities, schemas)
- `src/components/ui/` — shadcn/ui components imported directly from `@/components/ui/button`, etc.
- `src/types/index.ts` — re-exports all types for convenience
- `src/lib/` — utilities imported individually by function name
## Component Patterns
- Fetched data server-side via Prisma
- Direct database access
- No hooks, no event handlers
- Can import from `@/actions/` for mutations
- Marked with `'use client'` at top
- Handle interactivity (click, form submit, search)
- Call Server Actions for mutations
- Never import Prisma or database directly
## Form Patterns
## Styling
- CSS-first configuration via `globals.css`
- No `tailwind.config.js` needed (using CSS `@theme` blocks)
- All styling via utility classes
- Import from `@/components/ui/`
- Never manually edit components in `src/components/ui/` (auto-generated by shadcn)
- Use `cn()` utility for conditional classes
## Authentication & Authorization
- Use Prisma extension in `src/lib/db.ts` for automatic site-scoped filtering
- Never manually add `WHERE` site_id filters — the extension applies them automatically
- Explicit role checks only when business logic requires different UIs (e.g., Admin dashboards)
## Database Access Patterns
## Data Mutation Patterns
- Client components call server actions
- Server actions validate input with Zod
- Server actions return `ActionResult<T>`
- Prisma audit middleware logs mutations automatically
## Special Patterns
- Encrypted at rest via `src/lib/ssn-encryption.ts`
- Only `ssn_last4` column stored plaintext (for search via last 4)
- Full SSN never logged, never sent to client except for authorized roles
- Excluded from Metabase connection
- Store as `DateTime` in Prisma (ISO 8601)
- Format for display via `Intl.DateTimeFormat` or date library
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
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

## Pattern Overview
- Spec-driven development using BMAD (Business Model Architecture Design) + GSD (Get Shit Done) hybrid methodology
- Legacy WebForms app is read-only reference; never modified during migration
- Architecture documented before implementation; all decisions recorded as ADRs in `/specs/decisions/`
- Full-stack TypeScript/Next.js with Server Components/Actions, Prisma ORM, Clerk auth, Metabase OSS reporting
- Site-scoped authorization enforced at middleware + database layer
- Column-level SSN encryption with audit logging for compliance
## Layers
- Purpose: Server-rendered pages via React Server Components, client interactivity via islands pattern
- Location: `/src/app/`
- Contains: Route handlers (page.tsx), layouts, loading/error boundaries, API routes
- Depends on: Clerk auth middleware, Server Actions in `/src/actions/`
- Used by: End users via HTTP/HTTPS
- Purpose: Enforce Clerk session, extract user role/site context, inject into request context
- Location: `/src/middleware.ts`
- Contains: Clerk middleware composition, role/site extraction from JWT
- Depends on: Clerk SDK, Prisma for role lookup
- Used by: All routes automatically; optionally extended via Prisma client extension
- Purpose: Type-safe database queries with automatic site-scoping and audit middleware
- Location: `/src/lib/db.ts` (client instance + extensions), `prisma/schema.prisma` (schema)
- Contains: Prisma client singleton, site-scoping extension (`where` clause injection), audit middleware
- Depends on: PostgreSQL on Supabase, Node.js crypto for SSN encryption
- Used by: Server Actions, Server Components, Route Handlers
- Purpose: Handle data mutations (CREATE, UPDATE, DELETE) with validation, authorization checks, and audit logging
- Location: `/src/actions/{domain}.ts` (e.g., `youth.ts`, `enrollment.ts`)
- Contains: Exported `async` functions marked `'use server'`, Zod validation, Prisma calls, error handling
- Depends on: Zod schemas (`/src/schemas/`), Prisma client, libraries in `/src/lib/`
- Used by: Client components via form submission or direct calls, never called from other Server Actions
- Purpose: Single source of truth for form validation and API input validation
- Location: `/src/schemas/{domain}.ts` (e.g., `youth.ts`, `enrollment.ts`)
- Contains: Zod schema objects with `.parse()` and `.safeParse()` methods, reusable across client and server
- Depends on: Zod library only
- Used by: Server Actions for input validation, React Hook Form for form-level validation, route handlers
- Purpose: Render interfaces, handle client-side state (forms, loading, errors), wire actions to data
- Location: `/src/components/{domain}/` for domain-specific, `/src/components/shared/` for reusable, `/src/components/ui/` for primitives
- Contains: React functional components, some marked `'use client'` for interactivity
- Depends on: shadcn/ui primitives, Tailwind CSS, React Hook Form
- Used by: Route handlers (page.tsx files)
- Purpose: Cross-cutting concerns and reusable helpers
- Location: `/src/lib/` and `/src/config/`
- Contains: SSN encryption, audit logging, Metabase JWT, grant year logic, Pino logger, auth helpers, env validation
- Depends on: Standard libraries (Node.js crypto, pino, zod)
- Used by: Server Actions, middleware, other library modules
- Purpose: Embed signed Metabase dashboards/questions in app with site-scoped data
- Location: `/src/app/reports/` (pages), `/src/api/metabase-embed/` (JWT signing), `/src/components/reports/metabase-embed.tsx`
- Contains: Report listing pages, JWT Route Handler, reusable Metabase iframe component
- Depends on: Metabase OSS instance (port 3001), PostgreSQL read-only connection
- Used by: Central Team users for dashboards (census, billing, attendance)
## Data Flow
```
```
```
```
- Server state: URL search params for filters, session data in Clerk/Middleware context
- Client state: Local React state in components (form inputs, loading flags, errors)
- Shared state: None — no global Redux/Zustand needed at this scale (< 50 users)
- Cache: Next.js built-in caching on Server Components; no Redis needed yet
## Key Abstractions
- Purpose: Standardize Server Action return values across the app
- Examples: `src/types/action-result.ts`
- Pattern: Every Server Action returns `{ success: true; data: T } | { success: false; error: string }` instead of throwing exceptions
- Usage: Enables client components to handle errors gracefully without try/catch; type-safe data extraction
- Purpose: Automatically inject `WHERE` clauses to enforce site-scoped access on every query
- Examples: Used by all routes serving Site Team/Instructor roles
- Pattern: Registered in `src/lib/db.ts` as a Prisma client extension; transparently filters queries
- Usage: Impossible to accidentally fetch cross-site data; authorization burden shifts from developer to ORM
- Purpose: Log all CUD operations on core entities (Youth, Enrollment, Attendance, etc.)
- Examples: Implemented in `src/lib/audit.ts`
- Pattern: Prisma middleware intercepts $executeRaw and model operations, captures before/after snapshots
- Usage: Compliance requirement; every user action is traceable to a Clerk user + timestamp + before-after diff
- Purpose: Encrypt SSN at application level while maintaining search-by-last-4 capability
- Examples: `src/lib/ssn-encryption.ts` exports `encryptSSN()`, `decryptSSN()`, `extractLast4()`
- Pattern: Column-level encryption via Node.js crypto; plaintext `ssn_last4` column for indexed search
- Usage: Metabase connection excludes `ssn` column; UI masks full SSN, shows only last 4
- Purpose: Derive grant year from enrollment/attendance dates; consistent between app and Metabase
- Examples: `src/lib/grant-year.ts`
- Pattern: Standalone function `computeGrantYear(date: Date): number` — grant year runs July 1 through June 30
- Usage: Called during enrollment/attendance operations and exposed to Metabase via view or stored procedure
## Entry Points
- Location: `src/app/layout.tsx`
- Triggers: Every HTTP request
- Responsibilities: Wrap app in ClerkProvider, set up global Pino logger, apply Tailwind CSS, render root error boundary
- Location: `src/middleware.ts`
- Triggers: Before every route handler
- Responsibilities: Verify Clerk session, extract user role/site, make available to route context via `getAuth()` helper
- Location: `src/app/page.tsx`
- Triggers: User navigates to `/`
- Responsibilities: Redirect to appropriate section (youth, enrollments, reports) based on user role
- Location: `src/app/youth/page.tsx` (list), `src/app/youth/new/page.tsx` (create), `src/app/youth/[youthId]/page.tsx` (detail)
- Triggers: User navigates to `/youth`, `/youth/new`, `/youth/:id`
- Responsibilities: Query youth data, render search/list/form components, wire createYouth/updateYouth actions
- Location: `src/app/enrollments/page.tsx`
- Triggers: User navigates to `/enrollments`
- Responsibilities: List enrollments filtered by site, render enrollment forms and actions
- Location: `src/app/attendance/page.tsx` (class picker), `src/app/attendance/[classId]/page.tsx` (roster)
- Triggers: Instructor navigates to attendance section
- Responsibilities: Query class roster, render attendance sign-in UI, submit attendance via Server Action
- Location: `src/app/reports/[name]/page.tsx` (e.g., census, billing, attendance)
- Triggers: User navigates to `/reports/*`
- Responsibilities: Generate Metabase JWT token, render signed iframe for dashboard
- Location: `src/app/api/health/route.ts`
- Triggers: External monitoring tools poll `/api/health`
- Responsibilities: Check database connectivity, return JSON status
- Location: `src/app/api/metabase-embed/route.ts`
- Triggers: Report page requests signed token
- Responsibilities: Verify user auth, generate JWT signed with Metabase secret, return token and embed URL
## Error Handling
- **Validation Errors:** Zod schema `.safeParse()` returns `{ success: false; error: ZodError }` — caught by Server Action, returned to client as `{ success: false; error: 'Validation failed' }`
- **Authorization Errors:** Middleware and `getAuth()` helper check role/site; return 403 Forbidden at route level or throw from Server Action, caught and returned to client
- **Database Errors:** Prisma throws on constraint violations, connection errors, etc. — caught in Server Action, logged via Pino, returned as generic error message to client
- **Route Errors:** Next.js `error.tsx` boundary per route segment catches unhandled errors and renders error page
- **Global Errors:** Root `error.tsx` catches critical errors; displays fallback UI
## Cross-Cutting Concerns
- Implementation: Pino logger in `src/lib/logger.ts`
- Pattern: Import logger, call `logger.info()`, `logger.warn()`, `logger.error()` at decision points in Server Actions and route handlers
- Output: Structured JSON to stdout, can be redirected to file or Windows Event Log on server
- Implementation: Zod schemas in `src/schemas/{domain}.ts`
- Pattern: Define schema once, use in Server Action input validation and React Hook Form for client-side feedback
- Coverage: Every Server Action input validated; forms validated in real-time
- Implementation: Clerk middleware + getAuth() helper in `src/lib/auth.ts`
- Pattern: Middleware runs first, user context available to all routes; explicit public route allowlist in middleware
- Default: All routes require authentication; public routes (login page, health check) explicitly allowed
- Implementation: Role/site checks in Server Actions and route handlers
- Pattern: Extract user role/site from Clerk via getAuth(), check against required role, filter data via Prisma extension
- Enforcement: Middleware + Prisma extension ensures no forgotten checks; anti-pattern to manually filter in queries
- Implementation: Prisma middleware in `src/lib/audit.ts`
- Pattern: Middleware automatically captures CREATE/UPDATE/DELETE on core models; stores in `audit_log` table with user/timestamp/before-after
- No manual calls needed; transparent to business logic
## Migration Sequence (Strangler Fig)
```typescript
```
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->

<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
