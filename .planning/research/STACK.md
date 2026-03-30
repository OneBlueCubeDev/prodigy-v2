# Technology Stack

**Project:** Prodigy — ASP.NET WebForms to Next.js Migration
**Domain:** Internal youth program management platform (< 50 users)
**Researched:** 2026-03-29
**Researcher confidence:** MEDIUM-HIGH (WebSearch verified against official docs/changelogs)

---

## TL;DR

The chosen stack (Next.js 15, Tailwind v4, shadcn/ui, Prisma, PostgreSQL, Clerk, Metabase OSS) is
sound for this use case. The one item requiring a decision is **Next.js version**: 15 is the right
choice for now, not 16. The one item requiring a **cost/architecture conversation** is **Metabase
OSS**: the free tier does not support embedded SSO, which may affect how reports surface in the UI.

---

## Recommended Stack

### Core Framework

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Next.js | **15.x (15.2.4 latest)** | Full-stack React framework | Stable, well-documented, React 19 support, App Router is the right pattern for this app's server-side data needs. **Do NOT upgrade to 16 yet** — v16 removes synchronous access to `params`, `cookies()`, and `headers()`, renamed `middleware.ts` to `proxy.ts`, and is still early in ecosystem adoption. |
| TypeScript | 5.x (bundled with Next.js) | Type safety across the codebase | Non-negotiable for a solo dev project; catches data model mistakes that would corrupt the youth-centric model |
| React | 19.x (bundled with Next.js 15) | UI rendering | Required by Next.js 15; View Transitions and server component patterns are stable |

**Next.js 15 vs 16 verdict:** Stay on **15.x**. Next.js 16 (stable October 2025, current 16.2.1) has
meaningful breaking changes: fully removes sync access to async request APIs, renames
`middleware.ts`, and the ecosystem (including shadcn/ui) is still catching up. For a small internal
app with a solo developer, the upgrade friction is not worth the benefit yet. Revisit after 16.1+
stabilizes in mid-2026. (MEDIUM confidence — based on multiple community sources + official release
notes.)

---

### Styling

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Tailwind CSS | **v4.x** | Utility-first CSS | CSS-first configuration (no `tailwind.config.js`), 100x faster incremental builds, modern CSS variables. This is the right choice for a greenfield project in 2026. |
| shadcn/ui | **latest (copy-paste model)** | Component library | Most-starred React component library in 2025-2026, 0KB runtime overhead, WAI-ARIA compliant via Radix UI, works natively with Next.js App Router and Tailwind v4. Copy-paste model means full ownership of components — critical for accessibility customization in a youth-serving org. |

**Tailwind v4 + shadcn/ui compatibility note:** shadcn/ui has official Tailwind v4 migration docs
at `ui.shadcn.com/docs/tailwind-v4`. The main change: replace `tailwindcss-animate` with
`tw-animate-css`, update color variables to OKLCH, replace `@tailwind` directives with
`@import "tailwindcss"`. This is well-documented and is the expected path for all new projects.
(HIGH confidence — official docs verified.)

---

### Database

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| PostgreSQL | 16+ | Primary data store | Mature, reliable, strong support for audit triggers (needed for the 18-table audit trail requirement), excellent Prisma support. |
| Prisma ORM | **6.x** (v6.19 latest stable) | Database access layer | Type-safe queries, auto-generated TypeScript types, migration tooling. v6 is stable and production-ready. v7 (current 7.2.0) is available but moves to TypeScript engine (Rust-free) — still maturing. Stick with v6 for now. |

**Prisma v6 vs v7 verdict:** Use **Prisma 6.x**. Prisma 7 is the latest release but was announced
as a major version with breaking changes (config file moved to `prisma.config.ts`, datasource url
removed from `schema.prisma`). For a project starting in 2026 that needs to be stable, Prisma 6 is
the right anchor. Revisit v7 when the Next.js + Prisma community has more production case studies.
(MEDIUM confidence — official Prisma changelog verified; migration guide reviewed.)

**PostgreSQL hosting decision:** This app runs on self-managed or managed PostgreSQL. For a
< 50-user internal tool:
- **Recommended:** Neon (managed serverless PostgreSQL, free tier, branching for dev/staging)
- **Alternative:** Self-hosted PostgreSQL on a VPS (more control, more ops burden)
- **Avoid:** Supabase for this project — you are already using Clerk for auth, and Supabase auth
  would conflict. Supabase's value is its auth + realtime bundle; without those, Neon is cheaper
  and more focused.

**Singleton pattern is mandatory.** Every Next.js + Prisma project must use the `globalThis`
singleton to avoid connection pool exhaustion in development hot-reload:

```typescript
// src/lib/prisma.ts
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }

export const prisma =
  globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production')
  globalForPrisma.prisma = prisma
```

---

### Authentication

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Clerk | **latest SDK (@clerk/nextjs)** | Auth, MFA, RBAC | MFA built-in and enforceable per-user without custom code. RBAC via `publicMetadata` is the right model for this app's three roles (Admin, Central, Site). First-class Next.js App Router support with Server Components. |

