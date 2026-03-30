# Phase 1: Youth Registration - Research

**Researched:** 2026-03-30
**Domain:** Next.js 15 App Router — forms, search, duplicate detection, SSN encryption
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-01:** Single scrollable page with collapsible sections (Demographics, Guardian, Address/Phone, SSN). No wizard, no tabs.
- **D-02:** Required fields: First Name, Last Name, DOB, Guardian Name. All other fields optional (gender, race, ethnicity, SSN, guardian phone/relation, address, phone).
- **D-03:** SSN field visible to all staff roles during registration (encrypts on save). On the detail page, only Admin can view the full decrypted SSN — all other roles see masked `***-**-1234`.
- **D-04:** Duplicate check triggers after first name, last name, and DOB are all filled. If SSN last 4 is entered later, it refines the check.
- **D-05:** Match logic: exact match on (first_name + last_name + DOB) OR (ssn_last4). Uses existing Prisma indexes `@@index([last_name, first_name])` and `@@index([ssn_last4])`.
- **D-06:** Duplicates surface as a yellow warning banner inline on the form — not a modal blocker. Staff can click "Not a Match" to dismiss and continue. Override is logged in audit trail. Register button remains enabled.
- **D-07:** Single search bar that searches across name, DOB, and SSN last 4. Results filter live as staff types (debounced server query).
- **D-08:** Default view (before search): show most recently registered youth, sorted by created_at descending.
- **D-09:** Simple page-number pagination (Previous / 1 2 3 / Next). URL params for bookmarkable pages.
- **D-10:** Read-only detail page with an "Edit" button that toggles the same page into edit mode (fields become inputs). No separate /edit route.
- **D-11:** Phase 1 shows demographics, guardian, and address only. No stub sections for enrollment or attendance.
- **D-12:** No audit trail section on the detail page in Phase 1.

### Claude's Discretion

- Form field layout (2-column vs stacked) — decide based on responsive design needs
- Exact debounce timing for search and duplicate detection
- Empty state messaging
- Loading skeleton patterns
- Toast notification wording for success/error states

### Deferred Ideas (OUT OF SCOPE)

None — discussion stayed within phase scope.
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| YOUTH-01 | Staff can register a new youth with demographics, guardian info, address, and phone in a single form (< 5 min) | Registration form with RHF + Zod, shadcn Form, collapsible sections, POST via Server Action |
| YOUTH-02 | SSN stored encrypted, displayed masked (last 4 only) to authorized roles | `encryptSSN()` / `extractLast4()` from Phase 0; role check in detail page for decrypt |
| YOUTH-03 | Inline duplicate detection surfaces likely matches during registration before creating a new record | Debounced `checkDuplicate` Server Action; yellow banner pattern; audit override log |
| YOUTH-04 | Staff can search for existing youth by name, DOB, or SSN | Debounced `searchYouth` action; OR query on Prisma indexes; URL params for pagination |
| YOUTH-05 | Staff can edit youth demographics after registration | Toggle edit mode on detail page via `useState`; `updateYouth` Server Action |
| YOUTH-06 | One youth = one record, always. No workflow creates a duplicate person record | Duplicate detection gate + audit-logged override is the enforcement mechanism |
</phase_requirements>

---

## Summary

Phase 1 builds the youth management core: registration, search, and detail/edit. All infrastructure from Phase 0 is complete and directly usable — SSN encryption, audit logging, auth helpers, site-scoped Prisma client, and the app shell. No new infrastructure is needed.

The primary implementation challenge is the reactive duplicate detection pattern (D-04): the `checkDuplicate` Server Action must fire as the user fills fields, debounced to avoid hammering the database, and surface results without blocking form submission. This is a client-side orchestration problem — the form must track which fields are filled and only call `checkDuplicate` when the minimum set is present.

The secondary challenge is the inline edit pattern (D-10): a single route that renders read-only by default and switches to edit mode via local state. This is simpler than a separate `/edit` route but requires careful state management to avoid stale data after a successful save.

