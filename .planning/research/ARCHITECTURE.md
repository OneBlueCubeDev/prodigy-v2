# Architecture Patterns

**Project:** Prodigy — Youth Program Management Platform
**Domain:** Internal youth program management (UACDC staff-facing)
**Researched:** 2026-03-29
**Sources:** Legacy SQL Server schema (dbo/Tables/*), BMAD architecture.md, .planning/codebase/ARCHITECTURE.md, .planning/codebase/STRUCTURE.md, PROJECT.md
**Confidence:** HIGH — derived from actual legacy schema and completed BMAD architectural decisions

---

## Core Structural Insight: The Youth-Centric Model

The legacy system's fundamental flaw — and the new system's defining constraint — is data model architecture. The legacy app uses a single `Persons` table for both youth and staff, with a `PersonTypeID` discriminator and a separate `Students` table extending it. Crucially, `Enrollments.PersonID` directly references `Persons`, meaning that closing and re-enrolling a youth creates a new `Persons` row rather than a new enrollment row, destroying longitudinal identity.

The new model inverts this: `Youth` is a first-class standalone entity with a permanent, stable ID. Enrollments, attendance records, and relationships all hang off the youth identity — the youth never changes when program participation changes. This is not a technical preference; it is the primary business requirement.

---

## Component Boundaries

| Component | Responsibility | Communicates With | Notes |
|-----------|---------------|-------------------|-------|
| **Middleware** (`src/middleware.ts`) | Verify Clerk session; extract role + site_id into request context | Clerk SDK, Prisma (role lookup) | Runs before every request; enforces auth boundary |
| **Youth Domain** (`src/app/youth/`, `src/actions/youth.ts`) | Create, search, update youth; manage guardians/contacts | Prisma (db), Schemas, Audit | Core entity — all other domains reference Youth |
| **Enrollment Domain** (`src/app/enrollments/`, `src/actions/enrollment.ts`) | Enroll youth in programs; transfer; release; track status | Youth (foreign key), Programs (foreign key), Prisma | Decoupled from identity — no duplicate person records on re-enrollment |
| **Program Structure** (`src/app/programs/`, `src/actions/program.ts`, `course.ts`, `class.ts`) | Define programs, courses, course-instances per site, individual classes | Site (site_id scope), Staff (instructor assignment) | 4-level hierarchy: Program → Course → CourseInstance (site-run) → Class (single session) |
| **Attendance Domain** (`src/app/attendance/`, `src/actions/attendance.ts`) | Mobile-optimized sign-in per class; track tardy/left-early | Class (foreign key), Youth (foreign key), Audit | Attendance record = (class_id, youth_id) pair; instructor-facing, mobile-first |
| **Reporting** (`src/app/reports/`, `src/app/api/metabase-embed/`) | Embed signed Metabase dashboards; generate JWT tokens | Metabase OSS instance (port 3001), Clerk auth | Reporting is read-only; Metabase holds all query logic; app only signs JWTs |
| **Auth / User Management** (`src/middleware.ts`, `src/lib/auth.ts`, `src/app/admin/users/`) | Role assignment; site assignment; Clerk webhook sync | Clerk, `user_sites` table in Prisma | Source of truth is Prisma `user_sites`; Clerk `publicMetadata` is cache |
| **Audit Layer** (`src/lib/audit.ts`) | Capture before/after snapshots on all CUD operations | Prisma (middleware), `audit_log` table | Transparent to business logic — fires automatically on Prisma writes |
| **Data Access** (`src/lib/db.ts`) | Prisma client with site-scoping extension | PostgreSQL (Supabase), all Server Actions | Extension automatically injects `WHERE site_id = ?` for Site/Instructor roles |
| **Validation** (`src/schemas/`) | Zod schemas shared by Server Actions and React Hook Form | Server Actions, client components | Single definition — no schema drift between client and server validation |
| **Admin / Lookups** (`src/app/admin/`, `src/actions/lookup.ts`) | Manage reference data (statuses, types, sites); user management | Prisma, Clerk Admin API | Low-churn data; seed on deploy, admin UI for runtime changes |

---

## Data Model: Youth-Centric Design

### Entity Relationships

```
Site (physical location)
  |
  +-- CourseInstance (a course run at this site in a period)
        |
        +-- Class (a single session — date, instructor, lesson)
              |
              +-- ClassAttendance (youth_id + class_id = one attendance record)

Program (grant-funded program definition, org-wide)
  |
  +-- Course (curriculum definition within program)
        |
        +-- CourseInstance (site-specific run of the course)

Youth (permanent identity record)
  |
  +-- Guardian / Contact (PersonRelationship in legacy — separate Guardian model in new)
  +-- Address / Phone (embedded or related contact info)
  +-- Enrollment (youth enrolled in a program at a site)
  |     +-- Program (which program)
  |     +-- Site (which site)
  |     +-- Status (active, released, graduated)
  |     +-- GrantYear (computed from DateAdmitted, July 1 – June 30)
  +-- ClassAttendance → Class → CourseInstance → Course → Program
```

### Key Legacy Tables → New Model Mapping

| Legacy Table | Legacy Problem | New Model |
|---|---|---|
| `Persons` (PersonTypeID discriminator) | Conflates youth and staff; re-enrollment creates duplicates | `Youth` (standalone), `User` (staff, managed by Clerk) |
| `Students` (extends Persons) | Separate table for student-specific fields causes join overhead | Merged into `Youth` — all youth fields in one table |
| `Enrollments` (PersonID → Persons) | PersonID changes on re-enrollment | `Enrollment` with stable `youth_id` FK; re-enrollment = new row, never new youth |
| `Enrollments.GrantYear` (computed SQL column with hardcoded edge case) | `CASE WHEN DateApplied >= '5/1/2013'` — brittle hardcode | `computeGrantYear(date)` TypeScript function, July 1 – June 30 boundary, no hardcoded dates |
| `Courses` + `CourseInstances` + `Classes` | Three levels, confusingly named | Preserved hierarchy but renamed for clarity: `Program → Course → CourseInstance → Class` |
| `PersonRelationships` (self-join, role flags) | Guardian/contact/physician mixed into one polymorphic table | `Guardian` model (dedicated) + optional `EmergencyContact` sub-fields |
| `ClassAttendances.Student_PersonID` | References `Persons` — broken if person duplicated | `ClassAttendance.youth_id` references `Youth` directly |
| `Sites` (extends `Locations`) | Location join required for site name | `Site` is standalone with direct `name` field |
| `StaffMembers.UserID` → aspnet_Users | ASP.NET Membership — proprietary, non-portable | Clerk `userId` stored in `User.clerk_id` column |
| 18 `*_Audit` tables with triggers | Trigger-based, hard to query uniformly | Single `audit_log` table: `{ model, record_id, action, before, after, user_id, timestamp }` |

### Prisma Schema Skeleton (Target State)

```prisma
// Identity root — stable forever
model Youth {
  id              String   @id @default(cuid())
  firstName       String
  lastName        String
  dateOfBirth     DateTime
  genderId        String?
  ssn             String?  // encrypted via app layer
  ssnLast4        String?  // plaintext for search
  siteId          String   // home site (not enrollment site)
  status          YouthStatus @default(ACTIVE)

  enrollments     Enrollment[]
  attendances     ClassAttendance[]
  guardians       Guardian[]
  addresses       YouthAddress[]
  phoneNumbers    YouthPhone[]
  ethnicities     YouthEthnicity[]

  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
}

// Enrollment is about program participation, not identity
model Enrollment {
  id              String   @id @default(cuid())
  youthId         String
  programId       String
  siteId          String
  enrollmentType  String
  status          EnrollmentStatus @default(ACTIVE)
  dateApplied     DateTime
  dateAdmitted    DateTime?
  dateReleased    DateTime?
  releaseReason   String?
  grantYear       Int      // computed: July 1 – June 30

  youth           Youth    @relation(fields: [youthId], references: [id])
  program         Program  @relation(fields: [programId], references: [id])
  site            Site     @relation(fields: [siteId], references: [id])
}

// Program hierarchy (org-wide definitions)
model Program {
  id              String   @id @default(cuid())
  name            String
  programType     String
  status          ProgramStatus
  courses         Course[]
  enrollments     Enrollment[]
}

model Course {
  id              String   @id @default(cuid())
  programId       String
  name            String
  courseType      String
  status          CourseStatus
  program         Program  @relation(fields: [programId], references: [id])
  instances       CourseInstance[]
}

// Site-scoped run of a course
model CourseInstance {
  id              String   @id @default(cuid())
  courseId        String
  siteId          String
  instructorId    String?
  startDate       DateTime
  endDate         DateTime?
  course          Course   @relation(fields: [courseId], references: [id])
  site            Site     @relation(fields: [siteId], references: [id])
  classes         Class[]
}

// Single class session
model Class {
  id              String   @id @default(cuid())
  courseInstanceId String
  instructorId    String?
  dateStart       DateTime
  dateEnd         DateTime?
  status          ClassStatus
  courseInstance  CourseInstance @relation(fields: [courseInstanceId], references: [id])
  attendances     ClassAttendance[]
}

// Attendance: one row per youth per class
model ClassAttendance {
  id              String   @id @default(cuid())
  classId         String
  youthId         String
  tardy           Boolean  @default(false)
  leftEarly       Boolean  @default(false)
  notes           String?
  class           Class    @relation(fields: [classId], references: [id])
  youth           Youth    @relation(fields: [youthId], references: [id])
}

// Audit: single table replaces 18 trigger tables
model AuditLog {
  id              String   @id @default(cuid())
  model           String   // "Youth" | "Enrollment" | "Class" | etc.
  recordId        String
  action          AuditAction // CREATE | UPDATE | DELETE
  before          Json?
  after           Json?
  userId          String   // Clerk userId
  timestamp       DateTime @default(now())
}
```

---

## Data Flow

### Read Flow (Server Component → Database)

```
User navigates to /youth
  → Clerk middleware verifies session, extracts { role, siteId } → injects to request context
  → Next.js calls page.tsx (Server Component, no client JS)
  → page.tsx calls getYouthList() using Prisma client from src/lib/db.ts
  → Prisma site-scoping extension fires: automatically appends WHERE site_id = user.siteId
    (Admin role bypasses; Site/Instructor role filtered automatically)
  → PostgreSQL executes query, returns rows
  → Server Component serializes data as props → renders HTML
  → Browser receives hydrated page (no separate API call, no loading flash)
```

### Write Flow (Client Component → Server Action → Database)

```
Staff submits youth registration form
  → Client component calls createYouth(formData) — Server Action ('use server')
  → Server Action parses input through createYouthSchema (Zod)
  → If invalid: return { success: false, error: 'Validation failed' }
  → Server Action calls getAuth() → checks role allows CREATE
  → Calls prisma.youth.create({ data: { ...validated, ssnLast4, ssn: encrypt(ssn) } })
  → Prisma audit middleware intercepts CREATE
  → Audit middleware logs { model: 'Youth', action: 'CREATE', after: {...}, userId }
  → PostgreSQL executes INSERT, returns new row
  → Server Action returns { success: true, data: youth }
  → Client component receives result, shows success toast, redirects to youth detail page
```

### Attendance Flow (Mobile-Optimized Path)

```
Instructor opens /attendance
  → Class selector shows today's classes for instructor's site
  → Instructor selects class → navigates to /attendance/[classId]
  → Server Component loads: Class + roster (youth enrolled in this course instance)
  → Attendance roster renders — each youth row has tap target for present/absent/tardy
  → Instructor taps to mark attendance → optimistic UI update (client state)
  → On submit: submitAttendance(classId, attendanceMap) Server Action
  → Bulk upsert to ClassAttendance table (one row per youth in roster)
  → Return { success: true } → toast confirmation
```

### Reporting Flow (Metabase Embed)

```
Central Team opens /reports/census
  → page.tsx calls /api/metabase-embed?dashboard=census (Route Handler)
  → Route Handler: verifies Clerk session, checks role === 'CENTRAL' or 'ADMIN'
  → Generates signed JWT with { dashboard_id, site_filter (if scoped) }
  → Returns { token, iframeUrl }
  → MetabaseEmbed component renders <iframe src={iframeUrl}?token={token}>
  → Metabase validates JWT, queries PostgreSQL read-only connection, renders dashboard
  → SSN column excluded from Metabase connection at database level
```

### Grant Year Computation Flow

```
Enrollment submitted with dateAdmitted = '2026-09-15'
  → Server Action calls computeGrantYear(dateAdmitted)
  → computeGrantYear: if month >= 7 (July) return year, else return year - 1
  → computeGrantYear('2026-09-15') → grantYear = 2026  (Sept is after July cutoff)
  → computeGrantYear('2026-03-15') → grantYear = 2025  (March is before July cutoff)
  → Stored as integer column on Enrollment
  → Metabase reports group by grantYear column — consistent with app logic
```

---

## Component Architecture (Next.js Layer)

### Component Classification

| Type | Location | Rules |
|------|----------|-------|
| **Server Components** (default) | `src/app/**/page.tsx`, most components | No `'use client'`, fetch data directly, render HTML |
| **Client Components** (islands) | `src/components/**/*.tsx` marked `'use client'` | Forms, interactive lists, optimistic UI; receive data as props |
| **Server Actions** | `src/actions/*.ts` | Marked `'use server'`; handle all mutations; return `ActionResult<T>` |
| **Route Handlers** | `src/app/api/**/route.ts` | Only for Metabase JWT, Clerk webhook, health check |

### Islands Pattern

```
page.tsx (Server Component)
  → fetches youth list from DB
  → passes data as props to:
      YouthSearch (Client Component — handles search input state)
      YouthList (Server or Client — table render)
      YouthRegistrationForm (Client Component — form, hook form, calls createYouth action)
```

Server Components handle data loading. Client Components handle interactivity. Server Actions handle mutations. No global state store is needed.

---

## Cross-Cutting Concerns

### Authorization Enforcement Points

Three layers, each defense-in-depth:

1. **Clerk Middleware** — rejects unauthenticated requests before they hit any route handler
2. **Role check in Server Actions** — `getAuth()` verifies role can perform the operation
3. **Prisma site-scoping extension** — injects `WHERE site_id = ?` on every query for Site/Instructor roles

No single layer is sufficient alone. Together they make authorization bypass extremely difficult and eliminate "I forgot to filter this query" bugs.

### Audit Trail

The legacy system used 18 separate `*_Audit` tables populated by SQL Server triggers. This approach is replaced by a single `audit_log` table populated by Prisma middleware in `src/lib/audit.ts`. The new approach:

- One table to query for all audit history across all models
- Captures Clerk `userId` (not SQL Server login name)
- Stores before/after as JSON — queryable in Metabase
- Fires automatically on all Prisma CUD operations — impossible to forget

### SSN Handling

```
Storage:   ssn column = encrypted(AES-256, Node.js crypto)
           ssn_last4 column = plaintext last 4 digits (indexed)
Search:    WHERE ssn_last4 = '1234'  (no decrypt required)
Display:   UI shows '***-**-1234' only
Metabase:  Database user used by Metabase does NOT have SELECT on ssn column
```

---

## Build Order (Dependency Graph)

The following order is forced by data dependencies — each phase must complete before the next can be implemented meaningfully.

### Phase 1: Foundation (No feature works without this)

```
Next.js 15 scaffold
  → Prisma schema (Youth, Site, Lookup tables)
  → Database connection + migrations
  → Clerk integration (middleware + getAuth helper)
  → Prisma site-scoping extension
  → Audit middleware (src/lib/audit.ts)
  → SSN encryption utilities (src/lib/ssn-encryption.ts)
  → ActionResult<T> type, Pino logger
  → Environment variable validation (src/config/env.ts)
```

**Why first:** Every other phase writes Server Actions that depend on `db.ts` (Prisma client + extension), `auth.ts` (Clerk), `audit.ts` (audit middleware), and `ActionResult<T>`. Building these once upfront means every subsequent feature is consistent.

### Phase 2: Youth Registration (Core Entity)

```
Youth Prisma model finalized
  → createYouthSchema (Zod)
  → createYouth / updateYouth Server Actions
  → Youth registration form (React Hook Form + shadcn)
  → Youth search and list page
  → Youth detail page
  → Guardian management (sub-feature of youth detail)
```

**Why second:** `Youth` is the root entity. Enrollments, attendance, and reports all reference `youth_id`. The `Youth` model must be stable before any downstream feature can be built against it. Guardian is included here because it is captured during registration in the target workflow.

### Phase 3: Program Structure (Required before Enrollment)

```
Program, Course, CourseInstance, Class Prisma models
  → Program CRUD (admin-only)
  → Course CRUD (admin-only)
  → CourseInstance CRUD (site-scoped, per grant period)
  → Class CRUD + instructor assignment
```

**Why third:** Enrollment requires a `program_id`. Attendance requires a `class_id`. Both must exist before enrollment or attendance can be built.

### Phase 4: Enrollment

```
Enrollment Prisma model
  → computeGrantYear utility (src/lib/grant-year.ts)
  → enrollYouth / transferEnrollment / releaseEnrollment Server Actions
  → Enrollment form and list
  → Enrollment status transitions
```

**Why fourth:** Requires both `Youth` (Phase 2) and `Program` (Phase 3). Grant year computation belongs here because it is set at enrollment time and must be correct before attendance records are created.

### Phase 5: Attendance

```
ClassAttendance Prisma model
  → submitAttendance Server Action (bulk upsert pattern)
  → Class selector (today's classes for instructor's site)
  → Attendance roster (mobile-optimized, large tap targets)
  → Attendance history view (per youth, per class)
```

**Why fifth:** Requires `Youth` (Phase 2), `Class` (Phase 3), and optionally `Enrollment` (Phase 4) to build the roster. Depends on class structure being stable.

### Phase 6: Reporting (Metabase Integration)

```
Metabase JWT signing utility (src/lib/metabase.ts)
  → /api/metabase-embed Route Handler
  → Report index page
  → Census, billing, attendance dashboards (configured in Metabase, not in app)
  → Metabase database connection (read-only user, SSN column excluded)
```

**Why sixth:** Metabase dashboards query data from Phases 2–5. Building reporting before data exists produces empty dashboards and makes configuration harder to validate.

### Phase 7: Admin + Polish

```
User management (Clerk webhook sync + user_sites table)
  → Role assignment UI
  → Lookup data editor
  → Playwright E2E parity tests
  → Data migration script (SQL Server → PostgreSQL)
```

**Why last:** User management is operational infrastructure, not blocking for development (use seeded dev users). Parity tests require the full feature set to exist. Data migration runs once before cutover, not during development.

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Enrollment-Centric Identity

**What:** Storing or querying youth by enrollment ID, or creating a new Youth record when re-enrolling.
**Why bad:** Reproduces the exact legacy flaw that destroyed longitudinal tracking and corrupted grant reports.
**Instead:** Always create an `Enrollment` row; never create or modify the `Youth` row on re-enrollment.

### Anti-Pattern 2: Manual Site Filtering in Queries

**What:** Writing `WHERE site_id = user.siteId` in individual Server Actions or page queries.
**Why bad:** Easy to forget on new routes; one missed filter = data leak across sites.
**Instead:** The Prisma site-scoping extension in `src/lib/db.ts` injects this automatically for Site/Instructor roles. Never filter manually.

### Anti-Pattern 3: Server Actions That Call Other Server Actions

**What:** A Server Action (`createEnrollment`) calling another Server Action (`getYouthById`).
**Why bad:** Breaks the data flow model; creates implicit dependencies that are hard to test and debug.
**Instead:** Server Actions call Prisma directly. If shared logic is needed, extract it to a plain function in `src/lib/`.

### Anti-Pattern 4: Hardcoded Grant Year Boundaries

**What:** `if (date >= '2026-07-01' && date <= '2027-06-30') return 2026`
**Why bad:** Requires code changes every year; the legacy system has a hardcoded 2013 edge case that is still in production.
**Instead:** Use `computeGrantYear(date)` — pure function, tests trivially, never needs updating.

### Anti-Pattern 5: Client Components for Data Fetching

**What:** Using `useEffect` + `fetch` to load youth list in a client component.
**Why bad:** Causes loading flashes, adds client-side state complexity, and sends unnecessary JS to the browser.
**Instead:** Data fetching happens in Server Components (`page.tsx`). Client Components receive data as props.

### Anti-Pattern 6: Route Handlers for Application CRUD

**What:** `POST /api/youth` instead of a Server Action.
**Why bad:** Adds HTTP overhead, requires auth re-verification, generates boilerplate; Server Actions are simpler and type-safe.
**Instead:** Route Handlers are reserved for: Metabase JWT signing, Clerk webhooks, health check only.

---

## Scalability Considerations

This is an internal app with < 50 concurrent users. Architectural decisions reflect that reality — simplicity over premature optimization.

| Concern | At current scale (< 50 users) | If scale grows |
|---------|-------------------------------|----------------|
| Database | PostgreSQL on Supabase, no read replicas | Add read replica for Metabase; connection pooling via PgBouncer |
| Caching | Next.js built-in caching sufficient | Add Redis for session/auth caching if Clerk latency becomes issue |
| Real-time | None needed — polling or page refresh acceptable | Add Server-Sent Events for live attendance if required |
| State | URL params + local React state | No change — still appropriate at 10x scale |
| Auth | Clerk single region | Already globally distributed |
| Reporting | Metabase on same server | Move Metabase to dedicated instance if query load increases |

---

## Sources

- `/Users/shaneburke/dev/projects/Prodigy-Migration/legacy-src/POD Database/dbo/Tables/*.sql` — Actual legacy schema (HIGH confidence)
- `/Users/shaneburke/dev/projects/Prodigy-Migration/_bmad-output/planning-artifacts/architecture.md` — BMAD architectural decisions (HIGH confidence)
- `/Users/shaneburke/dev/projects/Prodigy-Migration/.planning/codebase/ARCHITECTURE.md` — Analyzed codebase architecture (HIGH confidence)
- `/Users/shaneburke/dev/projects/Prodigy-Migration/.planning/codebase/STRUCTURE.md` — Directory and naming conventions (HIGH confidence)
- `/Users/shaneburke/dev/projects/Prodigy-Migration/.planning/PROJECT.md` — Requirements and constraints (HIGH confidence)
