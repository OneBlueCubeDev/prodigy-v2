# Codebase Structure

**Analysis Date:** 2026-03-29

## Directory Layout

```
prodigy-migration/
├── legacy-src/                              # ASP.NET WebForms app (READ ONLY)
│   ├── POD/                                 # Main WebForms app with pages
│   │   ├── Pages/                           # .aspx pages and code-behind
│   │   ├── App_Data/                        # Configuration and data files
│   │   ├── App_Themes/                      # CSS themes
│   │   ├── Templates/                       # Master pages and user controls
│   │   ├── Login.aspx                       # Login page
│   │   └── Global.asax                      # Application startup
│   ├── POD.Data/                            # Data access layer (static methods)
│   ├── POD.Logic/                           # Business logic layer (static methods)
│   ├── POD.Azure/                           # Azure-specific utilities
│   ├── POD.Logging/                         # Logging implementation
│   ├── POD Database/                        # Database setup scripts
│   └── 3rdParty/                            # Third-party libraries (Telerik, etc.)
│
├── src/                                     # Next.js 16 App Router (NEW)
│   ├── app/                                 # Routes and pages
│   │   ├── layout.tsx                       # Root layout with ClerkProvider
│   │   ├── page.tsx                         # Home/dashboard
│   │   ├── sign-in/[[...sign-in]]/page.tsx # Clerk sign-in page
│   │   ├── sign-up/[[...sign-up]]/page.tsx # Clerk sign-up page
│   │   ├── youth/                           # Youth management routes
│   │   │   ├── page.tsx                     # Youth list/search
│   │   │   ├── new/page.tsx                 # Youth registration form
│   │   │   └── [youthId]/                   # Individual youth routes
│   │   │       ├── page.tsx                 # Youth detail/edit
│   │   │       ├── enrollments/page.tsx     # Youth's enrollments
│   │   │       └── guardians/page.tsx       # Guardian management
│   │   ├── enrollments/                     # Enrollment management
│   │   │   └── page.tsx                     # Enrollment list
│   │   ├── attendance/                      # Attendance routes
│   │   │   ├── page.tsx                     # Class picker
│   │   │   └── [classId]/page.tsx           # Attendance roster + sign-in
│   │   ├── programs/                        # Program/course/class management
│   │   │   ├── page.tsx                     # Program list
│   │   │   ├── new/page.tsx                 # Create program
│   │   │   └── [programId]/                 # Program details
│   │   │       ├── page.tsx                 # Program detail/edit
│   │   │       └── courses/                 # Courses in program
│   │   │           └── [courseId]/classes/page.tsx
│   │   ├── reports/                         # Reporting pages (Metabase embeds)
│   │   │   ├── page.tsx                     # Report index
│   │   │   ├── census/page.tsx              # Census dashboard
│   │   │   ├── billing/page.tsx             # Billing dashboard
│   │   │   └── attendance/page.tsx          # Attendance dashboard
│   │   ├── admin/                           # Admin routes
│   │   │   ├── page.tsx                     # Admin dashboard
│   │   │   ├── users/page.tsx               # User management
│   │   │   └── lookups/page.tsx             # Lookup data management
│   │   ├── api/                             # API routes
│   │   │   ├── health/route.ts              # Health check
│   │   │   ├── metabase-embed/route.ts      # Metabase JWT signing
│   │   │   └── clerk-webhook/route.ts       # Clerk webhook handler
│   │   ├── globals.css                      # Tailwind base styles
│   │   ├── loading.tsx                      # Root loading state
│   │   ├── error.tsx                        # Root error boundary
│   │   └── not-found.tsx                    # 404 page
│   │
│   ├── actions/                             # Server Actions (data mutations)
│   │   ├── youth.ts                         # createYouth, updateYouth, searchYouth
│   │   ├── guardian.ts                      # createGuardian, updateGuardian
│   │   ├── enrollment.ts                    # enrollYouth, transferEnrollment, releaseEnrollment
│   │   ├── attendance.ts                    # submitAttendance
│   │   ├── program.ts                       # createProgram, updateProgram
│   │   ├── course.ts                        # createCourse, updateCourse
│   │   ├── class.ts                         # createClass, updateClass, assignInstructor
│   │   └── lookup.ts                        # createLookup, updateLookup
│   │
│   ├── components/                          # React components
│   │   ├── ui/                              # shadcn/ui primitives (auto-generated)
│   │   │   ├── button.tsx
│   │   │   ├── input.tsx
│   │   │   ├── form.tsx
│   │   │   ├── dialog.tsx
│   │   │   ├── select.tsx
│   │   │   ├── table.tsx
│   │   │   ├── toast.tsx
│   │   │   └── ... (other shadcn components)
│   │   │
│   │   ├── youth/                           # Youth domain components
│   │   │   ├── youth-registration-form.tsx
│   │   │   ├── youth-search.tsx
│   │   │   ├── youth-detail-card.tsx
│   │   │   ├── guardian-form.tsx
│   │   │   └── duplicate-detection.tsx
│   │   │
│   │   ├── enrollment/                      # Enrollment domain components
│   │   │   ├── enrollment-form.tsx
│   │   │   ├── enrollment-list.tsx
│   │   │   └── enrollment-status-badge.tsx
│   │   │
│   │   ├── attendance/                      # Attendance domain components
│   │   │   ├── attendance-roster.tsx        # Mobile-optimized sign-in UI
│   │   │   └── class-selector.tsx
│   │   │
│   │   ├── programs/                        # Program domain components
│   │   │   ├── program-form.tsx
│   │   │   ├── course-form.tsx
│   │   │   └── class-form.tsx
│   │   │
│   │   ├── reports/                         # Reporting components
│   │   │   └── metabase-embed.tsx           # Reusable Metabase iframe wrapper
│   │   │
│   │   ├── admin/                           # Admin components
│   │   │   ├── user-management.tsx
│   │   │   └── lookup-editor.tsx
│   │   │
│   │   └── shared/                          # Reusable app components
│   │       ├── data-table.tsx               # Reusable table component
│   │       ├── search-input.tsx
│   │       ├── site-filter.tsx
│   │       ├── confirm-dialog.tsx
│   │       └── navbar.tsx
│   │
│   ├── schemas/                             # Zod validation schemas
│   │   ├── youth.ts                         # createYouthSchema, updateYouthSchema
│   │   ├── guardian.ts
│   │   ├── enrollment.ts
│   │   ├── attendance.ts
│   │   ├── program.ts
│   │   ├── course.ts
│   │   ├── class.ts
│   │   └── lookup.ts
│   │
│   ├── lib/                                 # Shared utilities and libraries
│   │   ├── db.ts                            # Prisma client singleton + site-scoping extension
│   │   ├── auth.ts                          # Clerk helpers, role/site extraction
│   │   ├── ssn-encryption.ts                # Encrypt/decrypt SSN, extract last4
│   │   ├── audit.ts                         # Prisma audit middleware
│   │   ├── metabase.ts                      # Metabase JWT token generation
│   │   ├── grant-year.ts                    # Grant year computation (July-June)
│   │   ├── logger.ts                        # Pino logger instance
│   │   └── utils.ts                         # cn() helper, general utilities
│   │
│   ├── types/                               # TypeScript types and interfaces
│   │   ├── action-result.ts                 # ActionResult<T> type definition
│   │   ├── auth.ts                          # Role, SiteScope, UserSession types
│   │   └── index.ts                         # Re-exports
│   │
│   ├── config/                              # Configuration
│   │   ├── env.ts                           # Zod-validated environment variables
│   │   └── constants.ts                     # App-wide constants (roles, statuses)
│   │
│   └── middleware.ts                        # Clerk auth + role/site context injection
│
├── prisma/                                  # Prisma ORM
│   ├── schema.prisma                        # Single schema file — all models, enums
│   ├── migrations/                          # Prisma-managed schema migrations
│   └── seed.ts                              # Lookup data + dev data seeding
│
├── e2e/                                     # Playwright E2E tests
│   ├── playwright.config.ts                 # Playwright configuration
│   ├── youth-registration.spec.ts           # E2E: registration flow parity test
│   ├── enrollment.spec.ts                   # E2E: enrollment workflow parity test
│   ├── attendance.spec.ts                   # E2E: attendance sign-in parity test
│   └── fixtures/
│       └── test-data.ts                     # Shared test data and helpers
│
├── specs/                                   # Migration specifications and planning
│   ├── _audit/                              # BMAD Analyst phase output
│   │   ├── 01-page-inventory.md             # All 55 .aspx pages inventoried
│   │   ├── 02-service-inventory.md          # Service analysis (none found)
│   │   ├── 03-report-inventory.md           # All SSRS reports inventoried
│   │   ├── 04-background-jobs.md            # Background job analysis
│   │   └── pages.xml, services.xml, reports.xml, config.xml  # Repomix exports
│   │
│   ├── _migration-map/                      # BMAD Architect phase output
│   │   └── architecture.md                  # Full Next.js architecture document
│   │
│   ├── decisions/                           # Architecture Decision Records
│   │   ├── ADR-001.md                       # Reporting: SSRS → Metabase OSS
│   │   ├── ADR-002.md                       # Auth: Forms Auth → Clerk
│   │   └── (more ADRs as needed)
│   │
│   └── features/                            # Per-feature migration specs
│       ├── [feature-name]/
│       │   ├── migration-spec.md            # User stories and acceptance criteria
│       │   └── stories/
│       │       ├── 01-api-route.md          # API layer story
│       │       ├── 02-page-component.md     # UI layer story
│       │       └── 03-playwright-test.md    # Test story
│       └── (one dir per feature, created as features enter Phase 4)
│
├── scripts/                                 # Utility scripts
│   └── migrate-legacy.ts                    # One-time SQL Server → PostgreSQL migration
│
├── _bmad-output/                            # BMAD planning artifacts (reference only)
│   ├── planning-artifacts/
│   │   ├── prd.md                           # Product Requirements Document
│   │   ├── architecture.md                  # Full architecture analysis
│   │   ├── epics.md                         # Epic breakdown and story estimation
│   │   ├── ux-design-specification.md       # UI/UX requirements
│   │   └── (other planning docs)
│   └── implementation-artifacts/            # Generated during implementation
│
├── .github/                                 # GitHub configuration
│   ├── workflows/
│   │   ├── ci.yml                           # GitHub Actions: test + build
│   │   └── playwright.yml                   # Playwright parity tests on PR
│   └── copilot-instructions.md              # GitHub Copilot context
│
├── public/                                  # Static assets
│   └── favicon.ico
│
├── CLAUDE.md                                # Agent memory (kept current with status)
├── MIGRATION.md                             # Migration process and principles
├── .env.example                             # Environment variables template
├── .env.local                               # Local dev (git-ignored)
├── .gitignore                               # Git exclusions
├── components.json                          # shadcn/ui configuration
├── next.config.ts                           # Next.js configuration
├── tailwind.config.ts                       # Tailwind CSS configuration
├── tsconfig.json                            # TypeScript configuration
├── vitest.config.ts                         # Vitest configuration
├── package.json                             # npm/pnpm dependencies
└── pnpm-lock.yaml                           # Locked dependency versions
```

