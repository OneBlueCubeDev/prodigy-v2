import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock Clerk auth()
const mockAuth = vi.fn();
vi.mock('@clerk/nextjs/server', () => ({
  auth: () => mockAuth(),
}));

// Import AFTER mock setup
const { checkRole, getAuthContext } = await import('@/lib/auth');

describe('Auth Helpers (AUTH-02, AUTH-04)', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('checkRole returns true when role matches', async () => {
    mockAuth.mockResolvedValue({
      userId: 'user_123',
      sessionClaims: { metadata: { role: 'admin' } },
    });
    expect(await checkRole('admin')).toBe(true);
  });

  it('checkRole returns false when role does not match', async () => {
    mockAuth.mockResolvedValue({
      userId: 'user_123',
      sessionClaims: { metadata: { role: 'site' } },
    });
    expect(await checkRole('admin')).toBe(false);
  });

  it('checkRole returns false when no session claims', async () => {
    mockAuth.mockResolvedValue({
      userId: null,
      sessionClaims: null,
    });
    expect(await checkRole('admin')).toBe(false);
  });

  it('getAuthContext extracts userId, role, and siteId', async () => {
    mockAuth.mockResolvedValue({
      userId: 'user_456',
      sessionClaims: { metadata: { role: 'site', site_id: 'site_789' } },
    });
    const ctx = await getAuthContext();
    expect(ctx.userId).toBe('user_456');
    expect(ctx.role).toBe('site');
    expect(ctx.siteId).toBe('site_789');
  });
});
