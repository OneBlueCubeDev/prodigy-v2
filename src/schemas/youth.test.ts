import { describe, it, expect } from 'vitest';

// Import schemas (TDD RED: these don't exist yet)
const {
  createYouthSchema,
  updateYouthSchema,
  searchYouthSchema,
  checkDuplicateSchema,
} = await import('@/schemas/youth');

const validInput = {
  firstName: 'John',
  lastName: 'Doe',
  dateOfBirth: '2010-05-15',
  guardianName: 'Jane Doe',
};

describe('createYouthSchema', () => {
  it('parses valid required fields', () => {
    const result = createYouthSchema.parse(validInput);
    expect(result.firstName).toBe('John');
    expect(result.lastName).toBe('Doe');
    expect(result.dateOfBirth).toBe('2010-05-15');
    expect(result.guardianName).toBe('Jane Doe');
  });

  it('fails when required fields are missing', () => {
    expect(() => createYouthSchema.parse({})).toThrow();
  });

  it('fails when firstName is empty', () => {
    expect(() =>
      createYouthSchema.parse({ ...validInput, firstName: '' }),
    ).toThrow();
  });

  it('fails when lastName is empty', () => {
    expect(() =>
      createYouthSchema.parse({ ...validInput, lastName: '' }),
    ).toThrow();
  });

  it('fails when dateOfBirth is empty', () => {
    expect(() =>
      createYouthSchema.parse({ ...validInput, dateOfBirth: '' }),
    ).toThrow();
  });

  it('fails when guardianName is empty', () => {
    expect(() =>
      createYouthSchema.parse({ ...validInput, guardianName: '' }),
    ).toThrow();
  });

  it('accepts valid SSN (9 digits)', () => {
    const result = createYouthSchema.parse({ ...validInput, ssn: '123456789' });
    expect(result.ssn).toBe('123456789');
  });

  it('fails when SSN is not 9 digits', () => {
    expect(() =>
      createYouthSchema.parse({ ...validInput, ssn: '12345' }),
    ).toThrow();
  });

  it('accepts empty string for SSN (optional)', () => {
    const result = createYouthSchema.parse({ ...validInput, ssn: '' });
    expect(result.ssn).toBe('');
  });

  it('accepts optional address fields', () => {
    const result = createYouthSchema.parse({
      ...validInput,
      address: '123 Main St',
      city: 'Dallas',
      state: 'TX',
      zip: '75201',
    });
    expect(result.address).toBe('123 Main St');
    expect(result.city).toBe('Dallas');
  });

  it('accepts optional guardian fields', () => {
    const result = createYouthSchema.parse({
      ...validInput,
      guardianPhone: '214-555-1234',
      guardianRelation: 'Mother',
    });
    expect(result.guardianPhone).toBe('214-555-1234');
    expect(result.guardianRelation).toBe('Mother');
  });
});

describe('updateYouthSchema', () => {
  it('succeeds with only id (all other fields optional)', () => {
    const result = updateYouthSchema.parse({ id: 'abc123' });
    expect(result.id).toBe('abc123');
  });

  it('fails when id is missing', () => {
    expect(() => updateYouthSchema.parse({ firstName: 'John' })).toThrow();
  });

  it('accepts partial updates', () => {
    const result = updateYouthSchema.parse({
      id: 'abc123',
      firstName: 'Updated',
    });
    expect(result.firstName).toBe('Updated');
    expect(result.lastName).toBeUndefined();
  });

  it('accepts full update', () => {
    const result = updateYouthSchema.parse({ id: 'abc123', ...validInput });
    expect(result.id).toBe('abc123');
    expect(result.firstName).toBe('John');
  });
});

describe('checkDuplicateSchema', () => {
  it('succeeds with required fields', () => {
    const result = checkDuplicateSchema.parse({
      firstName: 'J',
      lastName: 'D',
      dateOfBirth: '2010-01-01',
    });
    expect(result.firstName).toBe('J');
    expect(result.lastName).toBe('D');
    expect(result.dateOfBirth).toBe('2010-01-01');
  });

  it('accepts optional ssnLast4 (exactly 4 chars)', () => {
    const result = checkDuplicateSchema.parse({
      firstName: 'J',
      lastName: 'D',
      dateOfBirth: '2010-01-01',
      ssnLast4: '6789',
    });
    expect(result.ssnLast4).toBe('6789');
  });

  it('fails when ssnLast4 is not 4 characters', () => {
    expect(() =>
      checkDuplicateSchema.parse({
        firstName: 'J',
        lastName: 'D',
        dateOfBirth: '2010-01-01',
        ssnLast4: '123',
      }),
    ).toThrow();
  });
});

describe('searchYouthSchema', () => {
  it('succeeds with empty input, defaults page to 1', () => {
    const result = searchYouthSchema.parse({});
    expect(result.page).toBe(1);
  });

  it('accepts query string', () => {
    const result = searchYouthSchema.parse({ q: 'John' });
    expect(result.q).toBe('John');
    expect(result.page).toBe(1);
  });

  it('accepts numeric page', () => {
    const result = searchYouthSchema.parse({ page: 3 });
    expect(result.page).toBe(3);
  });

  it('coerces string page to number', () => {
    const result = searchYouthSchema.parse({ page: '2' });
    expect(result.page).toBe(2);
  });

  it('fails when page is less than 1', () => {
    expect(() => searchYouthSchema.parse({ page: 0 })).toThrow();
  });
});
