---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - prd.md
workflowType: 'architecture'
project_name: 'Prodigy-Migration'
user_name: 'Shane'
date: '2026-03-29'
lastStep: 8
status: 'complete'
completedAt: '2026-03-29'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
46 requirements across 7 domains. The architecture must support CRUD operations for youth, enrollments, programs/courses/classes, and attendance — all filtered through a role-based, site-scoped access model. Reporting is offloaded to Metabase OSS. A one-time data migration with identity deduplication bridges legacy SQL Server to the new PostgreSQL model.

**Non-Functional Requirements:**
- Performance: < 1.5s initial load, < 300ms navigation, < 500ms form submissions, < 3s Metabase embeds. 50 concurrent users at peak.
- Security: MFA via Clerk, role-based API-layer authorization, column-level SSN encryption, full audit trail (user/timestamp/action/before-after), HTTPS everywhere.
- Reliability: 4-hour RTO, automated backups via Supabase, best-effort uptime (no formal SLA).
- Integration: Clerk (auth), Metabase OSS (reporting), PostgreSQL/Supabase (primary store), legacy SQL Server (migration source only).

**Scale & Complexity:**
- Primary domain: Full-stack internal web application
- Complexity level: Medium
- Estimated architectural components: ~8 (auth, youth management, enrollment, attendance, program structure, reporting, audit, migration)

### Technical Constraints & Dependencies

- Next.js 16 App Router with server components/actions — shapes data fetching patterns
- Prisma ORM — dictates migration strategy, audit middleware approach, and query patterns
- Clerk — externalizes auth entirely; role/site metadata must sync from Clerk to app authorization logic
- Metabase OSS with signed JWT embedding — reporting stays out of the app codebase; requires a restricted DB connection excluding SSN columns
- PostgreSQL on Supabase — encryption at rest managed by platform; column-level SSN encryption is application responsibility
- Chrome-only, no offline, no real-time, no SEO — eliminates entire categories of architectural complexity
- Solo developer with AI — architecture must be simple enough to maintain and debug without a team

### Cross-Cutting Concerns Identified

1. **Site-scoped authorization** — every data query for Site Team/Instructor roles must filter by assigned site or class. Must be enforced at API layer consistently across all routes.
2. **Audit logging** — all CUD operations on core entities need before/after snapshots. Prisma middleware or PostgreSQL triggers — a design decision with maintenance and performance tradeoffs.
3. **SSN encryption & masking** — column-level encryption at rest, last-4 masking in UI, exclusion from Metabase. Must support search-by-last-4 without decrypting all records.
4. **Grant year computation** — derived from enrollment/attendance dates, not configured. Must be consistent across app logic and Metabase queries.

## Starter Template Evaluation

### Primary Technology Domain

Full-stack internal web application — Next.js 16 App Router with server components/actions.

### Starter Options Considered

| Option | Framework | Pros | Cons |
|--------|-----------|------|------|
| `create-next-app` | Next.js 16.2 | Current version, clean slate, no unwanted opinions | Manual setup for Prisma/Clerk/testing |
| `create-t3-app` | Next.js 15 | Full-stack typesafety, Prisma pre-wired | Behind on Next.js, includes tRPC (not needed), uses Auth.js not Clerk |
| Ixartz SaaS Boilerplate | Next.js 16 | Clerk + RBAC + testing pre-wired | Uses Drizzle not Prisma, heavy SaaS opinions to strip |

### Selected Starter: `create-next-app@latest`

**Rationale:** Cleanest foundation for a project with specific tool choices (Clerk, Prisma, Metabase) that don't align with any opinionated starter. Layering these tools onto a vanilla Next.js 16 app via their official CLIs is straightforward and avoids fighting boilerplate opinions.

**Initialization Command:**

```bash
pnpm create next-app@latest prodigy \
  --typescript --tailwind --eslint --app \
  --src-dir --import-alias="@/*" --turbopack
```

**Post-scaffold setup:**

```bash
# shadcn/ui
pnpm dlx shadcn@latest init

# Prisma
pnpm add prisma @prisma/client
pnpm dlx prisma init

# Clerk
pnpm add @clerk/nextjs

# Testing
pnpm add -D vitest @vitejs/plugin-react @testing-library/react @testing-library/jest-dom
pnpm create playwright
```

