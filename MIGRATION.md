# WebForms → Next.js Migration

> **Status**: In Progress — Phase 0 Complete, Phase 1 Next
> **Approach**: Spec-Driven Development — BMAD (planning) + GSD (execution) hybrid
> **Repo**: GitHub (migrated from Azure DevOps)

---

## Overview

This document defines the end-to-end migration process from ASP.NET WebForms to Next.js using a **BMAD + GSD hybrid** methodology. BMAD handles discovery, requirements, architecture, and story design. GSD handles roadmapping, phase planning, and execution.

The migration uses a **Strangler Fig** pattern — the legacy app stays live until the full MVP is validated and stakeholders sign off, then a big-bang cutover switches all users.

---

## Current State

| Item | Detail |
|---|---|
| Framework | ASP.NET WebForms |
| UI Pattern | UpdatePanels + ScriptManager (AJAX), Telerik UI |
| Auth | Forms Authentication |
| Reporting | SSRS (.rdl files) |
| Database | SQL Server (UACDC-POD) |
| Hosting | On-premises Windows Server |
| Repo | GitHub (migrated from Azure DevOps) |

---

## Target State

| Item | Decision |
|---|---|
| Framework | Next.js 16 App Router |
| Language | TypeScript (strict mode) |
| UI | Tailwind CSS v4 + shadcn/ui |
| Auth | Clerk (MFA enforced) |
| ORM | Prisma 7 |
| Database | PostgreSQL (Supabase cloud / Docker local) |
| Reporting | Metabase OSS (signed iframe embedding) |
| Hosting | Vercel (cloud) or Node.js standalone behind IIS (on-prem) |

---

## Architecture Decision Records

| ADR | Decision | Status |
|---|---|---|
| ADR-001 | Reporting: SSRS → Metabase OSS | Approved |
| ADR-002 | Auth: Forms Auth → Clerk (MFA enforced) | Approved |
| ADR-003 | State: ViewState/Session → Next.js server state | Approved |
| ADR-004 | PDF exports: pixel-perfect reports keep SSRS, everything else → Metabase | Approved |
| ADR-005 | Background jobs: Global.asax timers → (TBD) | Pending |
| ADR-006 | Email: SmtpClient → (TBD) | Pending |

---

## Repo Structure

```
Prodigy-Migration/
├── legacy-src/                    ← WebForms app (READ ONLY — never modify)
│
├── src/                           ← Next.js app (built incrementally)
│   ├── app/                       ← Routes, layouts, API handlers
│   ├── components/                ← UI components (shared/, ui/, domain/)
│   ├── lib/                       ← Utilities (db, auth, audit, SSN, etc.)
│   ├── actions/                   ← Server Actions
│   ├── schemas/                   ← Zod validation schemas
│   ├── types/                     ← TypeScript types
│   ├── config/                    ← Environment validation
│   └── proxy.ts                   ← Clerk auth middleware (Next.js 16)
│
├── prisma/
│   ├── schema.prisma              ← Database schema
│   └── seed.ts                    ← Seed data
│
├── specs/                         ← BMAD Analyst output (Phase 1)
│   ├── _audit/                    ← Legacy inventories + Repomix XML
│   ├── _migration-map/            ← Architecture blueprint
│   ├── decisions/                 ← ADRs
│   └── features/                  ← Per-feature migration specs
│
├── _bmad-output/                  ← BMAD agent artifacts (Phases 2-4)
│   ├── planning-artifacts/        ← PRD, architecture, UX, epics
│   └── implementation-artifacts/  ← Sprint status, stories
│
├── .planning/                     ← GSD execution state (Phases 5-7)
│   ├── PROJECT.md                 ← Project context + core value
│   ├── REQUIREMENTS.md            ← Requirements (derived from BMAD PRD)
│   ├── ROADMAP.md                 ← Phase roadmap with success criteria
│   ├── STATE.md                   ← Current execution state
│   ├── config.json                ← GSD workflow config
│   ├── phases/                    ← Per-phase plans, research, verification
│   └── research/                  ← Project-level research
│
├── scripts/                       ← Dev server management (bash + PowerShell)
├── e2e/                           ← Playwright E2E tests
├── CLAUDE.md                      ← Agent instructions (always current)
├── MIGRATION.md                   ← This file — process template
└── .gitignore
```

