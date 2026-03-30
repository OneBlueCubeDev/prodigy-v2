---
phase: 01-youth-registration
plan: 03
subsystem: ui
tags: [next.js, react, typescript, tailwind, shadcn, prisma, url-params]

# Dependency graph
requires:
  - phase: 01-01
    provides: Youth Prisma model, createYouth server action, auth utilities
provides:
  - Youth list page at /youth with server-side search and pagination
  - YouthSearchBar client component with 300ms debounce and URL-param sync
  - YouthPagination client component with numbered pages and Previous/Next
  - YouthListTable server-friendly table with SSN masking and empty states
  - Loading skeleton for /youth route
affects: [enrollment, attendance, detail-page]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - URL-driven filter state via useSearchParams + router.push (no useState for filters)
    - buttonVariants + cn() on Link for styled anchor buttons (base-ui Button has no asChild)
    - Intl.DateTimeFormat with timeZone UTC to prevent date shifting on DOB display
    - Promise.all for concurrent findMany + count queries

key-files:
  created:
    - src/components/youth/youth-search-bar.tsx
    - src/components/youth/youth-pagination.tsx
    - src/components/youth/youth-list-table.tsx
    - src/app/(app)/youth/page.tsx
    - src/app/(app)/youth/loading.tsx
  modified: []

key-decisions:
  - "buttonVariants + cn() on Link used instead of Button asChild — base-ui/react Button has no asChild prop (Radix-style)"
  - "Intl.DateTimeFormat with timeZone UTC used for date formatting to prevent timezone shifts on stored UTC dates"

patterns-established:
  - "URL params for filter state: useSearchParams + router.push, no global state"
  - "Server Component queries with Promise.all for concurrent count + data fetch"
  - "Link with buttonVariants() + cn() as pattern for navigation that looks like a button"

requirements-completed: [YOUTH-04]

# Metrics
duration: 3min
completed: 2026-03-30
---

# Phase 01 Plan 03: Youth List Page Summary

**URL-driven youth list with debounced search, SSN-masked table, numbered pagination, and empty states — all powered by server-side Prisma queries on ?q and ?page params**

## Performance

- **Duration:** ~3 min
- **Started:** 2026-03-30T15:28:21Z
- **Completed:** 2026-03-30T15:31:24Z
- **Tasks:** 2
- **Files created:** 5

## Accomplishments
- YouthSearchBar: 300ms debounced input that updates ?q URL param (resets page to 1 on change)
- YouthPagination: numbered page buttons with Previous/Next, active page highlighted with bg-primary, aria-current="page"
- YouthListTable: Name/DOB/SSN masked/Registered columns, two distinct empty states (no-youth vs no-results)
- /youth page: async Server Component that awaits searchParams, builds Prisma OR where clause, fetches with Promise.all
- Loading skeleton that mirrors header, search bar, and 5 table rows

## Task Commits

1. **Task 1: Search bar and pagination components** - `09f2807` (feat)
2. **Task 2: Youth list table, loading skeleton, and page route** - `4cc76ff` (feat)

**Plan metadata:** (pending final commit)

## Files Created/Modified
- `src/components/youth/youth-search-bar.tsx` - Debounced search input updating ?q and ?page URL params
- `src/components/youth/youth-pagination.tsx` - Numbered pagination with Previous/Next, active page indicator
- `src/components/youth/youth-list-table.tsx` - Table with Name/DOB/SSN masked/Registered columns and empty states
- `src/app/(app)/youth/page.tsx` - Async Server Component with Prisma search query and pagination
- `src/app/(app)/youth/loading.tsx` - Skeleton matching page structure (header, search bar, 5 rows)

## Decisions Made
- **buttonVariants + cn() on Link** instead of Button with asChild — base-ui/react Button component has no `asChild` prop (that's a Radix/shadcn pattern). Using `buttonVariants()` from cva + `cn()` directly on `<Link>` achieves same result without the type error.
- **Intl.DateTimeFormat with timeZone: 'UTC'** — DOB is stored as UTC midnight. Without UTC timezone, display can shift dates by one day in local timezones west of UTC.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Replaced Button asChild with buttonVariants + cn() on Link**
- **Found during:** Task 2 (youth list table and page route)
- **Issue:** Button from `@base-ui/react/button` has no `asChild` prop — TypeScript error TS2322 on both youth/page.tsx and youth-list-table.tsx
- **Fix:** Imported `buttonVariants` and `cn`, applied to `<Link>` directly: `<Link className={cn(buttonVariants(), 'mt-4')}>`
- **Files modified:** src/app/(app)/youth/page.tsx, src/components/youth/youth-list-table.tsx
- **Verification:** TypeScript compilation passes with no errors in new files
- **Committed in:** 4cc76ff (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (Rule 1 - bug in API usage assumption)
**Impact on plan:** Fix required for correct compilation. No scope changes.

## Issues Encountered
- pre-existing TypeScript errors in youth-registration-form.tsx (missing react-hook-form/sonner packages) and form.tsx/sonner.tsx — out of scope for this plan, not caused by this plan's changes.

## Known Stubs
None — all data flows from live Prisma queries. No hardcoded mock data.

## Next Phase Readiness
- /youth is fully functional: search by name, DOB, or SSN last 4; paginated results; empty states
- YouthListTable renders links to /youth/[youthId] (detail page — not yet built, 404 currently)
- YouthSearchBar and YouthPagination are reusable for any future list views

---
*Phase: 01-youth-registration*
*Completed: 2026-03-30*

## Self-Check: PASSED

Files verified present:
- FOUND: src/components/youth/youth-search-bar.tsx
- FOUND: src/components/youth/youth-pagination.tsx
- FOUND: src/components/youth/youth-list-table.tsx
- FOUND: src/app/(app)/youth/page.tsx
- FOUND: src/app/(app)/youth/loading.tsx

Commits verified:
- FOUND: 09f2807 (feat(01-03): add youth search bar and pagination components)
- FOUND: 4cc76ff (feat(01-03): add youth list page, table, and loading skeleton)
