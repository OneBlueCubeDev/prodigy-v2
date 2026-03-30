# Testing Patterns

**Analysis Date:** 2026-03-29

This document defines the testing framework, structure, and patterns for the Prodigy migration project. Both unit/component and end-to-end testing are required.

## Test Framework

**Test Runner:**
- Framework: Vitest
- Config: `vitest.config.ts`
- Environment: jsdom (for component testing)
- React Plugin: `@vitejs/plugin-react`

**Assertion Library:**
- Jest assertions (built into Vitest)
- React Testing Library for component queries
- Playwright for end-to-end testing

**Run Commands:**

```bash
# Run all unit/component tests
pnpm test

# Watch mode (rerun on file changes)
pnpm test --watch

# Coverage report
pnpm test --coverage

# E2E tests
pnpm test:e2e

# E2E tests in UI mode
pnpm test:e2e --ui
```

## Test File Organization

**Location Pattern:**
- Unit/component tests: Co-located next to source files
- File naming: `{module}.test.ts` or `{module}.test.tsx`
- E2E tests: `e2e/` directory at project root

**Vitest Configuration File:**
`vitest.config.ts` in project root with React plugin and jsdom environment.

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./vitest.setup.ts'],
  },
})
```

**Playwright Configuration File:**
`e2e/playwright.config.ts` with basic HTTP server configuration.

```typescript
// e2e/playwright.config.ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  use: {
    baseURL: 'http://localhost:3000',
  },
  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
})
```

## Test Structure

**Suite Organization:**

```typescript
// src/lib/ssn-encryption.test.ts
import { describe, it, expect } from 'vitest'
import { encryptSSN, decryptSSN } from './ssn-encryption'

describe('SSN Encryption', () => {
  describe('encryptSSN', () => {
    it('should encrypt a valid SSN', () => {
      const result = encryptSSN('123456789')
      expect(result.last4).toBe('6789')
      expect(result.encrypted).toBeDefined()
    })

    it('should throw on invalid SSN format', () => {
      expect(() => encryptSSN('invalid')).toThrow()
    })
  })

  describe('decryptSSN', () => {
    it('should decrypt a previously encrypted SSN', () => {
      const ssn = '123456789'
      const encrypted = encryptSSN(ssn)
      const decrypted = decryptSSN(encrypted.encrypted)
      expect(decrypted).toBe(ssn)
    })
  })
})
```

**Test File Structure Pattern:**
1. Imports (vitest, React Testing Library, source code)
2. Test suites via `describe()` blocks
3. Individual tests via `it()` statements
4. Setup/teardown via `beforeEach()`/`afterEach()`

## Patterns

**Async Testing:**
Use `async`/`await` for Server Actions and promise-based code.

```typescript
// src/actions/youth.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'vitest'
import { createYouth } from './youth'

describe('createYouth', () => {
  it('should create a youth record with valid input', async () => {
    const result = await createYouth({
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2010-05-15',
      ssn: '123456789',
    })

    expect(result.success).toBe(true)
    if (result.success) {
      expect(result.data.id).toBeDefined()
      expect(result.data.firstName).toBe('John')
    }
  })

  it('should return error on invalid input', async () => {
    const result = await createYouth({ firstName: 'John' })

    expect(result.success).toBe(false)
    if (!result.success) {
      expect(result.error).toContain('lastName')
    }
  })
})
```

**Error Testing:**
Test error paths explicitly. Always check `ActionResult` success flag.

```typescript
// src/actions/enrollment.test.ts
describe('enrollYouth', () => {
  it('should fail when enrolling into non-existent program', async () => {
    const result = await enrollYouth({
      youthId: 'valid-id',
      programId: 'non-existent',
      siteId: 'site-1',
    })

    expect(result.success).toBe(false)
    if (!result.success) {
      expect(result.error).toContain('program')
    }
  })
})
```

## Mocking

**Framework:** Vitest's built-in mocking via `vi` module

**What to Mock:**
- Database calls (Prisma client)
- External API calls (Clerk, Metabase)
- Filesystem operations

**What NOT to Mock:**
- Business logic functions
- Type validation (Zod)
- Utility functions (date formatting, encryption)
- Components under test (only mock dependencies)

**Mocking Database Calls:**

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { createYouth } from './youth'
import { db } from '@/lib/db'

vi.mock('@/lib/db')

describe('createYouth', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should call db.youth.create with encrypted SSN', async () => {
    const mockCreate = vi.fn().mockResolvedValue({
      id: 'youth-1',
      firstName: 'John',
      ssn_last4: '6789',
    })
    vi.mocked(db.youth).create = mockCreate

    await createYouth({
      firstName: 'John',
      lastName: 'Doe',
      ssn: '123456789',
    })

    expect(mockCreate).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          ssn_last4: '6789',
        }),
      })
    )
  })
})
```

**Mocking External APIs:**

