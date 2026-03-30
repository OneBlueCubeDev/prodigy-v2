# Codebase Concerns

**Analysis Date:** 2026-03-29

## Overview

Prodigy is a migration project from ASP.NET WebForms to Next.js 14 App Router. The legacy codebase is read-only and remains untouched at `/legacy-src/`. All concerns listed below relate to the new codebase architecture, migration risks, and implementation challenges identified during planning phases.

The project is in Phase 0 (Bootstrap) with planning artifacts complete but no implementation code written yet. Concerns are categorized by type and risk level.

---

## Deferred Technical Decisions

**Impact:** Implementation will require completing these decisions during execution.

### ADR-005: Background Jobs Migration

**Issue:** Legacy system uses `Global.asax` timers for background tasks. Replacement strategy undetermined.

**Files:** Not yet implemented — scheduled for detailed analysis during Phase 1

**Impact:** Blocking feature if legacy app has scheduled jobs that must move to Next.js. Current state unknown.

**Current status:** ADRs marked TBD in `CLAUDE.md` — to be completed during BMAD Analyst phase

**Fix approach:**
1. Inventory legacy background jobs via Phase 1 BMAD Analyst (read `Global.asax`, custom HttpModules, scheduled tasks)
2. Write ADR-005 with replacement strategy: Node.js Cron, AWS EventBridge, Render background jobs, or remain in legacy app
3. Document timing constraints and failure handling before implementation

---

### ADR-006: Email Service Migration

**Issue:** Legacy system uses `SmtpClient` for password reset and notification emails. New service undetermined.

**Files:** Not yet implemented — referenced in `/specs/_audit/04-background-jobs.md` (to be analyzed)

**Impact:** Without an email service decision, password resets, notifications, and any mail-dependent workflows cannot be completed.

**Current status:** TBD — awaiting Analyst phase inventory

**Fix approach:**
1. Identify all email operations in legacy codebase (password reset, notifications, reports)
2. Decide: SendGrid, Mailgun, AWS SES, or Resend API
3. Document transactional vs. bulk; add to ADR index
4. Include in Story 1.1 or early architecture implementation

---

## Data Migration & Deduplication Risks

**Impact:** Core functionality of the system; must be correct on first run.

### Youth Record Deduplication

**Issue:** Legacy system creates duplicate person records when users close and re-enroll youth. Migration script (Story 7.2) must deduplicate these records correctly.

**Files:**
- `scripts/migrate-legacy.ts` (not yet written)
- Migration logic will live in `/src/lib/` or `/scripts/`

**Risk:** If deduplication fails, longitudinal data is corrupted in the new system. Cannot be easily reversed post-cutover.

**Triggers:** Complex matching rules during SQL Server → PostgreSQL transfer. How do we know two `Person` records in legacy DB are the same youth?

**Assumptions in current plan:**
- Match by SSN first (unique identifier)
- Match by name + DOB if SSN unavailable
- Manual review mode for ambiguous matches

**Improvement path:**
1. Define deduplication algorithm in Story 7.2 with acceptance criteria
2. Build test fixtures from real legacy data samples
3. Run against staging copy of SQL Server first; manually verify results
4. Dry-run against PostgreSQL copy; compare row counts and sample records
5. Document manual intervention process if algorithm fails on edge cases

---

### Enrollment History Preservation

**Issue:** When youth records are deduplicated, their enrollment history must be stitched together correctly (FR52).

**Files:** `scripts/migrate-legacy.ts`, `/src/lib/` data access logic

**Risk:** Lost enrollments, incorrect grant year calculations, broken reporting if history is incomplete or fragmented.

**Example failure mode:** Youth "John Smith" enrolled at Site A in 2023, then closed and re-enrolled as "Jon Smith" at Site B in 2024. If deduplication misses one record, we lose enrollment history.

**Fix approach:**
- Define schema mapping from legacy `Enrollment` to new `Enrollment` + `Youth` model before writing migration script
- Create reference data: legacy person IDs and their mapped new youth IDs
- Validate post-migration: count enrollments per youth, check date ranges, spot-check grant year calculations

