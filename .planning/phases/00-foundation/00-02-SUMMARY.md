---
phase: 00-foundation
plan: 02
subsystem: ui-shell
tags: [shadcn, clerk, app-shell, sidebar, header, program-selector, seed-data]
dependency_graph:
  requires:
    - 00-01 (Next.js scaffold, Prisma schema, auth utilities, db singleton)
  provides:
    - shadcn/ui initialized with Tailwind v4 (8 Phase 0 components)
    - App shell layout (sidebar 240px + header 56px)
    - Clerk sign-in page at /sign-in
    - Program selector page at /select-program (AUTH-03)
    - selectProgram Server Action with selected_program cookie (AUTH-04)
    - Dashboard placeholder at /dashboard
    - Seed script with all lookup tables and test programs
  affects:
    - 00-03 (tests for program-card, app-header, select-program page)
    - 00-04 (integration verification of auth flow and program selection)
    - All subsequent phases (inherit app shell layout)
tech_stack:
  added:
    - shadcn/ui v4 (base-nova style, neutral palette)
    - tw-animate-css (shadcn animation dependency)
    - class-variance-authority (shadcn dependency)
    - tsx v4.21 (TypeScript seed script runner)
    - @base-ui/react (shadcn dependency)
  patterns:
    - shadcn components in src/components/ui/ (auto-generated, never manually edited)
    - Client/Server component split: AppSidebar='use client', AppHeader=Server Component
    - Sheet overlay for mobile sidebar (shadcn Sheet component)
    - Server Action for program selection (AUTH-04 pattern with auth() call)
    - Prisma upsert pattern for idempotent seed data
    - Standalone PrismaClient in seed script (documented exception to CLAUDE.md rule)
key_files:
  created:
    - src/app/(auth)/sign-in/[[...sign-in]]/page.tsx
    - src/app/(app)/layout.tsx
    - src/app/(app)/select-program/page.tsx
    - src/app/(app)/dashboard/page.tsx
    - src/components/shared/app-sidebar.tsx
    - src/components/shared/app-header.tsx
    - src/components/program-selector/program-card.tsx
    - src/actions/program.ts
    - prisma/seed.ts
  modified:
    - src/app/globals.css (shadcn CSS variables added, --primary updated to blue-600)
    - package.json (prisma.seed config added, tsx installed)
    - src/components/ui/button.tsx (already in 00-01 initial commit)
    - src/components/ui/card.tsx
    - src/components/ui/badge.tsx
    - src/components/ui/avatar.tsx
    - src/components/ui/dropdown-menu.tsx
    - src/components/ui/separator.tsx
    - src/components/ui/skeleton.tsx
    - src/components/ui/sheet.tsx
    - components.json
decisions:
  - "shadcn init used oklch color space instead of hsl — updated --primary to oklch(0.546 0.215 261.3) equivalent of blue-600 for UI-SPEC compliance"
  - "AppSidebar is 'use client' (uses Sheet/UserButton interactivity), AppHeader is Server Component (calls getAuthContext)"
  - "selectProgram uses form action binding (program-card.tsx) rather than onClick for progressive enhancement"
  - "Standalone PrismaClient in seed.ts is documented CLAUDE.md exception — seed runs outside Next.js runtime"
metrics:
  duration_minutes: 15
  completed_date: "2026-03-30"
  tasks_completed: 3
  files_created: 18
---

# Phase 00 Plan 02: UI Shell, shadcn/ui, and Seed Data Summary

shadcn/ui initialized with Tailwind v4, app shell built (sidebar 240px + header 56px with role badge), Clerk sign-in page, program selector with card grid and "Continue to Dashboard" CTA, and seed script populating all lookup tables plus 3 test programs linked to 4 sites.

## What Was Built

### Task 1 — shadcn/ui Initialization and Phase 0 Components

- Ran `pnpm dlx shadcn@latest init -t next --defaults` — created `components.json` (base-nova style)
- Verified no `tailwind.config.ts` created — Tailwind v4 CSS-only config preserved
- Added 7 components: `card`, `badge`, `avatar`, `dropdown-menu`, `separator`, `skeleton`, `sheet`
- `button.tsx` was already installed in the 00-01 initial commit
- Updated `--primary` CSS variable in `globals.css` to `oklch(0.546 0.215 261.3)` (blue-600 equivalent, per UI-SPEC color contract)