```typescript
import { describe, it, expect, vi } from 'vitest'
import { generateMetabaseToken } from './metabase'
import * as jwt from 'jsonwebtoken'

vi.mock('jsonwebtoken')

describe('generateMetabaseToken', () => {
  it('should sign JWT with correct payload', () => {
    vi.mocked(jwt.sign).mockReturnValue('mock-token')

    const token = generateMetabaseToken({ userId: 'user-1' })

    expect(jwt.sign).toHaveBeenCalledWith(
      expect.objectContaining({ sub: 'user-1' }),
      expect.any(String)
    )
    expect(token).toBe('mock-token')
  })
})
```

## Fixtures and Factories

**Test Data Factories:**
Create consistent test data via factory functions in `e2e/fixtures/`.

```typescript
// e2e/fixtures/test-data.ts
export async function createTestYouth(page) {
  await page.goto('/youth/new')
  await page.fill('input[name="firstName"]', 'Test')
  await page.fill('input[name="lastName"]', 'Youth')
  await page.fill('input[name="dateOfBirth"]', '2010-05-15')
  await page.fill('input[name="ssn"]', '123456789')
  await page.click('button:has-text("Register")')
  await page.waitForURL('/youth/*')
}

export async function createTestProgram(page) {
  await page.goto('/admin/programs')
  await page.click('button:has-text("New Program")')
  await page.fill('input[name="name"]', 'Test Program')
  await page.click('button:has-text("Create")')
  await page.waitForURL('/programs/*')
}
```

**Usage in E2E Tests:**

```typescript
// e2e/youth-registration.spec.ts
import { test, expect } from '@playwright/test'
import { createTestYouth } from './fixtures/test-data'

test('should register a new youth', async ({ page }) => {
  await createTestYouth(page)
  await expect(page.locator('h1')).toContainText('Test Youth')
})
```

## Coverage

**Coverage Requirements:**
- Target: 80% line coverage for business logic
- Not enforced: 100% coverage not required (diminishing returns)
- Focus on: Server Actions, Zod schemas, utility functions

**View Coverage:**

```bash
pnpm test --coverage
```

**Coverage Configuration:**
Add to `vitest.config.ts`:

```typescript
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'e2e/',
        'src/components/ui/', // shadcn components
      ],
    },
  },
})
```

## Test Types

**Unit Tests:**
Test individual functions in isolation with mocked dependencies.

**Scope:**
- Utility functions (`src/lib/*.ts`)
- Business logic in Server Actions
- Zod schemas (validation rules)
- Type guards

**Example:**

```typescript
// src/lib/grant-year.test.ts
import { describe, it, expect } from 'vitest'
import { getGrantYear } from './grant-year'

describe('getGrantYear', () => {
  it('should return same year for dates Jan-Jun', () => {
    expect(getGrantYear(new Date('2026-03-15'))).toBe(2025)
    expect(getGrantYear(new Date('2026-06-30'))).toBe(2025)
  })

  it('should return next year for dates Jul-Dec', () => {
    expect(getGrantYear(new Date('2026-07-01'))).toBe(2026)
    expect(getGrantYear(new Date('2026-12-31'))).toBe(2026)
  })
})
```

**Component Tests:**
Test React components with React Testing Library.

**Scope:**
- Component rendering with various props
- User interactions (click, form submit)
- Accessibility attributes
- Integration with Server Actions

**Example:**

```typescript
// src/components/youth/youth-search.test.tsx
import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { YouthSearch } from './youth-search'

vi.mock('@/actions/youth', () => ({
  searchYouth: vi.fn().mockResolvedValue([
    {
      id: 'youth-1',
      firstName: 'John',
      lastName: 'Doe',
    },
  ]),
}))

describe('YouthSearch', () => {
  it('should render search input', () => {
    render(<YouthSearch />)
    expect(screen.getByPlaceholderText('Search...')).toBeInTheDocument()
  })

  it('should call searchYouth on form submit', async () => {
    const user = userEvent.setup()
    const { searchYouth } = await import('@/actions/youth')

    render(<YouthSearch />)
    await user.type(screen.getByPlaceholderText('Search...'), 'John')
    await user.click(screen.getByText('Search'))

    expect(searchYouth).toHaveBeenCalledWith('John')
  })
})
```

**Integration Tests:**
Test features across multiple layers (component + Server Action + database).

**Scope:**
- Full form submission workflow
- Data persistence to database
- Cross-component data flow

**Example:**

```typescript
// src/app/youth/new/page.test.tsx
import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import YouthNewPage from './page'

// This assumes db is mocked at vitest setup level
describe('Youth Registration Page', () => {
  it('should create a youth and redirect to detail page', async () => {
    const user = userEvent.setup()
    const { container } = render(<YouthNewPage />)

    await user.type(screen.getByLabelText('First Name'), 'John')
    await user.type(screen.getByLabelText('Last Name'), 'Doe')
    await user.type(screen.getByLabelText('Date of Birth'), '05/15/2010')
    await user.type(screen.getByLabelText('SSN'), '123456789')
    await user.click(screen.getByText('Register'))

    // Verify success state or redirect
    await screen.findByText('Youth registered successfully')
  })
})
```