**Architectural Decisions Provided by Starter:**

- **Language & Runtime:** TypeScript (strict), React 19.2, React Compiler (stable)
- **Styling:** Tailwind CSS v4 + shadcn/ui component library
- **Build Tooling:** Turbopack (dev), Webpack (production), pnpm
- **Testing:** Vitest + React Testing Library (unit/component), Playwright (E2E)
- **Code Organization:** App Router with `src/` directory, `@/*` import alias
- **Development Experience:** Turbopack hot reload, TypeScript strict mode, ESLint

**Note:** Project initialization using this command should be the first implementation story.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- SSN encryption approach (application-level + `ssn_last4` column)
- Authorization pattern (middleware + Prisma extension for site scoping)
- Clerk metadata sync (hybrid — JWT claims + local `user_sites` table)
- API pattern (hybrid — Server Actions + Route Handlers)

**Important Decisions (Shape Architecture):**
- Audit logging via Prisma middleware
- React Hook Form + Zod for complex forms
- Node.js standalone behind IIS reverse proxy
- GitHub Actions for CI, manual deploy

**Deferred Decisions (Post-MVP):**
- Caching layer (not needed at current scale)
- Error tracking service (Sentry or similar)
- Containerization (Docker for Azure migration)
- Automated deployment pipeline

### Data Architecture

| Decision | Choice | Rationale |
|----------|--------|-----------|
| ORM | Prisma | Defined in PRD; type-safe, migration tooling, middleware support |
| Database | PostgreSQL on Supabase | Defined in PRD; managed backups, encryption at rest |
| SSN Encryption | Application-level (Node.js crypto) + plaintext `ssn_last4` column | Testable in TypeScript, `ssn_last4` enables search without decryption, Metabase connection excludes encrypted column |
| Audit Logging | Prisma middleware → `audit_log` table | Captures Clerk user ID, before/after JSON diffs, fully testable; bypass risk negligible with sole developer and read-only Metabase connection |
| Caching | None (MVP) | < 50 users, Next.js built-in caching sufficient, add Redis/similar only if metrics warrant |
| Validation | Zod | Native integration with Server Actions, Prisma, and React Hook Form |

### Authentication & Security

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Authentication | Clerk with MFA enforced | Defined in PRD; externalizes auth entirely |
| Authorization | Next.js middleware + Prisma client extension | Automatic site-scoped `WHERE` injection; impossible to forget a filter on new routes |
| Role/Site Metadata | Hybrid — Clerk `publicMetadata` (JWT) + `user_sites` table (source of truth) | Zero-latency role/site access on every request; DB is authoritative, syncs to Clerk via admin action or webhook |

### API & Communication Patterns

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Primary API Pattern | Server Actions for all app CRUD | Less boilerplate, type-safe, no external consumers |
| Route Handlers | Metabase JWT endpoint, Clerk webhooks only | Explicit HTTP endpoints only where needed |
| Error Handling | Typed result objects (`{ success, data/error }`) | Predictable, no try/catch in client components |
| Validation | Zod schemas shared between client and server | Single source of truth for form + API validation |

### Frontend Architecture

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State Management | None — React built-ins + URL search params | No global client state needed; data from server, forms local, filters in URL |
| Form Handling | React Hook Form + Zod (complex forms), native forms (simple) | Youth registration needs multi-field form management; attendance submission is simple |
| Component Library | shadcn/ui + Tailwind CSS v4 | Defined in PRD; accessible, composable, customizable |
| Rendering | Server Components default, Client Components for interactivity | App Router convention; minimize client JS bundle |

### Infrastructure & Deployment

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Hosting | Node.js standalone (`output: "standalone"`) behind IIS reverse proxy on Windows Server | Simplest path for current infrastructure; no Docker overhead |
| Future Hosting | Azure App Service (when ready to migrate) | Containerize at migration time, not before |
| CI/CD | GitHub Actions (test + build), manual deploy | Automated testing as safety net; manual deploy avoids Windows Server remote access complexity |
| Environment Config | `.env.local` (dev) + `.env.production` (server) + Zod validation at startup | Fail-fast on missing config; git-ignored secrets |
| Logging | Pino (structured JSON to stdout) | Fast, parseable, redirectable to file or Windows Event Log |
| Health Check | `/api/health` endpoint | Simple uptime monitoring without external services |
| Error Tracking | Deferred to post-MVP | Structured logs sufficient at current scale; add Sentry if needed |

