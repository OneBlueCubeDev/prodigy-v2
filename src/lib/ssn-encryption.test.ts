import { describe, it, expect, beforeAll } from 'vitest';
import { encryptSSN, decryptSSN, extractLast4 } from '@/lib/ssn-encryption';

// Set test encryption key (64 hex chars = 32 bytes)
beforeAll(() => {
  process.env.SSN_ENCRYPTION_KEY = 'a'.repeat(64);
});

describe('SSN Encryption (INFRA-03)', () => {
  it('encrypts SSN to hex string that is not plaintext', () => {
    const encrypted = encryptSSN('123-45-6789');
    expect(encrypted).not.toContain('123-45-6789');
    expect(encrypted).toMatch(/^[0-9a-f]+$/); // hex only
  });

  it('round-trips: decrypt(encrypt(ssn)) === ssn', () => {
    const ssn = '123-45-6789';
    const encrypted = encryptSSN(ssn);
    expect(decryptSSN(encrypted)).toBe(ssn);
  });

  it('produces different ciphertext for same input (random IV)', () => {
    const ssn = '123-45-6789';
    const a = encryptSSN(ssn);
    const b = encryptSSN(ssn);
    expect(a).not.toBe(b);
  });

  it('extractLast4 returns last 4 digits from full SSN', () => {
    expect(extractLast4('123-45-6789')).toBe('6789');
  });

  it('extractLast4 returns input when already 4 digits', () => {
    expect(extractLast4('6789')).toBe('6789');
  });

  it('extractLast4 strips non-digit characters', () => {
    expect(extractLast4('123 45 6789')).toBe('6789');
  });
});