---

## Agent Rules

These rules apply to every agent session (Claude Code, GitHub Copilot, BMAD agents, GSD):

- **NEVER** modify any file in `/legacy-src` — it is a read-only reference
- **ALWAYS** check `/specs/_audit/` before creating a new component or page
- **ALWAYS** use the dev server scripts in `/scripts/` to start/stop the app
- New pages go in `/src/app/[route]/page.tsx`
- New API routes go in `/src/app/api/[name]/route.ts`
- Package manager: **pnpm only**
- Follow conventions in `CLAUDE.md`

---

## Migration Process — BMAD + GSD Hybrid

The migration follows a seven-phase process. BMAD handles discovery and planning (Phases 1-4). GSD handles roadmapping, execution planning, and implementation (Phases 5-7). Each phase produces artifacts that feed the next.

```
┌─────────────────────────────────────────────────────────────┐
│                    BMAD (Planning)                           │
│                                                             │
│  Phase 1: Analyst ──→ Phase 2: PM ──→ Phase 3: Architect   │
│  (Discovery)          (PRD)           (Blueprint + UX)      │
│       │                  │                   │              │
│       ▼                  ▼                   ▼              │
│  Legacy inventories   Requirements     Architecture +       │
│  (specs/_audit/)      (prd.md)        Epics + Stories       │
│                                                             │
│  Phase 4: Readiness Check                                   │
│  (Validates all BMAD artifacts before handoff)              │
│                                                             │
├─────────────────── HANDOFF ─────────────────────────────────┤
│                                                             │
│                     GSD (Execution)                          │
│                                                             │
│  Phase 5: Project Init ──→ Phase 6: Plan + Execute ──→     │
│  (PROJECT.md, REQUIREMENTS,  (Per-phase: discuss →          │
│   ROADMAP)                    research → plan → execute →   │
│                               verify)                       │
│                                                             │
│  Phase 7: Verify + Cutover                                  │
│  (Parity testing, traffic switch, legacy retirement)        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

### Phase 1 — BMAD Analyst (Discovery)

Pack the legacy codebase with Repomix, then feed to the BMAD Analyst agent to produce structured inventories.

**Repomix commands:**
```bash
repomix \
  --include "legacy-src/**/*.aspx,legacy-src/**/*.aspx.cs,legacy-src/**/*.master,legacy-src/**/*.master.cs" \
  --output ./specs/_audit/pages.xml

repomix \
  --include "legacy-src/**/*.asmx,legacy-src/**/*.asmx.cs,legacy-src/**/*.ashx" \
  --output ./specs/_audit/services.xml

repomix \
  --include "legacy-src/**/*.rdl,legacy-src/**/*.rdlc" \
  --output ./specs/_audit/reports.xml

repomix \
  --include "legacy-src/Web.config,legacy-src/Global.asax*,legacy-src/**/*.csproj" \
  --output ./specs/_audit/config.xml