### Decision Impact Analysis

**Implementation Sequence:**
1. Scaffold Next.js 16 + Prisma + Clerk + shadcn/ui (starter template)
2. Define Prisma schema with `ssn_last4` column and `audit_log` table
3. Implement Clerk middleware + Prisma extension for site-scoped auth
4. Build Server Actions with Zod validation and typed result objects
5. Wire React Hook Form for registration/enrollment forms
6. Set up Metabase JWT Route Handler
7. Configure Prisma audit middleware
8. Set up GitHub Actions CI pipeline
9. Configure IIS reverse proxy on Windows Server

**Cross-Component Dependencies:**
- Clerk session → middleware → Prisma extension (auth chain must be established first)
- Zod schemas shared across Server Actions, React Hook Form, and env validation
- Audit middleware depends on Clerk user context being available in Prisma operations
- Metabase JWT endpoint depends on Clerk auth middleware for access control

## Implementation Patterns & Consistency Rules

### Naming Patterns

| Area | Convention | Example |
|------|-----------|---------|
| DB tables | snake_case, plural | `youth`, `enrollments`, `audit_logs` |
| DB columns | snake_case | `first_name`, `site_id`, `created_at` |
| Foreign keys | `{referenced_table_singular}_id` | `youth_id`, `program_id` |
| Prisma models | PascalCase, singular | `Youth`, `Enrollment`, `AuditLog` |
| Files (components) | kebab-case | `youth-registration-form.tsx` |
| Files (utilities) | kebab-case | `ssn-encryption.ts` |
| React components | PascalCase | `YouthRegistrationForm`, `AttendanceRoster` |
| Functions/variables | camelCase | `getYouthById`, `enrollmentStatus` |
| Server Actions | camelCase, verb-first | `createYouth`, `submitAttendance`, `enrollInProgram` |
| Route Handlers | `/api/kebab-case` | `/api/metabase-embed`, `/api/clerk-webhook` |
| Zod schemas | camelCase + `Schema` suffix | `createYouthSchema`, `attendanceSubmissionSchema` |
| Types/Interfaces | PascalCase, no prefix | `Youth`, `Enrollment` (no `I` or `T` prefix) |
| Environment vars | SCREAMING_SNAKE_CASE | `DATABASE_URL`, `CLERK_SECRET_KEY` |

### Structure Patterns

| Area | Convention |
|------|-----------|
| Tests | Co-located: `youth-search.test.ts` next to `youth-search.ts` |
| Components | Feature-based: `src/components/youth/`, `src/components/attendance/` |
| Server Actions | `src/actions/{domain}.ts` — e.g., `src/actions/youth.ts`, `src/actions/enrollment.ts` |
| Zod schemas | `src/schemas/{domain}.ts` — shared between actions and forms |
| Prisma | `prisma/schema.prisma` (single file), `src/lib/db.ts` (client instance + extensions) |
| Shared utilities | `src/lib/` — e.g., `src/lib/ssn-encryption.ts`, `src/lib/audit.ts` |
| Types | `src/types/` for shared types, co-located for component-specific types |
| Config | `src/config/` — e.g., `src/config/env.ts` (Zod-validated env), `src/config/constants.ts` |

### Format Patterns

| Area | Convention | Example |
|------|-----------|---------|
| Server Action return | `ActionResult<T>` type | `{ success: true, data: Youth } \| { success: false, error: string }` |
| Dates in DB | `DateTime` (Prisma/PostgreSQL native) | `2026-03-29T14:30:00.000Z` |
| Dates in UI | Formatted via `Intl.DateTimeFormat` | `March 29, 2026` |
| JSON fields | camelCase (Prisma default) | `{ firstName, lastName, siteId }` |
| Null handling | Explicit nulls, never `undefined` in DB | Prisma handles this naturally |
| IDs | cuid2 (Prisma default for `@default(cuid())`) | `clx1abc2d0001...` |

