# Project Research Summary

**Project:** Prodigy — ASP.NET WebForms to Next.js Migration
**Domain:** Internal youth program management platform (UACDC staff-facing, < 50 users)
**Researched:** 2026-03-29
**Confidence:** HIGH

## Executive Summary

Prodigy is an internal staff tool for managing a grant-funded youth program. The migration is not a
1:1 rewrite — it is a deliberate data model correction. The legacy system's defining flaw is that
youth identity is fused with enrollment records, meaning re-enrollment creates duplicate person
records and corrupts longitudinal compliance data. The new system inverts this: `Youth` is a
permanent, stable identity; `Enrollment` is a separate event hanging off that identity. Every
architectural and feature decision in this project flows from that single correction. Build the
youth-centric model first and everything else follows naturally. Deviate from it and you will
reproduce exactly the problems the migration exists to solve.

The recommended stack is well-suited to the problem and the team size. Next.js 15 with Clerk,
Prisma 6, PostgreSQL (Neon), Tailwind v4, and shadcn/ui is a modern, stable combination with
strong official documentation. The one architecture decision still requiring stakeholder input is
Metabase: the OSS tier is free and capable for grant compliance reports, but the React embedding
SDK requires a paid plan ($500/month). For an internal tool where staff can navigate directly to
a standalone Metabase URL, the OSS tier is almost certainly sufficient. This decision must be made
before the reporting phase begins.

The primary risks are not technical — they are data integrity and compliance risks. Duplicate youth
records in the migration, grant year computation divergence between the app and Metabase, and a
big-bang cutover without verified data parity are all pitfalls that cannot be fixed after the fact.
The mitigation for every one of them is the same: establish the canonical behavior early (Phase 1),
encode it as a shared utility, and run reconciliation scripts before committing to cutover.

---

## Key Findings

### Recommended Stack

The stack is straightforward for 2026 Next.js development. The key constraint is version discipline:
stay on Next.js 15.x (not 16 — breaking changes, ecosystem still catching up), Prisma 6.x (not 7
— major config restructure), and ensure Next.js is pinned at or above 15.2.3 to patch
CVE-2025-29927. The `CLAUDE.md` file currently lists NextAuth.js for auth — this is incorrect per
PROJECT.md; Clerk is the right choice and satisfies MFA + RBAC requirements with far less custom
code. **Update CLAUDE.md accordingly.**

**Core technologies:**
- **Next.js 15.x**: Full-stack React framework — App Router + Server Components is the right pattern for server-side data access; stay on 15.2.4+, not 16
- **Clerk**: Auth, MFA, RBAC — enforces MFA app-wide from dashboard, handles three-role RBAC via `publicMetadata`, free for < 50 users
- **Prisma 6.x**: Database ORM — type-safe queries, migration tooling, audit middleware via `$extends()` (not deprecated `$use()`)
- **PostgreSQL 16+ (Neon)**: Primary data store — managed branching for dev/staging, excellent Prisma support, audit trigger-compatible
- **Tailwind v4 + shadcn/ui**: Styling + components — CSS-first config, zero runtime overhead, WAI-ARIA compliant; follow official v4 migration path
- **Metabase OSS (Docker)**: Reporting — replaces SSRS; OSS tier = standalone URL access (free); embedded React SDK = Pro plan ($500/mo, not recommended)
- **zod + react-hook-form + next-safe-action**: Validation and forms — shared schemas between client and server, type-safe Server Actions
- **Playwright**: E2E parity tests — gate for big-bang cutover sign-off
- **pnpm 10.x**: Package manager — mandated by PROJECT.md, non-negotiable

### Expected Features

The critical path is: Auth → Lookup data → Youth registration → Enrollment → Classes → Attendance →
Reports. Every feature upstream blocks every feature downstream. The audit trail must be live from
the first youth record created — retrofitting it is painful and may leave compliance gaps.

**Must have (table stakes) — blocking grant compliance or core operations:**
- MFA authentication with three-role RBAC (Admin, Central, Site) — prerequisite to everything
- Lookup/reference data management — prerequisite to all forms
- Youth registration with inline duplicate detection — must be clean from day 1
- Program enrollment lifecycle (active, transfer, release, rollover) — core operational record
- Class/course management (Program → Course → CourseInstance → Class hierarchy)
- Mobile-first attendance tracking for classes and events — eliminate paper clipboard
- Youth attendance history view — compliance read access
- Database audit trail on all CUD operations — non-negotiable, funder compliance
- Grant compliance reports: Census, Billing, Attendance (via Metabase OSS)
- Staff management with site assignments — drives data visibility

