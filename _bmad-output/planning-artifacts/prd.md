---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-02b-vision', 'step-02c-executive-summary', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish', 'step-12-complete']
classification:
  projectType: web_app
  domain: edtech
  complexity: medium
  projectContext: brownfield
inputDocuments:
  - MIGRATION.md
  - specs/_audit/01-page-inventory.md
  - specs/_audit/02-service-inventory.md
  - specs/_audit/03-report-inventory.md
  - specs/_audit/04-background-jobs.md
documentCounts:
  briefs: 0
  research: 0
  brainstorming: 0
  projectDocs: 5
workflowType: 'prd'
lastEdited: '2026-03-29'
editHistory:
  - date: '2026-03-29'
    changes: 'Post-validation edits: expanded attendance FRs (FR14-24) for sign-in/sign-out workflow, refined FR6 match criteria, added grant year formula to FR34, specified session timeout NFR, added COPPA/FERPA reference, renumbered FRs 25-52'
---

# Product Requirements Document - Prodigy

**Author:** Shane
**Date:** 2026-03-29

## Executive Summary

Prodigy is an internal youth program management platform used by UACDC staff to register youth, manage program enrollments, track class attendance, and produce grant compliance reports. The existing system is an ASP.NET WebForms monolith (55 pages, Telerik UI, SSRS reporting, SQL Server) that forces a broken data model on its users: enrollment and person identity are fused, so closing an enrollment and re-enrolling a youth creates a duplicate person record. This destroys longitudinal tracking, corrupts reporting, and drives staff to paper-based workarounds — particularly for class attendance.

This migration rebuilds Prodigy on Next.js 15 (App Router), TypeScript, Tailwind/shadcn/ui, Prisma, PostgreSQL, Clerk authentication, and Metabase OSS reporting. The legacy app stays live until the full MVP is validated and stakeholders sign off, then a big-bang cutover switches all users to the new system. The new app runs on an independent PostgreSQL database — no shared state with legacy SQL Server. The migration is not 1:1 feature parity; core workflows around youth registration, program enrollment, class/course management, and attendance are being fundamentally rethought and simplified.

The central design shift is moving from an enrollment-centric model to a **youth-centric model**. One youth, one record, many enrollments across programs, sites, and years. This eliminates duplicate person records, enables full longitudinal tracking ("tell the story of how a youth has enrolled in programs over the years"), and makes grant reporting accurate by default. The attendance workflow is being redesigned to be faster than the paper clipboards staff currently use as workarounds. Every design decision is filtered through one question: **is this simpler than what we have today?**

## Project Classification

| Attribute | Value |
|-----------|-------|
| **Project Type** | Internal web application |
| **Domain** | EdTech / Youth Program Management |
| **Complexity** | Medium |
| **Project Context** | Brownfield — modernization with workflow rethink |
| **Target Stack** | Next.js 15, TypeScript, Tailwind, shadcn/ui, Prisma, PostgreSQL, Clerk, Metabase OSS |
| **Cutover Strategy** | Big-bang after stakeholder sign-off; legacy stays live until validated |
| **Users** | Internal staff only — < 50 users (Administrators, Central Team, Site Team) |
| **Resource Model** | Solo developer with Claude AI assistance |

## Success Criteria

### User Success

- **Site Coordinators:** Can register a new youth (demographics, guardian info, address/phone) in a single streamlined form without touching enrollment, doctors, pickup auth, or notes.
- **Instructors:** Can take class attendance on a mobile device in under 2 minutes per class, with data visible to central office on refresh. No paper forms needed.
- **Central Team:** Can pull census, billing, and attendance reports from Metabase with accurate data — no duplicate person records inflating counts or breaking grant year calculations.
- **All users:** MFA-secured login via Clerk. Interface simple enough that no special training is required beyond basic orientation.

### Business Success

