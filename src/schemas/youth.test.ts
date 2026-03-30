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

  it('accepts valid SSN last 4 (4 digits)', () => {
    const result = createYouthSchema.parse({ ...validInput, ssnLast4: '1234' });
    expect(result.ssnLast4).toBe('1234');
  });

  it('fails when SSN last 4 is not 4 digits', () => {
    expect(() =>
      createYouthSchema.parse({ ...validInput, ssnLast4: '12345' }),
    ).toThrow();
  });

  it('accepts empty string for SSN last 4 (optional)', () => {
    const result = createYouthSchema.parse({ ...validInput, ssnLast4: '' });
    expect(result.ssnLast4).toBe('');
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
  it('fails when id is missing', () => {
    expect(() => updateYouthSchema.parse(validInput)).toThrow();
  });

  it('fails when required fields are missing', () => {
    expect(() => updateYouthSchema.parse({ id: 'abc123' })).toThrow();
  });

  it('succeeds with id and all required fields', () => {
    const result = updateYouthSchema.parse({ id: 'abc123', ...validInput });
    expect(result.id).toBe('abc123');
    expect(result.firstName).toBe('John');
  });

  it('validates required fields on update', () => {
    expect(() =>
      updateYouthSchema.parse({ id: 'abc123', ...validInput, firstName: '' }),
    ).toThrow();
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
