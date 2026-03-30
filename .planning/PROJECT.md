# Prodigy

## What This Is

Prodigy is an internal youth program management platform for UACDC staff. It handles youth registration, program enrollment, class/course management, attendance tracking, and grant compliance reporting. This project migrates the existing ASP.NET WebForms monolith to Next.js 15, replacing a broken enrollment-centric data model with a youth-centric model where one youth = one record, always.

## Core Value

Every youth has exactly one record. Enrollments, attendance, and reports all trace back to that single identity — no duplicates, no paper workarounds, no corrupted grant data.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Youth-centric data model (one youth, one record, many enrollments)
- [ ] Streamlined youth registration (demographics, guardian, address/phone in one form, < 5 min)
- [ ] Program enrollment management decoupled from person identity
- [ ] Class/course management with site and program scoping
- [ ] Mobile-first attendance tracking (< 2 min per class, no paper)
- [ ] Grant compliance reporting via Metabase OSS (census, billing, attendance)
- [ ] Computed grant year (derived from dates, not hardcoded)
- [ ] Clerk MFA authentication with role-based access (Admin, Central, Site)
- [ ] Database audit trail (parity with legacy 18-table trigger system)
- [ ] Playwright parity tests (behavioral validation before cutover)

### Out of Scope

- 1:1 feature parity with legacy app — workflows are being rethought, not replicated
- Legacy SQL Server integration — new app uses independent PostgreSQL
- Gradual rollout — big-bang cutover after stakeholder sign-off
- Mobile native app — web-first, responsive design only

## Context

- **Legacy system:** ASP.NET WebForms, 55 pages, Telerik UI, SSRS reporting, SQL Server
- **Core legacy problem:** Enrollment and person identity are fused. Closing/re-enrolling creates duplicate person records, destroying longitudinal tracking and corrupting reports
- **Users:** < 50 internal UACDC staff (Site Coordinators, Instructors, Central Team, Admins)
- **Paper workarounds:** Staff use paper clipboards for attendance because the digital workflow is too slow/broken
- **Existing planning:** Full BMad artifact suite (PRD with 52 FRs, architecture doc, UX spec, epics with stories)
- **Solo developer with Claude AI assistance**

## Constraints

- **Tech stack:** Next.js 15 App Router, TypeScript, Tailwind CSS v4, shadcn/ui, Prisma, PostgreSQL, Clerk, Metabase OSS
- **Package manager:** pnpm only
- **Legacy code:** /legacy-src is read-only reference — never modify
- **Auth:** Clerk with MFA enforced for all users
- **Reporting:** Metabase OSS replaces SSRS (ADR-001)
- **Cutover:** Legacy stays live until full MVP validated and stakeholders sign off
- **Design principle:** Every decision filtered through "is this simpler than what we have today?"

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Next.js 15 (not 14 or 16) | Stable, well-documented, matches PRD | -- Pending |
| Youth-centric data model | Eliminates systemic duplicate records | -- Pending |
| Clerk for auth (not NextAuth.js) | MFA built-in, simpler than rolling own | -- Pending |
| Metabase OSS for reporting | Replaces SSRS, self-service for staff | -- Pending |
| Big-bang cutover | Simpler than gradual rollout for < 50 users | -- Pending |
| BMad artifacts as scope source of truth | PRD, architecture, UX spec, epics define scope | -- Pending |
| Computed grant year | Derived from enrollment/attendance dates, not config | -- Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? -> Move to Out of Scope with reason
2. Requirements validated? -> Move to Validated with phase reference
3. New requirements emerged? -> Add to Active
4. Decisions to log? -> Add to Key Decisions
5. "What This Is" still accurate? -> Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-30 after Phase 0 (Foundation) completion — auth, schema, audit trail, infrastructure utilities verified*