**Primary recommendation:** Build `youth-registration-form.tsx` as a `'use client'` component with React Hook Form + Zod. Use `useEffect` + `useCallback` to watch form fields and debounce the `checkDuplicate` call. For the list page, use URL search params as state (Next.js `useSearchParams` / `router.push`) for bookmarkable search + pagination.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| react-hook-form | 7.72.0 (current) | Complex form state, validation UX, dirty tracking | Required by CLAUDE.md for complex forms; handles field-level errors, form reset, dirty state |
| @hookform/resolvers | 5.2.2 (current) | Connects Zod schemas to RHF | Necessary adapter; v5 explicitly supports Zod v4 |
| zod | 4.3.6 (installed) | Schema validation for Server Actions and forms | Already installed; used for all input validation per conventions |
| shadcn/ui Form | via `pnpm dlx shadcn add form` | Accessible form primitives wrapping RHF | Required by CLAUDE.md; auto-installs into `src/components/ui/form.tsx` |
| shadcn/ui Input | via `pnpm dlx shadcn add input` | Text input primitive | Required by CLAUDE.md; already referenced in conventions |
| shadcn/ui Select | via `pnpm dlx shadcn add select` | Dropdown for gender/race/ethnicity/relation | Required by CLAUDE.md |
| shadcn/ui Collapsible | via `pnpm dlx shadcn add collapsible` | D-01 collapsible form sections | Needed for locked decision D-01 |
| shadcn/ui Alert | via `pnpm dlx shadcn add alert` | D-06 yellow duplicate warning banner | Needed for locked decision D-06 |
| shadcn/ui Table | via `pnpm dlx shadcn add table` | Youth list page results table | Required by CLAUDE.md |
| shadcn/ui Toast (Sonner) | via `pnpm dlx shadcn add sonner` | Success/error toast notifications | Required by CLAUDE.md conventions |

### Currently Installed (Phase 0)
| Library | Version | Purpose |
|---------|---------|---------|
| shadcn Button | installed | Submit/Edit/Save buttons |
| shadcn Card | installed | Detail page section cards |
| shadcn Badge | installed | Status indicators |
| shadcn Skeleton | installed | Loading states |
| shadcn Sheet | installed | Mobile sidebar (already in use) |

### Not Yet Installed (must be added in Wave 0)
- `react-hook-form` — not in package.json, not in pnpm-lock.yaml
- `@hookform/resolvers` — not in package.json, not in pnpm-lock.yaml
- shadcn Form, Input, Select, Collapsible, Alert, Table, Sonner — not in `src/components/ui/`

**Installation:**
```bash
# Phase 1 form deps
pnpm add react-hook-form @hookform/resolvers

# shadcn components needed
pnpm dlx shadcn add form input select collapsible alert table sonner
```

**Zod v4 + @hookform/resolvers v5 compatibility note:**
`@hookform/resolvers` v5+ explicitly supports Zod v4. Import resolver from `@hookform/resolvers/zod`. No special configuration needed. Confirmed working as of v5.2.2 (March 2025).

**Version verification:**
- `react-hook-form`: `npm view react-hook-form version` → 7.72.0 (verified 2026-03-30)
- `@hookform/resolvers`: `npm view @hookform/resolvers version` → 5.2.2 (verified 2026-03-30)
- `zod`: 4.3.6 already installed

---

## Architecture Patterns

### Recommended Project Structure (Phase 1 additions)
```
src/
├── app/
│   └── (app)/
│       └── youth/
│           ├── page.tsx                     # Youth list + search (Server Component)
│           ├── new/
│           │   └── page.tsx                 # Registration page (thin wrapper)
│           └── [youthId]/
│               └── page.tsx                 # Detail/edit page
├── actions/
│   └── youth.ts                             # createYouth, updateYouth, searchYouth, checkDuplicate
├── components/
│   └── youth/
│       ├── youth-registration-form.tsx      # 'use client' — RHF form + duplicate detection
│       ├── youth-search-bar.tsx             # 'use client' — debounced search input
│       ├── youth-list-table.tsx             # Server or client — renders search results
│       ├── youth-detail-view.tsx            # 'use client' — read/edit toggle
│       └── duplicate-warning-banner.tsx     # 'use client' — yellow alert with dismiss
├── schemas/
│   └── youth.ts                             # createYouthSchema, updateYouthSchema, searchYouthSchema
└── types/
    └── index.ts                             # (update re-exports if new Youth types added)
```