**Clerk for < 50 internal users:** Free tier supports up to 10,000-50,000 MRUs (the limit was
raised in 2026). At 50 users, this is permanently free. (MEDIUM confidence — pricing page
information from multiple sources is inconsistent; verify at clerk.com/pricing before go-live.)

**MFA enforcement:** Clerk allows MFA to be enforced app-wide from the dashboard — no custom
middleware needed. This directly satisfies the PRD requirement for Clerk MFA on all users.

**RBAC pattern for this app:** Use `publicMetadata` on the user object (not Clerk Organizations).
The project has simple internal roles (Admin, Central, Site), not multi-tenant org structures.
Organizations add unnecessary complexity for a single-tenant internal tool.

```typescript
// Role check in Server Component
import { currentUser } from '@clerk/nextjs/server'

const user = await currentUser()
const role = user?.publicMetadata?.role as 'admin' | 'central' | 'site'
```

**Security note:** CVE-2025-29927 (CVSS 9.1) affects Next.js middleware security in versions below
15.2.3. The project must stay on **Next.js 15.2.3 or above** to avoid this vulnerability.

**CLAUDE.md discrepancy:** The current `CLAUDE.md` lists `NextAuth.js` as the auth solution
(ADR-002). `PROJECT.md` and the milestone context specify Clerk. **Clerk is the correct choice.**
NextAuth.js requires more custom code for MFA, has no built-in RBAC primitives, and would require
significant additional work to reach feature parity with what Clerk provides out of the box. The
CLAUDE.md should be updated to reflect Clerk as the auth solution.

---

### Reporting

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Metabase OSS | **latest (self-hosted via Docker)** | Grant compliance and operational reporting | Replaces SSRS. Staff can self-serve on reports without developer involvement. No licensing cost. |

**Critical OSS limitation:** Metabase OSS supports **static embedding only** (signed JWT iframes
with a "Powered by Metabase" watermark). The Modular Embedding SDK (React components, no iframe)
requires a **Pro plan** ($500/month or $5,000/year), which is pay-gated. For an internal tool where
staff access Metabase directly, the OSS tier is fine — they navigate to the Metabase URL, log in
with their own Metabase credentials, and run reports. Embedding in the Next.js app is possible via
signed iframes but carries the watermark.

**Decision required:** Determine whether reports need to be embedded inside the Next.js UI (iframe
with watermark acceptable?) or whether staff will use the standalone Metabase instance directly.
Both are viable for an internal tool. This affects Phase architecture for the reporting module.

**Self-hosted setup:**
```bash
docker run -d -p 3000:3000 --name metabase metabase/metabase
```
Metabase stores its own application data in a separate PostgreSQL database (separate from app data).

---

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `zod` | latest | Schema validation | All form inputs, API route validation, type narrowing |
| `react-hook-form` | v7 | Form state management | Every form in the app — attendance, registration, enrollment |
| `@hookform/resolvers` | latest | RHF + Zod integration | Bridge between react-hook-form and zod schemas |
| `date-fns` | v3+ | Date manipulation | Grant year computation, attendance date ranges, compliance periods |
| `Playwright` | latest | E2E testing / parity tests | Behavioral parity tests before cutover (explicit PRD requirement) |
| `next-safe-action` | latest | Type-safe Server Actions | Wraps Server Actions with Zod validation and error handling |
| `@tanstack/react-table` | v8 | Data tables | Attendance lists, youth roster, enrollment views |

---

### Package Manager

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| pnpm | **10.x** | Package management | Mandated by `PROJECT.md`. Correct choice: 2x-5x faster installs than npm, hard-linked store saves disk space, best monorepo support. Non-negotiable per project constraints. |

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Auth | Clerk | NextAuth.js (Auth.js v5) | NextAuth requires custom adapter, no built-in MFA UI, manual RBAC. Clerk satisfies MFA + RBAC requirements in ~30 min setup. |
| Auth | Clerk | Supabase Auth | Supabase Auth doesn't co-exist cleanly with Clerk; you'd be paying for a BaaS platform but only using its DB component. |
| ORM | Prisma 6 | DrizzleORM | Drizzle is gaining traction for its lightweight footprint and SQL-first approach. Valid alternative, but Prisma's migration tooling and audit trigger support is better for this app's schema complexity. |
| ORM | Prisma 6 | Prisma 7 | Prisma 7 is production-ready but the config file restructure (prisma.config.ts) is a papercut for a new project starting now. Switch when ecosystem catches up. |
| Framework | Next.js 15 | Next.js 16 | v16 has real breaking changes (async params enforcement, middleware rename). No benefit for this app today. |
| DB Hosting | Neon | Supabase PostgreSQL | Supabase is a BaaS — for this project, Clerk handles auth and Prisma handles data access, leaving Supabase with nothing to add beyond a PostgreSQL instance at higher cost. |
| DB Hosting | Neon | Self-hosted Postgres | Valid for ops teams. Neon's branching (dev/staging/prod isolation) and managed backups reduce solo-dev maintenance burden. |
| Reporting | Metabase OSS | Metabase Pro | At $500/month, Pro is unjustifiable for a < 50-user internal tool. OSS is sufficient if reports are accessed via standalone Metabase URL (not embedded in the app). |
| Reporting | Metabase OSS | Grafana | Grafana is optimized for time-series/metrics, not tabular grant compliance data. Metabase's query builder is more accessible to non-technical UACDC staff. |
| Styling | Tailwind v4 | Tailwind v3 | Greenfield project — v4 is the current standard. No reason to start on a version that will need migration. |

