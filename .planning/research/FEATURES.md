# Feature Landscape

**Domain:** Youth program management platform (internal staff tool)
**Researched:** 2026-03-29
**Confidence:** HIGH — grounded in legacy app audit (55 pages, 13 logic classes), PROJECT.md requirements, and industry research

---

## Context: What This Tool Is and Is Not

Prodigy is an **internal staff tool** for < 50 UACDC staff. It is not a parent portal, not a public-facing registration site, and not a payment platform. Every feature decision should be filtered through: "Does this make life easier for a Site Coordinator, Instructor, or Central Team member doing their job?" The users are staff, not the youth themselves.

The core thesis is a **youth-centric data model**: one youth = one record, always. Every feature in this platform operates against that record. Enrollment, attendance, and reporting are all views of a single youth identity, never duplicated.

---

## Table Stakes

Features staff expect. Missing any of these means the tool fails at its primary job.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Youth registration (demographics + guardian + contact) | Every youth must exist in the system before enrollment | Medium | Name, DOB, SSN (masked), race/ethnicity, gender, address, phone, parent/guardian, emergency contacts. Must complete in < 5 min per PROJECT.md requirement |
| Youth search with duplicate detection | Staff must find an existing youth before creating a new record | Low | Search by name/DOB/SSN. Must surface likely matches to prevent duplicates — the core disease of the legacy system |
| Program enrollment | Youth are enrolled into programs, not classes | Medium | An enrollment has a site, status (active/inactive/released), enrollment type, and grant year. Decoupled from person identity |
| Enrollment lifecycle management | Staff routinely transfer, release, and roll over youth | Medium | Transfer between sites, release (exit), rollover to next grant year — all without creating duplicate person records |
| Class/course management | Staff need to schedule and manage what youth attend | Medium | Courses are templates; class instances are scheduled occurrences with instructor, location, days/times, capacity |
| Attendance tracking (class-based) | Federal grant compliance requires attendance records | High | Mark present/absent per youth per class session. Must be fast — < 2 min per class per PROJECT.md. Mobile-first critical |
| Attendance tracking (event-based) | Special events tracked separately from classes | Medium | Same data model, different event type. Legacy has separate event CRUD + event attendance |
| Youth attendance history | Staff and central team need to view a youth's full attendance record | Low | Read-only view of all attendance across programs. Used for compliance audits |
| Role-based access control | Site staff should not see other sites' youth | Medium | Three roles: Admin (all access), Central (all sites read, cross-site reports), Site (own site only). Program scoping on top of role scoping |
| Program-scoped context | Staff work within one program at a time | Low | After login, user selects a program. All views filtered by selected program. Legacy uses Session["ProgramID"] — needs clean equivalent |
| Staff management | Admins manage staff accounts and site assignments | Medium | Create/edit staff records, assign to sites, provision system access. Site assignment drives data visibility |
| Grant compliance reports (Census) | Funders require monthly census of youth served | High | Census = youth who attended at least once per reporting period. Filtered by program, site, date range. Delivered via Metabase OSS |
| Grant compliance reports (Billing) | Funders require billing/hours documentation | High | Attendance-based billing report. Program and site scoped. Delivered via Metabase OSS |
| Grant compliance reports (Attendance) | Funders require attendance documentation | High | Aggregate and individual attendance data. Multiple time ranges. Delivered via Metabase OSS |
| Computed grant year | Grant year derived from dates, not configuration | Low | Prevents stale config bugs. Grant year = computed from enrollment/attendance dates. Solves a known legacy bug |
| Database audit trail | Compliance requires knowing who changed what and when | High | Every insert/update/delete logged with user, timestamp, old/new values. Parity with legacy 18-table trigger system. Non-negotiable for funder audits |
| MFA authentication | Staff access sensitive youth data (SSN, demographics) | Low | Clerk with MFA enforced. All roles. No exceptions |
| Lookup/reference data management | Dropdowns need admin-managed lists | Low | Races, ethnicities, genders, enrollment types, statuses, etc. Admin-only CRUD. Used everywhere |

---

## Differentiators