### Pattern 1: Server Action with Zod v4

**What:** Every mutation goes through a `'use server'` file, validates with `zodResolver`, returns `ActionResult<T>`.
**When to use:** All data mutations — createYouth, updateYouth.

```typescript
// src/actions/youth.ts
'use server';

import { requireAuth } from '@/lib/auth';
import { db } from '@/lib/db';
import { encryptSSN, extractLast4 } from '@/lib/ssn-encryption';
import { logger } from '@/lib/logger';
import { createYouthSchema } from '@/schemas/youth';
import type { ActionResult } from '@/types/action-result';
import type { Youth } from '@prisma/client';

export async function createYouth(
  input: unknown
): Promise<ActionResult<Youth>> {
  try {
    const { userId } = await requireAuth();
    const data = createYouthSchema.parse(input);

    // SSN handling — never log SSN
    let ssnEncrypted: string | undefined;
    let ssnLast4: string | undefined;
    if (data.ssn) {
      ssnEncrypted = encryptSSN(data.ssn);
      ssnLast4 = extractLast4(data.ssn);
    }

    const youth = await db.youth.create({
      data: {
        first_name: data.firstName,
        last_name: data.lastName,
        date_of_birth: new Date(data.dateOfBirth),
        ssn: ssnEncrypted,
        ssn_last4: ssnLast4,
        gender_id: data.genderId,
        race_id: data.raceId,
        ethnicity_id: data.ethnicityId,
        address: data.address,
        city: data.city,
        state: data.state,
        zip: data.zip,
        phone: data.phone,
        guardian_name: data.guardianName,
        guardian_phone: data.guardianPhone,
        guardian_relation: data.guardianRelation,
      },
    });

    logger.info({ youth_id: youth.id, user_id: userId }, 'Youth created');
    return { success: true, data: youth };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    logger.error({ error: message }, 'createYouth failed');
    return { success: false, error: message };
  }
}
```

### Pattern 2: React Hook Form + Zod v4

**What:** Client component wires RHF to shadcn Form primitives with zodResolver.
**When to use:** Registration form (D-01 complex form with sections).

```typescript
// src/components/youth/youth-registration-form.tsx
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { createYouthSchema } from '@/schemas/youth';
import type { z } from 'zod';
import { createYouth } from '@/actions/youth';

type FormValues = z.infer<typeof createYouthSchema>;

export function YouthRegistrationForm() {
  const form = useForm<FormValues>({
    resolver: zodResolver(createYouthSchema),
    defaultValues: { firstName: '', lastName: '', guardianName: '' },
  });

  async function onSubmit(data: FormValues) {
    const result = await createYouth(data);
    if (!result.success) {
      form.setError('root', { message: result.error });
      return;
    }
    // redirect to detail page
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)}>
        {/* sections */}
      </form>
    </Form>
  );
}
```

### Pattern 3: Debounced Duplicate Detection

**What:** Watch form fields via RHF `watch()`, debounce 500ms, call `checkDuplicate` Server Action.
**When to use:** Registration form only — triggered by D-04 field fill logic.

