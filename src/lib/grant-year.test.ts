import { describe, it, expect } from 'vitest';
import { computeGrantYear } from '@/lib/grant-year';

describe('Grant Year', () => {
  it('returns current year for dates July 1 and after', () => {
    expect(computeGrantYear(new Date('2025-07-01'))).toBe(2025);
    expect(computeGrantYear(new Date('2025-08-15'))).toBe(2025);
    expect(computeGrantYear(new Date('2025-12-31'))).toBe(2025);
  });

  it('returns previous year for dates before July 1', () => {
    expect(computeGrantYear(new Date('2025-06-30'))).toBe(2024);
    expect(computeGrantYear(new Date('2025-01-15'))).toBe(2024);
    expect(computeGrantYear(new Date('2025-03-01'))).toBe(2024);
  });

  it('handles year boundary correctly', () => {
    // Jan 1 2026 is still grant year 2025
    expect(computeGrantYear(new Date('2026-01-01'))).toBe(2025);
    // July 1 2026 starts grant year 2026
    expect(computeGrantYear(new Date('2026-07-01'))).toBe(2026);
  });
});
