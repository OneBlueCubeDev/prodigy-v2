# Domain Pitfalls

**Domain:** Youth program management platform — ASP.NET WebForms to Next.js 15 migration
**Project:** Prodigy (UACDC)
**Researched:** 2026-03-29
**Overall confidence:** HIGH (grounded in actual legacy schema and stored procedures read directly from /legacy-src)

---

## Critical Pitfalls

Mistakes that cause rewrites, grant audit failures, or irreversible data damage.

---

### Pitfall 1: Replicating the Enrollment-Centric Identity Model

**What goes wrong:** The new schema preserves the legacy pattern where a youth's identity is encoded inside an enrollment row. The legacy `Enrollments` table holds `PersonID`, `ProgramID`, `SiteLocationID`, and a computed `GrantYear` all on the same record — fusing "who this person is" with "what program they're in." Recreating this in Prisma (even with a renamed table) means closing/re-enrolling still corrupts longitudinal data.

**Why it happens:** Developers copy the shape of legacy stored procedures (like `spGetGrantYearProgramEnrollmentData`, which JOINs `Persons → Students → Enrollments → ClassAttendances`) without questioning the model those procedures were written to compensate for. The procedures exist precisely because the model is broken.

**Consequences:** Duplicate youth records appear in the new system. Attendance and enrollment history is split across ghost records. Census reports double-count youth or miss them entirely. Grant auditors find inconsistencies.

**Prevention:**
- The `Youth` table must be the identity anchor. `Enrollment` references `youthId`, never the reverse.
- A youth's demographic record (name, DOB, SSN, guardian) must be updatable without touching any enrollment.
- Enforce via Prisma schema: `Enrollment.youthId` is a required FK; `Youth` has no `enrollmentId` column.
- Write a Prisma schema test in Phase 1: "Youth can exist with zero enrollments. Deleting an enrollment does not cascade to Youth."

**Detection:** If your Prisma schema has `programId` or `siteId` on the `Youth` model, the model is still enrollment-centric. Stop and redesign.

**Phase:** Phase 1 (Data Model) — must be correct before any feature is built on top.

---

### Pitfall 2: Grant Year Logic Diverges Between App and Metabase

**What goes wrong:** The app computes grant year one way; Metabase SQL queries compute it a different way. A youth enrolled on July 15 appears in grant year 2026 in the app but 2025 in the census report. Grant funding counts are wrong. Funder audits fail.

**Why it happens:** The legacy system uses three separate artifacts for grant year: a SQL computed column on `Enrollments` (hardcoding a 2013 edge case), a scalar UDF `udfGrantYear(@targetDate)` that reads from a `TimePeriods` lookup table, and business logic in stored procedures. The new system has no equivalent lookup table — grant year is computed from a formula. If Metabase SQL is written independently of the app formula, they drift.

**Actual legacy formula** (from `udfGrantYear.sql`):
- Grant year starts July 1 of the current year if `@targetDate >= July 1`, otherwise July 1 of the prior year.
- Falls back to formula if no matching row found in `TimePeriods` table (the lookup table is optional, not authoritative).
- The 2013 edge case in the `Enrollments` computed column (`GrantYear AS CASE WHEN DateApplied between '5/1/2013' AND '7/1/2013' THEN '7/1/2013'`) is a data repair patch, not a rule.

**Consequences:** Reports submitted to funders show different youth counts than the app. Historical data from the migration period is ambiguous. Staff waste time reconciling discrepancies.

**Prevention:**
- Write `src/lib/grant-year.ts` with the canonical formula and a full comment block including the July 1 boundary, the edge case history, and examples.
- Expose this logic to Metabase via a PostgreSQL view or function, not by re-implementing it in SQL queries.
- Create a test fixture with known dates and expected grant year outputs. Run this against both the app function and the Metabase SQL.
- Add Story acceptance criterion: "The grant year shown on the enrollment detail page matches the grant year shown in the census Metabase report for the same enrollment."

**Detection:** If Metabase SQL contains `CASE WHEN EXTRACT(MONTH FROM date) >= 7` written by hand without reference to the shared function, this pitfall has already occurred.