### Process Patterns

| Area | Convention |
|------|-----------|
| Loading states | Next.js `loading.tsx` files per route segment |
| Error boundaries | Next.js `error.tsx` files per route segment |
| Not found | Next.js `not-found.tsx` files |
| Form errors | Display inline via React Hook Form `errors` object |
| Server Action errors | Return in `ActionResult`, display via toast (shadcn/ui) for global errors |
| Auth protection | Clerk middleware protects all routes by default; public routes explicitly allowed |
| Logging | Pino logger: `info` for operations, `warn` for recoverable issues, `error` for failures |
| Audit entries | Prisma middleware auto-logs; no manual audit calls needed in business logic |

### Enforcement Guidelines

**All AI Agents MUST:**
- Follow the naming conventions above — no exceptions, no creative variations
- Place files in the correct directory per the structure patterns
- Return `ActionResult<T>` from every Server Action
- Use Zod schemas for all form validation and Server Action input validation
- Never bypass the Clerk middleware or Prisma extension for site scoping
- Use `src/lib/db.ts` for all database access (never create a new Prisma client)
- Co-locate tests with the code they test

**Anti-Patterns (Never Do This):**
- Creating a new `PrismaClient()` instance outside `src/lib/db.ts`
- Manual site filtering in individual queries (use the Prisma extension)
- Throwing exceptions from Server Actions (return `ActionResult` instead)
- Using `any` type — use `unknown` and narrow with Zod
- Storing dates as strings in the database
- Putting business logic in React components (belongs in Server Actions or `src/lib/`)

## Project Structure & Boundaries

### Complete Project Directory Structure

