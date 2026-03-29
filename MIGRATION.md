# WebForms → Next.js Migration

> **Status**: In Progress  
> **Approach**: Spec-Driven Development — BMAD + GSD hybrid  
> **Repo**: GitHub (migrated from Azure DevOps)

---

## Overview

This document is the starting point for the full migration of the existing ASP.NET WebForms application to a modern Next.js stack. It captures the approach, tech decisions, folder structure, and step-by-step process.

The migration uses a **Strangler Fig** pattern — both apps run simultaneously, with traffic switched feature-by-feature as each page passes parity testing. The legacy app is never deleted until every route has a verified Next.js replacement.

---

## Current State

| Item | Detail |
|---|---|
| Framework | ASP.NET WebForms |
| UI Pattern | UpdatePanels + ScriptManager (AJAX) |
| Auth | Forms Authentication |
| Reporting | SSRS (.rdl files) |
| Database | SQL Server (UACDC-POD) |
| Hosting | On-premises Windows Server |
| Repo | GitHub (migrated from Azure DevOps) |

---

## Target State

| Item | Decision |
|---|---|
| Framework | Next.js 14+ App Router |
| Language | TypeScript |
| UI | Tailwind CSS + shadcn/ui |
| Auth | NextAuth.js (Azure AD / Entra ID) |
| ORM | Prisma |
| Database | PostgreSQL (Supabase cloud / SQL Server on-prem) |
| Reporting | Metabase OSS |
| Hosting | Vercel (cloud) or Node.js native (on-prem) |

---

## Repo Structure

```
your-repo/
├── legacy-src/                 ← WebForms app (READ ONLY — never modify)
│   ├── YourApp.sln
│   └── YourApp/
│       ├── Web.config
│       ├── Global.asax
│       ├── Default.aspx
│       └── ...
│
├── src/                        ← New Next.js app (built incrementally)
│
├── specs/
│   ├── _audit/                 ← BMAD Analyst output + Repomix XML
│   ├── _migration-map/         ← BMAD Architect output
│   ├── decisions/              ← Architecture Decision Records (ADRs)
│   └── features/               ← Per-feature migration specs + stories
│
├── playwright/                 ← Behavioral parity tests
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml              ← Build + test on every push
│   │   └── playwright.yml      ← Parity tests on every PR
│   └── copilot-instructions.md ← GitHub Copilot agent context
│
├── CLAUDE.md                   ← Claude Code agent memory (keep updated)
├── MIGRATION.md                ← This file
└── .gitignore
```

---

## Architecture Decision Records

Technology decisions are documented as ADRs in `/specs/decisions/` before any implementation begins. All decisions must be approved by a human before the BMAD Scrum Master writes stories.

| ADR | Decision |
|---|---|
| ADR-001 | Reporting: SSRS → Metabase OSS |
| ADR-002 | Auth: Forms Auth → NextAuth.js + Azure AD |
| ADR-003 | State: ViewState/Session → Next.js server state |
| ADR-004 | PDF exports: pixel-perfect reports keep SSRS, everything else → Metabase |
| ADR-005 | Background jobs: Global.asax timers → (TBD during Analyst phase) |
| ADR-006 | Email: SmtpClient → (TBD during Analyst phase) |

> ADRs marked TBD are completed during the BMAD Analyst phase once the legacy codebase has been inventoried.

---

## Agent Rules

These rules are encoded in `CLAUDE.md` and apply to every agent session (Claude Code, GitHub Copilot, BMAD agents, GSD).

- **NEVER** modify any file in `/legacy-src` — it is a read-only reference
- **ALWAYS** check `/specs/_audit/01-page-inventory.md` before creating a new component or page
- **ALWAYS** follow conventions in `/specs/_migration-map/architecture.md`
- New pages go in `/src/app/[route]/page.tsx`
- New API routes go in `/src/app/api/[name]/route.ts`
- New components go in `/src/components/[feature]/`
- Every story must have a matching Playwright parity test before traffic is switched

---

## Migration Process

The migration follows a six-phase BMAD + GSD hybrid process. Each phase produces artifacts that feed the next.

### Phase 0 — Bootstrap ✅
Set up repo structure, install tooling, pack legacy codebase with Repomix.

**Tooling required:**
```bash
npx bmad-method install        # BMAD planning agents
npx get-shit-done-cc --global  # GSD isolated execution
npm install -g repomix         # codebase packer
```

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

**Output:** `/specs/_audit/pages.xml`, `services.xml`, `reports.xml`, `config.xml`

---

### Phase 1 — BMAD Analyst (Discovery)
Feed Repomix output to the BMAD Analyst agent to produce structured inventories.

```bash
# In Claude Code
/analyst
```

**Prompts to run:**

1. Page inventory — read `pages.xml` → produce `specs/_audit/01-page-inventory.md`
   - All .aspx pages with URL, Master Page, purpose, UpdatePanels, postback events, ViewState, business logic, session keys
   - Risk tier each page: LOW / MEDIUM / HIGH

2. Service inventory — read `services.xml` → produce `specs/_audit/02-service-inventory.md`
   - Every WebMethod and handler with params, return types, TypeScript interface equivalents

3. Report inventory — read `reports.xml` → produce `specs/_audit/03-report-inventory.md`
   - Every .rdl file with data source, parameters, output format, which pages use it

4. Background jobs — read `config.xml` → produce `specs/_audit/04-background-jobs.md`
   - All scheduled/background work in Global.asax and custom HttpModules

**Output:** Four inventory files in `/specs/_audit/`

---

### Phase 2 — BMAD PM (Migration PRD)
PM agent reads inventories and produces the prioritized migration backlog.

```bash
/pm
```

