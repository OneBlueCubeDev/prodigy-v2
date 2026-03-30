import { describe, it, expect, vi, beforeEach } from 'vitest';

// --- Mocks (set up before any imports) ---

// Mock requireAuth
const mockRequireAuth = vi.fn().mockResolvedValue({
  userId: 'user_test_123',
  role: 'admin' as const,
  siteId: undefined,
});
vi.mock('@/lib/auth', () => ({
  requireAuth: () => mockRequireAuth(),
}));

// Mock Prisma db
const mockYouthCreate = vi.fn();
const mockYouthUpdate = vi.fn();
const mockYouthFindMany = vi.fn();
const mockYouthCount = vi.fn();
const mockYouthFindUnique = vi.fn();

vi.mock('@/lib/db', () => ({
  db: {
    youth: {
      create: (...args: unknown[]) => mockYouthCreate(...args),
      update: (...args: unknown[]) => mockYouthUpdate(...args),
      findMany: (...args: unknown[]) => mockYouthFindMany(...args),
      count: (...args: unknown[]) => mockYouthCount(...args),
      findUnique: (...args: unknown[]) => mockYouthFindUnique(...args),
    },
  },
}));

// SSN encryption mock no longer needed — only last 4 digits stored

// Mock logger
vi.mock('@/lib/logger', () => ({
  default: {
    info: vi.fn(),
    warn: vi.fn(),
    error: vi.fn(),
    debug: vi.fn(),
  },
}));

// Mock revalidatePath
const mockRevalidatePath = vi.fn();
vi.mock('next/cache', () => ({
  revalidatePath: (...args: unknown[]) => mockRevalidatePath(...args),
}));

// Import AFTER mocks
const { createYouth, updateYouth, searchYouth, checkDuplicate, getYouthById, logDuplicateOverride } =
  await import('@/actions/youth');

// Sample youth record returned from DB
const sampleYouth = {
  id: 'youth_abc123',
  first_name: 'John',
  last_name: 'Doe',
  date_of_birth: new Date('2010-05-15'),
  ssn: null,
  ssn_last4: null,
  gender_id: null,
  race_id: null,
  ethnicity_id: null,
  address: null,
  city: null,
  county_id: null,
  state: null,
  zip: null,
  phone: null,
  guardian_name: 'Jane Doe',
  guardian_phone: null,
  guardian_relation: null,
  created_at: new Date(),
  updated_at: new Date(),
};

const validCreateInput = {
  firstName: 'John',
  lastName: 'Doe',
  dateOfBirth: '2010-05-15',
  guardianName: 'Jane Doe',
};

describe('createYouth', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockRequireAuth.mockResolvedValue({
      userId: 'user_test_123',
      role: 'admin' as const,
      siteId: undefined,
    });
    mockYouthCreate.mockResolvedValue(sampleYouth);
  });

  it('calls requireAuth before any DB operation', async () => {
    await createYouth(validCreateInput);
    expect(mockRequireAuth).toHaveBeenCalledTimes(1);
  });

  it('returns success with youth data on valid input', async () => {
    const result = await createYouth(validCreateInput);
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data).toEqual(sampleYouth);
    }
  });

  it('calls db.youth.create with correct data', async () => {
    await createYouth(validCreateInput);
    expect(mockYouthCreate).toHaveBeenCalledWith({
      data: expect.objectContaining({
        first_name: 'John',
        last_name: 'Doe',
        guardian_name: 'Jane Doe',
        ssn: null,
        ssn_last4: null,
      }),
    });
  });

  it('calls revalidatePath("/youth") after creation', async () => {
    await createYouth(validCreateInput);
    expect(mockRevalidatePath).toHaveBeenCalledWith('/youth');
  });

  it('stores SSN last 4 when provided', async () => {
    const inputWithSSN = { ...validCreateInput, ssnLast4: '6789' };
    await createYouth(inputWithSSN);
    expect(mockYouthCreate).toHaveBeenCalledWith({
      data: expect.objectContaining({
        ssn: null,
        ssn_last4: '6789',
      }),
    });
  });

  it('stores null for ssn_last4 when not provided', async () => {
    await createYouth(validCreateInput);
    expect(mockYouthCreate).toHaveBeenCalledWith({
      data: expect.objectContaining({
        ssn: null,
        ssn_last4: null,
      }),
    });
  });

  it('returns error result when unauthenticated', async () => {
    mockRequireAuth.mockRejectedValue(new Error('Unauthorized'));
    const result = await createYouth(validCreateInput);
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(result.error).toContain('Unauthorized');
    }
  });

  it('returns error result when DB fails', async () => {
    mockYouthCreate.mockRejectedValue(new Error('DB connection failed'));
    const result = await createYouth(validCreateInput);
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(result.error).toContain('DB connection failed');
    }
  });

  it('returns error result on invalid input (missing required fields)', async () => {
    const result = await createYouth({});
    expect(result.success).toBe(false);
  });
});

