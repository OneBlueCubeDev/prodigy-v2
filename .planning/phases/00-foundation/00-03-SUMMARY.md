---
phase: 00-foundation
plan: 03
subsystem: testing
tags: [vitest, playwright, unit-tests, tdd, infrastructure]
dependency_graph:
  requires:
    - 00-01 (ssn-encryption.ts, grant-year.ts, auth.ts, audit.ts, health route)
  provides:
    - Vitest test framework configuration
    - Playwright E2E configuration (desktop + mobile Chrome)
    - Unit tests for all Phase 0 infrastructure utilities
    - Grant year UTC timezone fix
  affects:
    - All future plans (test infrastructure now available)
    - CI/CD pipeline (tests now runnable)
tech_stack:
  added:
    - vitest@4.1.2 (unit test runner, node environment)
    - "@playwright/test" (E2E configuration)
  patterns:
    - TDD: test files co-located with source (*.test.ts)
    - Vitest vi.mock() for Clerk and Prisma isolation
    - Dynamic import after mock setup for correct module interception
key_files:
  created:
    - vitest.config.ts
    - e2e/playwright.config.ts
    - e2e/program-selector.spec.ts
    - src/lib/ssn-encryption.test.ts
    - src/lib/grant-year.test.ts
    - src/lib/auth.test.ts
    - src/lib/audit.test.ts
    - src/app/api/health/route.test.ts
  modified:
    - package.json (added test scripts)
    - src/lib/grant-year.ts (UTC timezone bug fix)
decisions:
  - "Use dynamic import after vi.mock() for correct Clerk and Prisma mock interception in Vitest"
  - "Fix grant-year.ts to use getUTCMonth/getUTCFullYear — ISO string dates are UTC, local timezone methods cause off-by-one errors"
metrics:
  duration: "~3 minutes"
  completed: "2026-03-30"
  tasks_completed: 2
  tests_created: 19
  files_created: 8
  files_modified: 2
requirements_satisfied:
  - AUTH-02
  - AUTH-04
  - INFRA-01
  - INFRA-02
  - INFRA-03
  - INFRA-05
---

# Phase 0 Plan 3: Test Infrastructure Summary

**One-liner:** Vitest and Playwright configured with 19 passing unit tests covering SSN encryption (AES-256-GCM), grant year boundary logic, Clerk auth helpers, audit log writes, and health check responses.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Vitest and Playwright configuration | 3da0b32 | vitest.config.ts, e2e/playwright.config.ts, e2e/program-selector.spec.ts, package.json |
| 2 | Unit tests for all Phase 0 utilities | b79dc34 | 5 test files created, grant-year.ts bug fixed |

## Test Results

```
Test Files  5 passed (5)
     Tests  19 passed (19)
  Duration  ~236ms
```

**Test breakdown:**
- `ssn-encryption.test.ts` — 6 tests: hex output, round-trip, random IV, extractLast4 variants
- `grant-year.test.ts` — 3 test groups: July 1+, before July 1, year boundary
- `auth.test.ts` — 4 tests: checkRole match, mismatch, null claims, getAuthContext extraction
- `audit.test.ts` — 4 tests: write operation creates record, ID extraction, system fallback, null result
- `health/route.test.ts` — 2 tests: 200 ok, 503 error

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed timezone-sensitive grant year computation**
- **Found during:** Task 2 (RED phase — tests failed)
- **Issue:** `computeGrantYear` used `getMonth()` and `getFullYear()` (local timezone), but `new Date('2025-07-01')` creates a UTC midnight date. In UTC-4 timezone, this evaluates to June 30 local time, causing the July boundary test to return 2024 instead of 2025.
- **Fix:** Changed `grant-year.ts` to use `getUTCMonth()` and `getUTCFullYear()` for consistent UTC-based calculations
- **Files modified:** `src/lib/grant-year.ts`
- **Commit:** b79dc34

**2. [Rule 3 - Blocking] Generated Prisma client**
- **Found during:** Task 2 (audit.test.ts failed to load `@prisma/client`)
- **Issue:** Prisma client not generated — `node_modules/.prisma/client/default` missing
- **Fix:** Ran `pnpm prisma generate` to generate the client from the schema
- **Impact:** Not committed (generated artifact); worktree now has client available

## Self-Check: PASSED

- [x] vitest.config.ts exists
- [x] e2e/playwright.config.ts exists
- [x] All 5 test files exist
- [x] `pnpm test` exits 0 (19/19 tests pass)
- [x] Commits 3da0b32 and b79dc34 exist