```typescript
'use client';

import { useEffect, useCallback, useState } from 'react';
import { useWatch } from 'react-hook-form';
import { checkDuplicate } from '@/actions/youth';

// Inside YouthRegistrationForm:
const firstName = useWatch({ control: form.control, name: 'firstName' });
const lastName = useWatch({ control: form.control, name: 'lastName' });
const dateOfBirth = useWatch({ control: form.control, name: 'dateOfBirth' });
const ssnLast4 = useWatch({ control: form.control, name: 'ssnLast4' });

useEffect(() => {
  // Only run when minimum fields are filled (D-04)
  if (!firstName || !lastName || !dateOfBirth) {
    setDuplicates([]);
    return;
  }
  const timer = setTimeout(async () => {
    const result = await checkDuplicate({ firstName, lastName, dateOfBirth, ssnLast4 });
    if (result.success) setDuplicates(result.data);
  }, 500); // 500ms debounce
  return () => clearTimeout(timer);
}, [firstName, lastName, dateOfBirth, ssnLast4]);
```

### Pattern 4: URL-State Search + Pagination (D-07, D-08, D-09)

**What:** Search query and page stored in URL params. Server Component reads params, renders results.
**When to use:** Youth list page — enables bookmarkable URLs and browser back/forward.

```typescript
// src/app/(app)/youth/page.tsx  (Server Component)
import { db } from '@/lib/db';
import { YouthSearchBar } from '@/components/youth/youth-search-bar';
import { YouthListTable } from '@/components/youth/youth-list-table';

const PAGE_SIZE = 20;

export default async function YouthListPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; page?: string }>;
}) {
  const { q, page } = await searchParams;
  const currentPage = Math.max(1, parseInt(page ?? '1', 10));
  const skip = (currentPage - 1) * PAGE_SIZE;

  const where = q ? {
    OR: [
      { first_name: { contains: q, mode: 'insensitive' as const } },
      { last_name: { contains: q, mode: 'insensitive' as const } },
      { ssn_last4: q },
    ],
  } : {};

  const [youth, total] = await Promise.all([
    db.youth.findMany({ where, skip, take: PAGE_SIZE, orderBy: { created_at: 'desc' } }),
    db.youth.count({ where }),
  ]);

  return (
    <div>
      <YouthSearchBar defaultValue={q} />
      <YouthListTable youth={youth} total={total} page={currentPage} pageSize={PAGE_SIZE} />
    </div>
  );
}
```

### Pattern 5: Inline Edit Toggle (D-10)

**What:** Detail page uses `useState(isEditing)`. Read-only view renders static values; edit mode renders RHF form fields.
**When to use:** Youth detail page — no separate /edit route.

```typescript
'use client';

import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { updateYouth } from '@/actions/youth';

export function YouthDetailView({ youth }: { youth: Youth }) {
  const [isEditing, setIsEditing] = useState(false);
  const form = useForm({ defaultValues: mapYouthToFormValues(youth) });

  async function onSave(data: FormValues) {
    const result = await updateYouth({ id: youth.id, ...data });
    if (result.success) {
      setIsEditing(false);
    }
  }

  if (!isEditing) {
    return <YouthReadView youth={youth} onEdit={() => setIsEditing(true)} />;
  }
  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSave)}>
        {/* editable fields */}
        <Button type="submit">Save</Button>
        <Button variant="ghost" onClick={() => setIsEditing(false)}>Cancel</Button>
      </form>
    </Form>
  );
}
```

### Anti-Patterns to Avoid

- **Using `router.refresh()` after save instead of `revalidatePath()`:** Server Component data will not update. Use `revalidatePath('/youth/[youthId]')` inside the Server Action so the page data re-fetches automatically.
- **Calling `checkDuplicate` on every keystroke:** Always debounce (500ms). Un-debounced calls will create database load and race conditions.
- **Placing `db` import in client component:** `checkDuplicate` and all queries must live in `src/actions/youth.ts`, not in the form component.
- **Logging `ssn` or full SSN anywhere:** Only log `youth_id`. Never log the raw or encrypted SSN value.
- **Creating PrismaClient() in Server Action:** Always import `db` from `@/lib/db`.
- **Storing search state in React state instead of URL params:** Breaks browser back/forward and prevents bookmarking per D-09.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Form validation UX (errors, dirty state, submit lock) | Custom validation loop | react-hook-form + zodResolver | RHF handles 20+ edge cases: async validation, revalidation mode, touched state |
| Accessible form fields with labels + error messages | `<div><label /><input /><span />` | shadcn `<FormField>` + `<FormMessage>` | Auto-associates label/error with input via `aria-describedby` |
| Debounce utility | `setTimeout` management in component body | Native `useEffect` + `clearTimeout` | Simple enough to inline; no library needed |
| SSN encryption | Custom crypto | `encryptSSN()` / `decryptSSN()` from Phase 0 | Already implemented and tested |
| Audit logging | Manual `db.auditLog.create()` calls | Prisma audit middleware in `db.ts` | Phase 0 middleware auto-logs all writes transparently |

