---
phase: 0
slug: foundation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-29
---

# Phase 0 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Vitest 4.1.2 |
| **Config file** | `vitest.config.ts` — does not exist yet (Wave 0 gap) |
| **Quick run command** | `pnpm vitest run` |
| **Full suite command** | `pnpm vitest run --coverage` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run `pnpm vitest run`
- **After every plan wave:** Run `pnpm vitest run --coverage && pnpm playwright test`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 00-01-01 | 01 | 1 | AUTH-02 | unit | `pnpm vitest run src/lib/auth.test.ts` | ❌ W0 | ⬜ pending |
| 00-01-02 | 01 | 1 | AUTH-04 | unit | `pnpm vitest run src/actions/*.test.ts` | ❌ W0 | ⬜ pending |
| 00-01-03 | 01 | 1 | AUTH-03 | smoke (E2E) | `pnpm playwright test e2e/program-selector.spec.ts` | ❌ W0 | ⬜ pending |
| 00-01-04 | 01 | 1 | INFRA-01 | integration | `pnpm vitest run src/lib/audit.test.ts` | ❌ W0 | ⬜ pending |
| 00-01-05 | 01 | 1 | INFRA-02 | integration | `pnpm vitest run src/lib/audit.test.ts` | ❌ W0 | ⬜ pending |
| 00-01-06 | 01 | 1 | INFRA-03 | unit | `pnpm vitest run src/lib/ssn-encryption.test.ts` | ❌ W0 | ⬜ pending |
| 00-01-07 | 01 | 1 | INFRA-05 | smoke | `pnpm vitest run src/app/api/health/route.test.ts` | ❌ W0 | ⬜ pending |
| 00-01-08 | 01 | 1 | LOOK-02 | integration | `pnpm vitest run src/lib/db.test.ts` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `vitest.config.ts` — framework config; specify `environment: 'node'` for lib tests, `environment: 'jsdom'` for component tests
- [ ] `src/lib/ssn-encryption.test.ts` — covers INFRA-03
- [ ] `src/lib/auth.test.ts` — covers AUTH-02, AUTH-04 (mock Clerk `auth()`)
- [ ] `src/lib/audit.test.ts` — covers INFRA-01, INFRA-02
- [ ] `src/lib/grant-year.test.ts` — covers grant year boundary cases (July 1 both sides)
- [ ] `src/app/api/health/route.test.ts` — covers INFRA-05
- [ ] `e2e/playwright.config.ts` — E2E config
- [ ] `e2e/program-selector.spec.ts` — covers AUTH-03

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| MFA enforced via Clerk Dashboard | AUTH-01 | MFA enforcement is a Clerk Dashboard state, not testable in unit/integration tests | Navigate to Clerk Dashboard → Multi-factor → Verify "Require multi-factor authentication" is enabled |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