- **Data accuracy:** Zero duplicate person records created by the enrollment workflow. One youth = one record, always.
- **Grant year reporting:** Grant year is a computed field derived from enrollment/attendance dates — no manual config edits, no hardcoded boundaries.
- **Paper reduction:** Class attendance and youth registration are fully digital. Site teams no longer maintain paper clipboards or manual logs.
- **Security:** MFA enforced for all users via Clerk. Role-based access controls enforced consistently across all routes.

### Technical Success

- **API layer:** Clean REST API designed from scratch (no legacy service contracts to migrate — the old app had zero APIs).
- **Audit trail:** Database audit logging preserved through Prisma middleware or PostgreSQL triggers, maintaining parity with the 18-table SQL Server trigger system.
- **Parity validation:** Playwright tests confirm behavioral parity between legacy and new system before cutover.

### Measurable Outcomes

| Metric | Target |
|--------|--------|
| Duplicate person records created per month | 0 (down from current systemic duplication) |
| Time to take class attendance (per class) | < 2 minutes on mobile |
| Time to register a new youth | < 5 minutes |
| Grant year report generation | Automated — no manual config changes |
| Paper forms in active use | Eliminated for attendance and registration |
| MFA adoption | 100% of users |

## User Journeys

### Journey 1: Maria — Site Coordinator registers a new youth

**Opening Scene:** Maria works the front desk at the Southside site. A parent walks in with their 12-year-old, wanting to sign up for the afterschool program. In the old system, Maria would have to create an enrollment — filling out a massive form that mixes the kid's demographics with program details, pickup authorizations, doctors, and notes. If the kid was ever enrolled before at another site, Maria has no way to know — she'd create a duplicate record.

**Rising Action:** Maria opens Prodigy on her desktop, searches for the youth by name and DOB. No match — this is a new kid. She clicks "Register Youth" and fills out demographics (name, DOB, race, ethnicity, gender, primary language), address, phone, then adds the parent as a guardian with their own demographics and contact info. She saves. The youth now exists in the system — one record, no enrollment yet.

**Climax:** Maria then clicks "Enroll in Program," selects the Southside Prevention Youth program, and confirms. Done. Two clean steps. If this kid later moves to the Eastside site and enrolls in a different program, the Eastside coordinator will find the existing record — no duplicate.

**Resolution:** Maria just registered and enrolled a youth in under 5 minutes with zero confusion about what fields belong where. The parent didn't have to wait while she navigated a 15-section form. The data is clean from day one.

### Journey 2: James — Instructor takes class attendance

**Opening Scene:** James teaches a Tuesday/Thursday art class at the Northside site. Today he has 18 kids on the roster. In the old system, he'd print a paper roster, check off names with a pen, and hand the sheet to the site coordinator who'd manually enter it into the system later that week — if it didn't get lost first.

**Rising Action:** James pulls out his phone during class, opens Prodigy, and taps into his Tuesday art class. The roster loads with all 18 enrolled youth. He sees who's here and taps each present student — green checkmarks appear instantly.

**Climax:** Two students are absent. James leaves them unmarked and hits "Submit Attendance." The central office can see the attendance data immediately — no waiting for paper to be transcribed, no lost sheets, no data entry errors.

**Resolution:** Attendance took James 90 seconds between activities. The central team pulls the monthly attendance report that afternoon and the numbers are already current. No more "James, did you turn in your attendance sheets?"

### Journey 3: Diane — Central Team pulls grant reporting

**Opening Scene:** Diane works at the UACDC central office. It's the end of the month and she needs to pull the census report for the current grant year across all six sites. In the old system, she'd navigate to the SSRS report page, wait for it to render, and hope the numbers are right — knowing that duplicate person records from re-enrollments inflate the headcount every year.

**Rising Action:** Diane opens Metabase and navigates to the Census dashboard. She selects the current month and "All Sites." The report renders in seconds with filterable columns. She spots that Northside enrollment is down and drills into the site-specific view.

**Climax:** The numbers are accurate. Every youth is counted once regardless of how many programs they're enrolled in or how many times they've been re-enrolled across grant years. The grant year is computed automatically — no one had to update a config file in October.