**Key insight:** The hard problems in this phase (encryption, audit, auth) are already solved by Phase 0 infrastructure. Phase 1 is primarily UI and query work.

---

## Common Pitfalls

### Pitfall 1: `revalidatePath` missing after mutation
**What goes wrong:** After `createYouth` or `updateYouth` succeeds, the list page or detail page shows stale data.
**Why it happens:** Next.js caches Server Component data by default. Writing to the DB does not automatically invalidate the cache.
**How to avoid:** Call `revalidatePath('/youth')` (list) and `revalidatePath('/youth/[youthId]', 'page')` (detail) inside every Server Action that mutates youth records.
**Warning signs:** Redirect after create lands on detail page but shows no data, or old data.

### Pitfall 2: Date of Birth timezone drift
**What goes wrong:** DOB stored as `2005-03-15T00:00:00.000Z` renders as `2005-03-14` in the browser (UTC vs local).
**Why it happens:** JS `new Date('2005-03-15')` is parsed as UTC midnight; displaying in local timezone shifts the date back.
**How to avoid:** Store as `@db.Date` in Prisma (date-only, no time). On the client, parse as `new Date(dob + 'T00:00:00')` (local midnight) or use `Intl.DateTimeFormat` with `timeZone: 'UTC'` for display. The grant-year utility in Phase 0 already uses `getUTCMonth` — follow the same pattern.
**Warning signs:** DOB in form shows one day earlier than what was entered.

### Pitfall 3: Duplicate detection race condition
**What goes wrong:** Staff types quickly; the second debounced call resolves before the first, displaying stale duplicate results.
**Why it happens:** Server Action calls are not cancellable; the second call may resolve earlier if the server responds faster.
**How to avoid:** Track a request ID or use an `AbortController` pattern. Simplest: store a `latestRequestId` ref, increment on each call, and only apply results if `result.requestId === latestRequestId`.
**Warning signs:** Duplicate banner appears then disappears (or vice versa) even though fields haven't changed.

### Pitfall 4: Zod v4 schema differences from v3
**What goes wrong:** Using Zod v3 API patterns (`z.string().optional().nullable()`, `.transform()` on output) that behave differently in v4.
**Why it happens:** Zod v4 changed some type inference semantics. The project uses `zod@4.3.6`.
**How to avoid:** Use `z.string().optional()` for optional fields. For SSN, strip formatting: `z.string().regex(/^\d{9}$/).optional()`. Test schemas in isolation with `.safeParse()`.
**Warning signs:** TypeScript errors on Zod schema `.parse()` return types.

### Pitfall 5: shadcn Form components not installed
**What goes wrong:** `import { Form } from '@/components/ui/form'` fails at build time.
**Why it happens:** Phase 0 only installed Button, Card, Badge, Skeleton, Sheet, Separator, DropdownMenu. Form, Input, Select, Collapsible, Alert, Table, and Sonner are not yet installed.
**How to avoid:** Wave 0 must run `pnpm dlx shadcn add form input select collapsible alert table sonner` before any component code is written.
**Warning signs:** Module not found errors on `@/components/ui/form`.