```

**BMAD agent prompts:**
1. Page inventory → `specs/_audit/01-page-inventory.md`
2. Service inventory → `specs/_audit/02-service-inventory.md`
3. Report inventory → `specs/_audit/03-report-inventory.md`
4. Background jobs → `specs/_audit/04-background-jobs.md`

**Output:** Four inventory files in `/specs/_audit/` + Repomix XML sources

**Status:** ✅ Complete

---

### Phase 2 — BMAD PM (Requirements)

PM agent reads inventories and produces the Product Requirements Document.

**BMAD skills:** `/bmad-create-prd` or `/bmad-agent-pm`

**Produces:**
- `_bmad-output/planning-artifacts/prd.md` — Full PRD with functional requirements, non-functional requirements, user journeys, domain model, success criteria
- `_bmad-output/planning-artifacts/prd-validation-report.md` — Validation against inventories

**Quality gate:** Human reviews and approves PRD before proceeding. All ADRs written from technology decisions list.

**Status:** ✅ Complete

---

### Phase 3 — BMAD Architect + UX + SM (Blueprint)

Architect, UX Designer, and Scrum Master agents produce the technical blueprint, UX specification, and epic breakdown.

**BMAD skills:** `/bmad-create-architecture`, `/bmad-create-ux-design`, `/bmad-create-epics-and-stories`

**Produces:**
- `_bmad-output/planning-artifacts/architecture.md` — Full architecture (directory tree, data flow, auth, reporting, naming conventions)
- `_bmad-output/planning-artifacts/ux-design-specification.md` — UX patterns, wireframes, interaction specs
- `_bmad-output/planning-artifacts/epics.md` — Epic breakdown with stories and acceptance criteria

**Status:** ✅ Complete

---

### Phase 4 — BMAD Readiness Check

Validates all BMAD artifacts are complete and consistent before handing off to GSD.

**BMAD skill:** `/bmad-check-implementation-readiness`

**Produces:**
- `_bmad-output/planning-artifacts/implementation-readiness-report-2026-03-29.md`

**Quality gate:** All documents found, no gaps, no conflicts. Green light for execution.

**Status:** ✅ Complete

---

### Phase 5 — GSD Project Init (Roadmap)

GSD ingests BMAD artifacts and creates the execution roadmap. Requirements are derived from the BMAD PRD, mapped to phases with success criteria.

**GSD commands:**
```bash
/gsd:new-project          # Creates PROJECT.md from BMAD artifacts
                          # → Human answers discovery questions
                          # → Produces REQUIREMENTS.md, ROADMAP.md, STATE.md
```

**Produces:**
- `.planning/PROJECT.md` — Project context, core value, constraints
- `.planning/REQUIREMENTS.md` — Requirements (traced from BMAD PRD FRs/NFRs)
- `.planning/ROADMAP.md` — Phased roadmap with dependency chain
- `.planning/STATE.md` — Execution state tracking

**Roadmap phases** (derived from BMAD epics + dependency analysis):

| Phase | Name | What it delivers |
|-------|------|-----------------|
| 0 | Foundation | Auth, schema, audit trail, infrastructure utilities |
| 1 | Youth Registration | Youth CRUD, search, duplicate detection, SSN handling |
| 2 | Programs & Courses | Program/course/class hierarchy, scheduling |
| 3 | Enrollment | Enroll, transfer, release, multi-program support |
| 4 | Attendance | Sign-in/out, tardy calc, session management |
| 5 | Reporting | Metabase embed, census/billing/attendance reports |
| 6 | Admin & Cutover | User management, data migration, PAT, go-live |

**Status:** ✅ Complete

---

### Phase 6 — GSD Plan + Execute (Per Phase)

Each roadmap phase follows the same GSD cycle. This is the core execution loop — repeat for each phase.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Discuss     │────→│   Research    │────→│    Plan       │
│  (optional)   │     │  (optional)   │     │              │
│ /gsd:discuss  │     │ /gsd:plan     │     │ /gsd:plan    │
│  -phase N     │     │  -phase N     │     │  -phase N    │
└──────────────┘     └──────────────┘     └──────┬───────┘
                                                  │
                      ┌──────────────┐     ┌──────▼───────┐
                      │   Verify      │←────│   Execute     │
                      │              │     │              │
                      │ (automatic)   │     │ /gsd:execute │
                      │              │     │  -phase N    │
                      └──────┬───────┘     └──────────────┘
                             │
                    ┌────────▼────────┐
                    │  Gaps found?     │
                    │  → /gsd:plan    │
                    │    -phase N     │
                    │    --gaps       │
                    └─────────────────┘
```

**Per-phase artifacts produced:**
- `CONTEXT.md` — Design decisions from discuss-phase
- `RESEARCH.md` — Technical research findings
- `UI-SPEC.md` — UI design contract (for frontend phases)
- `*-PLAN.md` — Executable plans with tasks, waves, dependencies
- `*-SUMMARY.md` — Execution summaries per plan
- `VERIFICATION.md` — Goal achievement verification