Features that make this tool materially better than the legacy and better than generic alternatives. Not expected by users, but valued once present.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Youth-centric data model (no enrollment-fused identity) | Eliminates the systemic duplicate record problem — longitudinal tracking works | High | This is the architectural differentiator. All competitors fuse enrollment with person. This tool separates them. Requires redesigning the data model entirely |
| Inline duplicate detection during registration | Stops the problem before it starts — staff see likely matches before creating a new record | Medium | Search-as-you-type on name + DOB during registration. Surface existing records with enrollment status |
| Mobile-first attendance (< 2 min per class) | Staff currently use paper clipboards because the digital workflow is too slow | Medium | Full-page class roster view, single-tap present/absent toggle, no page reloads, optimized for phone/tablet. The flagship UX improvement |
| Enrollment rollover (grant year transition) | Youth roll forward automatically without duplicating records | Medium | End-of-year workflow: mark enrollment for rollover, carry demographic data forward into new grant year enrollment. No re-entry required |
| Metabase self-service reporting | Central team can slice data without developer involvement | Medium | Metabase OSS dashboards replace SSRS. Staff can build custom questions. Removes IT dependency for report variants |
| Lesson plan management with approval workflow | Site coordinators document what was taught; central team approves | High | Lesson plan sets containing individual plans. Life skills tracking. Multi-site approval queue. Complex but unique to this organization's grant requirements |
| PAT (Program Assessment Tool) form | Structured assessment data collection tied to youth records | High | Tabbed multi-section form. Dynamic field rendering. Unique to UACDC's grant contract requirements |
| Risk assessment per enrollment | Document risk factors at enrollment time | Medium | Cascading site/location selection, structured assessment fields, role-scoped field visibility. Grant-required in some programs |
| Playwright behavioral parity tests | Regression safety net across big-bang migration | High | Automated test suite validating that new app behaves identically to legacy for critical workflows. Confidence for stakeholder cutover sign-off |

---

## Anti-Features

Things to deliberately NOT build. Scope creep in these directions will delay the migration without adding value for the actual users.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Parent/guardian portal | Zero stated requirement. Parents do not use this system. < 50 staff users only | Stay internal-tool-only. Parents interact with staff in person or by phone |
| Online payment processing | UACDC programs are grant-funded, not fee-based. No billing to families | Billing reports are for grant funders, not family invoicing |
| Public registration form | Registration is done by staff on behalf of youth, not self-service | Keep registration behind auth. If self-service ever needed, that's a future separate project |
| Mobile native app | Web-first per PROJECT.md. Responsive web covers the use case | Build responsive web, test on mobile browsers. Native app is not in scope and adds maintenance burden |
| SMS/push notifications | No stated requirement. Staff communicate through existing channels | Email is sufficient for any automated notifications (password reset, etc.) |
| Gradual/feature-flag rollout | Big-bang cutover per PROJECT.md. < 50 users, one team | Do not engineer a dual-run system. Legacy stays live until full sign-off, then cutover entirely |
| Legacy SQL Server integration | New app uses independent PostgreSQL per PROJECT.md | No data bridge, no sync layer. One-time data migration at cutover if needed |
| 1:1 feature parity with legacy | Legacy has 55 pages, many duplicative or broken workflows | Rethink workflows, don't replicate them. Cut legacy features that serve no current need |
| Inventory management | The legacy InventoryItemPage / Inventory.aspx pages exist but inventory is peripheral to the core mission | Defer indefinitely. Not in PROJECT.md Active requirements. If needed post-launch, add it then |
| Technical support ticket system | TechnicalSupport.aspx in legacy is a simple email form | Use existing support channels (email, Slack). Don't build a ticketing system |
| Certificate/document generation | Legacy DownLoad.aspx generates certificates. Niche feature | Defer. Not in Active requirements. Paper certificates or external tool if ever needed |

---

## Feature Dependencies

Understanding this ordering matters for phase planning.

```
Lookup/reference data
    --> Youth registration
        --> Enrollment
            --> Class/course management
                --> Class instances + scheduling
                    --> Attendance tracking (class)
                    --> Attendance tracking (event)
                        --> Youth attendance history
                        --> Grant compliance reports (all three)

Role-based access control
    --> Everything (all features gate on roles)

Staff management
    --> Role-based access control (roles attach to staff records)

Computed grant year
    --> Enrollment
    --> Grant compliance reports

Database audit trail
    --> Youth registration (must be on from day 1)
    --> Enrollment
    --> Attendance

MFA authentication
    --> Everything (auth is prerequisite to all features)

Enrollment rollover
    --> Enrollment (must exist before rollover can be designed)
    --> Computed grant year

Duplicate detection
    --> Youth registration (inline, built into registration flow)

Lesson plan management
    --> Class/course management (lesson plan sets attach to course instances)
    --> Staff management (instructors are staff)
    --> Approval workflow (requires Admin/Central roles)

PAT form
    --> Enrollment (PAT forms are per-enrollment)

Risk assessment
    --> Enrollment (risk assessment is per-enrollment)

Metabase reports
    --> Grant compliance data exists in PostgreSQL
    --> Attendance tracking (data source)
    --> Enrollment (data source)
```

