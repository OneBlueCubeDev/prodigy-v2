# Roadmap: Prodigy

## Overview

This roadmap migrates Prodigy from an ASP.NET WebForms monolith to Next.js 15. The migration is not a rewrite — it is a deliberate data model correction. The dependency chain is forced: the youth-centric identity model must be established before enrollment can be built; enrollment must exist before attendance can be tracked; attendance data must exist before reports can be validated. Each phase delivers a coherent, independently verifiable capability. The critical path runs Foundation → Youth → Program Structure → Enrollment → Attendance → Reporting → Admin/PAT/Migration.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 0: Foundation** - Project scaffolding, auth, audit trail, and shared infrastructure
- [ ] **Phase 1: Youth Registration** - Youth identity, registration, duplicate detection, and search
- [ ] **Phase 2: Program Structure** - Program, course, course instance, and class management
- [ ] **Phase 3: Enrollment** - Enrollment lifecycle, grant year computation, and rollover
- [ ] **Phase 4: Attendance Tracking** - Mobile-first class and event attendance
- [ ] **Phase 5: Reporting** - Grant compliance reports via Metabase OSS
- [ ] **Phase 6: Admin, PAT Forms, and Cutover** - Staff management, PAT forms, lookup admin, and data migration

## Phase Details

### Phase 0: Foundation
**Goal**: The Next.js 16 app is running with working authentication, a correct Prisma schema, an active audit trail, and shared infrastructure utilities that every subsequent phase inherits
**Depends on**: Nothing (first phase)
**Requirements**: AUTH-01, AUTH-02, AUTH-03, AUTH-04, LOOK-02, INFRA-01, INFRA-02, INFRA-03, INFRA-05
**Success Criteria** (what must be TRUE):
  1. Staff can sign in via Clerk with MFA and land on a program-selector screen; unauthenticated users are redirected to login
  2. All three roles (Admin, Central, Site) can be assigned and enforce access boundaries — Admin sees all, Site sees only their own site's data
  3. Every insert, update, and delete to any table writes a row to `audit_log` with user, timestamp, old and new values — no records exist without audit coverage
  4. SSN values written to the database are encrypted at rest; the application reads them back decrypted and displays only the last 4 digits
  5. Health check endpoint returns 200 OK; `computeGrantYear()` utility returns the correct grant year for dates on both sides of the July 1 boundary
**Plans:** 1/4 plans executed
Plans:
- [x] 00-01-PLAN.md — Scaffold Next.js 16, install deps, Prisma schema, core infrastructure utilities
- [ ] 00-02-PLAN.md — shadcn/ui init, app shell layout, program selector UI, seed data
- [ ] 00-03-PLAN.md — Test infrastructure (Vitest + Playwright config, all unit tests)
- [ ] 00-04-PLAN.md — Integration verification and human checkpoint
**UI hint**: yes

### Phase 1: Youth Registration
**Goal**: Staff can register youth, search for existing records, and view or edit demographics — with the youth-centric model enforced such that no workflow can create a duplicate person record
**Depends on**: Phase 0
**Requirements**: YOUTH-01, YOUTH-02, YOUTH-03, YOUTH-04, YOUTH-05, YOUTH-06
**Success Criteria** (what must be TRUE):
  1. Staff can complete a new youth registration (demographics, guardian, address, phone, SSN) in a single form in under 5 minutes
  2. During registration, if name + DOB + SSN last-4 match an existing record, the duplicate is surfaced before the form submits — no silent duplicate creation
  3. Staff can search by name, DOB, or SSN and navigate to a matching youth's detail page
  4. Staff can edit demographics on an existing youth record without creating a new record
  5. SSN is stored encrypted, displayed masked (last 4 only) to authorized roles, and never appears in server logs
**Plans**: TBD
**UI hint**: yes

### Phase 2: Program Structure
**Goal**: Admins and staff can manage the full four-level program hierarchy (Program → Course → CourseInstance → Class) so that enrollment and attendance have valid targets
**Depends on**: Phase 0
**Requirements**: PROG-01, PROG-02, PROG-03, PROG-04, LOOK-01
**Success Criteria** (what must be TRUE):
  1. Admin can create, edit, and deactivate programs; non-admin roles cannot modify program records
  2. Admin can create courses within a program; staff can create site-scoped course instances with instructor, location, days/times, and capacity
  3. Staff can schedule individual class sessions within a course instance; the class appears on the attendance roster
  4. Lookup table values (races, ethnicities, genders, enrollment types, statuses, sites) are editable by Admin and populate all form dropdowns consistently