### Pitfall 6: Site scoping does NOT apply to Youth model
**What goes wrong:** Developer expects `db.youth.findMany()` to auto-filter by site_id, but Youth has no `site_id` column.
**Why it happens:** The site-scoping Prisma extension in `db.ts` injects `WHERE site_id = ?` on all models. Youth records are global identity — they have no `site_id` (by design: one youth = one record across all sites).
**How to avoid:** Query `basePrisma.youth` or `db.youth` — both work. Do NOT pass a `site_id` filter on youth queries. The extension will fail silently if it tries to inject `site_id` on a model that doesn't have it.
**Warning signs:** Prisma validation errors about unknown field `site_id` on youth model.

---

## Code Examples

### Zod Schema for createYouth

```typescript
// src/schemas/youth.ts
import { z } from 'zod';

export const createYouthSchema = z.object({
  // Required (D-02)
  firstName: z.string().min(1, 'First name is required'),
  lastName: z.string().min(1, 'Last name is required'),
  dateOfBirth: z.string().min(1, 'Date of birth is required'),
  guardianName: z.string().min(1, 'Guardian name is required'),

  // Optional demographics
  genderId: z.string().optional(),
  raceId: z.string().optional(),
  ethnicityId: z.string().optional(),

  // Optional SSN — 9 digits stripped of formatting
  ssn: z.string().regex(/^\d{9}$/, 'SSN must be 9 digits').optional(),

  // Optional address
  address: z.string().optional(),
  city: z.string().optional(),
  state: z.string().optional(),
  zip: z.string().optional(),
  phone: z.string().optional(),

  // Optional guardian
  guardianPhone: z.string().optional(),
  guardianRelation: z.string().optional(),
});

export const updateYouthSchema = createYouthSchema.partial().extend({
  id: z.string().min(1),
});

export const searchYouthSchema = z.object({
  q: z.string().optional(),
  page: z.coerce.number().min(1).default(1),
});

export const checkDuplicateSchema = z.object({
  firstName: z.string(),
  lastName: z.string(),
  dateOfBirth: z.string(),
  ssnLast4: z.string().length(4).optional(),
});

export type CreateYouthInput = z.infer<typeof createYouthSchema>;
export type UpdateYouthInput = z.infer<typeof updateYouthSchema>;
export type CheckDuplicateInput = z.infer<typeof checkDuplicateSchema>;
```

### checkDuplicate Server Action

```typescript
// src/actions/youth.ts (excerpt)
export async function checkDuplicate(
  input: unknown
): Promise<ActionResult<Youth[]>> {
  try {
    await requireAuth();
    const { firstName, lastName, dateOfBirth, ssnLast4 } =
      checkDuplicateSchema.parse(input);

    const dob = new Date(dateOfBirth);

    const matches = await db.youth.findMany({
      where: {
        OR: [
          {
            first_name: { equals: firstName, mode: 'insensitive' },
            last_name: { equals: lastName, mode: 'insensitive' },
            date_of_birth: dob,
          },
          // Refine with SSN last 4 if provided (D-05)
          ...(ssnLast4 ? [{ ssn_last4: ssnLast4 }] : []),
        ],
      },
      take: 5,
    });

    return { success: true, data: matches };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err.message : 'Unknown error' };
  }
}
```

### SSN masking on detail page (D-03)

```typescript
// In youth detail Server Component:
const { role } = await getAuthContext();
const displaySSN =
  role === 'admin' && youth.ssn
    ? decryptSSN(youth.ssn)   // Only Admin sees full SSN
    : youth.ssn_last4
      ? `***-**-${youth.ssn_last4}`
      : 'Not provided';
```

### revalidatePath after mutation

```typescript
// At the end of createYouth Server Action (success path):
import { revalidatePath } from 'next/cache';

revalidatePath('/youth');
// Redirect is handled client-side via router.push after ActionResult.success
```

---

## Environment Availability