---

## SSN Encryption & Masking

**Impact:** Security and compliance requirement (FR43, FR44, FR46). Failure means exposing sensitive PII.

### Column-Level Encryption Implementation

**Issue:** Architecture specifies "application-level (Node.js crypto) + plaintext `ssn_last4` column" but exact encryption mechanism undetermined.

**Files:**
- `src/lib/ssn-encryption.ts` (Story 1.6 — not yet written)
- Prisma schema SSN column definition
- Used by: all youth CRUD operations in `src/actions/youth.ts`

**Risk:**
- Weak encryption allows decryption if database is compromised
- Key management: where is the encryption key stored? `.env` variable leak = exposed SSN
- Performance: encrypt/decrypt on every query adds latency
- Search: cannot search by full SSN if encrypted, only by `ssn_last4`

**Current approach:**
- Use Node.js built-in `crypto` module
- Encryption key in environment variable `SSN_ENCRYPTION_KEY`
- Store encrypted value in `ssn` column, plaintext last-4 in `ssn_last4`
- Only Admin and Central Team roles can decrypt

**Improvement path:**
1. Decide: AES-256-GCM (NIST recommended) or ChaCha20-Poly1305
2. Store encryption key in Supabase Vault or AWS Secrets Manager, not `.env`
3. Add key rotation ceremony + versioning (old encrypted values must still decrypt)
4. Never log SSN values, even encrypted
5. Add story acceptance criteria: "Decryption fails gracefully if key is wrong"

---

### SSN Masking in UI

**Issue:** Archive specifies last-4 display only, but implementation details missing.

**Files:**
- Youth display components (`src/components/youth/youth-detail-card.tsx`)
- Forms where SSN is input (`src/components/youth/youth-registration-form.tsx`)

**Risk:**
- Developers accidentally display full SSN in console logs, error messages, or API responses
- Role-based masking logic not enforced — Site Team user might see full SSN

**Current approach:**
- Utility function `maskSSN(ssn: string): string` — returns "XXX-XX-" + last4
- Only decrypt and show full SSN if `Clerk.user.role === 'Administrator' || 'Central Team'`
- All API responses from Server Actions return masked SSN to client

**Improvement path:**
1. Create Zod schema guard: `ssn.transform(v => isAdmin ? v : maskSSN(v))`
2. Add server-side middleware to strip SSN from API responses unless user is authorized
3. Test that SSN never appears in network logs (check Network tab in DevTools)
4. Add story AC: "SSN never appears in browser console, Network tab, or error logs for any role"

---

### Metabase SSN Exclusion

**Issue:** Reporting database connection must exclude SSN columns entirely (FR46). If misconfigured, SSN leaks into Metabase.

**Files:**
- Metabase data source configuration (not in codebase — manual config in Metabase UI)
- `src/app/api/metabase-embed/route.ts` (JWT token generation)

**Risk:** SSN visible in reports, violates compliance requirements

**Current approach:**
- Create read-only PostgreSQL user for Metabase with column-level grants: `GRANT SELECT (id, first_name, ...) ON youth TO metabase_user;` (exclude `ssn` column)
- JWT token signed with `METABASE_SECRET_KEY`; embedding uses signed iframe only

**Improvement path:**
1. Document SQL grant statements in setup guide — **must be reviewed by DBA before production**
2. Test: connect Metabase with metabase_user account and verify SSN column is not visible
3. Add to deployment checklist: "Verify Metabase user does NOT have SELECT on SSN columns"

---

## Authentication & Authorization Gaps

**Impact:** Role-based access control is enforced at API layer (NFR8). Failures allow data leaks.

### Site-Scoped Authorization

**Issue:** Architecture defines site-scoping via Prisma extension (`src/lib/db.ts`) but implementation details defer to Phase 1.

**Files:**
- `src/middleware.ts` (extracts role/site from Clerk JWT)
- `src/lib/db.ts` (Prisma client with site-scoping extension)
- All Server Actions in `src/actions/` must use the extended client