**GSD commands per phase:**
```bash
/gsd:discuss-phase N     # Capture design preferences (optional)
/gsd:ui-phase N          # Generate UI design contract (frontend phases)
/gsd:plan-phase N        # Research → plan → verify loop
/gsd:execute-phase N     # Wave-based parallel execution
/gsd:verify-work N       # Manual UAT testing
/gsd:progress            # Check overall status
```

**Status:** Phase 0 ✅ Complete | Phases 1-6 pending

---

### Phase 7 — Verify + Cutover

After all feature phases pass, run parity testing and switch traffic.

```bash
# Run parity tests against BOTH apps
PLAYWRIGHT_BASE_URL=http://localhost:5000 npx playwright test   # legacy
PLAYWRIGHT_BASE_URL=http://localhost:3040 npx playwright test   # new

# Both must pass before cutover
```

**Cutover checklist:**
- [ ] All phases verified (VERIFICATION.md status: passed)
- [ ] Data migration completed and validated
- [ ] Parity tests pass against both apps
- [ ] Stakeholder sign-off
- [ ] DNS/routing switch to new app
- [ ] Legacy app archived (not deleted until post-cutover validation period)

**Status:** Not started

---

## Migration Status

### Complete
- ✅ BMAD Discovery (Phase 1) — Legacy inventories
- ✅ BMAD Requirements (Phase 2) — PRD
- ✅ BMAD Architecture (Phase 3) — Blueprint + UX + Epics
- ✅ BMAD Readiness (Phase 4) — Implementation readiness validated
- ✅ GSD Project Init (Phase 5) — Roadmap created
- ✅ GSD Phase 0: Foundation — Auth, schema, audit, infrastructure, app shell

### In Progress
- Phase 1: Youth Registration — next up

### Not Started
- Phase 2: Programs & Courses
- Phase 3: Enrollment
- Phase 4: Attendance
- Phase 5: Reporting
- Phase 6: Admin & Cutover
- Phase 7: Verify + Cutover

---

## Key Principles

1. **Legacy code is never modified.** `/legacy-src` is read-only.
2. **BMAD before GSD.** Discovery, requirements, and architecture are defined before execution begins.
3. **Specs before code.** Every feature has requirements and plans before implementation.
4. **ADRs before stories.** Technology decisions are documented and approved first.
5. **Youth-centric model.** One youth = one record. This is the core design shift.
6. **Simpler than today.** Every decision filtered through: "is this simpler than what we have today?"
7. **Parity before cutover.** Tests must pass against both apps before traffic switches.
8. **CLAUDE.md is always current.** Update after each phase completes.

---

## Reporting Migration (SSRS → Metabase)

Per ADR-001, all reports migrate to Metabase OSS except pixel-perfect PDF compliance reports.

**Metabase instance:** Port 3001 on UACDC-POD (Java JAR)
**Data sources:** PostgreSQL (new system)
**Embedding pattern:** Signed JWT iframe in Next.js `/reports/*` routes

---

## Resources

| Resource | Location |
|---|---|
| Legacy page inventory | `specs/_audit/01-page-inventory.md` |
| Legacy service inventory | `specs/_audit/02-service-inventory.md` |
| Legacy report inventory | `specs/_audit/03-report-inventory.md` |
| Legacy background jobs | `specs/_audit/04-background-jobs.md` |
| BMAD PRD | `_bmad-output/planning-artifacts/prd.md` |
| BMAD Architecture | `_bmad-output/planning-artifacts/architecture.md` |
| BMAD UX Design | `_bmad-output/planning-artifacts/ux-design-specification.md` |
| BMAD Epics | `_bmad-output/planning-artifacts/epics.md` |
| GSD Requirements | `.planning/REQUIREMENTS.md` |
| GSD Roadmap | `.planning/ROADMAP.md` |
| GSD State | `.planning/STATE.md` |
| ADR index | `specs/decisions/` |
| Agent instructions | `CLAUDE.md` |
| Dev server scripts | `scripts/dev-server.sh` / `scripts/dev-server.ps1` |