**Phase:** Phase 1 (utilities) and Phase 6 (reporting). The formula must be written in Phase 1; Metabase SQL in Phase 6 must import it, not rewrite it.

---

### Pitfall 3: Youth Deduplication Migration Merges Wrong Records

**What goes wrong:** The migration script identifies two legacy `Persons` records as the same youth and merges them. They are actually two different people (siblings, common name + similar DOB). The younger sibling's enrollment history is permanently attached to the older sibling's record. There is no undo.

**Why it happens:** The legacy database has no unique constraint enforcing one record per youth. The `ShowDuplicateStudents.aspx` page exists specifically because duplicates are known to exist. Matching by name + DOB alone will produce false merges for siblings and same-name families that are common in tightly-knit community programs.

**Consequences:** Irreversible data corruption. A youth's grant compliance history is attached to the wrong person. Their DJJ ID (`DJJIDNum` from `Persons.sql`) is lost or swapped.

**Prevention:**
- SSN is the primary match key — only merge if SSN matches exactly (after normalization: strip dashes, enforce 9 digits).
- Name + DOB is a "candidate" signal, not a merge signal. Name + DOB matches must go to a manual review queue.
- The migration script must produce a review report: all candidate matches without SSN confirmation, with both records shown side by side.
- Require a human (UACDC staff member who knows the youth) to approve every name+DOB match before migration runs.
- Never delete legacy records. Mark them `migrated = true` with a FK to the new `Youth.id`. Keep the mapping table forever for audit purposes.
- Dry-run migration against a copy of the database; validate row counts per youth before touching production.

**Detection:** If the migration script merges more than ~5% of records via name+DOB alone (without SSN), pause and manually audit a sample.

**Phase:** Phase 7 (Migration). Must be designed before any migration code is written, not discovered during execution.

---

### Pitfall 4: Middleware-Only Authorization (CVE-2025-29927)

**What goes wrong:** Authorization checks live exclusively in `src/middleware.ts`. A CVE disclosed in March 2025 (CVE-2025-29927) allows bypassing Next.js middleware entirely by injecting the `x-middleware-subrequest` header. Attackers can access any route, including admin pages and Server Actions, without authentication.

**Why it happens:** Developers implement RBAC in middleware because it feels like a centralized gate. The Clerk docs show middleware examples. The pattern looks right. But middleware in Next.js runs at the edge and is designed for routing decisions, not authorization enforcement.

**Consequences:** Site Team user accesses another site's youth records. Unauthorized user reads or mutates enrollment data. SSN data leaks.

**Prevention:**
- Use Next.js >= 15.2.3 (patched). Verify this is the locked version in `package.json`.
- Middleware handles session validation and routing only. Never treat middleware as the sole authorization boundary.
- Every Server Action must call `auth()` from Clerk and verify role and site ownership independently of middleware.
- Every route handler must independently check authorization.
- Add the Prisma site-scoping extension as a second enforcement layer — even if authorization checks are bypassed, queries still filter by site.
- Block or strip the `x-middleware-subrequest` header at the IIS reverse proxy layer before requests reach Next.js.

**Detection:** If a Server Action does not call `auth()` before accessing data, it is vulnerable regardless of middleware configuration.

**Phase:** Phase 1 (auth scaffolding). The pattern must be established before any protected routes are built.

---

### Pitfall 5: Audit Logging Using Deprecated Prisma Middleware API

**What goes wrong:** Audit logging is implemented using `prisma.$use()` (Prisma middleware). Prisma deprecated this API at v4.16 and removed it entirely in v6. The app silently loses all audit logging when Prisma is upgraded.

**Why it happens:** Most blog posts and Stack Overflow answers for "Prisma audit logging" still reference `prisma.$use()`. It is the intuitive API. The deprecation is not loud — it doesn't break at install time.

**Consequences:** Compliance audit trail silently stops recording. Staff changes to youth records are no longer traceable. Grant compliance checks fail if auditors ask "who changed this record on date X."