**Risk:**
- Developer forgets to use the extended Prisma client → queries ignore site filter
- Site Team user sees another site's data
- Incorrect test fixtures allow access without site restriction

**Example failure:** A query like `await db.youth.findMany({ where: { siteId } })` works if developer remembers `siteId`. But if they use base Prisma client: `await new PrismaClient().youth.findMany()`, site filter is ignored.

**Current approach:**
- Always use `db` from `src/lib/db.ts`, never create new `PrismaClient()`
- Prisma extension auto-injects `AND site_id = $currentUserSiteId` to all queries
- Enforce via code review and linting rule

**Fix approach:**
1. Add ESLint rule to forbid `new PrismaClient()` — enforce import from `src/lib/db.ts`
2. Create test fixture: attempt unauthorized access, verify 403/query returns empty
3. Add Story 1.3 AC: "Site-scoped queries verified: Site Team user cannot see another site's youth"

---

### Clerk Role/Site Metadata Sync

**Issue:** Architecture specifies "hybrid" approach — JWT claims + `user_sites` table — but sync mechanism undefined.

**Files:**
- `src/lib/auth.ts` (role/site extraction)
- `src/middleware.ts` (injects context into request)
- `user_sites` table schema (Story 1.3, not yet written)

**Risk:**
- JWT claims go stale if user's role changes in Clerk but local table isn't updated
- Webhook doesn't fire → user keeps old role until next login
- Manual sync falls through the cracks

**Current approach:**
- Clerk JWT includes `publicMetadata: { role, siteIds }` at login
- `user_sites` table is source of truth; synced via Clerk webhook on user update
- If webhook fails, fallback to JWT claims (stale but functional)

**Improvement path:**
1. Write Story 1.2 (Clerk setup) with webhook implementation
2. Add Story 1.8 (User management) with manual "Sync roles from Clerk" button for admins
3. Log every webhook event; alert on repeated failures
4. Add test: "User role updated in Clerk → webhook fires → query returns new role within 5s"

---

## Performance & Scalability Concerns

**Impact:** NFRs specify < 1.5s initial load, < 300ms navigation. Current architecture may not achieve this.

### Youth Search Performance

**Requirement:** FR3, NFR4 — search by name or SSN last-4 in < 1s

**Files:**
- `src/actions/youth.ts` — `searchYouth` Server Action (not yet written)
- Potential index: `CREATE INDEX idx_youth_last_first ON youth(last_name, first_name)`

**Risk:**
- Full table scan on youth table (potentially thousands of records) slow at scale
- SSN last-4 search: if `ssn_last4` column has no index, every search does table scan
- Decryption of SSN for comparison adds latency

**Current approach:**
- Database indexes on `last_name`, `first_name`, `ssn_last4`
- Pagination: return first 20 results, load more on scroll
- Debounce client-side search to 300ms

**Fix approach:**
1. Create migration: add indexes on searchable columns
2. Load test with 10,000+ youth records; measure query time
3. If > 300ms: add PostgreSQL full-text search or Elasticsearch
4. Add Story 2.1 AC: "Search returns results in < 500ms with 10,000 youth records"

---

### Concurrent User Capacity

**Requirement:** NFR6 — 50 concurrent users at peak

**Files:**
- Supabase connection pool config (not in codebase)
- Database schema design

**Risk:**
- Default Supabase connection pool (15-20 connections) insufficient for 50 concurrent users
- Connection exhaustion → requests timeout
- N+1 queries compound the problem

**Current approach:**
- Supabase Connection Pooler (pgbouncer) configured for higher concurrency
- Prisma connection pool tuned in `.env`: `DATABASE_URL_POOL`
- Server Components cache queries where possible

**Fix approach:**
1. Document connection pool requirements in setup guide
2. Load test: simulate 50 concurrent users; monitor connection count
3. If pool exhausted: increase pool size or implement query caching
4. Add monitoring: log connection pool utilization in production

---

### Attendance Submission at Scale

**Issue:** Multiple instructors submitting attendance simultaneously (morning peak, 8am-8:15am).