describe('updateYouth', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockRequireAuth.mockResolvedValue({
      userId: 'user_test_123',
      role: 'admin' as const,
      siteId: undefined,
    });
    mockYouthUpdate.mockResolvedValue({
      ...sampleYouth,
      first_name: 'Updated',
    });
  });

  const validUpdateInput = { id: 'youth_abc123', ...validCreateInput };

  it('calls requireAuth before any DB operation', async () => {
    await updateYouth({ ...validUpdateInput, firstName: 'Updated' });
    expect(mockRequireAuth).toHaveBeenCalledTimes(1);
  });

  it('returns success with updated youth on valid input', async () => {
    const result = await updateYouth({ ...validUpdateInput, firstName: 'Updated' });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.first_name).toBe('Updated');
    }
  });

  it('calls db.youth.update with correct id', async () => {
    await updateYouth({ ...validUpdateInput, firstName: 'Updated' });
    expect(mockYouthUpdate).toHaveBeenCalledWith({
      where: { id: 'youth_abc123' },
      data: expect.objectContaining({ first_name: 'Updated' }),
    });
  });

  it('calls revalidatePath for both /youth and /youth/[id]', async () => {
    await updateYouth({ ...validUpdateInput, firstName: 'Updated' });
    expect(mockRevalidatePath).toHaveBeenCalledWith('/youth');
    expect(mockRevalidatePath).toHaveBeenCalledWith('/youth/youth_abc123');
  });

  it('updates SSN last 4 when provided', async () => {
    await updateYouth({ ...validUpdateInput, ssnLast4: '4321' });
    expect(mockYouthUpdate).toHaveBeenCalledWith({
      where: { id: 'youth_abc123' },
      data: expect.objectContaining({
        ssn_last4: '4321',
      }),
    });
  });

  it('returns error on invalid input (missing id)', async () => {
    const result = await updateYouth({ ...validCreateInput });
    expect(result.success).toBe(false);
  });
});

describe('searchYouth', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockRequireAuth.mockResolvedValue({
      userId: 'user_test_123',
      role: 'admin' as const,
      siteId: undefined,
    });
    mockYouthFindMany.mockResolvedValue([sampleYouth]);
    mockYouthCount.mockResolvedValue(1);
  });

  it('returns paginated results with total count', async () => {
    const result = await searchYouth({ q: 'John', page: 1 });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.youth).toEqual([sampleYouth]);
      expect(result.data.total).toBe(1);
    }
  });

  it('calls requireAuth before any DB operation', async () => {
    await searchYouth({});
    expect(mockRequireAuth).toHaveBeenCalledTimes(1);
  });

  it('returns all youth ordered by created_at desc when query is empty', async () => {
    mockYouthFindMany.mockResolvedValue([sampleYouth]);
    mockYouthCount.mockResolvedValue(1);
    await searchYouth({});
    expect(mockYouthFindMany).toHaveBeenCalledWith(
      expect.objectContaining({
        orderBy: { created_at: 'desc' },
      }),
    );
  });

  it('searches across name and SSN last4 with OR query', async () => {
    await searchYouth({ q: 'John' });
    expect(mockYouthFindMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.objectContaining({
          OR: expect.arrayContaining([
            expect.objectContaining({ first_name: expect.anything() }),
          ]),
        }),
      }),
    );
  });
});

describe('checkDuplicate', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockRequireAuth.mockResolvedValue({
      userId: 'user_test_123',
      role: 'admin' as const,
      siteId: undefined,
    });
    mockYouthFindMany.mockResolvedValue([]);
  });

  it('calls requireAuth before any DB operation', async () => {
    await checkDuplicate({
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2010-05-15',
    });
    expect(mockRequireAuth).toHaveBeenCalledTimes(1);
  });

  it('returns matching youth records via OR query for name+DOB', async () => {
    mockYouthFindMany.mockResolvedValue([sampleYouth]);
    const result = await checkDuplicate({
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2010-05-15',
    });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data).toEqual([sampleYouth]);
    }
  });

  it('includes ssnLast4 in OR conditions when provided', async () => {
    await checkDuplicate({
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2010-05-15',
      ssnLast4: '6789',
    });
    expect(mockYouthFindMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.objectContaining({
          OR: expect.arrayContaining([
            expect.objectContaining({ ssn_last4: '6789' }),
          ]),
        }),
      }),
    );
  });

  it('does not include ssnLast4 OR condition when not provided', async () => {
    await checkDuplicate({
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2010-05-15',
    });
    const call = mockYouthFindMany.mock.calls[0][0];
    const orConditions = call.where.OR;
    const hasSsnCondition = orConditions.some(
      (c: Record<string, unknown>) => 'ssn_last4' in c,
    );
    expect(hasSsnCondition).toBe(false);
  });
});

describe('getYouthById', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockRequireAuth.mockResolvedValue({
      userId: 'user_test_123',
      role: 'admin' as const,
      siteId: undefined,
    });
  });

  it('returns youth record when found', async () => {
    mockYouthFindUnique.mockResolvedValue(sampleYouth);
    const result = await getYouthById('youth_abc123');
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data).toEqual(sampleYouth);
    }
  });

  it('returns error when youth not found', async () => {
    mockYouthFindUnique.mockResolvedValue(null);
    const result = await getYouthById('nonexistent');
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(result.error).toContain('not found');
    }
  });

  it('calls requireAuth before DB operation', async () => {
    mockYouthFindUnique.mockResolvedValue(sampleYouth);
    await getYouthById('youth_abc123');
    expect(mockRequireAuth).toHaveBeenCalledTimes(1);
  });
});

describe('logDuplicateOverride', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockRequireAuth.mockResolvedValue({
      userId: 'user_test_123',
      role: 'admin' as const,
      siteId: undefined,
    });
  });

  it('calls requireAuth before logging', async () => {
    await logDuplicateOverride('youth_new', ['youth_existing_1']);
    expect(mockRequireAuth).toHaveBeenCalledTimes(1);
  });

  it('returns success after logging', async () => {
    const result = await logDuplicateOverride('youth_new', [
      'youth_existing_1',
      'youth_existing_2',
    ]);
    expect(result.success).toBe(true);
  });

  it('returns error when unauthenticated', async () => {
    mockRequireAuth.mockRejectedValue(new Error('Unauthorized'));
    const result = await logDuplicateOverride('youth_new', []);
    expect(result.success).toBe(false);
  });
});
