/**
 * Compute grant year from a date.
 * Grant year starts July 1 and runs through June 30.
 * A date of 2025-01-15 returns 2024 (grant year started July 2024).
 * A date of 2025-08-01 returns 2025 (grant year started July 2025).
 */
export function computeGrantYear(date: Date): number {
  const month = date.getUTCMonth(); // 0-indexed; June = 5; use UTC to avoid timezone drift
  const year = date.getUTCFullYear();
  return month >= 6 ? year : year - 1;
}