**Files:**
- `src/actions/attendance.ts` — `submitAttendance` Server Action (not yet written)
- Attendance locking logic (Story 5.6)

**Risk:** Race condition if two instructors submit the same class attendance simultaneously. Last write wins; earlier submission is lost.

**Fix approach:**
1. Add database constraint: unique `(class_id, session_date)` on attendance table
2. Pessimistic locking: check attendance status before allowing edit (if `submitted=true`, reject)
3. Optimistic locking: store `version` field, reject concurrent updates
4. Test: concurrent submissions on same class → second request returns "Already submitted" error

---

## Testing & Coverage Gaps

**Impact:** Migration is complex; insufficient testing risks bugs in production.

### No E2E Tests Written Yet

**Issue:** Project specifies Playwright E2E tests (Story 5.3 and per-feature stories), but framework choice vs. implementation is unclear.

**Files:**
- `playwright.config.ts` (not yet created)
- `e2e/*.spec.ts` test files (not yet written)
- No test data factory yet

**Risk:**
- Features may break under real conditions (network latency, race conditions)
- Regression testing time-consuming if manual
- Legacy app parity testing requires both apps running simultaneously

**Current approach:**
- Playwright E2E testing (per MIGRATION.md Phase 6)
- Test against both legacy (localhost:5000) and new (localhost:3000) apps
- Parity test must pass before traffic is switched

**Improvement path:**
1. Create Playwright config in Story 1.1
2. Build test data factory in `e2e/fixtures/test-data.ts`
3. Write baseline test for youth registration (Story 2.2)
4. Document: how to run parity tests (`PLAYWRIGHT_BASE_URL=http://localhost:5000 npm test`)
5. Add to CI: E2E tests run on every PR (requires both apps running)

---

### Audit Logging Verification

**Issue:** Audit logging (Story 1.5, FR45) must capture before/after values for all CUD operations. No tests defined yet.

**Files:**
- `src/lib/audit.ts` (Prisma middleware, not yet written)
- Audit logging tests (not yet written)

**Risk:**
- Middleware doesn't fire — no audit logs created
- Logs incomplete: missing user ID, timestamp, or before values
- Performance impact: audit logging slows all database writes

**Current approach:**
- Prisma middleware intercepts create/update/delete operations
- Logs to `audit_log` table with: user ID, action, before/after JSON, timestamp
- No synchronous performance impact (logging is async)

**Improvement path:**
1. Write Prisma middleware in Story 1.5
2. Create test: insert/update/delete youth → verify audit_log table has complete record
3. Create test: admin views audit logs → sees before/after diff
4. Load test: verify audit logging doesn't slow writes > 10ms

---

## Legacy Code Reference Risks

**Impact:** New system behavior must match legacy system. Misunderstandings create discrepancies.

### Page Inventory Complexity

**Issue:** 55 legacy `.aspx` pages with complex UpdatePanel AJAX logic. Architecture must map each to new routes.

**Files:**
- `specs/_audit/01-page-inventory.md` (complete)
- New pages (not yet written)

**Risk:**
- Developers implement new pages without understanding legacy behavior
- Edge cases in legacy app are missed in new implementation
- Parity tests fail because new app doesn't match legacy behavior exactly

**Current approach:**
- Page inventory documents every page, UpdatePanel, postback event, ViewState key
- Risk tier assigned (LOW/MEDIUM/HIGH)
- Parity tests for each migrated page required before cutover

**Improvement path:**
1. Each story that implements a page includes reference to `specs/_audit/01-page-inventory.md`
2. Story AC: "Behavior matches legacy page [name] per inventory"
3. Assign shadow testers: record legacy app workflows on video for reference

---

### Service Inventory Gap

**Issue:** Legacy app has zero web services/HTTP endpoints (pure postback monolith). New app must design API from scratch.

**Files:**
- `specs/_audit/02-service-inventory.md` (complete — shows "No Services Found")
- New API routes in `src/app/api/` and Server Actions in `src/actions/`