---

## Directory Purposes

**legacy-src/:**
- Purpose: Read-only reference implementation of the ASP.NET WebForms app
- Contains: 76 .aspx pages, 13 logic layer classes, 14 data layer classes, Telerik RadControls, Entity Framework
- Key files: `POD/Pages/` (all pages), `POD.Logic/` (business logic), `POD.Data/` (data access)
- **RULE:** Never modify any file in this directory; it is the source of truth for parity testing

**src/ (App Router):**
- Purpose: New Next.js 16 application; built incrementally during migration phases
- Contains: Routes, Server Components, Server Actions, React components, schemas, libraries
- Key structure: `/app/` for pages, `/actions/` for mutations, `/components/` for UI, `/schemas/` for validation
- **Expected at completion:** Mirrors legacy app functionality via TypeScript + modern patterns

**specs/_audit/:**
- Purpose: Analyst phase output; inventories of legacy app structure
- Contains: 55 pages inventoried (`01-page-inventory.md`), services analyzed (`02-service-inventory.md`), SSRS reports (`03-report-inventory.md`), background jobs (`04-background-jobs.md`)
- **Read** before starting implementation; provides risk tier, business logic summary, and SessionState/ViewState inventory
- **Generated by:** BMAD Analyst running Repomix exports through analysis