**Resolution:** Diane exports the report to PDF for the grant submission. What used to be a multi-day process of pulling reports, cross-checking for duplicates, and manually adjusting numbers is now a 10-minute task with data she trusts.

### Journey 4: Shane — Administrator manages the system

**Opening Scene:** Shane wears multiple hats — he's the system administrator but also does central team work. A new instructor has been hired at the Westside site and needs access to Prodigy. Meanwhile, a site coordinator reports they can't see a youth who was registered at another site.

**Rising Action:** Shane logs into Clerk's admin dashboard, creates the new instructor's account with MFA enabled, and assigns the Site Team role scoped to Westside. The instructor receives a setup email and is taking attendance by the next class session. Shane then switches to Prodigy and searches for the youth the coordinator mentioned — finds the record, confirms the enrollment is at a different site, and helps the coordinator enroll the youth at their site too.

**Climax:** Both issues resolved in minutes. No IT tickets, no database queries, no "let me check if there's a duplicate record." The role-based access means the new instructor sees only their Westside classes, and the youth-centric model means cross-site enrollment just works.

**Resolution:** Shane pulls up the monthly attendance and census reports for his own review, confident the data reflects reality. The system is simple enough that he spends less time on support and more time on program oversight.

### Journey → Capability Traceability

| Journey | Capabilities Revealed |
|---------|----------------------|
| **Maria (Site Coordinator)** | Youth search/dedup, youth registration form, program enrollment flow, guardian management, site-scoped views |
| **James (Instructor)** | Mobile-responsive UI, class roster view, tap-to-mark attendance, attendance submission, instructor-scoped class list |
| **Diane (Central Team)** | Metabase dashboards, cross-site reporting, grant year computation, census/billing/attendance reports, PDF export |
| **Shane (Administrator)** | Clerk user management, role assignment, site scoping, cross-site data visibility, system oversight |

## Domain-Specific Requirements

### Compliance & Regulatory

- **Youth PII Protection:** All personally identifiable information for minors (name, DOB, SSN, race, ethnicity, address, guardian info) stored with encryption at rest in PostgreSQL.
- **Data Retention:** Records retained indefinitely for longitudinal tracking and grant compliance. Audit tables track full change history (INSERT/UPDATE/DELETE) for all core entities — carried forward from legacy 18-table trigger system.
- **Grant Funder Compliance:** Data handling must satisfy grant reporting requirements. Specific funder requirements — including potential COPPA/FERPA applicability for minor PII — to be confirmed in stakeholder meetings alongside broader compliance review.

### Technical Constraints

- **SSN Security:** SSN fields encrypted at rest (column-level encryption or Prisma-level encryption), masked in UI (show last 4 digits only), access restricted to Administrator and Central Team roles. SSN never appears in logs, API responses to unauthorized roles, or Metabase queries accessible to Site Team.
- **Encryption at Rest:** All data storage encrypted at rest — PostgreSQL (Supabase manages this by default), backups, and any file storage.
- **MFA Enforcement:** All users required to use MFA via Clerk. No bypass for any role level.
- **Role-Based Data Access:** Site Team users see only their site's data. Instructors see only their assigned classes. Central Team and Administrators see cross-site data. Enforced at the API layer, not just the UI.

### Risk Mitigations

| Risk | Mitigation |
|------|------------|
| SSN exposure in logs/reports | Column-level encryption, UI masking, exclude from Metabase connection |
| Data loss during migration | Full backups of legacy SQL Server before cutover; migration script is repeatable |
| Audit trail gap during migration | Both legacy triggers and new Prisma middleware active during parallel operation |
| Unauthorized cross-site data access | API-layer enforcement of site scoping, not UI-only hiding |

## Web Application Specific Requirements

### Rendering & Navigation

| Concern | Decision |
|---------|----------|
| **Routing** | Client-side navigation via Next.js App Router for smooth SPA-like experience |
| **Data fetching** | Server components and server actions for data loading; client components for interactive UI |
| **Forms** | Client components with server actions for submissions (registration, enrollment, attendance) |
| **Reporting** | Metabase embedded via signed iframe — server-side token generation, client-side render |