```
prodigy/
├── .github/
│   └── workflows/
│       └── ci.yml                          # GitHub Actions: test + build
├── prisma/
│   ├── schema.prisma                       # Single schema file — all models
│   ├── migrations/                         # Prisma-managed migrations
│   └── seed.ts                             # Lookup data seeding + dev data
├── public/
│   └── favicon.ico
├── src/
│   ├── app/
│   │   ├── globals.css                     # Tailwind base styles
│   │   ├── layout.tsx                      # Root layout (ClerkProvider, Pino)
│   │   ├── loading.tsx                     # Root loading state
│   │   ├── error.tsx                       # Root error boundary
│   │   ├── not-found.tsx                   # 404 page
│   │   ├── page.tsx                        # Dashboard / home
│   │   ├── sign-in/[[...sign-in]]/
│   │   │   └── page.tsx                    # Clerk sign-in
│   │   ├── sign-up/[[...sign-up]]/
│   │   │   └── page.tsx                    # Clerk sign-up
│   │   ├── youth/
│   │   │   ├── page.tsx                    # Youth list/search (FR3, FR5)
│   │   │   ├── loading.tsx
│   │   │   ├── new/
│   │   │   │   └── page.tsx               # Youth registration form (FR1, FR2)
│   │   │   └── [youthId]/
│   │   │       ├── page.tsx               # Youth detail/edit (FR4)
│   │   │       ├── enrollments/
│   │   │       │   └── page.tsx           # Youth's enrollments (FR7, FR12)
│   │   │       └── guardians/
│   │   │           └── page.tsx           # Guardian management (FR2)
│   │   ├── enrollments/
│   │   │   ├── page.tsx                    # Enrollment list (FR8, FR11)
│   │   │   └── loading.tsx
│   │   ├── attendance/
│   │   │   ├── page.tsx                    # Class selection for attendance
│   │   │   └── [classId]/
│   │   │       └── page.tsx               # Attendance roster + tap-to-mark (FR14-FR16)
│   │   ├── programs/
│   │   │   ├── page.tsx                    # Program list (FR19)
│   │   │   ├── new/
│   │   │   │   └── page.tsx               # Create program
│   │   │   └── [programId]/
│   │   │       ├── page.tsx               # Program detail/edit (FR20)
│   │   │       └── courses/
│   │   │           ├── page.tsx           # Courses in program (FR20)
│   │   │           └── [courseId]/
│   │   │               └── classes/
│   │   │                   └── page.tsx   # Classes in course (FR21-FR23)
│   │   ├── reports/
│   │   │   ├── page.tsx                    # Report index
│   │   │   ├── census/
│   │   │   │   └── page.tsx               # Metabase embed — census (FR25)
│   │   │   ├── billing/
│   │   │   │   └── page.tsx               # Metabase embed — billing (FR26)
│   │   │   └── attendance/
│   │   │       └── page.tsx               # Metabase embed — attendance (FR27)
│   │   ├── admin/
│   │   │   ├── page.tsx                    # Admin dashboard
│   │   │   ├── users/
│   │   │   │   └── page.tsx               # User management (FR32-FR34)
│   │   │   └── lookups/
│   │   │       └── page.tsx               # Lookup data management (FR41-FR43)
│   │   └── api/
│   │       ├── health/
│   │       │   └── route.ts               # Health check endpoint
│   │       ├── metabase-embed/
│   │       │   └── route.ts               # Metabase JWT signing (FR25-FR27)
│   │       └── clerk-webhook/
│   │           └── route.ts               # Clerk webhook handler
│   ├── actions/
│   │   ├── youth.ts                        # createYouth, updateYouth, searchYouth
│   │   ├── guardian.ts                     # createGuardian, updateGuardian
│   │   ├── enrollment.ts                   # enrollYouth, transferEnrollment, releaseEnrollment
│   │   ├── attendance.ts                   # submitAttendance
│   │   ├── program.ts                      # createProgram, updateProgram
│   │   ├── course.ts                       # createCourse, updateCourse
│   │   ├── class.ts                        # createClass, updateClass, assignInstructor
│   │   └── lookup.ts                       # createLookup, updateLookup
│   ├── components/
│   │   ├── ui/                             # shadcn/ui components (auto-generated)
│   │   ├── youth/
│   │   │   ├── youth-registration-form.tsx
│   │   │   ├── youth-search.tsx
│   │   │   ├── youth-detail-card.tsx
│   │   │   └── guardian-form.tsx
│   │   ├── enrollment/
│   │   │   ├── enrollment-form.tsx
│   │   │   ├── enrollment-list.tsx
│   │   │   └── enrollment-status-badge.tsx
│   │   ├── attendance/
│   │   │   ├── attendance-roster.tsx        # Mobile-optimized tap-to-mark
│   │   │   └── class-selector.tsx
│   │   ├── programs/
│   │   │   ├── program-form.tsx
│   │   │   ├── course-form.tsx
│   │   │   └── class-form.tsx
│   │   ├── reports/
│   │   │   └── metabase-embed.tsx          # Reusable Metabase iframe wrapper
│   │   ├── admin/
│   │   │   ├── user-management.tsx
│   │   │   └── lookup-editor.tsx
│   │   └── shared/
│   │       ├── data-table.tsx              # Reusable table component
│   │       ├── search-input.tsx
│   │       ├── site-filter.tsx
│   │       └── confirm-dialog.tsx
│   ├── schemas/
│   │   ├── youth.ts                        # createYouthSchema, updateYouthSchema
│   │   ├── guardian.ts
│   │   ├── enrollment.ts
│   │   ├── attendance.ts
│   │   ├── program.ts
│   │   ├── course.ts
│   │   ├── class.ts
│   │   └── lookup.ts
│   ├── lib/
│   │   ├── db.ts                           # Prisma client + site-scoping extension
│   │   ├── auth.ts                         # Clerk helpers, role/site extraction
│   │   ├── ssn-encryption.ts               # Encrypt/decrypt + last4 extraction
│   │   ├── audit.ts                        # Prisma audit middleware
│   │   ├── metabase.ts                     # JWT token generation for embeds
│   │   ├── grant-year.ts                   # Grant year computation logic
│   │   ├── logger.ts                       # Pino logger instance
│   │   └── utils.ts                        # cn() and general utilities
│   ├── types/
│   │   ├── action-result.ts                # ActionResult<T> type definition
│   │   ├── auth.ts                         # Role, SiteScope, UserSession types
│   │   └── index.ts                        # Re-exports
│   ├── config/
│   │   ├── env.ts                          # Zod-validated environment variables
│   │   └── constants.ts                    # App-wide constants (roles, statuses)
│   └── middleware.ts                        # Clerk auth + role/site context injection
├── e2e/
│   ├── playwright.config.ts
│   ├── youth-registration.spec.ts          # E2E: registration flow
│   ├── attendance.spec.ts                  # E2E: attendance workflow
│   ├── enrollment.spec.ts                  # E2E: enrollment workflow
│   └── fixtures/
│       └── test-data.ts
├── scripts/
│   └── migrate-legacy.ts                   # One-time SQL Server → PostgreSQL migration (FR44-FR46)
├── .env.local                              # Local dev (git-ignored)
├── .env.example                            # Template with all required vars
├── .gitignore
├── components.json                         # shadcn/ui config
├── next.config.ts
├── tailwind.config.ts
├── tsconfig.json
├── vitest.config.ts
├── package.json
└── pnpm-lock.yaml
```

