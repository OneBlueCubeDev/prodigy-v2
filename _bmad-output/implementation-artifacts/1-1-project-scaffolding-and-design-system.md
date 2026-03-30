# Story 1.1: Project Scaffolding & Design System

Status: ready-for-dev

## Story

As a developer,
I want the project scaffolded with the full tech stack and design system configured,
so that all subsequent development has a consistent, themed foundation to build on.

## Acceptance Criteria

1. **AC1 — Next.js Project Scaffold:** A Next.js App Router project is created with TypeScript, Tailwind CSS v4, ESLint, `src/` directory, `@/*` import alias, and Turbopack. pnpm is the package manager.

2. **AC2 — shadcn/ui Initialized:** shadcn/ui is initialized with these core components installed: Button, Card, Input, Select, Checkbox, Label, Form, Table, Badge, Toast, Alert, Dialog, Alert Dialog, Dropdown Menu, Command, Tabs, Separator, Sheet, Sidebar.

3. **AC3 — Design System Tokens:** Semantic CSS variables are defined in `globals.css` for both light and dark modes matching the UX specification color table:
   - `--background`: `#FAFAFA` / `#0A0A0A`
   - `--card`: `#FFFFFF` / `#171717`
   - `--card-foreground`: `#171717` / `#FAFAFA`
   - `--primary`: `#2563EB` / `#3B82F6`
   - `--primary-foreground`: `#FFFFFF` / `#FFFFFF`
   - `--secondary`: `#F3F4F6` / `#262626`
   - `--muted`: `#F5F5F5` / `#262626`
   - `--muted-foreground`: `#737373` / `#A3A3A3`
   - `--accent`: `#16A34A` / `#22C55E`
   - `--destructive`: `#DC2626` / `#EF4444`
   - `--warning`: `#F59E0B` / `#FBBF24`
   - `--border`: `#E5E5E5` / `#2D2D2D`
   - `--ring`: `#2563EB` / `#3B82F6`

4. **AC4 — Typography System:** Inter is loaded via `next/font` with `system-ui` fallback. Text scale levels are established: Display (36px/bold), H1 (24px/semibold), H2 (20px/semibold), H3 (16px/semibold), Body (14px/normal), Small (12px/normal).

5. **AC5 — Theme Toggle:** The app defaults to the user's `prefers-color-scheme` preference. A light/dark theme toggle is available via `next-themes` and persists the user's selection.

6. **AC6 — Prisma Initialized:** Prisma is initialized with PostgreSQL provider. `prisma/schema.prisma` exists with the PostgreSQL datasource configured.

7. **AC7 — Testing Installed:** Vitest and Playwright are installed and configured. `vitest.config.ts` and `e2e/playwright.config.ts` exist with working configurations.

8. **AC8 — Environment Validation:** A Zod-validated `src/config/env.ts` exists that fails fast on missing required environment variables. `.env.example` documents all required variables. `.env.local` is git-ignored.

9. **AC9 — Health Check:** The `/api/health` endpoint returns a 200 OK response with basic status information.

## Tasks / Subtasks

- [ ] Task 1: Initialize Next.js project (AC: 1)
  - [ ] Run `pnpm create next-app@latest prodigy --typescript --tailwind --eslint --app --src-dir --import-alias="@/*" --turbopack`
  - [ ] Verify project runs with `pnpm dev`
  - [ ] Confirm `src/` directory structure, App Router, TypeScript strict mode, Tailwind CSS v4, and `@/*` import alias are all present

- [ ] Task 2: Initialize shadcn/ui and install components (AC: 2)
  - [ ] Run `pnpm dlx shadcn@latest init`
  - [ ] Install all required components: `pnpm dlx shadcn@latest add button card input select checkbox label form table badge toast alert dialog alert-dialog dropdown-menu command tabs separator sheet sidebar`
  - [ ] Verify `components.json` exists and `src/components/ui/` is populated

- [ ] Task 3: Configure design system tokens (AC: 3)
  - [ ] Edit `src/app/globals.css` to define all semantic CSS variables for light mode under `:root`
  - [ ] Define dark mode variables under `.dark` class (or `@media (prefers-color-scheme: dark)` as appropriate for next-themes)
  - [ ] Exact hex values per UX spec color table (see AC3 above)
  - [ ] Ensure shadcn/ui components pick up these tokens correctly

- [ ] Task 4: Set up typography system (AC: 4)
  - [ ] Configure Inter via `next/font/google` in `src/app/layout.tsx` with `system-ui, -apple-system, sans-serif` fallback
  - [ ] Apply the font to the `<body>` element via className
  - [ ] Establish Tailwind utility classes or CSS for the typography scale: Display (`text-4xl font-bold`), H1 (`text-2xl font-semibold`), H2 (`text-xl font-semibold`), H3 (`text-base font-semibold`), Body (`text-sm font-normal`), Small (`text-xs font-normal`)