**Should have (differentiators — valuable but not blocking cutover):**
- Youth-centric data model (no enrollment-fused identity) — this is the architectural core; it must be in MVP, it is not optional
- Enrollment rollover (grant year transition without re-entry) — staff pain point
- Metabase self-service reporting — removes IT dependency for report variants
- Playwright behavioral parity tests — confidence gate for cutover
- Lesson plan management with approval workflow — grant-required but complex; can paper-bridge short term
- PAT (Program Assessment Tool) form — dynamic, program-specific; can paper-bridge
- Risk assessment per enrollment — grant-required in some programs; can paper-bridge

**Defer (post-launch / v2+):**
- Inventory management — not in Active requirements
- Certificate/document generation — niche, not blocking
- Technical support ticketing — use email/Slack

**Never build (anti-features):**
Parent portal, payment processing, public registration, native app, legacy SQL Server integration,
dual-run/gradual rollout, 1:1 legacy feature parity for broken workflows.

### Architecture Approach

The app is organized around a clean domain boundary model with three enforcement layers for
authorization (Clerk middleware, Server Action `auth()` checks, Prisma site-scoping extension). No
single layer is sufficient alone. Server Components handle data fetching; Client Components handle
interactivity as islands; Server Actions handle all mutations; Route Handlers are reserved for
Metabase JWT signing, Clerk webhooks, and health checks only. There is no global state store —
data flows from database through Server Components as props.

**Major components:**
1. **Middleware** (`src/middleware.ts`) — Clerk session verification, role extraction; routes only, not authorization enforcement
2. **Youth Domain** (`src/app/youth/`, `src/actions/youth.ts`) — Core entity; all other domains reference `youth_id`
3. **Enrollment Domain** (`src/app/enrollments/`, `src/actions/enrollment.ts`) — Decoupled from identity; re-enrollment = new row, never new youth record
4. **Program Structure** (`src/app/programs/`) — Four-level hierarchy: Program → Course → CourseInstance → Class
5. **Attendance Domain** (`src/app/attendance/`) — Mobile-optimized; bulk upsert pattern; `(classId, youthId)` unique pairs
6. **Reporting** (`src/app/reports/`, `src/app/api/metabase-embed/`) — Signed JWT iframe or standalone Metabase URL; SSN column excluded from Metabase DB user
7. **Audit Layer** (`src/lib/audit.ts`) — Single `audit_log` table via Prisma `$extends()`; replaces legacy 18-table trigger system
8. **Data Access** (`src/lib/db.ts`) — Prisma singleton with site-scoping extension; never instantiate `PrismaClient` elsewhere

### Critical Pitfalls

1. **Enrollment-centric identity model** — Do not put `programId` or `siteId` on the `Youth` model. `Youth` is the identity anchor; `Enrollment` holds program participation. Write a schema test: "Youth can exist with zero enrollments." Failure to get this right in Phase 1 means every subsequent phase builds on a broken foundation.

2. **Grant year computation divergence** — The app must have a canonical `computeGrantYear(date)` function (July 1 boundary, no hardcoded years). Metabase SQL must call this as a PostgreSQL function, not reimplement it. A youth enrolled July 15 must appear in the same grant year in both the app and every compliance report.

3. **Middleware-only authorization (CVE-2025-29927)** — Never rely on `src/middleware.ts` alone for RBAC. Every Server Action must call `auth()` independently. Stay on Next.js >= 15.2.3 (patched). Prisma site-scoping extension is a second enforcement layer, not an optional optimization.

4. **Deprecated `prisma.$use()` for audit logging** — This API was removed in Prisma 6. Use `prisma.$extends()` only. Audit logging that silently stops recording is a compliance failure that may not be detected until a funder audit.

5. **Big-bang cutover without data parity verification** — Keep legacy running read-only for 30 days post-cutover. Run census and attendance reports in both systems before cutover. Count differences > 2% per program per grant year must halt cutover. Playwright parity tests are a hard gate, not advisory.