### Architectural Boundaries

**API Boundaries:**
- Clerk → `src/middleware.ts` → all routes (auth boundary)
- Client components → Server Actions in `src/actions/` (data mutation boundary)
- Server Components → Prisma via `src/lib/db.ts` (data read boundary)
- Metabase → PostgreSQL read-only connection (reporting boundary — SSN columns excluded)
- Route Handlers: `/api/metabase-embed` (JWT signing), `/api/clerk-webhook` (user sync), `/api/health` (monitoring)

**Data Flow:**
```
User → Clerk Auth → Middleware (role/site extraction)
  → Server Component (reads via Prisma + site-scoping extension)
  → Client Component (renders UI)
  → Server Action (validates with Zod, writes via Prisma)
  → Prisma Audit Middleware (logs to audit_log)
  → PostgreSQL
```

**Component Boundaries:**
- `src/components/ui/` — shadcn/ui primitives, never modified directly
- `src/components/{domain}/` — domain-specific components, import from `ui/` and `shared/`
- `src/components/shared/` — reusable app components (data table, search, filters)
- Components never import from `src/actions/` directly — pages wire actions to components via props

### Requirements to Structure Mapping

| FR Domain | Routes | Actions | Components | Schemas |
|-----------|--------|---------|------------|---------|
| Youth Management (FR1-6) | `src/app/youth/` | `src/actions/youth.ts`, `guardian.ts` | `src/components/youth/` | `src/schemas/youth.ts`, `guardian.ts` |
| Enrollment (FR7-13) | `src/app/enrollments/`, `src/app/youth/[id]/enrollments/` | `src/actions/enrollment.ts` | `src/components/enrollment/` | `src/schemas/enrollment.ts` |
| Attendance (FR14-18) | `src/app/attendance/` | `src/actions/attendance.ts` | `src/components/attendance/` | `src/schemas/attendance.ts` |
| Programs/Courses/Classes (FR19-24) | `src/app/programs/` | `src/actions/program.ts`, `course.ts`, `class.ts` | `src/components/programs/` | `src/schemas/program.ts`, `course.ts`, `class.ts` |
| Reporting (FR25-30) | `src/app/reports/` | — (Metabase handles) | `src/components/reports/` | — |
| Auth & Roles (FR31-36) | `src/app/admin/users/` | — (Clerk handles) | `src/components/admin/` | — |
| Security & Audit (FR37-40) | — (cross-cutting) | — (middleware) | — | — |
| Lookups (FR41-43) | `src/app/admin/lookups/` | `src/actions/lookup.ts` | `src/components/admin/` | `src/schemas/lookup.ts` |
| Migration (FR44-46) | — | — | — | `scripts/migrate-legacy.ts` |

### Cross-Cutting Concerns Mapping

| Concern | Files |
|---------|-------|
| Site-scoped auth | `src/middleware.ts`, `src/lib/db.ts` (Prisma extension), `src/lib/auth.ts` |
| Audit logging | `src/lib/audit.ts` (Prisma middleware), registered in `src/lib/db.ts` |
| SSN encryption | `src/lib/ssn-encryption.ts`, used in `src/actions/youth.ts` |
| Grant year computation | `src/lib/grant-year.ts`, used in reporting queries and Metabase |
| Error handling | `ActionResult<T>` in `src/types/action-result.ts`, `error.tsx` per route |
| Logging | `src/lib/logger.ts` (Pino), imported where needed |

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility:** All technology choices (Next.js 16, Prisma, Clerk, shadcn/ui, Metabase, Pino, Zod, React Hook Form) are actively maintained, mutually compatible, and have no known conflicts at their current versions.