**Prevention:**
- Implement audit logging using Prisma Client Extensions (`prisma.$extends()`), not `prisma.$use()`.
- Write a test that verifies audit_log rows are created on create/update/delete of a `Youth` record. Run this test in CI.
- Pin Prisma version in `package.json` and review the Prisma changelog before any major version bump.

**Detection:** If `src/lib/audit.ts` contains `prisma.$use(`, it uses the deprecated API. Audit this file before Phase 1 is merged.

**Phase:** Phase 1 (Story 1.5 — audit logging). Non-negotiable to get right first time.

---

## Moderate Pitfalls

Mistakes that require rework but don't destroy data or fail compliance.

---

### Pitfall 6: Treating Server Actions as Trusted Endpoints

**What goes wrong:** A Server Action receives a `youthId` from a form submission and queries the database without verifying the caller has permission to read that youth. A Site Team user at Site A guesses the `youthId` of a youth at Site B and retrieves their record via a crafted form submission.

**Why it happens:** TypeScript types communicate intent but don't enforce access at runtime. The `'use server'` directive does not add any authorization. Server Actions are public POST endpoints — any browser can call them with any payload.

**Consequences:** Cross-site data access. PII leakage. RBAC is theater, not enforcement.

**Prevention:**
- Every Server Action begins with `const { userId, role, siteIds } = await auth()`.
- All queries use the site-scoped Prisma extension (`db` from `src/lib/db.ts`, never `new PrismaClient()`).
- Add an ESLint rule to forbid `new PrismaClient()` outside `src/lib/db.ts`.
- Validate that returned record belongs to the caller's site before returning data.

**Detection:** Grep all `src/actions/` files for `auth()` calls. Any Server Action lacking one is unprotected.

**Phase:** Phase 1 (auth scaffolding). Template must be established so all future actions inherit the pattern.

---

### Pitfall 7: SSN Stored or Logged in Plaintext

**What goes wrong:** An SSN is captured in a form, passed through a Server Action, and logged to stdout via Pino at `logger.info({ body })`. It appears in server logs. Or a migration script dumps the `Persons.SocialSecurityNumber` column to a CSV for review and the file is committed to git.

**Why it happens:** Logging full request bodies is a standard debugging practice. SSN is just another string field to Pino. No type system flags it as sensitive.

**Consequences:** SSN visible in log aggregation tools, git history, or exported files. Compliance violation (FERPA, potential HIPAA depending on medical data stored in `Students.MedicalConditions`).

**Prevention:**
- The Zod schema for youth input must transform SSN on the server before any logging occurs: `ssn.transform(v => maskSSN(v))` in the schema returned to the client.
- Never log the full request body in Server Actions that handle youth data. Log only fields you explicitly choose.
- Add a git pre-commit hook that rejects files containing patterns matching SSN format (`\d{3}-\d{2}-\d{4}` or 9-digit sequences in CSV/JSON files).
- The `ssn` column must be excluded from Metabase's PostgreSQL user via column-level grants.
- Add a test: call the youth registration Server Action with a test SSN, verify that SSN does not appear in any log output.

**Detection:** Search git history and server logs for 9-digit numeric sequences after any migration dry-run.

**Phase:** Phase 1 (Story 1.6 — SSN encryption). Must be enforced before any youth data is created.

---

### Pitfall 8: Prisma Site-Scoping Extension Bypassed by Direct Instantiation

**What goes wrong:** A developer creates `new PrismaClient()` in a new file because they forgot to import from `src/lib/db.ts`, or because they need a quick test. That query bypasses the site-scoping extension entirely and returns data for all sites. A Site Team user at Site A can read Site B's youth records.

**Why it happens:** Prisma is a peer dependency available anywhere in the project. There is nothing stopping `import { PrismaClient } from '@prisma/client'` anywhere. The extension only applies to the singleton instance returned by `src/lib/db.ts`.

**Consequences:** Multi-site data leakage. RBAC fails silently.

**Prevention:**
- Add ESLint rule: `no-restricted-imports` forbidding `import { PrismaClient } from '@prisma/client'` outside `src/lib/db.ts`.
- Write a test: create a direct `PrismaClient` query for a youth at Site B while authenticated as Site A — the test should return empty, not the youth record. If it returns data, the extension is not active.
- Code review checklist item: "Does this file import `db` from `src/lib/db.ts`?"

