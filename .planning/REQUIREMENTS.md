# Requirements: Prodigy

**Defined:** 2026-03-29
**Core Value:** Every youth has exactly one record. Enrollments, attendance, and reports all trace back to that single identity.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Authentication & Authorization

- [ ] **AUTH-01**: Staff can log in via Clerk with MFA enforced for all users
- [ ] **AUTH-02**: Three roles enforced: Admin (all access), Central (all sites read + cross-site reports), Site (own site only)
- [ ] **AUTH-03**: After login, user selects a program — all views filtered by selected program
- [ ] **AUTH-04**: Every Server Action independently calls `auth()` (middleware is not a security boundary per CVE-2025-29927)

### Lookups & Reference Data

- [ ] **LOOK-01**: Admin can manage lookup tables (races, ethnicities, genders, enrollment types, statuses, sites)
- [ ] **LOOK-02**: Lookup values populate all form dropdowns consistently across the application

### Youth Registration

- [ ] **YOUTH-01**: Staff can register a new youth with demographics, guardian info, address, and phone in a single form (< 5 min)
- [ ] **YOUTH-02**: SSN is stored encrypted and displayed masked (last 4 only) to authorized roles
- [ ] **YOUTH-03**: Inline duplicate detection surfaces likely matches (name + DOB + SSN) during registration before creating a new record
- [ ] **YOUTH-04**: Staff can search for existing youth by name, DOB, or SSN
- [ ] **YOUTH-05**: Staff can edit youth demographics after registration
- [ ] **YOUTH-06**: One youth = one record, always. No workflow creates a duplicate person record

### Enrollment

- [ ] **ENRL-01**: Staff can enroll a youth into a program at a site (enrollment decoupled from person identity)
- [ ] **ENRL-02**: Enrollment has status lifecycle: active, inactive, released — with date tracking
- [ ] **ENRL-03**: Staff can transfer a youth's enrollment between sites without creating a new record
- [ ] **ENRL-04**: Staff can release (exit) a youth from an enrollment
- [ ] **ENRL-05**: Grant year is computed from enrollment date (July 1 fiscal year boundary) — no hardcoded config
- [ ] **ENRL-06**: Staff can roll over enrollments to next grant year without re-entering youth data
- [ ] **ENRL-07**: Youth enrollment history is viewable (all enrollments across programs, sites, years)

### Program Structure

- [ ] **PROG-01**: Admin can create and manage programs
- [ ] **PROG-02**: Admin can create courses within programs
- [ ] **PROG-03**: Staff can create course instances (site-scoped runs) with instructor, location, days/times, capacity
- [ ] **PROG-04**: Staff can schedule individual class sessions within a course instance

### Attendance

- [ ] **ATTN-01**: Staff can take class attendance on a mobile device in under 2 minutes per class
- [ ] **ATTN-02**: Class roster displays enrolled youth with single-tap present/absent toggle
- [ ] **ATTN-03**: Attendance data is visible to central office on page refresh (no batch sync)
- [ ] **ATTN-04**: Staff can record event attendance (separate from class attendance)
- [ ] **ATTN-05**: Staff can view a youth's complete attendance history across all programs
- [ ] **ATTN-06**: Sign-in and sign-out times are captured for each attendance record

### Reporting

- [ ] **REPT-01**: Census report available via Metabase — youth who attended at least once per reporting period, filtered by program/site/date
- [ ] **REPT-02**: Billing report available via Metabase — attendance-based billing, program and site scoped
- [ ] **REPT-03**: Attendance report available via Metabase — aggregate and individual attendance data, multiple time ranges
- [ ] **REPT-04**: All reports use the same computed grant year formula as the application
- [ ] **REPT-05**: Central team can build custom Metabase questions without developer involvement

### PAT Forms

- [ ] **PAT-01**: Staff can complete PAT (Program Assessment Tool) forms tied to an enrollment
- [ ] **PAT-02**: PAT form renders as tabbed multi-section form with dynamic fields
- [ ] **PAT-03**: Completed PAT forms are viewable in youth/enrollment history

### Staff Management