**specs/_migration-map/:**
- Purpose: Architect phase output; canonical reference for implementation
- Contains: `architecture.md` — full project structure, naming conventions, design decisions, requirements-to-code mapping
- **Read** before writing any code; all implementation follows decisions documented here
- **Reference:** CLAUDE.md links to this when agent context is needed

**specs/decisions/:**
- Purpose: Architecture Decision Records (ADRs)
- Contains: ADR-001 (Reporting), ADR-002 (Auth), and future ADRs for deferred decisions
- **Read** before implementing features that depend on decisions (e.g., Metabase integration before building /reports/)
- **Pattern:** Each ADR numbered, dated, includes context + decision + rationale

**specs/features/:**
- Purpose: Per-feature migration specifications
- Contains: Directories per feature (e.g., `youth-management/`, `attendance-workflow/`), each with `migration-spec.md` and `/stories/`
- **Created during:** Phase 4 (Scrum Master); populated as PM prioritizes features
- **Structure:** One directory per low/medium/high-risk tier feature from the PRD

**_bmad-output/:**
- Purpose: Reference artifacts from BMAD planning process (read-only)
- Contains: PRD, architecture analysis, epics, UX designs, parity testing guidance
- **Used by:** Implementation teams for context; archived for post-launch documentation

**prisma/:**
- Purpose: ORM schema and migrations
- Contains: Single `schema.prisma` file with all models (Youth, Enrollment, Attendance, etc.), enums (Role, Status), and relations
- Key files: `schema.prisma` (source of truth), `migrations/` (history), `seed.ts` (dev data)
- **Database:** PostgreSQL on Supabase; `DATABASE_URL` env var points to connection string

