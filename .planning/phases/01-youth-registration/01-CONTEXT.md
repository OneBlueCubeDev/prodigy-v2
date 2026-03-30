# Phase 1: Youth Registration - Context

**Gathered:** 2026-03-30
**Status:** Ready for planning

<domain>
## Phase Boundary

Staff can register youth, search for existing records, and view or edit demographics — with the youth-centric model enforced such that no workflow can create a duplicate person record. This phase delivers YOUTH-01 through YOUTH-06.

</domain>

<decisions>
## Implementation Decisions

### Registration Form Layout
- **D-01:** Single scrollable page with collapsible sections (Demographics, Guardian, Address/Phone, SSN). No wizard, no tabs.
- **D-02:** Required fields: First Name, Last Name, DOB, Guardian Name. All other fields optional (gender, race, ethnicity, SSN, guardian phone/relation, address, phone).
- **D-03:** SSN field visible to all staff roles during registration (encrypts on save). On the detail page, only Admin can view the full decrypted SSN — all other roles see masked `***-**-1234`.

### Duplicate Detection UX
- **D-04:** Duplicate check triggers after first name, last name, and DOB are all filled. If SSN last 4 is entered later, it refines the check.
- **D-05:** Match logic: exact match on (first_name + last_name + DOB) OR (ssn_last4). Uses existing Prisma indexes `@@index([last_name, first_name])` and `@@index([ssn_last4])`.
- **D-06:** Duplicates surface as a yellow warning banner inline on the form — not a modal blocker. Staff can click "Not a Match" to dismiss and continue. Override is logged in audit trail. Register button remains enabled.

### Youth Search Experience
- **D-07:** Single search bar that searches across name, DOB, and SSN last 4. Results filter live as staff types (debounced server query).
- **D-08:** Default view (before search): show most recently registered youth, sorted by created_at descending.
- **D-09:** Simple page-number pagination (Previous / 1 2 3 / Next). URL params for bookmarkable pages.

### Youth Detail/Edit Page
- **D-10:** Read-only detail page with an "Edit" button that toggles the same page into edit mode (fields become inputs). No separate /edit route.
- **D-11:** Phase 1 shows demographics, guardian, and address only. No stub sections for enrollment or attendance — those are added in future phases.
- **D-12:** No audit trail section on the detail page. Audit data exists in the database but is not surfaced in the UI during Phase 1.

### Claude's Discretion
- Form field layout (2-column vs stacked) — Claude can decide based on responsive design needs
- Exact debounce timing for search and duplicate detection
- Empty state messaging and illustrations
- Loading skeleton patterns
- Toast notification wording for success/error states

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Data Model
- `prisma/schema.prisma` — Youth model (line 178+), Enrollment model, indexes on last_name+first_name and ssn_last4

### Infrastructure (from Phase 0)
- `src/lib/ssn-encryption.ts` — `encryptSSN()`, `decryptSSN()`, `extractLast4()` — use for all SSN operations
- `src/lib/auth.ts` — `requireAuth()`, `getAuthContext()`, `checkRole()` — call in every Server Action
- `src/lib/audit.ts` — Prisma middleware for automatic audit logging
- `src/lib/db.ts` — Prisma client with site-scoping extension

### UI Foundation
- `src/components/ui/` — shadcn/ui primitives (button, card, input, badge, skeleton, sheet, separator, dropdown-menu)
- `src/components/shared/app-sidebar.tsx` — App shell sidebar
- `src/components/shared/app-header.tsx` — App shell header

### Conventions
- `.planning/codebase/CONVENTIONS.md` — Naming patterns, code style, import organization
- `.planning/codebase/STRUCTURE.md` — Directory layout and planned file locations

### Specs & Audit
- `specs/_audit/` — Legacy page/service/report inventories for reference
- `.planning/REQUIREMENTS.md` — YOUTH-01 through YOUTH-06 acceptance criteria

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `encryptSSN()` / `decryptSSN()` / `extractLast4()` in `src/lib/ssn-encryption.ts` — ready for SSN field handling
- `requireAuth()` / `getAuthContext()` in `src/lib/auth.ts` — required in every Server Action
- `ActionResult<T>` type pattern — established in Phase 0 for all mutations
- shadcn/ui: Button, Card, Input, Badge, Skeleton, Sheet, Separator, DropdownMenu already installed
- `src/lib/utils.ts` — `cn()` utility for conditional Tailwind classes

### Established Patterns
- Server Components for pages, Client Components only where interactivity needed (`'use client'`)
- Server Actions return `ActionResult<T>` — never throw
- Prisma site-scoping extension auto-filters queries — no manual WHERE site_id
- Zod schemas in `src/schemas/{domain}.ts` for validation (directory needs creation)
- React Hook Form + Zod for complex form management

### Integration Points
- New routes: `/youth` (list), `/youth/new` (register), `/youth/[youthId]` (detail/edit)
- New Server Actions: `src/actions/youth.ts` — `createYouth`, `updateYouth`, `searchYouth`, `checkDuplicate`
- New schemas: `src/schemas/youth.ts` — `createYouthSchema`, `updateYouthSchema`, `searchYouthSchema`
- Sidebar navigation: add Youth link to existing `app-sidebar.tsx`

</code_context>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-youth-registration*
*Context gathered: 2026-03-30*