- [ ] Task 5: Install and configure next-themes (AC: 5)
  - [ ] Install `next-themes`: `pnpm add next-themes`
  - [ ] Wrap layout with `<ThemeProvider attribute="class" defaultTheme="system" enableSystem>`
  - [ ] Create a simple `ThemeToggle` component in `src/components/shared/theme-toggle.tsx` using shadcn Button
  - [ ] Verify theme switches correctly between light/dark and persists user preference

- [ ] Task 6: Initialize Prisma (AC: 6)
  - [ ] Install Prisma: `pnpm add -D prisma && pnpm add @prisma/client`
  - [ ] Initialize: `pnpm dlx prisma init --datasource-provider postgresql`
  - [ ] Verify `prisma/schema.prisma` exists with PostgreSQL provider
  - [ ] Add `DATABASE_URL` to `.env.example`

- [ ] Task 7: Install and configure testing (AC: 7)
  - [ ] Install Vitest: `pnpm add -D vitest @vitejs/plugin-react @testing-library/react @testing-library/jest-dom jsdom`
  - [ ] Create `vitest.config.ts` with React plugin and jsdom environment
  - [ ] Install Playwright: `pnpm add -D @playwright/test && pnpm dlx playwright install`
  - [ ] Create `e2e/playwright.config.ts` with basic configuration
  - [ ] Create `e2e/fixtures/` directory
  - [ ] Add test scripts to `package.json`: `"test": "vitest"`, `"test:e2e": "playwright test"`
  - [ ] Verify both test runners execute without errors (empty test suite is fine)

- [ ] Task 8: Create environment validation (AC: 8)
  - [ ] Create `src/config/env.ts` with Zod schema validating required env vars (at minimum: `DATABASE_URL`)
  - [ ] Ensure it fails fast at import time if vars are missing
  - [ ] Create `.env.example` documenting all required variables with placeholder values
  - [ ] Verify `.env.local` is listed in `.gitignore`

- [ ] Task 9: Create health check endpoint (AC: 9)
  - [ ] Create `src/app/api/health/route.ts`
  - [ ] Return JSON `{ status: "ok", timestamp: <ISO string> }` with 200 status
  - [ ] Verify endpoint responds correctly via `curl` or browser

- [ ] Task 10: Create foundational project structure (AC: 1)
  - [ ] Create empty directory stubs for the architecture-specified structure:
    - `src/actions/`
    - `src/components/youth/`
    - `src/components/enrollment/`
    - `src/components/attendance/`
    - `src/components/programs/`
    - `src/components/reports/`
    - `src/components/admin/`
    - `src/components/shared/`
    - `src/schemas/`
    - `src/lib/`
    - `src/types/`
    - `src/config/`
    - `e2e/fixtures/`
    - `scripts/`
  - [ ] Create `src/lib/utils.ts` with the `cn()` utility (shadcn/ui standard: `clsx` + `tailwind-merge`)
  - [ ] Create `src/types/action-result.ts` with the `ActionResult<T>` type definition:
    ```typescript
    export type ActionResult<T> =
      | { success: true; data: T }
      | { success: false; error: string }
    ```
  - [ ] Create `src/config/constants.ts` as an empty placeholder for app-wide constants

- [ ] Task 11: Create root layout with providers (AC: 1, 4, 5)
  - [ ] Set up `src/app/layout.tsx` with Inter font, ThemeProvider, and Toaster
  - [ ] Create `src/app/loading.tsx` with a basic skeleton/spinner
  - [ ] Create `src/app/error.tsx` with "Something went wrong" + "Try again" button
  - [ ] Create `src/app/not-found.tsx` with 404 page

## Dev Notes

### Architecture Compliance

- **Package manager:** pnpm only. No npm or yarn.
- **Import alias:** `@/*` maps to `src/*`. All imports use this alias.
- **Tailwind CSS v4:** Ground-up rewrite from v3. No `tailwind.config.js` — configuration via CSS `@theme` directives in `globals.css`. Uses `@import "tailwindcss"` instead of `@tailwind` directives. Requires `@tailwindcss/postcss` plugin.
- **shadcn/ui v4:** CLI package is now `shadcn` (not `shadcn-ui`). Has native Tailwind v4 support. Components install into `src/components/ui/`.
- **No `tailwind.config.ts` may be needed if using Tailwind v4's CSS-first config.** The `create-next-app` scaffold may generate one — check if Tailwind v4 requires it or uses `@theme` in CSS instead.

### Naming Conventions (MUST follow)