---

## Installation

```bash
# Bootstrap Next.js 15 with Tailwind v4, TypeScript, App Router
pnpm create next-app@latest prodigy --typescript --tailwind --app --src-dir --import-alias "@/*"

# shadcn/ui (Tailwind v4 path)
pnpm dlx shadcn@latest init

# Prisma (v6)
pnpm add prisma@^6 @prisma/client@^6
pnpm add -D prisma@^6
pnpm exec prisma init

# Clerk
pnpm add @clerk/nextjs

# Form + validation
pnpm add zod react-hook-form @hookform/resolvers

# Date handling
pnpm add date-fns

# Server Actions safety
pnpm add next-safe-action

# Data tables
pnpm add @tanstack/react-table

# Playwright (parity tests)
pnpm add -D @playwright/test
pnpm exec playwright install
```

---

## Key Constraints From PROJECT.md

- Package manager: **pnpm only** — do not use npm or yarn in any script or CI
- New pages: `/src/app/[route]/page.tsx`
- New API routes: `/src/app/api/[name]/route.ts`
- Legacy code at `/legacy-src` is **read-only** — never modify
- Auth: Clerk with MFA enforced for ALL users (no exceptions)
- Cutover: big-bang after stakeholder sign-off, not gradual rollout

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Next.js 15 vs 16 | MEDIUM | Official release notes verified; community adoption data is WebSearch only |
| Tailwind v4 + shadcn/ui | HIGH | Official shadcn/ui docs confirm v4 migration path |
| Prisma v6 | HIGH | Official changelog verified; v7 breaking changes confirmed in docs |
| Clerk pricing / free tier | MEDIUM | Sources inconsistent on exact MAU limit (10K vs 50K); verify at clerk.com/pricing |
| Metabase OSS limitations | HIGH | Official docs confirm SDK is Pro-only; static embedding is OSS |
| PostgreSQL / Neon | MEDIUM | Recommendation based on use case fit; no hands-on benchmark data |
| pnpm v10 | HIGH | Confirmed as current stable version across multiple sources |
| CVE-2025-29927 | HIGH | Official security advisory; patched in Next.js 15.2.3+ |

---

## Open Questions

1. **Metabase embed vs standalone:** Does the UX require reports embedded in the Next.js app (iframe
   with watermark) or will staff use Metabase's own UI? This determines whether the OSS tier is
   fully sufficient or whether the watermark is a blocker.

2. **PostgreSQL hosting:** Neon or self-hosted? Neon's branching is valuable for dev/staging
   isolation but adds a cloud dependency. Confirm infra budget and ops preference.

3. **Prisma audit triggers:** Prisma doesn't generate triggers natively. The 18-table audit trail
   will require raw SQL migrations alongside Prisma migrations. Verify this pattern is acceptable
   before Phase 1 schema work begins.

4. **Clerk pricing confirmation:** Verify current free tier MAU limit before go-live. The 2026
   pricing change moved some limits; confirm at clerk.com/pricing.

---

## Sources

- [Next.js 15 release announcement](https://nextjs.org/blog/next-15)
- [Next.js 16 upgrade guide](https://nextjs.org/docs/app/guides/upgrading/version-16)
- [Tailwind CSS v4 upgrade guide](https://tailwindcss.com/docs/upgrade-guide)
- [shadcn/ui Tailwind v4 migration](https://ui.shadcn.com/docs/tailwind-v4)
- [Prisma 7 announcement](https://www.prisma.io/blog/announcing-prisma-orm-7-0-0)
- [Prisma v6 changelog](https://www.prisma.io/changelog)
- [Prisma Next.js guide](https://www.prisma.io/docs/guides/nextjs)
- [Clerk Next.js quickstart](https://clerk.com/docs/quickstarts/nextjs)
- [Clerk RBAC with Next.js 15](https://clerk.com/blog/nextjs-role-based-access-control)
- [Metabase embedding overview](https://www.metabase.com/docs/latest/embedding/start)
- [Metabase static embedding docs](https://www.metabase.com/docs/latest/embedding/static-embedding)
- [Metabase SDK Next.js integration](https://www.metabase.com/docs/latest/embedding/sdk/next-js)
- [CVE-2025-29927 (Next.js middleware bypass)](https://nextjs.org/docs/app/guides/upgrading/version-15)
