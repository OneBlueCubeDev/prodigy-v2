---
stepsCompleted: ['step-01-validate-prerequisites', 'step-02-design-epics', 'step-03-create-stories', 'step-04-final-validation']
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
---

# Prodigy-Migration - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for Prodigy-Migration, decomposing the requirements from the PRD, UX Design, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: Site Coordinator can register a new youth with demographics (name, DOB, race, ethnicity, gender, primary language), SSN, address, and phone numbers
FR2: Site Coordinator can add one or more parent/guardian records to a youth, each with their own demographics, address, and phone numbers
FR3: Site Coordinator can search for existing youth by first name, last name, or last 4 digits of SSN before creating a new record
FR4: Site Coordinator can view and edit a youth's registration details after creation
FR5: Central Team can view youth records across all sites
FR6: System surfaces potential duplicate youth records during registration search when last name matches AND (DOB matches OR SSN last-4 matches)
FR7: Site Coordinator can enroll a registered youth into a program at their site
FR8: Site Coordinator can view all enrollments at their site with filtering by status (active/inactive)
FR9: Site Coordinator can transfer a youth's enrollment to a different site
FR10: Site Coordinator can release (close) a youth's enrollment
FR11: Central Team can view enrollments across all sites
FR12: System supports multiple concurrent active enrollments for a single youth across different programs and sites
FR13: Central Team can delete an enrollment record
FR14: Instructor can view the roster for their assigned class on mobile or desktop
FR15: Instructor can sign in a youth by selecting their name, capturing Time IN automatically at the current time
FR16: Instructor can sign out a youth, capturing Time OUT automatically at the current time
FR17: Instructor can designate each sign-in as AI (Authorized Individual drop-off) or S (Self sign-in), defaulting to AI
FR18: System auto-calculates Tardy (Time IN > 15 minutes after class start) and Left Early (Time OUT before class end) per youth per session
FR19: Staff can enter attendance after the fact with manually editable Time IN and Time OUT fields
FR20: Instructor can record class session staff: instructor assistant(s), additional staff, and volunteers
FR21: Site Manager can verify a class attendance session by recording their name and verification date
FR22: Instructor can submit a completed attendance session, locking all times after submission
FR23: Central Team can view submitted attendance data across all sites without delay
FR24: Site Coordinator can view attendance data for their site's classes
FR25: Central Team can create, edit, and deactivate programs
FR26: Central Team can create, edit, and deactivate courses within a program
FR27: Central Team, Site Coordinator, and Administrator can create, edit, and deactivate classes within a course
FR28: Central Team, Site Coordinator, and Administrator can assign instructors to classes
FR29: Central Team, Site Coordinator, and Administrator can define class schedules (days, times, date ranges)
FR30: Central Team can assign courses to sites
FR31: Central Team can view a census report filtered by month, program, and site
FR32: Central Team can view a billing report filtered by month, program, and site
FR33: Central Team can view a monthly attendance report filtered by month, site, and class
FR34: System computes grant year automatically from enrollment and attendance dates, where grant year runs July 1 through June 30
FR35: Central Team can export reports to PDF
FR36: Reports count each youth once regardless of number of enrollments (no duplicate inflation)
FR37: All users can authenticate via Clerk with MFA enforced
FR38: Administrator can create, deactivate, and manage user accounts via Clerk
FR39: Administrator can assign roles (Administrator, Central Team, Site Team/Instructor) to users
FR40: Administrator can scope Site Team and Instructor roles to a specific site
FR41: System restricts Site Team users to viewing and managing only their assigned site's data
FR42: System restricts Instructors to viewing only their assigned classes
FR43: System encrypts all data at rest including SSN fields with column-level encryption
FR44: System masks SSN in the UI, displaying only last 4 digits, with full access restricted to Administrator and Central Team roles
FR45: System logs all create, update, and delete operations on core entities with timestamp, user, action type, and before/after values
FR46: SSN is excluded from Metabase database connections and never appears in reports
FR47: Administrator can view, add, edit, and deactivate lookup values (races, ethnicities, genders, statuses, enrollment types, youth types, locations)
FR48: System seeds lookup tables from legacy data during migration
FR49: Lookup values used in forms are presented as selectable options filtered to active values only
FR50: System provides a one-time migration script that transfers youth, enrollment, attendance, program, course, class, and lookup data from SQL Server to PostgreSQL
FR51: Migration script deduplicates person records, mapping multiple legacy person IDs to a single youth identity
FR52: Migration script preserves enrollment history, linking historical enrollments to deduplicated youth records

### NonFunctional Requirements

NFR1: Page load (initial) < 1.5s — First Contentful Paint on Chrome, office WiFi or mobile data
NFR2: Client-side navigation < 300ms — Route transitions within the app
NFR3: Form submission < 500ms — Registration, enrollment, attendance saves
NFR4: Search results < 1s — Youth search by name or last 4 SSN
NFR5: Metabase report render < 3s — Embedded iframe initial load
NFR6: Concurrent users — 50 simultaneous at peak (morning attendance across all sites)
NFR7: Authentication via Clerk with MFA enforced for all users, no exceptions
NFR8: Role-based access enforced at API layer; site-scoped data isolation for Site Team and Instructors
NFR9: All PostgreSQL data encrypted at rest; SSN fields with column-level encryption
NFR10: HTTPS/TLS for all connections (app, Clerk, Metabase, database)
NFR11: SSN masked in UI (last 4 only), excluded from Metabase connections, never logged, access restricted by role
NFR12: All CUD operations on core entities logged with user, timestamp, action, and before/after values
NFR13: Clerk-managed sessions; automatic timeout after 30 minutes of inactivity
NFR14: Recovery Time Objective (RTO) — 4 hours; system restored within 4 hours of any outage
NFR15: Automated PostgreSQL backups (Supabase managed); point-in-time recovery capability
NFR16: Best-effort uptime during business hours; no formal SLA required
NFR17: Clerk integration — OAuth/OIDC; user provisioning, MFA management, role sync
NFR18: Metabase OSS integration — Signed JWT iframe embedding; direct PostgreSQL read connection (SSN columns excluded)
NFR19: PostgreSQL (Supabase) — Prisma ORM; connection pooling for concurrent access
NFR20: Legacy SQL Server — One-time read access for data migration script; no ongoing integration post-cutover

### Additional Requirements

