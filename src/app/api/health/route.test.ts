import { describe, it, expect, vi } from 'vitest';

// Mock db
const mockQueryRaw = vi.fn();
vi.mock('@/lib/db', () => ({
  default: {
    $queryRaw: (...args: unknown[]) => mockQueryRaw(...args),
  },
}));

const { GET } = await import('@/app/api/health/route');

describe('Health Check (INFRA-05)', () => {
  it('returns 200 with { status: ok } when DB is available', async () => {
    mockQueryRaw.mockResolvedValue([{ '?column?': 1 }]);
    const response = await GET();
    const body = await response.json();
    expect(response.status).toBe(200);
    expect(body.status).toBe('ok');
  });

  it('returns 503 with error when DB is unavailable', async () => {
    mockQueryRaw.mockRejectedValue(new Error('Connection refused'));
    const response = await GET();
    const body = await response.json();
    expect(response.status).toBe(503);
    expect(body.status).toBe('error');
  });
});