**Pattern Consistency:** Naming conventions follow ecosystem standards per layer (snake_case DB, camelCase JS, PascalCase React, kebab-case files). `ActionResult<T>` and Zod validation applied uniformly across all Server Actions. Site-scoping enforced via a single Prisma extension, not per-query.

**Structure Alignment:** Feature-based directory organization maps 1:1 to FR domains. All cross-cutting concerns (`src/lib/`) are centralized and referenced from domain-specific code. Boundaries are clear between UI components, Server Actions, and data access.

### Requirements Coverage ✅

**Functional Requirements (FR1-FR46):** All 46 requirements have explicit architectural support — mapped to specific routes, actions, components, schemas, and library modules.

**Non-Functional Requirements:** Performance targets achievable with Server Components + Supabase at < 50 users. Security fully addressed via Clerk MFA, middleware-enforced authorization, application-level SSN encryption, and Prisma audit middleware. Reliability covered by Supabase managed backups and health endpoint.

### Implementation Readiness ✅

**Decision Completeness:** All critical and important decisions documented with rationale. Technology versions verified via web search. Deferred decisions explicitly listed with rationale.

**Structure Completeness:** Full project tree defined with every file and directory. FR-to-structure mapping table provides explicit traceability.

**Pattern Completeness:** Naming, structure, format, and process patterns cover all identified conflict points. Enforcement guidelines and anti-patterns documented.

### Gap Analysis Results

**Critical Gaps:** None identified.

**Important Notes:**
- CLAUDE.md ADR-002 references "NextAuth.js" but should be updated to "Clerk" per PRD and architectural decisions
- Grant year computation must be kept consistent between `src/lib/grant-year.ts` and Metabase SQL — document the formula in one place and reference it from both

**Minor Notes:**
- `e2e/` directory is outside `src/` per Playwright convention — agents should not move it
- `prisma/seed.ts` is sufficient for dev environment seeding at MVP scale

### Architecture Completeness Checklist

**✅ Requirements Analysis**
- [x] Project context thoroughly analyzed
- [x] Scale and complexity assessed (medium, < 50 users)
- [x] Technical constraints identified (Chrome-only, no offline, no real-time)
- [x] Cross-cutting concerns mapped (site auth, audit, SSN, grant year)

**✅ Architectural Decisions**
- [x] Critical decisions documented with rationale
- [x] Technology stack fully specified with versions
- [x] Integration patterns defined (Clerk, Metabase, Supabase)
- [x] Performance considerations addressed

**✅ Implementation Patterns**
- [x] Naming conventions established for all layers
- [x] Structure patterns defined (feature-based, co-located tests)
- [x] Format patterns specified (ActionResult, dates, IDs)
- [x] Process patterns documented (loading, errors, auth, logging)

**✅ Project Structure**
- [x] Complete directory structure defined
- [x] Component boundaries established
- [x] Integration points mapped
- [x] Requirements-to-structure mapping complete

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION

**Confidence Level:** High

**Key Strengths:**
- Youth-centric data model eliminates the core legacy problem (duplicate records)
- Site-scoped authorization via Prisma extension prevents data leaks by design
- Externalized auth (Clerk) and reporting (Metabase) keep the app codebase focused
- Simple deployment model (Node.js standalone) matches current infrastructure
- Every FR has a clear home in the project structure

**Areas for Future Enhancement:**
- Caching layer if performance metrics warrant (post-MVP)
- Error tracking service (Sentry) when structured logs aren't sufficient
- Docker containerization when Azure migration is ready
- Automated deployment pipeline when manual deploys become tedious

### Implementation Handoff

**AI Agent Guidelines:**
- Follow all architectural decisions exactly as documented
- Use implementation patterns consistently across all components
- Respect project structure and boundaries
- Refer to this document for all architectural questions
- When in doubt about a pattern, check the Enforcement Guidelines section

**First Implementation Priority:**
```bash
pnpm create next-app@latest prodigy \
  --typescript --tailwind --eslint --app \
  --src-dir --import-alias="@/*" --turbopack
```
