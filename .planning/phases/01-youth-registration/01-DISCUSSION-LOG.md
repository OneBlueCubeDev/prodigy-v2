# Phase 1: Youth Registration - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-03-30
**Phase:** 01-youth-registration
**Areas discussed:** Registration Form Layout, Duplicate Detection UX, Youth Search Experience, Youth Detail/Edit Page

---

## Registration Form Layout

### Form Structure

| Option | Description | Selected |
|--------|-------------|----------|
| Single page with sections | All fields on one scrollable page, grouped by section. Fastest to complete. | ✓ |
| Multi-step wizard | Step-by-step flow with progress indicator. More guided but slower. | |
| Tabbed sections | Horizontal tabs for each section. Middle ground. | |

**User's choice:** Single page with sections
**Notes:** None

### Required Fields

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal required | Only First Name, Last Name, DOB required. Everything else optional. | |
| Guardian required too | First Name, Last Name, DOB, plus guardian name required. | ✓ |
| You decide | Claude picks based on data model and grant reporting needs. | |

**User's choice:** Guardian required too
**Notes:** Ensures every youth has a contact on file from registration.

### SSN Access

| Option | Description | Selected |
|--------|-------------|----------|
| All staff can enter, only Admin views full | Any role can type SSN during registration. Only Admin views full SSN later. | ✓ |
| Admin-only SSN entry and view | Only Admins see the SSN field at all. | |
| You decide | Claude picks based on PRD and compliance. | |

**User's choice:** All staff can enter, only Admin views full
**Notes:** None

---

## Duplicate Detection UX

### Trigger Timing

| Option | Description | Selected |
|--------|-------------|----------|
| After name + DOB entered | Check fires when first name, last name, and DOB are all filled. Early warning. | ✓ |
| On form submit only | Check fires on submit. Staff fills entire form before learning about match. | |
| Live as-you-type | Debounced check on every keystroke. Most responsive but more server load. | |

**User's choice:** After name + DOB entered
**Notes:** SSN match refines results if entered later.

### Blocking Behavior

| Option | Description | Selected |
|--------|-------------|----------|
| Warn but allow override | Yellow warning banner. Staff can dismiss with "Not a Match". Override logged. | ✓ |
| Hard block until resolved | Register button disabled until staff explicitly confirms. | |
| You decide | Claude picks based on compliance and usability. | |

**User's choice:** Warn but allow override
**Notes:** Override logged in audit trail.

### Match Fields

| Option | Description | Selected |
|--------|-------------|----------|
| Name + DOB + SSN last 4 | Exact match on (name + DOB) OR (SSN last 4). Uses existing indexes. | ✓ |
| Fuzzy name matching | Soundex/Levenshtein on names + DOB. Catches typos but more complex. | |
| You decide | Claude picks matching strategy. | |

**User's choice:** Name + DOB + SSN last 4
**Notes:** None

---

## Youth Search Experience

### Search UX

| Option | Description | Selected |
|--------|-------------|----------|
| Single search bar with live filter | One input searching name, DOB, SSN last 4. Results filter as you type. | ✓ |
| Separate filter fields | Dedicated inputs for each field. More precise but more friction. | |
| You decide | Claude picks. | |

**User's choice:** Single search bar with live filter
**Notes:** None

### Default View

| Option | Description | Selected |
|--------|-------------|----------|
| Recent registrations | Most recently registered youth, paginated. Fresh records first. | ✓ |
| Empty until search | Only search bar shown. No list until query typed. | |
| All youth alphabetical | All records A-Z by last name. Traditional directory. | |

**User's choice:** Recent registrations
**Notes:** None

### Pagination

| Option | Description | Selected |
|--------|-------------|----------|
| Simple page numbers | Classic pagination with Prev/Next and page numbers. URL param bookmarkable. | ✓ |
| Load more button | Single button at bottom. Simpler but loses position on refresh. | |
| You decide | Claude picks. | |

**User's choice:** Simple page numbers
**Notes:** None

---

## Youth Detail/Edit Page

### View/Edit Mode

| Option | Description | Selected |
|--------|-------------|----------|
| Read-only with Edit button | Detail page shows read-only. Edit button toggles to edit mode on same page. | ✓ |
| Inline editable fields | Fields always editable. Click to edit in place. | |
| Separate edit route | Read-only at /youth/[id], edit at /youth/[id]/edit. | |

**User's choice:** Read-only with Edit button
**Notes:** No separate /edit route needed.

### Content Scope

| Option | Description | Selected |
|--------|-------------|----------|
| Demographics only | Phase 1 shows demographics, guardian, address only. No stubs for future data. | ✓ |
| Stub sections for future data | Show empty sections for Enrollments and Attendance with "No data yet" messages. | |

**User's choice:** Demographics only
**Notes:** Enrollment and attendance sections added in their respective phases.

### Audit Trail Display

| Option | Description | Selected |
|--------|-------------|----------|
| No audit on detail page | Audit exists in DB but not exposed in UI during Phase 1. | ✓ |
| Show recent changes | Collapsible section showing last 5 audit entries. | |
| You decide | Claude picks. | |

**User's choice:** No audit on detail page
**Notes:** None

---

## Claude's Discretion

- Form field layout (2-column vs stacked) — responsive design choice
- Debounce timing for search and duplicate detection
- Empty state messaging and illustrations
- Loading skeleton patterns
- Toast notification wording

## Deferred Ideas

None — discussion stayed within phase scope.
