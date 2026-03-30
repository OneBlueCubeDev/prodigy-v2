import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock the db module
const mockCreate = vi.fn().mockResolvedValue({});
vi.mock('@/lib/db', () => ({
  basePrisma: {
    auditLog: {
      create: (...args: unknown[]) => mockCreate(...args),
    },
  },
}));

// Mock logger to suppress output
vi.mock('@/lib/logger', () => ({
  default: {
    error: vi.fn(),
    info: vi.fn(),
    warn: vi.fn(),
    debug: vi.fn(),
  },
}));

const { logAuditEvent } = await import('@/lib/audit');

describe('Audit Logging (INFRA-01, INFRA-02)', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('creates audit log entry for write operation', async () => {
    await logAuditEvent(
      'Youth',
      'create',
      { data: { first_name: 'Test' } },
      { id: 'youth_1' },
      'user_123',
    );
    expect(mockCreate).toHaveBeenCalledTimes(1);
    expect(mockCreate).toHaveBeenCalledWith({
      data: expect.objectContaining({
        model: 'Youth',
        operation: 'create',
        record_id: 'youth_1',
        user_id: 'user_123',
      }),
    });
  });

  it('extracts record ID from result object', async () => {
    await logAuditEvent('Enrollment', 'update', {}, { id: 'enrl_99' });
    expect(mockCreate).toHaveBeenCalledWith({
      data: expect.objectContaining({
        record_id: 'enrl_99',
      }),
    });
  });

  it('uses "system" when no userId provided', async () => {
    await logAuditEvent('Site', 'create', {}, { id: 'site_1' });
    expect(mockCreate).toHaveBeenCalledWith({
      data: expect.objectContaining({
        user_id: 'system',
      }),
    });
  });

  it('handles missing result gracefully', async () => {
    await logAuditEvent('Youth', 'delete', {}, null);
    expect(mockCreate).toHaveBeenCalledTimes(1);
  });
});