---

## Implications for Roadmap

Based on the dependency graph and pitfall analysis, 7 phases are suggested. The ordering is forced
by data dependencies — no feature at a later phase can be meaningfully built before the phases it
depends on are stable.

### Phase 1: Foundation and Infrastructure
**Rationale:** Every Server Action, every route, every audit log entry depends on this scaffolding. Building it once correctly means every subsequent feature inherits consistent auth, audit, and data access patterns. This is also where the most critical pitfalls live — the wrong patterns established here propagate everywhere.
**Delivers:** Working Next.js 15 app, Prisma schema skeleton (Youth, Site, lookup tables), Clerk middleware, site-scoping extension, audit middleware via `$extends()`, SSN encryption utilities, `ActionResult<T>` type, Zod env validation, `computeGrantYear()` utility, dev database, IIS reverse proxy configuration
**Addresses:** Auth (table stakes), lookup data foundations, audit trail (must be on from day 1)
**Avoids:** Pitfall 1 (enrollment-centric identity — design Youth model correctly here), Pitfall 4 (CVE-2025-29927 — middleware-only auth), Pitfall 5 (deprecated `$use()` API), Pitfall 7 (SSN plaintext), Pitfall 8 (direct PrismaClient instantiation)
**Research flag:** Standard patterns — well-documented Next.js + Clerk + Prisma setup; no deep research needed

### Phase 2: Youth Registration
**Rationale:** `Youth` is the root entity. Every downstream feature — enrollment, attendance, reports — references `youth_id`. The Youth model must be stable and correct before anything is built against it.
**Delivers:** Youth registration form (demographics, guardian, contacts, SSN-masked), search with duplicate detection (name + DOB + SSN last 4), youth detail page, youth list with role-scoped filtering
**Addresses:** Youth registration (table stakes), duplicate detection (differentiator)
**Avoids:** Pitfall 7 (SSN in logs), Pitfall 8 (site scoping on all reads and writes)
**Research flag:** Standard patterns — form + Server Action pattern is established in Phase 1

### Phase 3: Program Structure
**Rationale:** Enrollment requires a `programId`. Attendance requires a `classId`. Both must exist before enrollment or attendance can be built.
**Delivers:** Program CRUD (admin-only), Course CRUD, CourseInstance CRUD (site-scoped, per grant period), Class CRUD with instructor assignment
**Addresses:** Class/course management (table stakes)
**Avoids:** Pitfall 4 (RBAC on admin-only operations)
**Research flag:** Standard patterns — basic admin CRUD with Prisma

### Phase 4: Enrollment
**Rationale:** Depends on Youth (Phase 2) and Programs (Phase 3). Grant year computation belongs here because it is set at enrollment time and must be correct before attendance records are created against it.
**Delivers:** Enrollment form with `computeGrantYear()` applied at admission, status transitions (active/released/transferred), enrollment rollover workflow, enrollment list and detail views
**Addresses:** Program enrollment lifecycle (table stakes), enrollment rollover (differentiator)
**Avoids:** Pitfall 11 (ViewState-replacement — use URL params for multi-step enrollment wizard, not just `useState`), Pitfall 14 (grant year on enrollment date, not attendance date)
**Research flag:** Needs attention — enrollment rollover logic is complex and must not create duplicate youth records; recommend dedicated story for rollover workflow design before coding

### Phase 5: Attendance Tracking
**Rationale:** Depends on Youth (Phase 2) and Class structure (Phase 3). Enrollment (Phase 4) provides the roster definition. This is the highest-impact UX improvement — replacing paper clipboards.
**Delivers:** Mobile-optimized class attendance roster (large tap targets, single-tap present/absent/tardy), bulk upsert Server Action, attendance history view per youth, event-based attendance
**Addresses:** Attendance tracking — class and event (table stakes), mobile-first UX (differentiator)
**Avoids:** Pitfall 13 (concurrent submission race condition — unique constraint on `(classId, sessionDate)` + `submitted` flag)
**Research flag:** Standard patterns — bulk upsert + optimistic UI is well-documented