**Risk:**
- Without legacy API to migrate, design decisions are subjective
- Inconsistent API patterns across different stories
- External consumers (Metabase, future mobile app) have no stable contract

**Current approach:**
- Server Actions as primary API pattern (for app CRUD)
- Route Handlers only for Metabase JWT, Clerk webhooks, health check
- Future mobile app would consume REST API built from Server Actions

**Improvement path:**
1. Document API pattern decisions in `specs/decisions/ADR-007-API-Design.md`
2. Create API documentation as stories are written (auto-generate from Zod schemas)
3. Consider tRPC or OpenAPI spec for contract stability if external consumers emerge

---

## Reporting & Grant Year Logic

**Impact:** Reporting is critical for grant compliance. Incorrect logic means failed funding.

### Grant Year Computation

**Issue:** FR34 specifies "grant year runs July 1 through June 30" computed from enrollment/attendance dates. Logic must be consistent across app and Metabase.

**Files:**
- `src/lib/grant-year.ts` (not yet written)
- Metabase SQL queries (not yet written)
- Used by: reporting, filtering, enrollment logic

**Risk:**
- App computes grant year one way; Metabase SQL another way
- Attendance shows in one grant year in app, different grant year in reports
- Grant funding counts are wrong

**Example:** Youth enrolls on July 15 (grant year 2026) but takes class on June 20 next year. Does that enrollment count toward grant year 2026 or 2027?

**Current approach:**
- Formula: `grantYear = year(enrollmentDate) if month(enrollmentDate) >= 7 else year(enrollmentDate) - 1`
- Apply same formula in app and Metabase SQL

**Fix approach:**
1. Write comprehensive comment in `src/lib/grant-year.ts` with formula and examples
2. Document formula in Metabase SQL comments
3. Create migration/test: known enrollment/attendance dates → verify correct grant year in reports
4. Add story AC: "Grant year computation matches formula in app and Metabase"

---

### Missing Report Feature: No "Admin can view audit logs" User Facing

**Issue:** Story 1.5 (Audit Logging) lacks direct user-facing feature. Audit logs are created but no UI to view them.

**Files:**
- Audit logs stored in `audit_log` table
- No UI route to view logs yet

**Risk:** Audit logs exist but are invisible to compliance/security team. Cannot investigate issues.

**Fix approach:**
1. Add to Story 1.8 or separate story: "Admin can view audit log entries filtered by date, user, action, entity"
2. Create route: `/admin/audit-logs` with filtering and export to CSV
3. Add AC: "Admin can view audit entries for any youth CRUD operation"

---

## Architecture & Pattern Enforcement

**Impact:** Architecture document specifies patterns but enforcement is left to developer discipline.

### No Linting Rules for Architecture Compliance

**Issue:** `.eslintrc` not yet configured. Patterns like "never use bare PrismaClient()" are documented but not enforced.

**Files:**
- `.eslintrc.json` or `eslint.config.js` (not yet written)

**Risk:**
- Developer creates new PrismaClient() without site-scoping
- Developer throws exceptions from Server Actions instead of returning ActionResult
- Developer uses `any` type instead of proper typing

**Fix approach:**
1. Create ESLint config in Story 1.1 with rules:
   - Forbid `new PrismaClient()`
   - Forbid `throw` in Server Actions (return ActionResult instead)
   - Forbid `any` type (enforce `unknown`)
2. Add pre-commit hook to run ESLint
3. Add to CI: ESLint check must pass before merge

---

### Component Boundary Enforcement

**Issue:** Architecture specifies "components never import from `src/actions/` directly" but no tooling enforces this.

**Files:**
- `src/components/**` should not import from `src/actions/**`

**Risk:** Component logic leaks into UI; Server Actions are called from client components; harder to refactor.

**Fix approach:**
1. Add ESLint rule `no-restricted-imports` to prevent imports from `src/actions/` in component files
2. Code review: catch violations
3. Refactor guide: "If component needs an action, accept it as a prop from parent page"

---

## Environment Configuration & Secrets

