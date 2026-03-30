---
phase: 1
slug: youth-registration
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-30
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Vitest 4.1.2 |
| **Config file** | `vitest.config.ts` |
| **Quick run command** | `pnpm test` |
| **Full suite command** | `pnpm test:coverage` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run `pnpm test src/actions/youth.test.ts`
- **After every plan wave:** Run `pnpm test`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | YOUTH-01 | unit | `pnpm test src/actions/youth.test.ts` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | YOUTH-02 | unit | `pnpm test src/actions/youth.test.ts` | ❌ W0 | ⬜ pending |
| 01-01-03 | 01 | 1 | YOUTH-03 | unit | `pnpm test src/actions/youth.test.ts` | ❌ W0 | ⬜ pending |
| 01-01-04 | 01 | 1 | YOUTH-04 | unit | `pnpm test src/actions/youth.test.ts` | ❌ W0 | ⬜ pending |
| 01-01-05 | 01 | 1 | YOUTH-05 | unit | `pnpm test src/actions/youth.test.ts` | ❌ W0 | ⬜ pending |
| 01-01-06 | 01 | 1 | YOUTH-06 | unit | `pnpm test src/actions/youth.test.ts` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `src/actions/youth.test.ts` — stubs for YOUTH-01 through YOUTH-06 (Server Action unit tests with mocked Prisma)
- [ ] `src/schemas/youth.test.ts` — validates Zod schema parsing for valid and invalid inputs

*Existing infrastructure covers test framework — only test files need creation.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Registration form completes in < 5 min | YOUTH-01 | UX timing | Fill all fields on `/youth/new`, measure wall-clock time |
| Duplicate warning banner is visually yellow | YOUTH-03 | Visual check | Register with existing name+DOB, confirm yellow banner appears |
| SSN masked display (***-**-1234) | YOUTH-02 | Visual check | View youth detail page as non-Admin role, confirm SSN is masked |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