**e2e/:**
- Purpose: End-to-end parity tests using Playwright
- Contains: Test specs for major workflows (registration, enrollment, attendance), fixtures with test data
- **Trigger:** Runs on every PR via GitHub Actions; must pass before feature is marked complete
- **Target:** Tests both legacy and new apps to verify parity before traffic switch

---

## Key File Locations

**Entry Points:**
- `src/app/layout.tsx` — Root layout with ClerkProvider, logger setup, global CSS
- `src/middleware.ts` — Auth + role/site extraction; runs before every request
- `src/app/page.tsx` — Home/dashboard; role-based redirect to appropriate section
- `src/app/sign-in/[[...sign-in]]/page.tsx` — Clerk sign-in page (public)
- `src/app/api/health/route.ts` — Health check endpoint for monitoring

**Configuration:**
- `.env.local` — Local development secrets (git-ignored)
- `src/config/env.ts` — Zod-validated environment variables (DATABASE_URL, CLERK_SECRET_KEY, etc.)
- `src/config/constants.ts` — App-wide constants (Role enum, Status enum, etc.)
- `next.config.ts` — Next.js build configuration (output: "standalone" for production)
- `tsconfig.json` — TypeScript strict mode, path aliases (@/* → src/*)
- `tailwind.config.ts` — Tailwind customizations
- `components.json` — shadcn/ui CLI configuration

**Core Logic:**
- `src/actions/` — All Server Actions (youth.ts, enrollment.ts, etc.)
- `src/lib/db.ts` — Prisma client singleton + site-scoping extension
- `src/lib/auth.ts` — getAuth() helper, role checks, user context extraction
- `src/lib/ssn-encryption.ts` — SSN encrypt/decrypt/extract-last4
- `src/lib/audit.ts` — Prisma middleware for audit logging
- `prisma/schema.prisma` — Entire data model in one file

**UI Components:**
- `src/components/ui/` — shadcn/ui component library (auto-generated by shadcn CLI)
- `src/components/{domain}/` — Domain-specific components (youth/, enrollment/, attendance/, etc.)
- `src/components/shared/` — Reusable components (data-table, search-input, site-filter)

**Validation:**
- `src/schemas/` — Zod schemas per domain (youth.ts, enrollment.ts, etc.)
- Each schema file exports `createXSchema`, `updateXSchema`, etc.

**Testing:**
- `e2e/` — Playwright E2E tests; run via `npx playwright test`
- `e2e/playwright.config.ts` — Playwright configuration (baseURL, timeout, reporters)
- `e2e/fixtures/` — Shared test data and helpers

**Migration Artifacts:**
- `MIGRATION.md` — Process documentation and principles (this is the spec)
- `CLAUDE.md` — Agent memory; kept current with ADR approvals, phase status
- `specs/_audit/` — Analyst output (read before implementation)
- `specs/_migration-map/architecture.md` — Full architecture reference
- `scripts/migrate-legacy.ts` — One-time SQL Server → PostgreSQL data migration

---

## Naming Conventions

**Files:**
- Pages: `page.tsx` (next.js convention; location determines route)
- Route handlers: `route.ts` (next.js convention)
- Components: `kebab-case.tsx` (e.g., `youth-registration-form.tsx`)
- Utilities: `kebab-case.ts` (e.g., `ssn-encryption.ts`)
- Tests: `kebab-case.test.ts` or `kebab-case.spec.ts` (co-located next to source)

**Directories:**
- Feature domains: `kebab-case` (e.g., `src/components/youth/`, `src/actions/youth.ts`)
- Route segments: `kebab-case` or `[brackets]` for dynamic (e.g., `/youth/[youthId]/`)
- Utilities: `lib/`, `config/`, `types/` (flat, not per-domain)
- API routes: `/api/kebab-case` (e.g., `/api/metabase-embed`, `/api/clerk-webhook`)

**React Components:**
- PascalCase (e.g., `YouthRegistrationForm`, `AttendanceRoster`)
- Files use kebab-case (e.g., `src/components/youth/youth-registration-form.tsx` exports `YouthRegistrationForm`)

**Functions/Variables:**
- camelCase (e.g., `getYouthById()`, `enrollmentStatus`, `userRole`)
- Server Actions: verb-first, camelCase (e.g., `createYouth()`, `submitAttendance()`, `enrollInProgram()`)

**Database:**
- Tables: snake_case, plural (e.g., `youth`, `enrollments`, `audit_logs`)
- Columns: snake_case (e.g., `first_name`, `site_id`, `created_at`)
- Foreign keys: `{table_singular}_id` (e.g., `youth_id`, `program_id`)
- Prisma models: PascalCase, singular (e.g., `Youth`, `Enrollment`, `AuditLog`)

**Environment Variables:**
- SCREAMING_SNAKE_CASE (e.g., `DATABASE_URL`, `CLERK_SECRET_KEY`, `METABASE_URL`)

**Zod Schemas:**
- File: `{domain}.ts` (e.g., `src/schemas/youth.ts`)
- Exports: `createYouthSchema`, `updateYouthSchema` (verb + model + "Schema" suffix)

---

## Where to Add New Code

**New Page (Route):**
- Create `src/app/{path}/page.tsx` (location determines route)
- Use Server Component by default; wrap interactive parts with `'use client'` boundary
- Call Server Actions for mutations; pass as props to interactive components

**New Feature Component:**
- Create `src/components/{domain}/{component-name}.tsx`
- PascalCase component export, kebab-case filename
- Import shadcn/ui and shared components as needed
- Avoid importing Server Actions directly; receive via props

**New Server Action:**
- Add to `src/actions/{domain}.ts` (or create if new domain)
- Mark with `'use server'` directive
- Validate input with Zod schema
- Return `ActionResult<T>` (never throw exceptions)
- Log operations via Pino logger
- Mutations automatically audit-logged by Prisma middleware

**New Zod Schema:**
- Create or edit `src/schemas/{domain}.ts`
- Export named schemas: `createXSchema`, `updateXSchema`, `searchXSchema`, etc.
- Use in Server Actions for input validation
- Use in React Hook Form for client-side feedback

**New Database Model:**
- Edit `prisma/schema.prisma`
- Add model with full field list, relations, indexes
- Run `pnpm prisma migrate dev` to generate migration
- Add seed data to `prisma/seed.ts` if needed for development

**New Utility:**
- Add to `src/lib/{name}.ts` (e.g., `ssn-encryption.ts`, `grant-year.ts`)
- Document via TSDoc comments
- Export functions that are reusable across actions/components

**New API Route (explicit HTTP):**
- Create `src/app/api/{name}/route.ts`
- Use only for: Metabase JWT signing, Clerk webhooks, health checks
- All app CRUD uses Server Actions, not route handlers

**New Test:**
- Co-locate with source: `src/components/youth/youth-registration-form.test.ts` next to `youth-registration-form.tsx`
- Use Vitest + React Testing Library for unit tests
- Use Playwright for E2E tests in `e2e/` directory

---

## Special Directories

**prisma/migrations/:**
- Purpose: Prisma-managed SQL migration history
- Generated: Automatically by `pnpm prisma migrate dev`
- Committed: Yes — enables team/server to apply same schema changes
- **Rule:** Never edit migration files manually; use `prisma migrate dev` to generate new migrations

**node_modules/ (pnpm):**
- Purpose: Installed dependencies
- Generated: By `pnpm install` from pnpm-lock.yaml
- Committed: No — only commit pnpm-lock.yaml
- **Rule:** Reproduce via `pnpm install` on fresh clone

**.env files:**
- `.env.local` — Local development (git-ignored, not committed)
- `.env.example` — Template showing required variables (committed)
- `.env.production` — Production secrets on server only (not in git)

**.next/ and .turbo/:**
- Purpose: Next.js build artifacts and Turbopack cache
- Generated: By `pnpm dev` and `pnpm build`
- Committed: No — in `.gitignore`

---

## Git Branching Strategy

- `main` — Deployed to production; protected branch
- Feature branches — `feature/[story-id]` or `feature/[domain]` per story implementation
- Create PR after each GSD story completes; merge after parity testing passes

---

*Structure analysis: 2026-03-29*