### Task 2 — App Shell, Sign-In Route, and Program Selector

- **Clerk sign-in page** at `src/app/(auth)/sign-in/[[...sign-in]]/page.tsx` — centered `<SignIn />` component
- **AppSidebar** (`'use client'`): 240px fixed on desktop (`w-60`), Sheet overlay on mobile with hamburger trigger, Prodigy branding, Home nav item, program indicator, UserButton at bottom
- **AppHeader** (Server Component): sticky `h-14`, role badge (admin=default/blue, central=secondary, site=outline), calls `getAuthContext()` for role display
- **App shell layout** at `src/app/(app)/layout.tsx`: flex container, AppSidebar + AppHeader + `<main>`
- **Program selector** at `src/app/(app)/select-program/page.tsx`: fetches programs by role (admin/central = all active; site = scoped via UserSite), renders card grid `grid-cols-1 md:grid-cols-2 lg:grid-cols-3`, empty state with exact UI-SPEC copy
- **ProgramCard** client component: shadcn Card with hover shadow, "Continue to Dashboard" CTA button (min 44px touch target), form action binding to `selectProgram`
- **selectProgram Server Action**: calls `auth()` (AUTH-04), sets `selected_program` cookie (httpOnly, sameSite lax, 30-day maxAge), redirects to `/dashboard`
- **Dashboard placeholder**: minimal page with welcome message
- Checked `/specs/_audit/` before creating components per CLAUDE.md — audit directory contains legacy page inventory only, no component specs

### Task 3 — Seed Script and tsx

- `prisma/seed.ts`: upserts all lookup table reference data (6 races, 2 ethnicities, 5 genders, 3 enrollment types, 4 enrollment statuses)
- Seeded 4 UACDC sites: Main Campus, Marvell, Elaine, Helena
- Seeded 3 test programs: 21st Century Community Learning Centers, Delta Youth Scholars, Summer Arts Academy
- Links each program to all 4 sites via `ProgramSite.upsert` (idempotent)
- Added `"prisma": { "seed": "pnpm tsx prisma/seed.ts" }` to `package.json`
- Installed `tsx@^4.21.0` dev dependency for TypeScript seed execution
- Documents standalone `PrismaClient()` as a documented exception to CLAUDE.md rule

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] shadcn uses oklch color space, not hsl**
- **Found during:** Task 1
- **Issue:** UI-SPEC specifies `hsl(221.2 83.2% 53.3%)` for `--primary`. shadcn init wrote `oklch(0.205 0 0)` (dark grey). Color space mismatch would break the blue CTA contract.
- **Fix:** Updated `--primary` to `oklch(0.546 0.215 261.3)` — the oklch equivalent of blue-600. Added comment referencing UI-SPEC.
- **Files modified:** `src/app/globals.css`
- **Commit:** 090ef64

## Known Stubs

The program selector page fetches live data from Prisma — no stub values. The dashboard page is a placeholder with static text, but this is intentional (dashboard content is out of Phase 0 scope). The AppSidebar shows `currentProgram` from props, which will be wired in a later plan once the cookie-reading logic is built into the layout.

**Intentional stubs:**
1. `src/app/(app)/layout.tsx` — does not pass `currentProgram` to AppSidebar yet. The selected_program cookie exists but is not read in the layout. This will be resolved in a later plan when the program context is wired through.
2. `src/app/(app)/dashboard/page.tsx` — static welcome placeholder, no data widgets. Full dashboard is Phase 2+ scope.

## Commits

| Task | Commit | Message |
|------|--------|---------|
| 1 | 090ef64 | feat(00-02): initialize shadcn/ui with Phase 0 components |
| 2 | 8797a50 | feat(00-02): build Clerk sign-in, app shell, program selector, and dashboard |
| 3 | ff8324f | feat(00-02): create seed script with lookup data and test programs |

## Requirements Satisfied

| ID | Description | Status |
|----|-------------|--------|
| AUTH-01 | Clerk sign-in page renders at /sign-in | Clerk `<SignIn />` component at `/sign-in` route |
| AUTH-03 | Program selector with assigned programs | Program selector page with role-scoped queries |
| LOOK-02 | Lookup tables seeded with reference data | Seed script with all 5 lookup table types |

## Self-Check: PASSED