### Browser & Device Support

| Browser | Version | Priority |
|---------|---------|----------|
| Chrome | Latest 2 versions | Primary — only supported browser |
| Others | Not supported | Internal policy: Chrome on all staff devices |

No polyfills, legacy browser fallbacks, or cross-browser testing required.

| Breakpoint | Primary Use Case |
|------------|-----------------|
| **Mobile (< 768px)** | Instructor attendance capture (phone/tablet in classroom) |
| **Desktop (> 1024px)** | Site coordinator registration, central team reporting, admin tasks |

Mobile-first design for attendance workflow. Desktop-optimized for data-heavy views (enrollment grids, reports, admin panels).

### Constraints & Exclusions

- **No SEO** — entire application behind authentication
- **No offline support** — staff always on network (office WiFi or mobile data)
- **No push notifications** — refresh-based data visibility is sufficient
- **No WebSocket/real-time** — standard request/response for all data operations
- **No accessibility compliance** — WCAG is nice-to-have; basic semantic HTML and keyboard navigation only
- **Session management** — Clerk handles session persistence; no custom session state (eliminates legacy ViewState and Session[""] patterns entirely)

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach:** Problem-solving MVP — deliver the core workflows (registration, enrollment, attendance, reporting) with the new youth-centric data model. The MVP must fully replace the legacy system for day-to-day operations before going live.

**Cutover Strategy:** Big-bang cutover after stakeholder sign-off, not feature-by-feature. Legacy app stays live and operational until the full MVP is validated. No shared database — new PostgreSQL instance runs independently from legacy SQL Server.

**Resource Model:** Solo developer with Claude AI assistance. Scope must be achievable incrementally with automated testing as the quality gate.

### MVP Feature Set (Phase 1)

**Core User Journeys Supported:**

| Journey | Supported in MVP |
|---------|-----------------|
| Maria — Register youth & enroll in program | Full |
| James — Mobile class attendance | Full |
| Diane — Grant reporting (census, billing, attendance) | Core reports only |
| Shane — User management & system admin | Full (via Clerk + admin views) |

**Must-Have Capabilities:**

- **Auth & Roles:** Clerk authentication with MFA, role-based access (Admin, Central Team, Site Team/Instructor), site-scoped data isolation
- **Youth Registration:** Decoupled from enrollment — demographics, guardians, address/phone, SSN (encrypted)
- **Program Enrollment:** Enroll registered youth in program at site, track enrollment status, support multiple concurrent enrollments
- **Class Attendance:** Mobile-friendly roster with tap-to-mark, submit per class session, visible to central office on refresh
- **Programs/Courses/Classes:** CRUD for program structure (central team manages), class scheduling, instructor assignment
- **Core Reporting:** Census, billing, and monthly attendance reports in Metabase with grant year as computed field
- **Audit Trail:** Prisma middleware logging all creates/updates/deletes on core entities
- **Data Migration:** One-time migration script from SQL Server to PostgreSQL — deduplicate person records, map enrollments to unified youth identities
- **Lookup Data:** Reference tables (races, genders, ethnicities, statuses, enrollment types, youth types) migrated and manageable

**Explicitly Out of MVP:**

- Inventory management
- Risk assessments
- PAT forms
- Longitudinal youth history views
- Non-core reports (non-attendance, enrollment detail, master class schedule)
- Pickup authorizations, doctor/physician records
- Enrollment notes
- Password reset email (Clerk handles this natively)

### Phase 2 — Growth

- Remaining SSRS reports migrated to Metabase
- Course and class management workflow rework
- Longitudinal youth history view (enrollment timeline across programs/years)
- Enrollment notes and supplementary data
- Pickup authorizations and physician records
- Advanced filtering and search across all data views

### Phase 3 — Expansion

- Inventory management
- Risk assessments
- PAT forms
- Full paper elimination across all workflows
- Advanced analytics dashboards beyond grant compliance
- Automated grant year rollover notifications and validation
- Parent/guardian portal (if ever needed)