**Detection:** `grep -r "new PrismaClient()" src/` — any hit outside `src/lib/db.ts` is a vulnerability.

**Phase:** Phase 1 (scaffolding). Establish the lint rule before any data access code is written.

---

### Pitfall 9: Metabase Embedding Secret Key in Application Code or Version Control

**What goes wrong:** The `METABASE_SECRET_KEY` is hardcoded in a route handler, committed to git in a `.env` file, or logged on startup. Anyone with repository access can generate valid Metabase JWTs, bypassing all embedded reporting security.

**Why it happens:** Metabase's embedding documentation shows the key inline in code examples. Quick-starting developers copy examples without externalizing the secret.

**Consequences:** Unauthorized users generate JWTs and access all embedded reports — including census data, youth demographics, attendance records. The Metabase "locked parameters" model is broken because the key is known.

**Prevention:**
- `METABASE_SECRET_KEY` lives only in environment variables, never in source code.
- Validate this variable exists via Zod `env.ts` at startup — fail fast if missing, but never log its value.
- Add `.env` and `.env.local` to `.gitignore`; verify this is enforced.
- The Metabase JWT endpoint (`/api/metabase-embed`) must independently verify Clerk session before signing any JWT.
- Rotate the key immediately if any repository compromise is suspected.

**Detection:** `grep -r "METABASE_SECRET_KEY" src/` — any hit outside `src/config/env.ts` is a leak risk.

**Phase:** Phase 6 (reporting integration).

---

### Pitfall 10: Tailwind v4 and shadcn/ui Initialization Failure

**What goes wrong:** `npx shadcn@latest init` fails after Tailwind v4 is installed because the CLI validates Tailwind by looking for `tailwind.config.js`, which does not exist in v4 (configuration moved to CSS). Components cannot be added. Bootstrap stalls.