**E2E Tests:**
Test complete user workflows in a real browser.

**Scope:**
- Full page navigation flows
- Cross-page workflows (register → enroll → check attendance)
- Browser-specific features
- Mobile responsiveness

**Example:**

```typescript
// e2e/youth-registration.spec.ts
import { test, expect } from '@playwright/test'

test('should register and enroll a youth', async ({ page }) => {
  // Navigate to registration
  await page.goto('http://localhost:3000/youth/new')
  await expect(page).toHaveTitle(/Registration/)

  // Fill and submit form
  await page.fill('input[name="firstName"]', 'John')
  await page.fill('input[name="lastName"]', 'Doe')
  await page.fill('input[name="dateOfBirth"]', '05/15/2010')
  await page.fill('input[name="ssn"]', '123456789')
  await page.click('button[type="submit"]')

  // Verify redirect to detail page
  await expect(page).toHaveURL(/\/youth\/\w+/)
  await expect(page.locator('h1')).toContainText('John Doe')

  // Enroll youth
  await page.click('button:has-text("Enroll in Program")')
  await page.selectOption('select[name="programId"]', 'program-1')
  await page.click('button:has-text("Confirm")')

  // Verify enrollment appears in list
  await page.goto('http://localhost:3000/enrollments')
  await expect(page.locator('td')).toContainText('John Doe')
})
```

## Common Patterns

**Testing Validation (Zod Schemas):**

```typescript
import { describe, it, expect } from 'vitest'
import { createYouthSchema } from '@/schemas/youth'

describe('createYouthSchema', () => {
  it('should validate valid input', () => {
    const valid = {
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2010-05-15',
      ssn: '123456789',
    }
    expect(() => createYouthSchema.parse(valid)).not.toThrow()
  })

  it('should reject missing required fields', () => {
    const invalid = { firstName: 'John' }
    expect(() => createYouthSchema.parse(invalid)).toThrow()
  })

  it('should reject invalid SSN format', () => {
    const invalid = {
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2010-05-15',
      ssn: 'invalid',
    }
    expect(() => createYouthSchema.parse(invalid)).toThrow()
  })
})
```

**Testing Server Actions with ActionResult:**

```typescript
describe('Server Actions', () => {
  it('should return ActionResult success type', async () => {
    const result = await createYouth(validInput)

    expect(result).toHaveProperty('success')
    expect(result.success).toBe(true)

    if (result.success) {
      expect(result.data).toHaveProperty('id')
      expect(result.data).not.toHaveProperty('error')
    }
  })

  it('should return ActionResult error type on failure', async () => {
    const result = await createYouth(invalidInput)

    expect(result).toHaveProperty('success')
    expect(result.success).toBe(false)

    if (!result.success) {
      expect(result).toHaveProperty('error')
      expect(result.error).toBeA('string')
    }
  })
})
```

**Testing Prisma with Site Scoping:**

```typescript
import { beforeEach, afterEach } from 'vitest'
import { db } from '@/lib/db'

describe('Prisma with site scoping', () => {
  let testYouthId: string

  beforeEach(async () => {
    // Create test data
    const youth = await db.youth.create({
      data: {
        firstName: 'Test',
        lastName: 'Youth',
        siteId: 'site-1',
      },
    })
    testYouthId = youth.id
  })

  afterEach(async () => {
    // Clean up
    await db.youth.deleteMany({})
  })

  it('should only return youth from assigned sites due to extension', async () => {
    // Note: Prisma extension applies site filter automatically
    const results = await db.youth.findMany()
    // Results will only include youth from user's assigned sites
  })
})
```

## CI Integration

**GitHub Actions:** Tests run automatically on pull requests and commits to `main`.

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install
      - run: pnpm test
      - run: pnpm test:e2e
```

## Best Practices

**When to Test:**
- Server Actions: Always (they're the API boundary)
- Utility functions: Always (they're reusable)
- Components: Critical user paths (registration, attendance, enrollment)
- Schemas: Always (validation is critical)

**When NOT to Test:**
- shadcn/ui components (they're pre-tested)
- Simple presentational components with no logic
- Styling/CSS (use visual regression tests if needed)

**Test Naming:**
- Descriptive `describe()` blocks
- `it()` statements start with verb: "should", "must", "will"

```typescript
describe('YouthSearch', () => {
  it('should filter results by first name')
  it('should display last 4 SSN when searching by SSN')
  it('should return no results for non-matching query')
})
```

**Assertion Clarity:**
- One assertion per test when possible
- Multiple related assertions acceptable if they test one behavior

```typescript
// Good: Clear intent
it('should return ActionResult with success flag', () => {
  const result = createYouth(input)
  expect(result.success).toBe(true)
})

// Also good: Multiple assertions for related behavior
it('should encrypt SSN and extract last 4', () => {
  const { encrypted, last4 } = encryptSSN('123456789')
  expect(encrypted).toBeDefined()
  expect(last4).toBe('6789')
})
```

---

*Testing analysis: 2026-03-29*