### Phase 6: Reporting (Metabase Integration)
**Rationale:** Metabase dashboards query data from Phases 2–5. Building reporting before data exists produces empty dashboards and makes query logic impossible to validate.
**Delivers:** Metabase Docker setup with read-only PostgreSQL user (SSN column excluded), Metabase JWT signing utility, `/api/metabase-embed` Route Handler, report pages for Census, Billing, Attendance dashboards, grant year PostgreSQL function exposed to Metabase
**Addresses:** Grant compliance reports — Census, Billing, Attendance (table stakes), self-service reporting (differentiator)
**Avoids:** Pitfall 2 (grant year divergence — Metabase calls shared PostgreSQL function), Pitfall 9 (Metabase secret key in env only, never source code)
**Research flag:** Needs attention — stakeholder must decide embedded iframe vs standalone Metabase URL before this phase starts; this decision changes the architecture of the reporting module

### Phase 7: Admin, Polish, and Migration
**Rationale:** User management is operational infrastructure that can use seeded dev users during development. Playwright parity tests require the full feature set. Data migration runs once before cutover. All of this is last-mile work that cannot begin until the feature set is complete.
**Delivers:** Staff management UI with Clerk webhook sync, role and site assignment UI, lookup data editor, Playwright E2E parity test suite, data migration script (SQL Server → PostgreSQL) with deduplication review workflow, reconciliation scripts for cutover validation
**Addresses:** Staff management (table stakes), Playwright parity tests (differentiator), MFA/auth (table stakes — admin user management)
**Avoids:** Pitfall 3 (migration merges wrong records — SSN as primary match key, name+DOB requires human review), Pitfall 12 (big-bang cutover without parity verification)
**Research flag:** Needs attention — data migration deduplication strategy must be designed and reviewed by UACDC staff before any migration code runs; the `ShowDuplicateStudents.aspx` legacy page is the starting point for understanding the known duplicate population

### Phase Ordering Rationale

- **Foundation before features** — auth, audit, and data access must be correct before any feature writes its first row; retrofitting audit logging or site-scoping is expensive and leaves gaps
- **Identity before participation** — Youth (Phase 2) is the root entity; Enrollment (Phase 4) hangs off it; this ordering prevents the enrollment-centric model from creeping back in
- **Structure before attendance** — you cannot take attendance for a class that doesn't exist; Program/Course/Class (Phase 3) must precede Attendance (Phase 5)
- **Data before reports** — Metabase (Phase 6) must have real data to validate against; an empty Metabase dashboard confirms nothing
- **Features before migration** — the data migration (Phase 7) requires a stable schema target; migrating to a schema that is still changing causes rework

### Research Flags

Phases likely needing deeper research or design work during planning:
- **Phase 4 (Enrollment rollover):** The grant year rollover workflow is complex and touches the core youth-centric model; a dedicated story for workflow design is recommended before any implementation starts
- **Phase 6 (Metabase reporting):** Stakeholder decision required on embedded iframe vs standalone URL before phase begins; this changes the architecture and may affect Phase 0 infrastructure choices (port allocation, Docker networking)
- **Phase 7 (Data migration):** Deduplication review workflow must be designed with UACDC staff participation; the migration script must produce a human-readable review report before any merges are committed

Phases with standard patterns (can skip dedicated research):
- **Phase 1 (Foundation):** Next.js 15 + Clerk + Prisma setup is well-documented via official sources; STACK.md has exact install commands
- **Phase 2 (Youth registration):** Form + Server Action pattern is established by Phase 1 scaffolding; follows standard Next.js App Router patterns
- **Phase 3 (Program structure):** Basic admin CRUD with role-scoped Prisma queries; no novel patterns
- **Phase 5 (Attendance):** Bulk upsert + optimistic UI is a well-documented React/Next.js pattern

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | MEDIUM-HIGH | Next.js 15 and Tailwind v4 + shadcn/ui confirmed via official docs (HIGH); Clerk pricing should be verified at clerk.com/pricing before go-live (MEDIUM); Prisma 6 vs 7 decision verified via official changelog (HIGH) |
| Features | HIGH | Grounded in actual legacy audit (55 pages, 13 logic classes), PROJECT.md requirements, and regulatory sources; not based on assumptions |
| Architecture | HIGH | Derived from actual legacy SQL schema files and completed BMAD architectural decisions; component boundaries confirmed against real stored procedure analysis |
| Pitfalls | HIGH | Grounded in actual legacy code (udfGrantYear.sql, spGetCensusReportData.sql, EnrollmentPage.aspx.cs); not hypothetical; CVE-2025-29927 confirmed via official security advisory |