- Architecture specifies `create-next-app@latest` as starter template with TypeScript, Tailwind, ESLint, App Router, src directory, @/* import alias, and Turbopack
- Post-scaffold setup required: shadcn/ui init, Prisma init, Clerk install, Vitest + Playwright install
- SSN encryption via Node.js crypto (application-level) with plaintext `ssn_last4` column for search
- Authorization via Next.js middleware + Prisma client extension for automatic site-scoped WHERE injection
- Clerk metadata sync: hybrid approach — JWT claims for zero-latency access + `user_sites` table as source of truth
- Server Actions as primary API pattern for all app CRUD; Route Handlers only for Metabase JWT endpoint, Clerk webhooks, and health check
- Typed result objects (`ActionResult<T>`) for all Server Action returns — no thrown exceptions
- Zod schemas shared between client and server for form + API validation
- React Hook Form + Zod for complex forms (registration, enrollment); native forms for simple ones (attendance)
- Prisma audit middleware for CUD logging with Clerk user context
- Pino structured JSON logging to stdout
- `/api/health` health check endpoint
- Node.js standalone output behind IIS reverse proxy on Windows Server
- GitHub Actions CI pipeline (test + build); manual deploy
- Zod-validated environment variables with fail-fast on missing config
- Feature-based component organization: `src/components/{domain}/`
- Co-located tests: test files next to source files
- cuid2 for all entity IDs

### UX Design Requirements

UX-DR1: Implement shadcn/ui design system with custom Prodigy color palette — semantic CSS variables for background, card, primary (blue), accent (UACDC green), destructive, warning, muted, border, and ring tokens in both light and dark modes
UX-DR2: Implement light/dark theme toggle using `next-themes`, respecting `prefers-color-scheme` on first load with user override persisted
UX-DR3: Implement sidebar navigation layout using shadcn/ui Sidebar component — 256px expanded, icon-only collapsed, hamburger → Sheet on mobile; role-scoped nav items (Instructor: Attendance + My Classes; Site Coord adds Youth + Enrollments; Central adds Programs + Reports; Admin adds Admin section)
UX-DR4: Implement responsive layout with three breakpoints — mobile (<768px): single column, full-width cards, hamburger nav, p-4 padding; tablet (768-1024px): sidebar icon-only, two-column forms; desktop (>1024px): sidebar expanded, multi-column layouts, full data tables, p-6 padding
UX-DR5: Implement typography system using Inter via `next/font` with system-ui fallback — Display (36px/bold), H1 (24px/semibold), H2 (20px/semibold), H3 (16px/semibold), Body (14px/normal), Small (12px/normal)
UX-DR6: Build AttendanceRoster custom component with dual-mode support — real-time mode (tap to sign in/out with auto-captured timestamps) and after-the-fact mode (manually editable time fields); desktop table layout and mobile card layout; AI/S toggle defaulting to AI; auto-calculated Tardy and Left Early; class session staff section (instructor, assistants, additional staff, volunteers); site manager verification field; submit locks all times
UX-DR7: Build YouthSearchResult card component showing name, DOB, SSN last-4 (masked), site, and enrollment status — used in instant debounced search (300ms) with results appearing as-you-type
UX-DR8: Build YouthRegistrationForm as single scrollable form with section headers and separators — Demographics → Address → Phone → Guardian sections; inline validation on blur; SSN shown during entry then masked on blur; "Register New Youth" button only appears after search returns no match
UX-DR9: Build StatCard dashboard component with label, large number (36px bold), and role-specific landing pages — Site Coordinator sees their site stats, Instructor sees today's classes, Central Team sees cross-site overview
UX-DR10: Build MetabaseEmbed component — secure iframe wrapper with server-side JWT token generation for signed embedding
UX-DR11: Build SiteFilter component — persistent site selector for Central Team (hidden for Site Team users whose data is auto-scoped)
UX-DR12: Implement button hierarchy — primary (solid blue, one per section), secondary (outline/ghost), destructive (solid red, always with confirmation dialog), accent (solid green for attendance submit); verb-first labels; full-width on mobile in form contexts
UX-DR13: Implement feedback patterns — success toasts (green, 4s auto-dismiss, bottom-right desktop / bottom-center mobile), inline field errors (red, persistent, plain language), global error toasts (red, 6s), warning banners (amber, persistent, dismissible), info hints (muted, persistent)
UX-DR14: Implement form patterns — validation on blur, required field asterisks, error messages below fields in plain language, section grouping with separators, smart defaults (site = user's site, state = "AR", AI/S = AI), SSN masking on blur
UX-DR15: Implement empty and loading states — Next.js loading.tsx with skeleton cards/tables matching expected layout; empty lists with centered message + action button; empty search with "Register New Youth" CTA
UX-DR16: Implement search and filtering patterns — debounced instant search (300ms), horizontal filter bar with Select dropdowns above data tables, filters persisted in URL search params, "Clear all" link when filters active, result counts displayed
UX-DR17: Implement accessibility — WCAG AA color contrast (4.5:1 body, 3:1 large text), minimum 44x44px touch targets, visible focus rings, semantic HTML elements, keyboard navigation, labels on all inputs, aria-labels on icon-only buttons, skip-to-main-content link, color never as sole indicator
UX-DR18: Implement navigation patterns — breadcrumbs for nested routes, back arrow on mobile, active state highlighting in sidebar with primary color, Cmd+K command palette for quick search

### FR Coverage Map

FR1: Epic 2 - Youth registration with demographics, SSN, address, phone
FR2: Epic 2 - Guardian management for youth
FR3: Epic 2 - Youth search by name or SSN last-4
FR4: Epic 2 - View and edit youth registration details
FR5: Epic 2 - Central Team cross-site youth visibility
FR6: Epic 2 - Duplicate detection during registration search
FR7: Epic 4 - Enroll youth into program at site
FR8: Epic 4 - View site enrollments with status filtering
FR9: Epic 4 - Transfer enrollment to different site
FR10: Epic 4 - Release (close) enrollment
FR11: Epic 4 - Central Team cross-site enrollment visibility
FR12: Epic 4 - Multiple concurrent enrollments per youth
FR13: Epic 4 - Central Team delete enrollment
FR14: Epic 5 - View class roster on mobile or desktop
FR15: Epic 5 - Sign in youth with auto-captured Time IN
FR16: Epic 5 - Sign out youth with auto-captured Time OUT
FR17: Epic 5 - AI/S designation per sign-in
FR18: Epic 5 - Auto-calculate Tardy and Left Early
FR19: Epic 5 - After-the-fact attendance entry with editable times
FR20: Epic 5 - Record class session staff
FR21: Epic 5 - Site Manager verification of attendance session
FR22: Epic 5 - Submit attendance session, locking times
FR23: Epic 5 - Central Team cross-site attendance visibility
FR24: Epic 5 - Site Coordinator view attendance for site classes
FR25: Epic 3 - Create, edit, deactivate programs
FR26: Epic 3 - Create, edit, deactivate courses within program
FR27: Epic 3 - Create, edit, deactivate classes within course
FR28: Epic 3 - Assign instructors to classes
FR29: Epic 3 - Define class schedules
FR30: Epic 3 - Assign courses to sites
FR31: Epic 6 - Census report filtered by month, program, site
FR32: Epic 6 - Billing report filtered by month, program, site
FR33: Epic 6 - Monthly attendance report filtered by month, site, class
FR34: Epic 6 - Auto-compute grant year (July 1 - June 30)
FR35: Epic 6 - Export reports to PDF
FR36: Epic 6 - Reports count each youth once (no duplicate inflation)
FR37: Epic 1 - Clerk authentication with MFA enforced
FR38: Epic 1 - Administrator manages user accounts via Clerk
FR39: Epic 1 - Administrator assigns roles to users
FR40: Epic 1 - Administrator scopes roles to specific site
FR41: Epic 1 - Site Team restricted to assigned site data
FR42: Epic 1 - Instructors restricted to assigned classes
FR43: Epic 1 - Encryption at rest including column-level SSN encryption
FR44: Epic 2 - SSN masking in UI (last-4 display, role-restricted)
FR45: Epic 1 - Audit logging for all CUD operations
FR46: Epic 6 - SSN excluded from Metabase connections and reports
FR47: Epic 1 - Administrator manages lookup values
FR48: Epic 1 - Lookup tables seeded from legacy data
FR49: Epic 1 - Lookup values filtered to active in forms
FR50: Epic 7 - Migration script transfers all data from SQL Server to PostgreSQL
FR51: Epic 7 - Migration deduplicates person records to unified youth identities
FR52: Epic 7 - Migration preserves enrollment history linked to deduplicated youth

## Epic List

### Epic 1: Project Foundation & Secure Access
Users can securely log in with MFA, see role-appropriate navigation, and administrators can manage users and system lookup data. The application shell, design system, audit logging, and SSN encryption infrastructure are established.
**FRs covered:** FR37, FR38, FR39, FR40, FR41, FR42, FR43, FR45, FR47, FR48, FR49

### Epic 2: Youth Registration & Search
Site Coordinators can register new youth (demographics, SSN, address, phone, guardians), search for existing records, and the system prevents duplicate creation through intelligent matching. Central Team can view youth across all sites.
**FRs covered:** FR1, FR2, FR3, FR4, FR5, FR6, FR44

### Epic 3: Program & Course Management
Central Team can create and manage the full program hierarchy — programs, courses, and classes — assign instructors, define schedules, and assign courses to sites.
**FRs covered:** FR25, FR26, FR27, FR28, FR29, FR30

### Epic 4: Program Enrollment
Site Coordinators can enroll registered youth into programs, view and filter enrollments, transfer between sites, and release enrollments. Central Team has cross-site visibility and can delete records. Multiple concurrent enrollments supported.
**FRs covered:** FR7, FR8, FR9, FR10, FR11, FR12, FR13

### Epic 5: Class Attendance
Instructors can take attendance on mobile faster than paper — sign in/out with auto-captured times, AI/S designation, after-the-fact entry mode, session staff recording, site manager verification, and submit-to-lock. Central Team and Site Coordinators can view attendance data.
**FRs covered:** FR14, FR15, FR16, FR17, FR18, FR19, FR20, FR21, FR22, FR23, FR24

### Epic 6: Reporting & Grant Analytics
Central Team can view census, billing, and attendance reports via Metabase embedded dashboards with grant year auto-computed (July 1 - June 30), PDF export, and zero duplicate inflation. SSN excluded from all report connections.
**FRs covered:** FR31, FR32, FR33, FR34, FR35, FR36, FR46

### Epic 7: Data Migration & Cutover
One-time migration script transfers all data from legacy SQL Server to PostgreSQL, deduplicates person records into unified youth identities, and preserves enrollment history.
**FRs covered:** FR50, FR51, FR52

---

## Epic 1: Project Foundation & Secure Access

Users can securely log in with MFA, see role-appropriate navigation, and administrators can manage users and system lookup data. The application shell, design system, audit logging, and SSN encryption infrastructure are established.

### Story 1.1: Project Scaffolding & Design System

As a developer,
I want the project scaffolded with the full tech stack and design system configured,
So that all subsequent development has a consistent, themed foundation to build on.

**Acceptance Criteria:**

**Given** no project exists yet
**When** the scaffold script is run
**Then** a Next.js 16 App Router project is created with TypeScript, Tailwind CSS v4, ESLint, `src/` directory, `@/*` import alias, and Turbopack
**And** shadcn/ui is initialized with core components installed (Button, Card, Input, Select, Checkbox, Label, Form, Table, Badge, Toast, Alert, Dialog, Alert Dialog, Dropdown Menu, Command, Tabs, Separator, Sheet, Sidebar)
**And** Prisma is initialized with PostgreSQL provider
**And** Vitest and Playwright are installed and configured
**And** pnpm is the package manager

**Given** the project is scaffolded
**When** the design system tokens are configured in `globals.css`
**Then** semantic CSS variables are defined for both light and dark modes: `--background`, `--card`, `--card-foreground`, `--primary` (blue), `--primary-foreground`, `--secondary`, `--muted`, `--muted-foreground`, `--accent` (UACDC green), `--destructive`, `--warning`, `--border`, `--ring`
**And** the color values match the UX specification (e.g., `--background: #FAFAFA` light / `#0A0A0A` dark)

**Given** the design system is configured
**When** the typography system is set up
**Then** Inter is loaded via `next/font` with system-ui fallback
**And** text scale levels are established: Display (36px/bold), H1 (24px/semibold), H2 (20px/semibold), H3 (16px/semibold), Body (14px/normal), Small (12px/normal)

**Given** the design system is configured
**When** a user visits the app
**Then** the theme defaults to the user's `prefers-color-scheme` preference
**And** a theme toggle (light/dark) is available via `next-themes` and persists the user's selection

**Given** the project is scaffolded
**When** environment configuration is set up
**Then** a Zod-validated `src/config/env.ts` exists that fails fast on missing required environment variables
**And** `.env.example` documents all required variables
**And** `.env.local` is git-ignored

**Given** the project is scaffolded
**When** the health check endpoint is accessed at `/api/health`
**Then** it returns a 200 OK response with basic status information

### Story 1.2: Authentication & Protected Routes

As a staff member,
I want to log in securely with MFA via Clerk,
So that only authorized users can access the system and my account is protected.

**Acceptance Criteria:**

**Given** Clerk is configured as the authentication provider
**When** an unauthenticated user visits any route except sign-in and sign-up
**Then** they are redirected to the sign-in page

**Given** a user is on the sign-in page
**When** they authenticate with valid credentials
**Then** they are signed in and redirected to the dashboard
**And** MFA is enforced — users without MFA configured are prompted to set it up

**Given** a user is on the sign-up page
**When** they complete registration
**Then** their account is created in Clerk with MFA enrollment required

**Given** a user is authenticated
**When** they are inactive for 30 minutes
**Then** their session expires and they must re-authenticate

**Given** the Clerk middleware is configured
**When** any request reaches the application
**Then** the middleware extracts the user's role and site scope from Clerk JWT `publicMetadata`
**And** this context is available to all server components and server actions

**Given** the sign-in and sign-up pages exist
**When** they are rendered
**Then** they use the Clerk `<SignIn>` and `<SignUp>` components styled to match the Prodigy design system

### Story 1.3: Role-Based Authorization & Site Scoping

As an administrator,
I want the system to enforce role-based access and site-scoped data isolation at the API layer,
So that users can only see and manage data appropriate to their role and assigned site.

**Acceptance Criteria:**

**Given** the Prisma schema is defined
**When** the `user_sites` table is created
**Then** it stores the authoritative mapping of users to roles (Administrator, Central Team, Site Team, Instructor) and assigned sites
**And** it serves as the source of truth that syncs to Clerk `publicMetadata`

**Given** a Prisma client extension is implemented in `src/lib/db.ts`
**When** a query is executed by a Site Team user
**Then** a site-scoped `WHERE` clause is automatically injected filtering to the user's assigned site
**And** this applies to all models with a `site_id` field

**Given** a Prisma client extension is implemented
**When** a query is executed by an Instructor
**Then** results are automatically filtered to only the instructor's assigned classes

**Given** a Prisma client extension is implemented
**When** a query is executed by a Central Team or Administrator user
**Then** no site-scoping filter is applied — they see data across all sites

**Given** the authorization system is in place
**When** a Site Team user attempts to access data from a different site via direct URL or API manipulation
**Then** the request returns no data or a 403 Forbidden response
**And** this is enforced at the API layer, not just the UI

**Given** role and site metadata exists in Clerk JWT
**When** the `src/lib/auth.ts` helper functions are called
**Then** they return typed role, site scope, and user session information extracted from the Clerk session

### Story 1.4: Application Shell & Role-Scoped Navigation

As a staff member,
I want a clean, responsive application layout with navigation appropriate to my role,
So that I can quickly access the features I need without seeing irrelevant options.

**Acceptance Criteria:**

**Given** a user is authenticated
**When** they view the app on desktop (> 1024px)
**Then** they see a sidebar navigation (256px wide) on the left with the main content area on the right (max-w-7xl, centered, p-6 padding)
**And** the sidebar is collapsible to icon-only mode

**Given** a user is authenticated
**When** they view the app on mobile (< 768px)
**Then** the sidebar is hidden and a hamburger icon is shown
**And** tapping the hamburger opens a Sheet overlay with the full navigation
**And** page content is full-width with p-4 padding

**Given** a user has the Instructor role
**When** the sidebar renders
**Then** they see only: Attendance, My Classes

**Given** a user has the Site Team role
**When** the sidebar renders
**Then** they see: Youth, Enrollments, Attendance, My Classes

**Given** a user has the Central Team role
**When** the sidebar renders
**Then** they see: Youth, Enrollments, Attendance, Programs, Reports

**Given** a user has the Administrator role
**When** the sidebar renders
**Then** they see all Central Team items plus an Admin section (Users, Lookups)

**Given** any authenticated user
**When** they navigate to a nested route
**Then** breadcrumbs are displayed in the page header (e.g., Youth > Maria Garcia > Enrollments)
**And** the current page is highlighted in the sidebar with the primary color

**Given** any page is loading
**When** the server component is fetching data
**Then** a `loading.tsx` skeleton is displayed matching the expected layout (skeleton cards/tables)

**Given** a server error occurs
**When** the error boundary catches it
**Then** an `error.tsx` page displays "Something went wrong" with a "Try again" button and option to go home

**Given** the layout renders
**When** keyboard navigation is used
**Then** a "Skip to main content" link is the first focusable element (visually hidden until focused)
**And** all interactive elements have visible focus rings

### Story 1.5: Audit Logging Infrastructure

As a system administrator,
I want all create, update, and delete operations logged with full context,
So that we maintain a complete audit trail for compliance and troubleshooting.

**Acceptance Criteria:**

**Given** the Prisma schema includes an `audit_log` table
**When** the table is defined
**Then** it stores: id, table_name, record_id, action (CREATE/UPDATE/DELETE), user_id (from Clerk), timestamp, before_values (JSON), after_values (JSON)

**Given** Prisma audit middleware is registered in `src/lib/db.ts`
**When** a create operation is performed on any core entity
**Then** an audit log entry is created with action = CREATE, after_values containing the new record, and the Clerk user ID

**Given** Prisma audit middleware is registered
**When** an update operation is performed on any core entity
**Then** an audit log entry is created with action = UPDATE, before_values containing the previous state, after_values containing the new state, and the Clerk user ID

**Given** Prisma audit middleware is registered
**When** a delete operation is performed on any core entity
**Then** an audit log entry is created with action = DELETE, before_values containing the deleted record, and the Clerk user ID

**Given** the audit middleware is in place
**When** any server action performs a CUD operation
**Then** the audit log is written automatically without any manual logging calls in business logic

### Story 1.6: SSN Encryption Infrastructure

As a system administrator,
I want SSN data encrypted at rest with a searchable last-4 column,
So that sensitive data is protected while still supporting search by last 4 digits.

**Acceptance Criteria:**

**Given** the `src/lib/ssn-encryption.ts` module is implemented
**When** an SSN is encrypted
**Then** Node.js crypto (AES-256-GCM) encrypts the full SSN value
**And** the encrypted value is stored in the `ssn_encrypted` column
**And** the plaintext last 4 digits are stored in the `ssn_last4` column

**Given** the encryption module is implemented
**When** an authorized user (Administrator or Central Team) requests the full SSN
**Then** the value can be decrypted from `ssn_encrypted`

**Given** the encryption module is implemented
**When** a search by last 4 SSN digits is performed
**Then** the search queries the plaintext `ssn_last4` column without decrypting all records

**Given** the encryption key management is configured
**When** the app starts
**Then** the encryption key is loaded from environment variables (never hardcoded)
**And** missing encryption key causes fail-fast startup error via Zod env validation

### Story 1.7: Lookup Data Management

As an administrator,
I want to manage lookup values (races, ethnicities, genders, statuses, enrollment types, youth types, locations),
So that forms throughout the system use consistent, up-to-date reference data.

**Acceptance Criteria:**

**Given** an Administrator navigates to Admin > Lookups
**When** the page loads
**Then** they see a list of lookup categories (races, ethnicities, genders, statuses, enrollment types, youth types, locations)
**And** each category shows its count of active/total values

**Given** an Administrator selects a lookup category
**When** the category detail loads
**Then** they see a data table with all values (active and inactive) with columns: name, status (Active/Inactive), and action buttons

**Given** an Administrator clicks "Add" on a lookup category
**When** they enter a name and submit
**Then** a new active lookup value is created
**And** a success toast confirms "Lookup value added"

**Given** an Administrator clicks "Edit" on a lookup value
**When** they modify the name and save
**Then** the value is updated
**And** a success toast confirms "Lookup value updated"

**Given** an Administrator clicks "Deactivate" on a lookup value
**When** the confirmation dialog is accepted
**Then** the value status changes to Inactive
**And** it no longer appears in form dropdowns
**And** existing records referencing this value are not affected

**Given** lookup values exist in the database
**When** any form in the system renders a lookup field (e.g., race, gender, ethnicity)
**Then** only active values are presented as selectable options

**Given** the Prisma seed script exists
**When** `prisma db seed` is run
**Then** lookup tables are populated with initial values matching legacy data categories

**Given** a non-Administrator user attempts to access Admin > Lookups
**When** the route is requested
**Then** they are redirected or shown a 403 — only Administrators can manage lookups

### Story 1.8: User Management & Role Assignment

As an administrator,
I want to create user accounts, assign roles, and scope them to specific sites,
So that each staff member has appropriate access from their first login.

**Acceptance Criteria:**

**Given** an Administrator navigates to Admin > Users
**When** the page loads
**Then** they see a list of all users with columns: name, email, role, assigned site(s), status (active/deactivated)

**Given** an Administrator clicks "Create User"
**When** they enter the user's email and submit
**Then** a new user account is created in Clerk with MFA enrollment required
**And** the user receives a setup email from Clerk

**Given** an Administrator is creating or editing a user
**When** they assign a role (Administrator, Central Team, Site Team, Instructor)
**Then** the role is saved to the `user_sites` table
**And** the role is synced to Clerk `publicMetadata` for JWT access

**Given** an Administrator assigns a Site Team or Instructor role
**When** they select a site scope
**Then** the user is associated with that specific site in the `user_sites` table
**And** the site scope is synced to Clerk `publicMetadata`
**And** the user will only see data for their assigned site

**Given** an Administrator deactivates a user
**When** the deactivation is confirmed
**Then** the user's Clerk account is deactivated
**And** they can no longer sign in
**And** their historical audit log entries are preserved

**Given** a non-Administrator user attempts to access Admin > Users
**When** the route is requested
**Then** they are redirected or shown a 403 — only Administrators can manage users

---

## Epic 2: Youth Registration & Search

Site Coordinators can register new youth (demographics, SSN, address, phone, guardians), search for existing records, and the system prevents duplicate creation through intelligent matching. Central Team can view youth across all sites.

### Story 2.1: Youth Search & Duplicate Detection

As a Site Coordinator,
I want to search for existing youth by name or last 4 SSN digits before registering a new one,
So that I can find existing records and avoid creating duplicates.

**Acceptance Criteria:**

**Given** a Site Coordinator navigates to the Youth page
**When** they type a name or last-4 SSN into the search bar
**Then** results appear as-you-type with 300ms debounce
**And** each result displays as a YouthSearchResult card showing: full name, DOB, SSN last-4 (masked), site, and enrollment status

**Given** a search returns results
**When** the results are displayed
**Then** a count is shown (e.g., "3 results for 'Garcia'")
**And** results are scoped to the user's site for Site Team, or all sites for Central Team/Admin

**Given** a search is performed
**When** the system detects potential duplicates (last name matches AND (DOB matches OR SSN last-4 matches))
**Then** matching records are highlighted with a warning banner: "Possible match found — please review before registering a new youth"

**Given** a search returns no results
**When** the "No results" state is displayed
**Then** a "Register New Youth" button appears below the empty results
**And** the coordinator must acknowledge no match was found before proceeding

**Given** a search result card is displayed
**When** the coordinator taps/clicks a result
**Then** they navigate to that youth's profile page

**Given** the search bar is empty
**When** no query has been entered
**Then** the "Register New Youth" button is not visible — search is mandatory before registration

### Story 2.2: Youth Registration Form

As a Site Coordinator,
I want to register a new youth with their demographics, SSN, address, and phone numbers in a single streamlined form,
So that I can complete intake in under 5 minutes without confusion about what fields belong where.

**Acceptance Criteria:**

**Given** a Site Coordinator clicks "Register New Youth" after searching
**When** the registration form loads
**Then** it displays as a single scrollable form with clearly labeled sections separated by dividers: Demographics, Address, Phone

**Given** the Demographics section is displayed
**When** the coordinator fills in the fields
**Then** they can enter: first name*, last name*, DOB*, race*, ethnicity*, gender*, primary language*, and SSN (optional)
**And** race, ethnicity, gender, and primary language fields are Select dropdowns populated from active lookup values
**And** required fields are marked with an asterisk (*)

**Given** the SSN field is being filled
**When** the coordinator enters a full SSN
**Then** the value is shown in plaintext during entry
**And** on blur, it masks to `***-**-1234` format
**And** on save, the SSN is encrypted via the encryption module and `ssn_last4` is stored

**Given** the Address section is displayed
**When** the coordinator fills in address fields
**Then** they can enter: street address, city, state (defaulting to "AR"), and zip code

**Given** the Phone section is displayed
**When** the coordinator fills in phone fields
**Then** they can add one or more phone numbers with type (home, cell, work)

**Given** any required field is left empty
**When** the field loses focus (on blur)
**Then** an inline error message appears below the field in red with plain language (e.g., "Enter a date of birth")

**Given** all required fields are valid
**When** the coordinator clicks "Register Youth"
**Then** the youth record is created in the database
**And** a success toast displays "Youth registered successfully"
**And** the page navigates to the new youth's profile

**Given** the form submission fails (server error)
**When** the error is returned
**Then** a global error toast displays (red, 6s auto-dismiss) with a descriptive message
**And** no data is lost — the form retains all entered values

### Story 2.3: Guardian Management

As a Site Coordinator,
I want to add parent/guardian records to a youth with their own demographics and contact info,
So that we have complete family information for each youth.

**Acceptance Criteria:**

**Given** a Site Coordinator is on the youth registration form or youth profile
**When** they access the Guardian section
**Then** they can add one or more guardians

**Given** the coordinator adds a guardian
**When** they fill in the guardian form
**Then** they can enter: first name*, last name*, relationship to youth*, phone number*, and address (optional — can default to youth's address)
**And** required fields are marked with asterisks and validated on blur

**Given** a guardian has been added
**When** the coordinator needs to add another guardian
**Then** they can click "Add Another Guardian" to add additional guardian records
**And** each guardian is displayed as a collapsible card showing name and relationship

**Given** a guardian record exists on a youth profile
**When** the coordinator clicks "Edit" on the guardian
**Then** they can modify the guardian's details and save
**And** a success toast confirms "Guardian updated"

**Given** a guardian record exists
**When** the coordinator clicks "Remove" on the guardian
**Then** a confirmation dialog appears
**And** upon confirmation, the guardian association is removed
**And** a success toast confirms "Guardian removed"

### Story 2.4: Youth Profile View & Edit

As a Site Coordinator,
I want to view and edit a youth's registration details after creation,
So that I can keep records accurate and up to date.

**Acceptance Criteria:**

**Given** a user navigates to a youth's profile page
**When** the profile loads
**Then** it displays all registration details organized by section: Demographics, Address, Phone, Guardians
**And** SSN displays as masked (`***-**-1234`) for all users

**Given** a user with Administrator or Central Team role views the profile
**When** they click "Show SSN"
**Then** the full SSN is decrypted and displayed temporarily
**And** Site Team and Instructor roles do not see the "Show SSN" option

**Given** a Site Coordinator clicks "Edit" on the youth profile
**When** the edit form loads
**Then** all fields are pre-populated with current values
**And** the same validation rules apply as during registration (inline errors on blur, required fields)

**Given** a Site Coordinator makes changes and saves
**When** the update is submitted
**Then** the youth record is updated in the database
**And** a success toast confirms "Youth updated successfully"
**And** the profile page reflects the changes immediately

**Given** a Site Coordinator views the youth profile
**When** they look at the profile actions
**Then** they see an "Enroll in Program" button (enabled for future Epic 4 implementation)

### Story 2.5: Cross-Site Youth Visibility

As a Central Team member,
I want to view youth records across all sites,
So that I can find any youth in the system regardless of which site registered them.

**Acceptance Criteria:**

**Given** a Central Team or Administrator user navigates to the Youth page
**When** the page loads
**Then** they see youth records from all sites (no site-scoping filter applied)
**And** each youth record shows which site registered them

**Given** a Central Team user views the Youth list
**When** a SiteFilter component is displayed
**Then** they can filter the list by site using a Select dropdown
**And** the filter defaults to "All Sites"
**And** the selected filter is persisted in URL search params

**Given** a Site Team user navigates to the Youth page
**When** the page loads
**Then** they see only youth registered at their assigned site
**And** no SiteFilter component is displayed (their data is auto-scoped)

**Given** a Central Team user searches for a youth
**When** results are returned
**Then** results include youth from all sites
**And** each result card shows the youth's site for identification

---

## Epic 3: Program & Course Management

Central Team can create and manage the full program hierarchy — programs, courses, and classes — assign instructors, define schedules, and assign courses to sites.

### Story 3.1: Program Management

As a Central Team member,
I want to create, edit, and deactivate programs,
So that the program catalog reflects our current offerings.

**Acceptance Criteria:**

**Given** a Central Team or Administrator user navigates to Programs
**When** the page loads
**Then** they see a data table of all programs with columns: name, status (Active/Inactive), number of courses, and action buttons
**And** the table supports sorting and filtering by status

**Given** a Central Team user clicks "Create Program"
**When** they fill in the program name and submit
**Then** a new active program is created
**And** a success toast confirms "Program created"
**And** the programs list refreshes to include the new program

**Given** a Central Team user clicks "Edit" on a program
**When** they modify the name and save
**Then** the program is updated
**And** a success toast confirms "Program updated"

**Given** a Central Team user clicks "Deactivate" on a program
**When** the confirmation dialog is accepted
**Then** the program status changes to Inactive
**And** it is no longer available for new enrollments
**And** existing enrollments in this program are not affected

**Given** a Site Team or Instructor user attempts to access Programs
**When** the route is requested
**Then** they do not see Programs in their navigation (role-scoped nav hides it)

### Story 3.2: Course Management

As a Central Team member,
I want to create, edit, and deactivate courses within a program and assign them to sites,
So that each site knows which courses they offer.

**Acceptance Criteria:**

**Given** a Central Team user navigates to a program's detail page
**When** the page loads
**Then** they see a list of courses within that program with columns: name, status, assigned sites, number of classes, and action buttons

**Given** a Central Team user clicks "Create Course"
**When** they fill in the course name and submit
**Then** a new active course is created within the current program
**And** a success toast confirms "Course created"

**Given** a Central Team user clicks "Edit" on a course
**When** they modify the name and save
**Then** the course is updated
**And** a success toast confirms "Course updated"

**Given** a Central Team user clicks "Deactivate" on a course
**When** the confirmation dialog is accepted
**Then** the course status changes to Inactive
**And** its classes are no longer available for new attendance sessions
**And** existing attendance records are not affected

**Given** a Central Team user selects "Assign to Sites" on a course
**When** they select one or more sites from a multi-select
**Then** the course is associated with those sites
**And** Site Team users at those sites can see and create classes for this course

### Story 3.3: Class Management & Scheduling

As a Central Team member, Site Coordinator, or Administrator,
I want to create classes within a course, define schedules, and assign instructors,
So that instructors know their teaching assignments and attendance rosters are generated correctly.

**Acceptance Criteria:**

**Given** an authorized user navigates to a course's detail page
**When** the page loads
**Then** they see a list of classes with columns: name, instructor, schedule (days/times), date range, status, and action buttons

**Given** an authorized user clicks "Create Class"
**When** they fill in the class form
**Then** they can enter: class name*, scheduled days (multi-select: Mon-Fri)*, start time*, end time*, start date*, end date*
**And** required fields are validated on blur
**And** a new active class is created on submit with a success toast

**Given** an authorized user clicks "Edit" on a class
**When** they modify class details and save
**Then** the class is updated
**And** a success toast confirms "Class updated"

**Given** an authorized user clicks "Deactivate" on a class
**When** the confirmation dialog is accepted
**Then** the class status changes to Inactive
**And** it no longer appears in the instructor's attendance class list
**And** existing attendance records are preserved

**Given** an authorized user clicks "Assign Instructor" on a class
**When** they select an instructor from a dropdown of users with Instructor or Site Team role at the relevant site
**Then** the instructor is assigned to the class
**And** the class appears in that instructor's "My Classes" view and attendance class list

**Given** a class has a defined schedule
**When** the schedule is saved
**Then** the start time and end time are stored and used for Tardy/Left Early auto-calculation in attendance (Epic 5)

**Given** a Site Coordinator creates or edits a class
**When** they interact with the class form
**Then** they can only manage classes at their assigned site (site-scoping enforced)

---

## Epic 4: Program Enrollment

Site Coordinators can enroll registered youth into programs, view and filter enrollments, transfer between sites, and release enrollments. Central Team has cross-site visibility and can delete records. Multiple concurrent enrollments supported.

### Story 4.1: Enroll Youth in Program

As a Site Coordinator,
I want to enroll a registered youth into a program at my site,
So that the youth is officially participating and appears on class rosters.

**Acceptance Criteria:**

**Given** a Site Coordinator is viewing a youth's profile
**When** they click "Enroll in Program"
**Then** a dialog or form appears with a Select dropdown of active programs that have courses assigned to the coordinator's site

**Given** the enrollment form is displayed
**When** the coordinator selects a program
**Then** the site field is pre-filled with the coordinator's assigned site
**And** the enrollment status defaults to Active

**Given** the coordinator confirms the enrollment
**When** the enrollment is submitted
**Then** an enrollment record is created linking the youth to the program at the site
**And** a success toast confirms "Enrolled in [Program Name]"
**And** the youth's profile shows the new enrollment

**Given** a youth already has an active enrollment in the same program at the same site
**When** the coordinator attempts to enroll them again
**Then** the system prevents the duplicate enrollment and displays an inline error

**Given** a youth has an active enrollment in Program A
**When** the coordinator enrolls them in Program B
**Then** both enrollments are active concurrently — multiple concurrent enrollments are supported

### Story 4.2: Enrollment List & Filtering

As a Site Coordinator,
I want to view all enrollments at my site with filtering by status,
So that I can manage active participants and review past enrollments.

**Acceptance Criteria:**

**Given** a Site Coordinator navigates to Enrollments
**When** the page loads
**Then** they see a data table of enrollments at their site with columns: youth name, program, site, status (Active/Released), enrollment date, and action buttons
**And** the table defaults to showing Active enrollments

**Given** the enrollment list is displayed
**When** the coordinator uses the status filter
**Then** they can toggle between Active, Released, and All enrollments
**And** the filter is persisted in URL search params

**Given** a Central Team or Administrator user navigates to Enrollments
**When** the page loads
**Then** they see enrollments across all sites
**And** a SiteFilter dropdown allows filtering by site (defaults to "All Sites")

**Given** the enrollment list has many records
**When** the table renders
**Then** pagination is applied with result counts shown (e.g., "Showing 1-25 of 142")

### Story 4.3: Transfer Enrollment

As a Site Coordinator,
I want to transfer a youth's enrollment to a different site,
So that youth who move between locations maintain their enrollment continuity.

**Acceptance Criteria:**

**Given** a Site Coordinator or Central Team user views an active enrollment
**When** they click "Transfer"
**Then** a dialog appears with a Select dropdown of available sites (excluding the current site)

**Given** the transfer dialog is displayed
**When** the user selects a destination site and confirms
**Then** the enrollment's site is updated to the new site
**And** a success toast confirms "Enrollment transferred to [Site Name]"
**And** the enrollment record preserves its history (original enrollment date, previous site tracked)

**Given** a Site Team user at the original site
**When** the transfer is complete
**Then** the enrollment no longer appears in their site-scoped view

**Given** a Site Team user at the destination site
**When** they view their enrollments
**Then** the transferred enrollment appears in their list

### Story 4.4: Release & Delete Enrollment

As a Site Coordinator,
I want to release (close) a youth's enrollment when they leave the program,
So that the enrollment status accurately reflects participation.

**Acceptance Criteria:**

**Given** a Site Coordinator views an active enrollment
**When** they click "Release"
**Then** a confirmation dialog appears explaining the enrollment will be closed

**Given** the release confirmation is accepted
**When** the release is processed
**Then** the enrollment status changes to Released
**And** a release date is recorded
**And** a success toast confirms "Enrollment released"
**And** the youth's other active enrollments (if any) are not affected

**Given** a released enrollment exists
**When** it appears in the enrollment list
**Then** it shows status "Released" with a badge and the release date

**Given** a Central Team user views any enrollment
**When** they click "Delete"
**Then** a destructive confirmation dialog appears (red styling) warning that this permanently removes the record

**Given** the delete confirmation is accepted
**When** the deletion is processed
**Then** the enrollment record is permanently deleted
**And** a success toast confirms "Enrollment deleted"
**And** the audit log captures the deletion with before-values

**Given** a Site Team user views an enrollment
**When** they look at available actions
**Then** they see "Release" but not "Delete" — only Central Team and Administrators can delete enrollments

---

## Epic 5: Class Attendance

Instructors can take attendance on mobile faster than paper — sign in/out with auto-captured times, AI/S designation, after-the-fact entry mode, session staff recording, site manager verification, and submit-to-lock. Central Team and Site Coordinators can view attendance data.

### Story 5.1: Class Selection & Roster View

As an Instructor,
I want to see my assigned classes and open a roster for attendance,
So that I can quickly start taking attendance for the right class.

**Acceptance Criteria:**

**Given** an Instructor navigates to Attendance
**When** the page loads
**Then** they see a list of their assigned classes as tappable cards showing: class name, course, schedule (days/times), and enrolled youth count
**And** today's classes are highlighted or sorted to the top

**Given** the Instructor taps a class
**When** the attendance roster loads
**Then** all enrolled youth are displayed alphabetically
**And** all youth start as unmarked (not signed in)
**And** a header shows: class name, date (today by default), and class time

**Given** the roster loads on desktop (> 1024px)
**When** the layout renders
**Then** it displays as a data table with columns: #, Youth Name, AI/S, Time IN, Time OUT, Tardy, Left Early, and action button

**Given** the roster loads on mobile (< 768px)
**When** the layout renders
**Then** each youth is displayed as a tappable card showing name and sign-in status
**And** touch targets are minimum 44x44px

**Given** the roster is displayed
**When** the running count updates
**Then** a summary line is visible at the top: "X of Y signed in"

### Story 5.2: Real-Time Sign In & Sign Out

As an Instructor,
I want to tap a youth's name to sign them in and tap "Out" to sign them out with times captured automatically,
So that attendance capture is faster than a paper clipboard.

**Acceptance Criteria:**

**Given** the attendance roster is open in real-time mode
**When** the Instructor taps a youth's name (or row)
**Then** Time IN is recorded at the current time
**And** the row/card turns green with a visual indicator
**And** AI/S defaults to AI (Authorized Individual)

**Given** a youth is signed in
**When** the Instructor taps the "Out" button for that youth
**Then** Time OUT is recorded at the current time
**And** the row updates to show both Time IN and Time OUT

**Given** a youth is signed in
**When** the Instructor needs to change the AI/S designation
**Then** they can toggle between AI and S via a dropdown or toggle button
**And** the default is AI; toggle to S only for self-sign-in

**Given** a youth was signed in by mistake
**When** the Instructor taps the signed-in youth again (before submitting)
**Then** the sign-in can be undone — Time IN is cleared and the row returns to unmarked state

**Given** multiple youth are arriving throughout the session
**When** the Instructor signs them in at different times
**Then** each youth's Time IN reflects the actual moment they were tapped
**And** the running count ("X of Y signed in") updates after each action

### Story 5.3: Tardy & Left Early Auto-Calculation

As a program administrator,
I want Tardy and Left Early flags auto-calculated from times and class schedule,
So that these indicators are accurate without manual entry or human error.

**Acceptance Criteria:**

**Given** a youth is signed in to a class session
**When** their Time IN is more than 15 minutes after the class start time
**Then** the Tardy flag is automatically set to true
**And** a "Tardy" badge is displayed on the youth's row/card

**Given** a youth is signed out of a class session
**When** their Time OUT is before the class end time
**Then** the Left Early flag is automatically set to true
**And** a "Left Early" badge is displayed on the youth's row/card

**Given** a youth's Time IN is within 15 minutes of class start
**When** Tardy is calculated
**Then** the Tardy flag is false and no badge is shown

**Given** a youth's Time OUT is at or after class end time
**When** Left Early is calculated
**Then** the Left Early flag is false and no badge is shown

**Given** Tardy and Left Early fields exist on the roster
**When** an Instructor views them
**Then** they are read-only — displayed as computed badges, never manually editable

### Story 5.4: After-the-Fact Attendance Entry

As a staff member,
I want to enter attendance after the fact with manually editable time fields,
So that attendance can be recorded when paper was used or real-time entry wasn't possible.

**Acceptance Criteria:**

**Given** a staff member opens a class for a past date or selects after-the-fact mode
**When** the roster loads
**Then** a banner displays: "Entering attendance for [date]"
**And** Time IN and Time OUT fields are editable text inputs (not auto-captured)

**Given** the after-the-fact roster is displayed
**When** the staff member types a Time IN for a youth
**Then** the time is accepted in standard format (e.g., 2:15 PM)
**And** Tardy is auto-calculated against the class start time

**Given** the staff member types a Time OUT for a youth
**When** the time is entered
**Then** Left Early is auto-calculated against the class end time

**Given** the staff member sets AI/S per youth
**When** they toggle the designation
**Then** it works the same as real-time mode (default AI, toggle to S)

**Given** all times are entered
**When** the staff member clicks "Submit"
**Then** the attendance session is saved with the manually entered times
**And** a success toast confirms submission
**And** all times are locked after submission

### Story 5.5: Session Staff & Site Manager Verification

As an Instructor,
I want to record the staff present during a class session and allow a site manager to verify the attendance,
So that session records are complete and verified for compliance.

**Acceptance Criteria:**

**Given** an attendance roster is open
**When** the class staff section is displayed at the top
**Then** the assigned instructor is auto-populated
**And** fields are available for: instructor assistant(s) (multi-select from staff or free text), additional staff (free text), and volunteers (free text)

**Given** the instructor fills in session staff
**When** they add an assistant
**Then** they can select from a dropdown of staff users at the site or type a free-text name
**And** multiple assistants can be added

**Given** an attendance session has been submitted
**When** a Site Manager views the session
**Then** they see a verification section with fields for: verifier name and verification date

**Given** a Site Manager fills in verification
**When** they enter their name and the date and save
**Then** the verification is recorded on the attendance session
**And** a success toast confirms "Session verified"
**And** verification can be completed at any time after submission

### Story 5.6: Submit Attendance & Lock

As an Instructor,
I want to submit a completed attendance session so that times are locked and the data is final,
So that central office can trust the submitted data won't change.

**Acceptance Criteria:**

**Given** an Instructor has signed in/out youth for a class session
**When** they tap "Submit Attendance"
**Then** a success toast confirms: "Attendance submitted for [Class Name] — X of Y signed in"
**And** the submit button changes to "Submitted ✓" (disabled state)

**Given** an attendance session has been submitted
**When** anyone views the session
**Then** all Time IN, Time OUT, and AI/S fields are locked and read-only
**And** the session displays a "Submitted" status indicator

**Given** an attendance session has not been submitted
**When** the Instructor navigates away
**Then** the in-progress data is preserved — they can return and continue

### Story 5.7: Attendance Visibility for Central Team & Site Coordinators

As a Central Team member or Site Coordinator,
I want to view submitted attendance data for reporting and oversight,
So that I can monitor attendance across classes and sites without delay.

**Acceptance Criteria:**

**Given** a Central Team user navigates to Attendance
**When** the page loads
**Then** they see attendance data across all sites
**And** they can filter by site, class, and date range
**And** filters are persisted in URL search params

**Given** a Site Coordinator navigates to Attendance
**When** the page loads
**Then** they see attendance data for their site's classes only (site-scoped)
**And** they can filter by class and date range

**Given** an Instructor submits attendance
**When** a Central Team user or Site Coordinator views the data
**Then** the submitted session is visible immediately on page refresh — no delay

**Given** attendance data is displayed
**When** the user views a class session
**Then** they see: class name, date, instructor, number signed in, submitted status, and verification status
**And** they can drill into the session to see individual youth sign-in/out times

---

## Epic 6: Reporting & Grant Analytics

Central Team can view census, billing, and attendance reports via Metabase embedded dashboards with grant year auto-computed (July 1 - June 30), PDF export, and zero duplicate inflation. SSN excluded from all report connections.

### Story 6.1: Metabase Integration & Secure Embedding

As a Central Team member,
I want reports embedded securely within Prodigy via Metabase,
So that I can access dashboards without leaving the application or managing separate credentials.

**Acceptance Criteria:**

**Given** the Metabase JWT Route Handler exists at `/api/metabase-embed`
**When** a report page requests an embed token
**Then** a signed JWT is generated server-side using the Metabase secret key
**And** the token is scoped to the specific dashboard being requested

**Given** the MetabaseEmbed component renders on a report page
**When** the iframe loads
**Then** the Metabase dashboard is displayed within the Prodigy layout
**And** the embed uses HTTPS for the connection

**Given** the Metabase database connection is configured
**When** the connection is established to PostgreSQL
**Then** SSN encrypted columns are excluded from the connection — Metabase cannot query or display SSN data

**Given** a non-Central Team user (Site Team or Instructor) attempts to access a report page
**When** the route is requested
**Then** they do not see Reports in their navigation and the route returns a 403

**Given** the embed token has expired
**When** the iframe attempts to load
**Then** a new token is generated automatically without user intervention

### Story 6.2: Census & Billing Reports

As a Central Team member,
I want to view census and billing reports filtered by month, program, and site,
So that I can produce accurate counts for grant submissions.

**Acceptance Criteria:**

**Given** a Central Team user navigates to Reports > Census
**When** the page loads
**Then** a Metabase census dashboard is embedded with filters: month (defaults to current), program (defaults to all), and site (defaults to all)

**Given** the census report renders
**When** the data is displayed
**Then** each youth is counted once regardless of how many enrollments they have — no duplicate inflation
**And** the count reflects unique youth with active enrollments matching the filter criteria

**Given** a Central Team user navigates to Reports > Billing
**When** the page loads
**Then** a Metabase billing dashboard is embedded with the same filter options: month, program, and site

**Given** either report is displayed
**When** the user adjusts filters (month, program, site)
**Then** the Metabase dashboard re-renders with the filtered data
**And** the report renders within 3 seconds

**Given** the grant year runs July 1 through June 30
**When** reports are filtered or grouped by grant year
**Then** the grant year is computed automatically from enrollment and attendance dates — not manually configured
**And** the computation is consistent between the app and Metabase queries

### Story 6.3: Monthly Attendance Report & PDF Export

As a Central Team member,
I want to view a monthly attendance report and export any report to PDF,
So that I can submit accurate attendance data for grant compliance.

**Acceptance Criteria:**

**Given** a Central Team user navigates to Reports > Attendance
**When** the page loads
**Then** a Metabase attendance dashboard is embedded with filters: month (defaults to current), site (defaults to all), and class (defaults to all)

**Given** the attendance report renders
**When** the data is displayed
**Then** it shows attendance summaries per class: total enrolled, total sessions, average attendance rate, and individual session details

**Given** any report is displayed (census, billing, or attendance)
**When** the user clicks "Export to PDF"
**Then** a PDF is generated via Metabase's native export functionality
**And** the PDF reflects the currently applied filters

**Given** the reports page loads
**When** the user views the Reports index
**Then** they see three card links: Census, Billing, and Attendance — clean and simple navigation to each report type

---

## Epic 7: Data Migration & Cutover

One-time migration script transfers all data from legacy SQL Server to PostgreSQL, deduplicates person records into unified youth identities, and preserves enrollment history.

### Story 7.1: Migration Script — Lookup & Program Structure Data

As a system administrator,
I want to migrate lookup tables, programs, courses, classes, and site data from legacy SQL Server to PostgreSQL,
So that the new system has all reference data and program structure before youth and enrollment data is migrated.

**Acceptance Criteria:**

**Given** the migration script connects to the legacy SQL Server (read-only)
**When** the lookup migration step runs
**Then** all lookup values (races, ethnicities, genders, statuses, enrollment types, youth types, locations/sites) are transferred to PostgreSQL
**And** values match the legacy data with correct mappings to the new schema

**Given** the lookup migration is complete
**When** the program structure migration step runs
**Then** all programs, courses, classes, class schedules, and instructor assignments are transferred
**And** course-to-site assignments are preserved
**And** foreign key relationships are maintained

**Given** the migration script runs
**When** any step fails
**Then** the script logs the error with context (table, record, reason)
**And** the script is repeatable — it can be re-run against a fresh PostgreSQL database without manual cleanup

### Story 7.2: Migration Script — Youth Deduplication & Identity Mapping

As a system administrator,
I want the migration to deduplicate person records and create unified youth identities,
So that the new system has one record per youth regardless of how many times they were enrolled in the legacy system.

**Acceptance Criteria:**

**Given** the legacy SQL Server contains person records with duplicates (same person enrolled multiple times creates separate records)
**When** the deduplication step runs
**Then** the script identifies duplicate persons using matching rules: exact name + DOB match, or exact name + SSN match
**And** each group of duplicates is merged into a single youth record in PostgreSQL

**Given** duplicate person records are identified
**When** they are merged
**Then** the most complete demographic data is preserved (non-null values preferred)
**And** a mapping table records all legacy person IDs → new youth ID for traceability

**Given** a person record has an SSN in legacy
**When** it is migrated
**Then** the SSN is encrypted using the application encryption module
**And** the `ssn_last4` column is populated with the plaintext last 4 digits

**Given** the deduplication is complete
**When** the results are reviewed
**Then** the script outputs a summary: total legacy persons, unique youth created, duplicates merged, and any records flagged for manual review

### Story 7.3: Migration Script — Enrollment History & Attendance Data

As a system administrator,
I want enrollment history and attendance records migrated with correct links to deduplicated youth,
So that historical data is preserved and accessible in the new system.

**Acceptance Criteria:**

**Given** youth deduplication is complete with a legacy-to-new ID mapping
**When** the enrollment migration step runs
**Then** all enrollment records are transferred to PostgreSQL
**And** each enrollment is linked to the correct deduplicated youth ID (not the legacy person ID)
**And** enrollment dates, statuses, program, and site associations are preserved

**Given** enrollments are migrated
**When** the attendance migration step runs
**Then** all attendance records are transferred with correct links to enrollments, classes, and youth
**And** Time IN, Time OUT, AI/S designation, Tardy, and Left Early values are preserved

**Given** the full migration is complete
**When** validation checks run
**Then** the script verifies: total youth count matches expected (after dedup), total enrollments match legacy count, attendance record counts match
**And** a validation report is output with pass/fail per check

**Given** the migration script has been validated against a copy of production data
**When** the cutover is approved
**Then** the script can be run against the real production SQL Server
**And** full backups of both legacy SQL Server and new PostgreSQL are taken before and after

---

That's **8 stories for Epic 1** covering all 11 FRs (FR37-FR42, FR43, FR45, FR47-FR49) plus foundational UX-DRs. Each story is standalone and enables the next without requiring future stories.

Does Epic 1 look complete and accurate? Ready to move on to Epic 2?