**Impact:** Misconfigured env vars can cause outages or expose secrets.

### Environment Variable Validation

**Issue:** Architecture specifies Zod-validated env config (`src/config/env.ts`) but details undefined.

**Files:**
- `src/config/env.ts` (not yet written)
- `.env.example` (template, not yet written)
- `.env.local`, `.env.production` (git-ignored, must be configured manually)

**Risk:**
- Missing env var causes app to crash at startup (good) or at runtime (bad)
- Secrets leaked in git history (`.env` accidentally committed)
- Wrong API key in production env

**Current approach:**
- Zod schema validates all required env vars at app startup
- Fail-fast: if `DATABASE_URL` missing, app exits with clear error message
- Template `.env.example` documents all required vars and their purposes

**Improvement path:**
1. Create `src/config/env.ts` in Story 1.1 with comprehensive Zod schema
2. Create `.env.example` with all vars, descriptions, and example values
3. Document in setup guide: "Copy `.env.example` to `.env.local` and fill in your values"
4. CI check: verify `.env` is in `.gitignore` and never committed

---

### Database Connection Pooling

**Issue:** Supabase connection pool configuration unclear. Too small, app hangs; too large, wastes memory.

**Files:**
- `.env`: `DATABASE_URL_POOL` (not yet configured)

**Risk:**
- Connection exhaustion under peak load (morning attendance)
- Slow queries hold connections longer, making exhaustion worse

**Current approach:**
- Supabase default pool (15-20 connections) may be insufficient
- Tuning docs provided for `DATABASE_URL_POOL`

**Fix approach:**
1. Document in setup guide: "For 50 concurrent users, set pool size to 25-30"
2. Add monitoring: log connection pool usage in production
3. Load test: verify pool doesn't exhaust under peak load

---

## Data Retention & Compliance Gaps

**Impact:** Grant compliance may require specific data retention policies.

### COPPA/FERPA Compliance Unknown

**Issue:** System handles youth PII including minors. COPPA (< 13) and FERPA (educational records) may apply. Compliance approach undefined.

**Files:**
- Not yet addressed in schema, policies, or data handling

**Risk:**
- Violation of federal compliance requirements
- Financial penalties, legal liability

**Current approach:**
- PRD notes: "potential COPPA/FERPA applicability for minor PII (to be confirmed)"
- Encryption and role-based access controls in place
- No explicit data retention policy yet

**Fix approach:**
1. Consult legal/compliance team: are COPPA/FERPA applicable?
2. If yes: document data retention policy (how long keep youth records after they turn 18?)
3. Implement: automatic data anonymization or deletion based on retention policy
4. Add to ADR index: ADR-008: COPPA/FERPA Compliance

---

## Deployment & Infrastructure

**Impact:** Infrastructure decisions affect availability and operations.

### Node.js Standalone Behind IIS Reverse Proxy

**Issue:** Architecture specifies "Node.js standalone output behind IIS reverse proxy on Windows Server." No documented setup yet.

**Files:**
- Next.js `next.config.ts` with `output: "standalone"`
- Not yet: IIS reverse proxy config, Windows service wrapper

**Risk:**
- Reverse proxy misconfigured → requests fail
- Node.js process crashes → no restart mechanism
- Deployment procedure unclear

**Improvement path:**
1. Create deployment guide in `docs/deployment.md`
2. Document IIS configuration (URL rewrite rules, proxy settings)
3. Recommend process manager: PM2 or forever for automatic restarts
4. Add health check endpoint `/api/health` (in Story 1.1)
5. CI automation: build next app, test health endpoint, document deployment steps

---

### GitHub Actions CI Configuration

**Issue:** Architecture specifies "GitHub Actions CI pipeline (test + build)" but workflow not yet written.

**Files:**
- `.github/workflows/ci.yml` (not yet written)

**Risk:**
- Code merged without running tests (CI not enforced)
- Build failures caught only in production
- No automated deployment feedback

**Fix approach:**
1. Create `.github/workflows/ci.yml` in Story 1.1:
   - Runs on: push to main, PR
   - Steps: install, lint, test (vitest + playwright), build
   - Fails PR if any step fails