**Overall confidence:** HIGH

### Gaps to Address

- **Metabase embed vs standalone (BLOCKER for Phase 6):** Stakeholder must decide whether reports are embedded in the Next.js UI (iframe with "Powered by Metabase" watermark, OSS) or accessed via standalone Metabase URL. This affects Phase 6 architecture and potentially Phase 0 infrastructure setup. Resolve before roadmap is finalized.
- **PostgreSQL hosting (resolve before Phase 1):** Neon (managed, branching, free tier) vs self-hosted PostgreSQL. Neon is recommended; confirm infra budget and ops preference with team.
- **Clerk pricing confirmation (resolve before go-live):** Free tier MAU limit was raised in 2026 but published figures are inconsistent. Verify at clerk.com/pricing. Prodigy's 50-user footprint should be permanently free; confirm this before committing to Clerk.
- **Prisma audit trigger pattern (validate in Phase 1):** Prisma 6 does not generate database triggers. The 18-table legacy audit requirement is satisfied by Prisma `$extends()` middleware writing to a single `audit_log` table. Confirm this pattern satisfies any external compliance audit requirements before Phase 1 is marked complete.
- **CLAUDE.md auth correction (immediate):** CLAUDE.md currently lists `NextAuth.js` as the auth solution (ADR-002). All research and PROJECT.md specify Clerk. CLAUDE.md should be updated before any development begins to prevent agent confusion.

---

## Sources

### Primary (HIGH confidence)
- `/legacy-src/POD Database/dbo/Tables/*.sql` — Actual legacy schema analysis (Persons, Enrollments, ClassAttendances, Students)
- `/legacy-src/POD Database/dbo/Functions/udfGrantYear.sql` — Canonical grant year logic
- `/legacy-src/POD Database/dbo/Stored Procedures/spGetCensusReportData.sql` — Census report join logic
- `/legacy-src/POD/Pages/EnrollmentPage.aspx.cs` — ViewState usage patterns
- `/specs/_audit/01-page-inventory.md` — 55-page legacy audit
- `/specs/_audit/02-service-inventory.md` — Logic class inventory
- `/specs/_audit/03-report-inventory.md` — SSRS report inventory
- `.planning/PROJECT.md` — Validated requirements and constraints
- `_bmad-output/planning-artifacts/architecture.md` — BMAD architectural decisions
- [Next.js 15 release notes](https://nextjs.org/blog/next-15)
- [shadcn/ui Tailwind v4 migration](https://ui.shadcn.com/docs/tailwind-v4)
- [Prisma 7 announcement and breaking changes](https://www.prisma.io/blog/announcing-prisma-orm-7-0-0)
- [Metabase static embedding docs](https://www.metabase.com/docs/latest/embedding/static-embedding)
- [CVE-2025-29927 Next.js middleware bypass](https://nextjs.org/docs/app/guides/upgrading/version-15)
- [21st CCLC Attendance Guidance, AZ Dept of Education 2025](https://www.azed.gov/sites/default/files/2025/12/AzEDS%20attendance%20guidance%2012.08.2025.pdf)

### Secondary (MEDIUM confidence)
- [Clerk Next.js quickstart](https://clerk.com/docs/quickstarts/nextjs) — RBAC patterns
- [Prisma Next.js guide](https://www.prisma.io/docs/guides/nextjs) — singleton pattern, site-scoping extension approach
- [Metabase SDK Next.js integration](https://www.metabase.com/docs/latest/embedding/sdk/next-js) — Pro-only SDK confirmed
- [Clerk RBAC with Next.js 15](https://clerk.com/blog/nextjs-role-based-access-control) — publicMetadata role pattern

### Tertiary (LOW confidence)
- [EZReports: Essential Features of Afterschool Management Software](https://www.ezreports.org/blog-TheEssentialFeaturesOfAfterschoolManagementSoftwareWhatToLookFor.html) — Industry feature context only; not used for core decisions
- Clerk pricing page — MAU limits inconsistent across sources; verify directly at go-live

---

*Research completed: 2026-03-29*
*Ready for roadmap: yes*