Step 2.6: All phase dependencies are provided by the existing project stack. No new external services required.

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| PostgreSQL (Docker) | Prisma queries | ✓ | postgres:15 | — |
| Node.js | Server Actions | ✓ | 18+ | — |
| pnpm | Package install | ✓ | 8+ | — |
| react-hook-form | Registration form | ✗ | not installed | none — must install in Wave 0 |
| @hookform/resolvers | RHF + Zod bridge | ✗ | not installed | none — must install in Wave 0 |
| shadcn form/input/select/collapsible/alert/table/sonner | UI components | ✗ | not installed | none — must install in Wave 0 |

**Missing dependencies with no fallback:**
- `react-hook-form` — blocking for all form work
- `@hookform/resolvers` — blocking for Zod integration
- shadcn Form, Input, Select, Collapsible, Alert, Table, Sonner — blocking for UI

**Wave 0 install commands:**
```bash
pnpm add react-hook-form @hookform/resolvers
pnpm dlx shadcn add form input select collapsible alert table sonner
```

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.2 |
| Config file | `vitest.config.ts` |
| Quick run command | `pnpm test` |
| Full suite command | `pnpm test:coverage` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| YOUTH-01 | `createYouth` saves to DB with correct fields | unit | `pnpm test src/actions/youth.test.ts` | ❌ Wave 0 |
| YOUTH-02 | SSN encrypted on write, masked on detail read | unit | `pnpm test src/actions/youth.test.ts` | ❌ Wave 0 |
| YOUTH-03 | `checkDuplicate` returns matches for name+DOB or ssn_last4 | unit | `pnpm test src/actions/youth.test.ts` | ❌ Wave 0 |
| YOUTH-04 | `searchYouth` returns paginated results matching query | unit | `pnpm test src/actions/youth.test.ts` | ❌ Wave 0 |
| YOUTH-05 | `updateYouth` modifies existing record without creating new one | unit | `pnpm test src/actions/youth.test.ts` | ❌ Wave 0 |
| YOUTH-06 | No pathway exists to bypass duplicate detection + create same person | unit | `pnpm test src/actions/youth.test.ts` | ❌ Wave 0 |

### Sampling Rate
- **Per task commit:** `pnpm test src/actions/youth.test.ts`
- **Per wave merge:** `pnpm test`
- **Phase gate:** `pnpm test` full suite green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `src/actions/youth.test.ts` — covers YOUTH-01 through YOUTH-06 (Server Action unit tests with mocked Prisma)
- [ ] `src/schemas/youth.test.ts` — validates schema parsing for valid and invalid inputs

---

## Project Constraints (from CLAUDE.md)

| Directive | Impact on Phase 1 |
|-----------|------------------|
| Never modify `/legacy-src` | Reference only — read `QuickAddPerson.aspx`, `EnrollmentPage.aspx` for field reference |
| Always check `/specs/_audit/` before creating components | Read `01-page-inventory.md` for legacy youth registration fields |
| New pages: `/src/app/[route]/page.tsx` | Youth routes: `/src/app/(app)/youth/page.tsx`, `/youth/new/page.tsx`, `/youth/[youthId]/page.tsx` |
| New API routes: `/src/app/api/[name]/route.ts` | Phase 1 uses Server Actions, not API routes |
| pnpm only | All installs via `pnpm add` / `pnpm dlx shadcn` |
| No `any` type | All Server Action inputs typed as `unknown`, narrowed via Zod `.parse()` |
| Never create `new PrismaClient()` | Always `import { db } from '@/lib/db'` |
| Never throw from Server Actions | Always return `ActionResult<T>` |
| Never log SSN | `logger.info({ youth_id }, ...)` only |
| Never manually add `WHERE site_id` | Youth model has no `site_id` — do not add one |
| Server Actions: call `requireAuth()` at top | Every action in `src/actions/youth.ts` starts with `await requireAuth()` |
| shadcn `Form` component | Use `<FormField>`, `<FormItem>`, `<FormControl>`, `<FormMessage>` wrappers |
| Always use `@/*` path alias | No `../../` imports |
| Always use dev server scripts | `./scripts/dev-server.sh start` for local testing |

---

## State of the Art