### Risk Mitigation Strategy

**Technical Risks:**

| Risk | Mitigation |
|------|------------|
| Data migration deduplication logic is wrong | Build migration script early, run against copy of production data, validate counts with stakeholder before cutover |
| Grant year computation doesn't match legacy reports | Side-by-side report comparison during UAT — same inputs, same outputs |
| SSN encryption breaks search/reporting | Design encryption approach upfront, test with Metabase access patterns before building UI |
| Solo developer bottleneck | Lean MVP scope, automated tests as safety net, Claude AI for velocity |

**Operational Risks:**

| Risk | Mitigation |
|------|------------|
| Staff resistance to new system | Stakeholder sign-off before cutover, simple UI that requires no training |
| Data loss during cutover | Full backup of legacy SQL Server, migration script is repeatable, rollback plan keeps legacy app available |
| Grant reporting deadline during migration | Legacy app stays live until cutover — no gap in reporting capability |

## Functional Requirements

### Youth Management

- **FR1:** Site Coordinator can register a new youth with demographics (name, DOB, race, ethnicity, gender, primary language), SSN, address, and phone numbers
- **FR2:** Site Coordinator can add one or more parent/guardian records to a youth, each with their own demographics, address, and phone numbers
- **FR3:** Site Coordinator can search for existing youth by first name, last name, or last 4 digits of SSN before creating a new record
- **FR4:** Site Coordinator can view and edit a youth's registration details after creation
- **FR5:** Central Team can view youth records across all sites
- **FR6:** System surfaces potential duplicate youth records during registration search when last name matches AND (DOB matches OR SSN last-4 matches)

### Program Enrollment

- **FR7:** Site Coordinator can enroll a registered youth into a program at their site
- **FR8:** Site Coordinator can view all enrollments at their site with filtering by status (active/inactive)
- **FR9:** Site Coordinator can transfer a youth's enrollment to a different site
- **FR10:** Site Coordinator can release (close) a youth's enrollment
- **FR11:** Central Team can view enrollments across all sites
- **FR12:** System supports multiple concurrent active enrollments for a single youth across different programs and sites
- **FR13:** Central Team can delete an enrollment record

### Class Attendance

- **FR14:** Instructor can view the roster for their assigned class on mobile or desktop
- **FR15:** Instructor can sign in a youth by selecting their name, capturing Time IN automatically at the current time
- **FR16:** Instructor can sign out a youth, capturing Time OUT automatically at the current time
- **FR17:** Instructor can designate each sign-in as AI (Authorized Individual drop-off) or S (Self sign-in), defaulting to AI
- **FR18:** System auto-calculates Tardy (Time IN > 15 minutes after class start) and Left Early (Time OUT before class end) per youth per session
- **FR19:** Staff can enter attendance after the fact with manually editable Time IN and Time OUT fields
- **FR20:** Instructor can record class session staff: instructor assistant(s), additional staff, and volunteers
- **FR21:** Site Manager can verify a class attendance session by recording their name and verification date
- **FR22:** Instructor can submit a completed attendance session, locking all times after submission
- **FR23:** Central Team can view submitted attendance data across all sites without delay
- **FR24:** Site Coordinator can view attendance data for their site's classes

### Program & Course Structure

- **FR25:** Central Team can create, edit, and deactivate programs
- **FR26:** Central Team can create, edit, and deactivate courses within a program
- **FR27:** Central Team, Site Coordinator, and Administrator can create, edit, and deactivate classes within a course
- **FR28:** Central Team, Site Coordinator, and Administrator can assign instructors to classes
- **FR29:** Central Team, Site Coordinator, and Administrator can define class schedules (days, times, date ranges)
- **FR30:** Central Team can assign courses to sites

### Reporting

- **FR31:** Central Team can view a census report filtered by month, program, and site
- **FR32:** Central Team can view a billing report filtered by month, program, and site
- **FR33:** Central Team can view a monthly attendance report filtered by month, site, and class
- **FR34:** System computes grant year automatically from enrollment and attendance dates, where grant year runs July 1 through June 30
- **FR35:** Central Team can export reports to PDF
- **FR36:** Reports count each youth once regardless of number of enrollments (no duplicate inflation)