**Why it happens:** Tailwind v4 switched to CSS-first configuration in early 2025. The `shadcn` CLI was not immediately updated to detect v4 correctly. Multiple open GitHub issues confirm this (shadcn-ui/ui #6446, #7952). The `tailwindcss-animate` plugin was also deprecated in favor of `tw-animate-css`.

**Consequences:** Hours lost debugging an initialization failure that looks like a project configuration problem.

**Prevention:**
- Before running `shadcn init`, verify shadcn/ui CLI version supports Tailwind v4 (confirmed working as of early 2026 per official shadcn docs).
- Initialize shadcn with `--css-variables` flag.
- Replace `tailwindcss-animate` with `tw-animate-css` in `package.json`.
- Keep `globals.css` as the single source of Tailwind configuration — no `tailwind.config.js`.
- Document exact init command in the project setup guide so it is reproducible.

**Detection:** If `npx shadcn@latest init` errors with "Tailwind CSS not found," check CLI version and Tailwind v4 compatibility before debugging project config.

**Phase:** Phase 0 (Bootstrap — Story 1.1). Run into at first component addition if not addressed.

---

### Pitfall 11: ViewState-Dependent Workflows Rebuilt as Client State Without Equivalent Persistence

**What goes wrong:** The legacy `EnrollmentPage.aspx.cs` uses ViewState extensively (`ViewState["PersonID"]`, `ViewState["TempPersonID"]`, `ViewState["RolloverID"]`) to track multi-step enrollment workflow state across postbacks. The new implementation uses React `useState` — which is lost on page refresh, navigation, or browser back. Users lose partially-completed enrollments.

**Why it happens:** ViewState is a server-side abstraction that persists across postbacks automatically. Developers replacing postbacks with React components replace ViewState with `useState` — but `useState` is session-memory only, not durable.

**Consequences:** Staff lose multi-step form progress when the phone rings, they navigate away, or accidentally reload. Enrollment forms must be restarted from scratch.

**Prevention:**
- For multi-step enrollment forms: persist intermediate state to the URL (search params) or to the database as a draft record, not to React state.
- Use URL params for step navigation: `/enrollments/new?youthId=123&step=2`. Navigating back restores state.
- Consider a `enrollment_draft` table in Prisma for incomplete enrollments (can be cleaned up after 24h).
- Do not model the enrollment wizard after the legacy postback pattern — model it as a URL-driven state machine.

**Detection:** Any multi-step form using only `useState` for step tracking will lose state on refresh. Test by starting an enrollment, pressing F5, and verifying state is preserved.

**Phase:** Phase 4 (enrollment management).

---

### Pitfall 12: Big-Bang Cutover Without Verified Data Parity

**What goes wrong:** Legacy data is migrated to PostgreSQL and the legacy system is switched off. Reports immediately show youth counts that don't match historical legacy reports. Staff cannot reconcile because the legacy system is gone.

**Why it happens:** Big-bang cutover is fast, but it compresses all validation into the pre-cutover window. Enrollment history stitching, grant year computation differences, and deduplication edge cases only surface under real workload.

**Consequences:** Funder audits fail because historical reports don't match. Staff lose confidence in the new system. No rollback path if legacy is decommissioned.

**Prevention:**
- Keep the legacy system running (read-only) for 30 days post-cutover, not decommissioned.
- Run the census and monthly attendance reports in both systems against the same date range before cutover. Counts must match within an acceptable delta (document what delta is acceptable).
- Build a reconciliation script: compare `Youth` count per program per grant year between legacy SQL Server and new PostgreSQL.
- Playwright parity tests must pass before cutover is allowed — this is already planned but must be gate-enforced (not advisory).
- Define a rollback plan: if critical discrepancy found within 30 days, describe exact steps to restore legacy as primary.

**Detection:** If reconciliation script shows > 2% count difference in any grant year for any program, hold cutover and investigate.

**Phase:** Phase 7 (Migration + Cutover).

---

## Minor Pitfalls

---

### Pitfall 13: Concurrent Attendance Submission Race Condition

**What goes wrong:** Two instructors open the same class attendance form simultaneously (morning peak, 8–8:15am). Both submit. The second write overwrites the first. Attendance records are silently lost.

**Why it happens:** Attendance submission is a multi-row upsert. Without optimistic locking or a unique constraint, the second submission replaces the first.

**Prevention:**
- Add unique constraint: `(classId, sessionDate)` on the attendance session record.
- Check `submitted = true` before allowing edits; reject with "Already submitted" error.
- Second submission attempt returns an error, not silent success.

**Phase:** Phase 5 (attendance tracking).

---

### Pitfall 14: Grant Year Formula Applied to Attendance Date Instead of Enrollment Date

**What goes wrong:** The census stored procedure (`spGetCensusReportData`) joins youth to the report via `ed.GrantYear between @yearStartDate and @yearEndDate` — the grant year is derived from the enrollment's `DateApplied`, not from when attendance occurred. If the new system computes grant year from attendance date instead of enrollment date, youth are miscounted.

**Why it happens:** Attendance records have a `DateTimeStamp`; enrollment records have a `DateApplied`. It seems natural to group by when attendance happened. The legacy behavior groups by when enrollment happened.

**Prevention:**
- Document this explicitly in `src/lib/grant-year.ts`: "Grant year is determined by enrollment DateApplied, not by attendance date."
- Metabase census query must join on enrollment date, not attendance date.

**Phase:** Phase 6 (reporting). Verify during report buildout.

---

### Pitfall 15: IIS Reverse Proxy Misconfiguration Drops Headers

**What goes wrong:** The Next.js app is deployed behind IIS as a reverse proxy. IIS strips `X-Forwarded-For` or `Host` headers. Clerk's `auth()` cannot determine the request origin. Sessions appear invalid on every request.

**Why it happens:** IIS URL Rewrite rules require explicit configuration to forward headers. Default IIS proxy config does not pass all headers through.

**Consequences:** Every user gets logged out. Clerk authentication fails in production but not in development.

**Prevention:**
- Document the required IIS URL Rewrite rule including `X-Forwarded-For`, `X-Forwarded-Host`, and `X-Forwarded-Proto` header forwarding.
- Test Clerk authentication against the IIS proxy config in a staging environment before any production deployment.
- Add to deployment checklist: "Verify session persists across page navigation in the IIS-proxied environment."

**Phase:** Phase 0 (Bootstrap) — deployment infrastructure.

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Phase 1 — Data Model | Replicating enrollment-centric identity (Pitfall 1) | Design Youth as identity anchor before writing any schema |
| Phase 1 — Auth Scaffolding | Middleware-only authorization (Pitfall 4); direct PrismaClient bypassing site-scoping (Pitfall 8) | Establish ESLint rules and Server Action auth template on Day 1 |
| Phase 1 — Audit Logging | Deprecated `prisma.$use()` API (Pitfall 5) | Use Prisma Client Extensions only |
| Phase 1 — SSN Handling | SSN in plaintext logs or git (Pitfall 7) | Mask before any logging; add pre-commit hook |
| Phase 2 — Youth Registration | SSN masking incomplete; site-scoping not applied to creation (Pitfalls 7, 8) | Apply same auth checks as reads to all write operations |
| Phase 4 — Enrollment | ViewState-based multi-step form replaced with stateless React state (Pitfall 11) | Use URL params or draft records for step persistence |
| Phase 4 — Enrollment | Grant year formula on wrong date field (Pitfall 14) | Lock formula in shared utility; document enrollment date anchor |
| Phase 5 — Attendance | Race condition on concurrent submission (Pitfall 13) | Unique constraint + submitted flag |
| Phase 6 — Reporting | Grant year divergence between app and Metabase (Pitfall 2) | Expose app formula as PostgreSQL function; Metabase calls it |
| Phase 6 — Reporting | Metabase secret key leak (Pitfall 9) | Env var only; column-level grants for SSN exclusion |
| Phase 7 — Migration | Deduplication merges wrong records (Pitfall 3) | SSN as primary key; name+DOB requires human review |
| Phase 7 — Cutover | Big-bang cutover without data parity verification (Pitfall 12) | Run reconciliation script; keep legacy live 30 days post-cutover |

---

## Sources

- Legacy schema analyzed directly: `/legacy-src/POD Database/dbo/Tables/Persons.sql`, `Enrollments.sql`, `ClassAttendances.sql`, `Students.sql`
- Legacy grant logic analyzed directly: `/legacy-src/POD Database/dbo/Functions/udfGrantYear.sql`, `Stored Procedures/spGetCensusReportData.sql`, `spGetGrantYearProgramEnrollmentData.sql`
- Legacy page complexity analyzed: `/legacy-src/POD/Pages/EnrollmentPage.aspx.cs` (ViewState usage pattern)
- Existing concern inventory: `.planning/codebase/CONCERNS.md`
- CVE-2025-29927 Next.js middleware bypass: [Next.js Security Best Practices 2026](https://www.authgear.com/post/nextjs-security-best-practices)
- Prisma middleware deprecation (v4.16 → v6 removal): [Prisma Middleware Documentation](https://www.prisma.io/docs/orm/prisma-client/client-extensions/middleware)
- Server Actions security vulnerabilities: [Secure Next.js Server Actions](https://makerkit.dev/blog/tutorials/secure-nextjs-server-actions)
- Tailwind v4 / shadcn/ui compatibility: [shadcn/ui Tailwind v4 docs](https://ui.shadcn.com/docs/tailwind-v4), [Issue #6446](https://github.com/shadcn-ui/ui/issues/6446)
- Metabase embedding security: [Securing Embedded Metabase](https://www.metabase.com/docs/latest/embedding/securing-embeds)
- Big-bang migration risks: [Big Bang vs Gradual Migration](https://xbsoftware.com/blog/big-bang-or-gradual-data-migration/)
- Fuzzy deduplication pitfalls: [Fuzzy Matching 101](https://dataladder.com/fuzzy-matching-101/)
- Clerk RBAC in Next.js: [Clerk RBAC Next.js](https://clerk.com/docs/guides/secure/basic-rbac)
- Multi-tenant Prisma scoping: [Multi-Tenancy with Prisma](https://zenstack.dev/blog/multi-tenant)