**Critical path:** Auth -> Lookups -> Youth -> Enrollment -> Classes -> Attendance -> Reports

---

## MVP Recommendation

Based on the critical path, staff pain points (paper clipboards), and grant compliance obligations, the MVP must contain:

**Must ship in MVP (blocking grant compliance or core operations):**

1. MFA authentication + role-based access (prerequisite to everything)
2. Lookup/reference data management (prerequisite to all forms)
3. Youth registration with duplicate detection (core identity, must be clean from day 1)
4. Program enrollment with lifecycle (active, release, transfer, rollover)
5. Class/course management with instances
6. Mobile-first attendance tracking — class and event (eliminate paper clipboard)
7. Youth attendance history view
8. Database audit trail (non-negotiable, compliance)
9. Grant compliance reports: Census, Billing, Attendance (via Metabase OSS)
10. Staff management with site assignments

**Defer to post-MVP (valuable but not blocking cutover):**

| Feature | Reason to Defer |
|---------|-----------------|
| Lesson plan management + approval workflow | Complex, grant-specific, does not block attendance/reporting |
| PAT form | Complex, dynamic, program-specific. Can use paper or legacy until post-cutover |
| Risk assessment | Present in legacy but can be paper-bridged short term |
| Inventory management | Not in Active requirements at all |

**Never build (anti-features above):**
Parent portal, payment processing, public registration, native app, legacy integration.

---

## Feature Complexity Summary

| Feature | Complexity | Risk |
|---------|------------|------|
| Youth registration | Medium | Medium — SSN masking, duplicate detection logic |
| Enrollment lifecycle | Medium | High — rollover logic is subtle; getting it wrong defeats the whole youth-centric model |
| Class/course management | Medium | Low |
| Attendance tracking (mobile) | Medium | Medium — UX must be fast; performance matters on mobile |
| Grant compliance reports | High | Medium — SQL is complex, but Metabase abstracts the UI |
| Database audit trail | High | High — must be complete from day 1; retrofitting is painful |
| Lesson plan + approval | High | Low-Medium — complex but well-understood workflow |
| PAT form | High | Medium — dynamic field rendering is complex |
| Risk assessment | Medium | Low |
| RBAC | Medium | Medium — three roles + program scoping + site scoping interact |

---

## Sources

- **Primary:** `/specs/_audit/01-page-inventory.md` (55-page legacy audit) — HIGH confidence
- **Primary:** `/specs/_audit/02-service-inventory.md` (logic class inventory) — HIGH confidence
- **Primary:** `/specs/_audit/03-report-inventory.md` (SSRS report inventory) — HIGH confidence
- **Primary:** `.planning/PROJECT.md` (validated requirements, constraints) — HIGH confidence
- [EZReports: Essential Features of Afterschool Management Software](https://www.ezreports.org/blog-TheEssentialFeaturesOfAfterschoolManagementSoftwareWhatToLookFor.html) — MEDIUM confidence (industry source)
- [21st CCLC Attendance Guidance, AZ Dept of Education 2025](https://www.azed.gov/sites/default/files/2025/12/AzEDS%20attendance%20guidance%2012.08.2025.pdf) — HIGH confidence (regulatory source)
- [EZReports: 21st CCLC Reporting & Data Management](https://www.ezreports.org/21stCCLCReportingDataManagement.aspx) — MEDIUM confidence (industry source)
- [Community Pass: Afterschool Program Management Software](https://www.communitypass.net/blog/afterschool-program-management-software) — LOW confidence (marketing)
- [HIPAA Audit Trail Requirements 2025](https://www.kiteworks.com/hipaa-compliance/hipaa-audit-log-requirements/) — MEDIUM confidence (regulatory guidance, audit trail principles apply even if not HIPAA-regulated)