### Authentication & Authorization

- **FR37:** All users can authenticate via Clerk with MFA enforced
- **FR38:** Administrator can create, deactivate, and manage user accounts via Clerk
- **FR39:** Administrator can assign roles (Administrator, Central Team, Site Team/Instructor) to users
- **FR40:** Administrator can scope Site Team and Instructor roles to a specific site
- **FR41:** System restricts Site Team users to viewing and managing only their assigned site's data
- **FR42:** System restricts Instructors to viewing only their assigned classes

### Data Security & Audit

- **FR43:** System encrypts all data at rest including SSN fields with column-level encryption
- **FR44:** System masks SSN in the UI, displaying only last 4 digits, with full access restricted to Administrator and Central Team roles
- **FR45:** System logs all create, update, and delete operations on core entities with timestamp, user, action type, and before/after values
- **FR46:** SSN is excluded from Metabase database connections and never appears in reports

### Lookup Data Management

- **FR47:** Administrator can view, add, edit, and deactivate lookup values (races, ethnicities, genders, statuses, enrollment types, youth types, locations)
- **FR48:** System seeds lookup tables from legacy data during migration
- **FR49:** Lookup values used in forms are presented as selectable options filtered to active values only

### Data Migration

- **FR50:** System provides a one-time migration script that transfers youth, enrollment, attendance, program, course, class, and lookup data from SQL Server to PostgreSQL
- **FR51:** Migration script deduplicates person records, mapping multiple legacy person IDs to a single youth identity
- **FR52:** Migration script preserves enrollment history, linking historical enrollments to deduplicated youth records

## Non-Functional Requirements

### Performance

| Metric | Requirement | Context |
|--------|-------------|---------|
| Page load (initial) | < 1.5s | First Contentful Paint on Chrome, office WiFi or mobile data |
| Client-side navigation | < 300ms | Route transitions within the app |
| Form submission | < 500ms | Registration, enrollment, attendance saves |
| Search results | < 1s | Youth search by name or last 4 SSN |
| Metabase report render | < 3s | Embedded iframe initial load |
| Concurrent users | 50 simultaneous | Full staff using system at peak (e.g., morning attendance across all sites) |

### Security

| Requirement | Detail |
|-------------|--------|
| Authentication | Clerk with MFA enforced for all users, no exceptions |
| Authorization | Role-based access enforced at API layer; site-scoped data isolation for Site Team and Instructors |
| Encryption at rest | All PostgreSQL data encrypted at rest; SSN fields with column-level encryption |
| Encryption in transit | HTTPS/TLS for all connections (app, Clerk, Metabase, database) |
| SSN handling | Masked in UI (last 4 only), excluded from Metabase connections, never logged, access restricted by role |
| Audit logging | All CUD operations on core entities logged with user, timestamp, action, and before/after values |
| Session management | Clerk-managed sessions; automatic timeout after 30 minutes of inactivity |

### Reliability

| Requirement | Detail |
|-------------|--------|
| Recovery Time Objective (RTO) | 4 hours — system must be restored within 4 hours of any outage |
| Data backup | Automated PostgreSQL backups (Supabase managed); point-in-time recovery capability |
| Uptime target | Best-effort during business hours; no formal SLA required for < 50 internal users |
| Failure mode | If system is unavailable, staff can defer data entry — no life-safety or financial impact from short outages |

### Integration

| System | Integration Type | Requirement |
|--------|-----------------|-------------|
| **Clerk** | Auth provider | OAuth/OIDC; user provisioning, MFA management, role sync |
| **Metabase OSS** | Reporting | Signed JWT iframe embedding; direct PostgreSQL read connection (SSN columns excluded) |
| **PostgreSQL (Supabase)** | Primary datastore | Prisma ORM; connection pooling for concurrent access |
| **Legacy SQL Server** | Migration source | One-time read access for data migration script; no ongoing integration post-cutover |