| Old Approach | Current Approach | Impact |
|--------------|------------------|--------|
| Form validation with manual `onChange` checks | React Hook Form 7 + Zod zodResolver | Use RHF; validation is declarative |
| `next/router` (pages router) | `useRouter` from `next/navigation` (App Router) | Import from `next/navigation`, not `next/router` |
| `getServerSideProps` | Server Components + async params | `searchParams` is now `Promise<{...}>` in Next.js 15 — must `await searchParams` |
| `pages/api/` route handlers | `src/app/api/[name]/route.ts` + Server Actions | Phase 1 uses Server Actions exclusively |
| Prisma 6 `DATABASE_URL` in schema | Prisma 7 datasource URL in `prisma.config.ts` | Phase 0 already handles this — no action |

**Deprecated/outdated:**
- `next/router` — replaced by `next/navigation` in App Router; `useRouter`, `useSearchParams`, `usePathname` all from `next/navigation`
- `getServerSideProps` — does not exist in App Router; page files are Server Components by default
- `pages/` directory — project uses `src/app/` exclusively

---

## Open Questions

1. **Collapsible sections: open by default or collapsed?**
   - What we know: D-01 specifies collapsible sections exist; no default state specified
   - What's unclear: Whether Demographics section should auto-expand (all fields) or staff prefers collapsed navigation
   - Recommendation: Default all sections to open on new registration (staff needs to see all fields). Allow collapse after first interaction.

2. **Search debounce timing**
   - What we know: D-07 says "debounced server query"; D-04 says check triggers as fields are filled
   - What's unclear: Whether 300ms or 500ms is more appropriate for search vs duplicate detection
   - Recommendation: 300ms for search (user expects instant filter), 500ms for duplicate detection (heavier query, fewer false positives during fast typing)

3. **DOB input type**
   - What we know: Schema stores as `DateTime @db.Date`; form needs DOB input
   - What's unclear: Whether `<input type="date">` (native browser) or a shadcn DatePicker is expected
   - Recommendation: Use `<input type="date">` — simpler, no additional component needed, consistent across browsers. Shadcn's DatePicker is complex and not yet installed.

---

## Sources

### Primary (HIGH confidence)
- Codebase — `prisma/schema.prisma` Youth model (lines 178–204) — confirmed fields and indexes
- Codebase — `src/lib/ssn-encryption.ts` — confirmed API: `encryptSSN(ssn)`, `decryptSSN(stored)`, `extractLast4(ssn)`
- Codebase — `src/lib/auth.ts` — confirmed API: `requireAuth()`, `getAuthContext()`, `checkRole()`
- Codebase — `src/lib/db.ts` — confirmed site-scoping extension applies `WHERE site_id` — does NOT apply to Youth (no site_id column)
- Codebase — `src/types/action-result.ts` — confirmed `ActionResult<T>` shape
- Codebase — `package.json` — confirmed react-hook-form and @hookform/resolvers are NOT installed; zod 4.3.6 IS installed
- Codebase — `src/components/ui/` — confirmed 8 shadcn components installed; Form/Input/Select/etc. NOT installed
- npm registry — `npm view react-hook-form version` → 7.72.0 (verified 2026-03-30)
- npm registry — `npm view @hookform/resolvers version` → 5.2.2 (verified 2026-03-30)

### Secondary (MEDIUM confidence)
- WebSearch — @hookform/resolvers v5 supports Zod v4 — confirmed via npm package page and GitHub release notes
- .planning/CONTEXT.md — all decisions D-01 through D-12 verified from user session

### Tertiary (LOW confidence)
- None

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — versions verified against npm registry; installed status confirmed from package.json and pnpm-lock.yaml
- Architecture: HIGH — patterns derived directly from Phase 0 codebase conventions and CONTEXT.md decisions
- Pitfalls: HIGH — derived from actual codebase inspection (site_id on Youth, Zod v4, Next.js 15 async searchParams)

**Research date:** 2026-03-30
**Valid until:** 2026-04-30 (stable stack; react-hook-form and Next.js rarely introduce breaking changes in minor releases)