2. Document: manual deploy to Windows Server (how to run build output)

---

## Risks from Project Scope

**Impact:** Solo developer + AI assistance is ambitious. Over-engineering common.

### Scope Creep Risk

**Issue:** MVP (Epic 1-7) is substantial: 52 functional requirements, 7 epics, 33 stories. Solo developer with AI could over-engineer.

**Files:**
- Entire codebase architecture and implementation

**Risk:**
- Perfectionism on non-critical features (e.g., obsessive linting rules)
- Over-abstraction: too many custom hooks, helpers, patterns
- Testing overkill: 100% coverage on simple functions slows delivery

**Deferred decisions signal intentionality:**
- No caching layer (post-MVP) ✅
- No error tracking service (post-MVP) ✅
- No Docker containerization (post-MVP) ✅

**Recommendation:**
1. Follow CLAUDE.md rules strictly — no creative additions
2. Each story must have clear acceptance criteria; stop when AC is met
3. Defer "nice-to-haves" explicitly to Phase 2+
4. Code review gate: human approval before merging to main

---

### Knowledge Transfer Risk

**Issue:** System is complex (52 FRs, multi-layer architecture). If solo developer leaves, knowledge is lost.

**Files:**
- Entire codebase
- Limited documentation (only CLAUDE.md, MIGRATION.md, specs/, planning docs)

**Risk:**
- New team member onboarding takes weeks
- Bugs are hard to fix without original developer
- Future changes are risky

**Fix approach:**
1. Keep CLAUDE.md and ADRs current — this is the knowledge base
2. Write code comments for non-obvious logic (e.g., grant year formula, deduplication algorithm)
3. Maintain architecture document as living reference
4. Document why decisions were made, not just what was decided

---

## Summary: Severity & Priority

| Issue | Severity | Priority | Phase |
|-------|----------|----------|-------|
| ADR-005, ADR-006 (TBD decisions) | High | Phase 0 → 1 | Must complete before affected stories start |
| Youth deduplication (FR51) | High | Phase 7 | Correct on first run; no undo |
| SSN encryption & masking (FR43, FR44) | High | Phase 1.6, 2+ | Security requirement; audit-critical |
| Site-scoped authorization (FR41) | High | Phase 1.3 | Data leak risk if broken |
| Audit logging (FR45) | Medium | Phase 1.5 | Compliance requirement; must verify implementation |
| Grant year computation (FR34) | Medium | Phase 6 | Reporting accuracy depends on this |
| Performance under load (NFR1-6) | Medium | Phase 2+ | Load test early; optimize if needed |
| E2E test coverage (parity testing) | Medium | Phase 2-7 | Must pass before cutover |
| Deployment & CI/CD setup | Medium | Phase 1.1 | Enables repeatable releases |
| COPPA/FERPA compliance | Medium-Low | Phase 1 | Determine applicability; document approach |
| Linting & pattern enforcement | Low | Phase 1.1 | Nice-to-have; code review as fallback |
| Component boundary enforcement | Low | Phase 1+ | Nice-to-have; refactoring cost if wrong |

---

## Recommendations

1. **Before Phase 1 starts:** Complete ADR-005 and ADR-006. Deferred decisions unblock Analyst phase handoff.

2. **During Phase 1.1 (Scaffolding):** Configure ESLint, set up CI/CD, create `.env` validation, document deployment.

3. **Phase 1.6 (SSN Encryption):** Pair encryption implementation with comprehensive test suite. SSN handling is security-critical.

4. **During Phase 2+ (Feature implementation):** Load test youth search and attendance submission early. Performance issues found later are expensive to fix.

5. **Before Phase 6 (Cutover):** Write Playwright parity tests for all stories. Automate testing to reduce manual verification burden.

6. **Post-MVP roadmap:** Defer caching, error tracking, Docker, and COPPA/FERPA details to Phase 2+. Stay focused on core MVP.

---

*Concerns audit: 2026-03-29*