**Plans**: TBD
**UI hint**: yes

### Phase 3: Enrollment
**Goal**: Staff can enroll a youth into a program, manage the full enrollment lifecycle (active, transfer, release), and carry enrollments forward to a new grant year without re-entering youth data
**Depends on**: Phase 1, Phase 2
**Requirements**: ENRL-01, ENRL-02, ENRL-03, ENRL-04, ENRL-05, ENRL-06, ENRL-07
**Success Criteria** (what must be TRUE):
  1. Staff can enroll an existing youth into a program at a site; the enrollment is decoupled from the youth identity record
  2. Enrollment status transitions (active → released, active → transferred) are tracked with dates; transfer moves the enrollment to a new site without creating a new youth record
  3. The grant year is computed automatically from the enrollment date using the July 1 fiscal year boundary — no staff input required and no hardcoded year in the codebase
  4. Staff can roll over active enrollments to the next grant year; youth data is carried forward and no duplicate records are created
  5. Staff can view a youth's complete enrollment history across all programs, sites, and grant years on a single screen
**Plans**: TBD
**UI hint**: yes

### Phase 4: Attendance Tracking
**Goal**: Staff can take class attendance on a mobile device in under 2 minutes, replacing paper clipboards, and authorized users can view complete attendance history for any youth
**Depends on**: Phase 3
**Requirements**: ATTN-01, ATTN-02, ATTN-03, ATTN-04, ATTN-05, ATTN-06
**Success Criteria** (what must be TRUE):
  1. Staff can open a class roster on a mobile device, tap present or absent for each youth, and submit attendance — the full workflow completes in under 2 minutes
  2. Sign-in and sign-out times are captured per attendance record; partial-day attendance is recorded correctly
  3. Submitted attendance is visible to central office on page refresh with no batch sync or delay
  4. Staff can record event attendance (separate from class sessions) tied to enrolled youth
  5. Staff can view a youth's complete attendance history across all programs and classes on a single screen
**Plans**: TBD
**UI hint**: yes

### Phase 5: Reporting
**Goal**: Central team can access Census, Billing, and Attendance compliance reports through Metabase OSS, with grant year computation consistent between the application and all reports
**Depends on**: Phase 4
**Requirements**: REPT-01, REPT-02, REPT-03, REPT-04, REPT-05
**Success Criteria** (what must be TRUE):
  1. Census report is available in Metabase showing youth who attended at least once per reporting period, filterable by program, site, and date range
  2. Billing report is available in Metabase with attendance-based billing data scoped to program and site
  3. Attendance report is available in Metabase with aggregate and individual attendance data across multiple time ranges
  4. All three reports apply the same grant year formula as the application — a youth enrolled July 15 appears in the same grant year in the app and in every report
  5. Central team can build custom Metabase questions by browsing the data model without developer involvement
**Plans**: TBD

### Phase 6: Admin, PAT Forms, and Cutover
**Goal**: Staff management is complete, PAT forms are functional, and the system has passed Playwright parity testing and data migration validation — ready for big-bang cutover
**Depends on**: Phase 5
**Requirements**: PAT-01, PAT-02, PAT-03, STAFF-01, STAFF-02, STAFF-03, INFRA-04
**Success Criteria** (what must be TRUE):
  1. Admin can create, edit, and deactivate staff records; assign staff to sites; provision and revoke Clerk access — all from the admin UI
  2. Staff can complete a PAT form tied to an enrollment; the form renders as a tabbed multi-section layout with dynamic fields; completed forms appear in youth and enrollment history
  3. Playwright parity test suite passes against the new application, confirming behavioral equivalence with the legacy system across all critical workflows
  4. Data migration script has run against production SQL Server data, deduplication review report has been signed off by UACDC staff, and record counts reconcile within 2% per program per grant year
**Plans**: TBD
**UI hint**: yes

## Progress

**Execution Order:**
Phases execute in numeric order: 0 → 1 → 2 → 3 → 4 → 5 → 6

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 0. Foundation | 1/4 | In Progress|  |
| 1. Youth Registration | 0/? | Not started | - |
| 2. Program Structure | 0/? | Not started | - |
| 3. Enrollment | 0/? | Not started | - |
| 4. Attendance Tracking | 0/? | Not started | - |
| 5. Reporting | 0/? | Not started | - |
| 6. Admin, PAT Forms, and Cutover | 0/? | Not started | - |