| Area | Convention | Example |
|------|-----------|---------|
| Files (components) | kebab-case | `theme-toggle.tsx` |
| Files (utilities) | kebab-case | `utils.ts`, `env.ts` |
| React components | PascalCase | `ThemeToggle` |
| Types/Interfaces | PascalCase, no prefix | `ActionResult` (no `I` or `T` prefix) |
| Environment vars | SCREAMING_SNAKE_CASE | `DATABASE_URL` |

### File Placement Rules

| File Type | Location |
|-----------|----------|
| shadcn/ui components | `src/components/ui/` (auto-generated, do not manually edit) |
| Custom shared components | `src/components/shared/` |
| Utility functions | `src/lib/` |
| Type definitions | `src/types/` |
| Zod schemas | `src/schemas/` |
| Server actions | `src/actions/` |
| Environment config | `src/config/env.ts` |
| Constants | `src/config/constants.ts` |
| Prisma schema | `prisma/schema.prisma` |
| E2E tests | `e2e/` |
| Unit/component tests | Co-located next to source files |

### Testing Setup Notes

- **Vitest:** Use `jsdom` environment for component tests. React plugin via `@vitejs/plugin-react`. Co-locate test files next to source: `component.test.ts` next to `component.tsx`.
- **Playwright:** Config in `e2e/playwright.config.ts`. Test files in `e2e/`. Fixture data in `e2e/fixtures/`.
- **CI:** `ci.yml` will run `vitest` and `playwright test` — not required for this story but be aware tests must pass in CI.

### Critical Technical Notes

- **Tailwind v4 breaking changes from v3:**
  - No `tailwind.config.js` — use CSS `@theme {}` blocks for customization
  - `@import "tailwindcss"` replaces `@tailwind base/components/utilities`
  - `@tailwindcss/postcss` replaces old PostCSS plugin
  - Automatic content detection — no `content` array needed
  - The `create-next-app` with `--tailwind` flag should set this up correctly for the latest version

- **next-themes setup:** Wrap in `<ThemeProvider attribute="class">` so Tailwind's `dark:` variant works. Set `defaultTheme="system"` and `enableSystem` to respect `prefers-color-scheme`.

- **shadcn/ui CSS variables:** When shadcn/ui init runs, it generates default CSS variables in `globals.css`. You MUST replace these defaults with the exact Prodigy color tokens from the UX spec (AC3). Do not keep the shadcn defaults.

- **Inter font:** Load via `next/font/google` — this automatically optimizes and self-hosts the font. Apply via `className` on `<body>`, not via CSS `@import`.

- **Zod env validation pattern:**
  ```typescript
  import { z } from "zod"
  const envSchema = z.object({
    DATABASE_URL: z.string().url(),
  })
  export const env = envSchema.parse(process.env)
  ```
  This fails fast at import time if any variable is missing or invalid.

- **ActionResult<T> type** — All future server actions will return this. Define it now so it's available from the start:
  ```typescript
  export type ActionResult<T> =
    | { success: true; data: T }
    | { success: false; error: string }
  ```

- **cn() utility** — Standard shadcn/ui pattern combining `clsx` and `tailwind-merge`:
  ```typescript
  import { type ClassValue, clsx } from "clsx"
  import { twMerge } from "tailwind-merge"
  export function cn(...inputs: ClassValue[]) {
    return twMerge(clsx(inputs))
  }
  ```
  Requires: `pnpm add clsx tailwind-merge`

- **Health check endpoint** — Must be a Route Handler (not a Server Action). No authentication required. Returns JSON with status and timestamp.

### Anti-Patterns (NEVER do these)

- Do NOT use `any` type — use `unknown` and narrow with Zod
- Do NOT create a `tailwind.config.js` if Tailwind v4 CSS-first config is sufficient
- Do NOT import fonts via CSS `@import` — use `next/font`
- Do NOT install packages with npm or yarn — pnpm only
- Do NOT put component-level types in `src/types/` — only shared/cross-cutting types go there
- Do NOT manually edit files in `src/components/ui/` after shadcn generates them

### Project Structure Notes

- This story creates the foundational directory structure that all subsequent stories build on
- The directory stubs (empty folders with `.gitkeep` if needed) establish the architecture's feature-based component organization
- `src/lib/utils.ts` with `cn()` is required by shadcn/ui components — install `clsx` and `tailwind-merge` as dependencies

### References

- [Source: _bmad-output/planning-artifacts/architecture.md — Starter Template Evaluation, Project Structure, Implementation Patterns]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md — Color System, Typography System, Spacing & Layout Foundation]
- [Source: _bmad-output/planning-artifacts/epics.md — Story 1.1 Acceptance Criteria]
- [Source: _bmad-output/planning-artifacts/prd.md — Technical Stack, Non-Functional Requirements]

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