- [ ] **STAFF-01**: Admin can create and edit staff records
- [ ] **STAFF-02**: Admin can assign staff to sites (site assignment drives data visibility)
- [ ] **STAFF-03**: Admin can provision and revoke system access via Clerk

### Infrastructure

- [ ] **INFRA-01**: Database audit trail logs every insert/update/delete with user, timestamp, old/new values
- [ ] **INFRA-02**: Audit trail is active from day 1 — no records exist without audit coverage
- [ ] **INFRA-03**: SSN encryption at rest in PostgreSQL
- [ ] **INFRA-04**: Playwright parity tests validate behavioral equivalence with legacy before cutover
- [ ] **INFRA-05**: Health check endpoint returns 200 OK with status

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Lesson Plans

- **LSSN-01**: Staff can create lesson plan sets attached to course instances
- **LSSN-02**: Lesson plans include life skills tracking
- **LSSN-03**: Central team can approve/reject submitted lesson plans

### Risk Assessment

- **RISK-01**: Staff can complete risk assessment forms per enrollment
- **RISK-02**: Risk assessment fields are role-scoped (some visible only to certain roles)

### Other

- **OTHR-01**: Inventory item management
- **OTHR-02**: Certificate/document generation

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Parent/guardian portal | Internal staff tool only. Parents interact in person or by phone |
| Online payment processing | Grant-funded programs, no billing to families |
| Public registration form | Registration done by staff on behalf of youth |
| Mobile native app | Web-first responsive design covers the use case |
| SMS/push notifications | Staff communicate through existing channels |
| Gradual/feature-flag rollout | Big-bang cutover for < 50 users per PROJECT.md |
| Legacy SQL Server integration | Independent PostgreSQL, one-time data migration at cutover |
| 1:1 legacy feature parity | Workflows are rethought, not replicated |
| Technical support ticket system | Use existing channels (email, Slack) |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTH-01 | TBD | Pending |
| AUTH-02 | TBD | Pending |
| AUTH-03 | TBD | Pending |
| AUTH-04 | TBD | Pending |
| LOOK-01 | TBD | Pending |
| LOOK-02 | TBD | Pending |
| YOUTH-01 | TBD | Pending |
| YOUTH-02 | TBD | Pending |
| YOUTH-03 | TBD | Pending |
| YOUTH-04 | TBD | Pending |
| YOUTH-05 | TBD | Pending |
| YOUTH-06 | TBD | Pending |
| ENRL-01 | TBD | Pending |
| ENRL-02 | TBD | Pending |
| ENRL-03 | TBD | Pending |
| ENRL-04 | TBD | Pending |
| ENRL-05 | TBD | Pending |
| ENRL-06 | TBD | Pending |
| ENRL-07 | TBD | Pending |
| PROG-01 | TBD | Pending |
| PROG-02 | TBD | Pending |
| PROG-03 | TBD | Pending |
| PROG-04 | TBD | Pending |
| ATTN-01 | TBD | Pending |
| ATTN-02 | TBD | Pending |
| ATTN-03 | TBD | Pending |
| ATTN-04 | TBD | Pending |
| ATTN-05 | TBD | Pending |
| ATTN-06 | TBD | Pending |
| REPT-01 | TBD | Pending |
| REPT-02 | TBD | Pending |
| REPT-03 | TBD | Pending |
| REPT-04 | TBD | Pending |
| REPT-05 | TBD | Pending |
| PAT-01 | TBD | Pending |
| PAT-02 | TBD | Pending |
| PAT-03 | TBD | Pending |
| STAFF-01 | TBD | Pending |
| STAFF-02 | TBD | Pending |
| STAFF-03 | TBD | Pending |
| INFRA-01 | TBD | Pending |
| INFRA-02 | TBD | Pending |
| INFRA-03 | TBD | Pending |
| INFRA-04 | TBD | Pending |
| INFRA-05 | TBD | Pending |

**Coverage:**
- v1 requirements: 45 total
- Mapped to phases: 0
- Unmapped: 45

---
*Requirements defined: 2026-03-29*
*Last updated: 2026-03-29 after initial definition*
