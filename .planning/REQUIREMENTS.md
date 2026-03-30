# Requirements: Prodigy

**Defined:** 2026-03-29
**Core Value:** Every youth has exactly one record. Enrollments, attendance, and reports all trace back to that single identity.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Authentication & Authorization

- [x] **AUTH-01**: Staff can log in via Clerk with MFA enforced for all users
- [x] **AUTH-02**: Three roles enforced: Admin (all access), Central (all sites read + cross-site reports), Site (own site only)
- [x] **AUTH-03**: After login, user selects a program — all views filtered by selected program
- [x] **AUTH-04**: Every Server Action independently calls `auth()` (middleware is not a security boundary per CVE-2025-29927)

### Lookups & Reference Data

- [ ] **LOOK-01**: Admin can manage lookup tables (races, ethnicities, genders, enrollment types, statuses, sites)
- [x] **LOOK-02**: Lookup values populate all form dropdowns consistently across the application

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

- [x] **INFRA-01**: Database audit trail logs every insert/update/delete with user, timestamp, old/new values
- [x] **INFRA-02**: Audit trail is active from day 1 — no records exist without audit coverage
- [x] **INFRA-03**: SSN encryption at rest in PostgreSQL
- [ ] **INFRA-04**: Playwright parity tests validate behavioral equivalence with legacy before cutover
- [x] **INFRA-05**: Health check endpoint returns 200 OK with status

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
| AUTH-01 | Phase 0 | Complete |
| AUTH-02 | Phase 0 | Complete |
| AUTH-03 | Phase 0 | Complete |
| AUTH-04 | Phase 0 | Complete |
| LOOK-01 | Phase 2 | Pending |
| LOOK-02 | Phase 0 | Complete |
| YOUTH-01 | Phase 1 | Pending |
| YOUTH-02 | Phase 1 | Pending |
| YOUTH-03 | Phase 1 | Pending |
| YOUTH-04 | Phase 1 | Pending |
| YOUTH-05 | Phase 1 | Pending |
| YOUTH-06 | Phase 1 | Pending |
| ENRL-01 | Phase 3 | Pending |
| ENRL-02 | Phase 3 | Pending |
| ENRL-03 | Phase 3 | Pending |
| ENRL-04 | Phase 3 | Pending |
| ENRL-05 | Phase 3 | Pending |
| ENRL-06 | Phase 3 | Pending |
| ENRL-07 | Phase 3 | Pending |
| PROG-01 | Phase 2 | Pending |
| PROG-02 | Phase 2 | Pending |
| PROG-03 | Phase 2 | Pending |
| PROG-04 | Phase 2 | Pending |
| ATTN-01 | Phase 4 | Pending |
| ATTN-02 | Phase 4 | Pending |
| ATTN-03 | Phase 4 | Pending |
| ATTN-04 | Phase 4 | Pending |
| ATTN-05 | Phase 4 | Pending |
| ATTN-06 | Phase 4 | Pending |
| REPT-01 | Phase 5 | Pending |
| REPT-02 | Phase 5 | Pending |
| REPT-03 | Phase 5 | Pending |
| REPT-04 | Phase 5 | Pending |
| REPT-05 | Phase 5 | Pending |
| PAT-01 | Phase 6 | Pending |
| PAT-02 | Phase 6 | Pending |
| PAT-03 | Phase 6 | Pending |
| STAFF-01 | Phase 6 | Pending |
| STAFF-02 | Phase 6 | Pending |
| STAFF-03 | Phase 6 | Pending |
| INFRA-01 | Phase 0 | Complete |
| INFRA-02 | Phase 0 | Complete |
| INFRA-03 | Phase 0 | Complete |
| INFRA-04 | Phase 6 | Pending |
| INFRA-05 | Phase 0 | Complete |

**Coverage:**
- v1 requirements: 45 total
- Mapped to phases: 45
- Unmapped: 0

---
*Requirements defined: 2026-03-29*
*Last updated: 2026-03-29 after roadmap creation — all 45 requirements mapped*