**Produces:** `specs/_audit/05-migration-prd.md`
- Prioritized migration order (Low risk first)
- Dependency map (which pages depend on which services)
- Full list of technology decisions needed (becomes ADR list)
- Success criteria for the migration

> After this phase: write all ADRs from the technology decisions list. Human approval required before proceeding to Architect.

---

### Phase 3 — BMAD Architect (Blueprint)
Architect reads all inventories, ADRs, and PRD to produce the canonical architecture document.

```bash
/architect
```

**Produces:** `specs/_migration-map/architecture.md`
- Full Next.js `/src/app` directory tree
- RSC vs `use client` decision rules
- Data fetching strategy per page type
- API layer: every service endpoint → Next.js route table
- Auth migration implementation (per ADR-002)
- Reporting embed pattern (per ADR-001)
- Master Pages → `layout.tsx` hierarchy
- Naming conventions

Then for each feature in the Low risk tier:

**Produces per feature:** `specs/features/[name]/migration-spec.md`
- Legacy behavior summary
- Next.js component tree
- Data fetching approach
- Route path
- Numbered acceptance criteria
- Playwright test scenarios

---

### Phase 4 — BMAD Scrum Master (Stories)
SM converts each migration spec into hyper-detailed implementation stories.

```bash
/sm
```

**Produces per feature (3–4 files):**
- `specs/features/[name]/stories/01-api-route.md`
- `specs/features/[name]/stories/02-page-component.md`
- `specs/features/[name]/stories/03-playwright-test.md`

**Story quality gate (human review before implementation):**
- [ ] Full file paths specified
- [ ] TypeScript interface names defined inline
- [ ] Exact component names specified
- [ ] API paths match architecture.md
- [ ] Acceptance criteria are numbered (AC1, AC2...)
- [ ] No unresolved decisions remaining
- [ ] Playwright test scenarios described

---

### Phase 5 — GSD Execution (Implementation)
GSD executes stories one at a time in isolated sub-agent contexts.

```bash
/gsd plan    # point at the story file
/gsd run     # execute in isolated sub-agent
/gsd verify  # check acceptance criteria
```

**Rules:**
- One story per GSD plan — never bundle multiple stories
- Each task produces a git commit
- Run stories in order: 01 → 02 → 03
- After all stories pass: run Playwright parity test

---

### Phase 6 — Verify + Route
After all stories for a feature pass Playwright parity testing, switch traffic in the Next.js middleware.

```bash
# Run parity test against BOTH apps
PLAYWRIGHT_BASE_URL=http://localhost:5000 npx playwright test [feature]  # legacy
PLAYWRIGHT_BASE_URL=http://localhost:3000 npx playwright test [feature]  # new

# Both must pass before cutover
```

```typescript
// middleware.ts — add route after verification
const migratedRoutes = [
  '/account/profile',   // ✓ verified
  // add each feature here after parity confirmed
]
```

Update migration status in `CLAUDE.md` after each feature completes.

---

## Migration Status

Track progress here. Update after each feature passes parity testing.

### Complete
*(none yet)*

### In Progress
*(none yet — starting with Phase 0)*

### Not Started
*(full list populated after BMAD Analyst runs and risk tiers are assigned)*

---

## Key Principles

1. **Legacy code is never modified.** `/legacy-src` is read-only. The reference implementation must stay intact for parity testing.

2. **Specs before code.** Every feature has a migration spec and approved stories before a single line of implementation is written.

3. **ADRs before stories.** Every technology decision is documented and approved before the Scrum Master writes stories that depend on it.

4. **Low risk first.** Establish patterns with simple pages before tackling UpdatePanel-heavy, high-complexity features.

5. **Parity before cutover.** Playwright tests must pass against both apps before traffic is switched. Never route users to an untested replacement.

6. **One story per GSD plan.** Context isolation is the entire point of GSD. Never bundle stories.

7. **CLAUDE.md is always current.** Update agent memory after each feature completes, each ADR is approved, and each architectural decision is made.

---

## Reporting Migration (SSRS → Metabase)

Per ADR-001, all reports migrate to Metabase OSS except pixel-perfect PDF compliance reports.

**Metabase instance:** Port 3001 on UACDC-POD (Java JAR, no Docker required)  
**Data sources:** SQL Server (legacy) + PostgreSQL (new system)  
**Embedding pattern:** Signed iFrame in Next.js `/reports/*` routes

```typescript
// src/app/reports/[name]/page.tsx
import jwt from 'jsonwebtoken'

const token = jwt.sign(
  { resource: { question: METABASE_QUESTION_ID } },
  process.env.METABASE_SECRET_KEY!,
  { expiresIn: '10m' }
)

const url = `${process.env.METABASE_URL}/embed/question/${token}#bordered=true&titled=true`

return <iframe src={url} className="w-full h-screen border-0" />
```

Report migration order mirrors the page migration priority — reports used by High-traffic pages migrate first.

---

## Resources

| Resource | Location |
|---|---|
| Page inventory | `specs/_audit/01-page-inventory.md` |
| Service inventory | `specs/_audit/02-service-inventory.md` |
| Report inventory | `specs/_audit/03-report-inventory.md` |
| Migration PRD | `specs/_audit/05-migration-prd.md` |
| Architecture blueprint | `specs/_migration-map/architecture.md` |
| ADR index | `specs/decisions/` |
| Feature specs | `specs/features/` |
| Agent memory | `CLAUDE.md` |
| BMAD docs | https://docs.bmad-method.org |
| GSD docs | https://github.com/TACHES/get-shit-done |
| Next.js docs | https://nextjs.org/docs |
| Metabase OSS | https://www.metabase.com/start/oss/ |
