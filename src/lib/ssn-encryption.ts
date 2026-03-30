import { createCipheriv, createDecipheriv, randomBytes } from 'crypto';

const ALGORITHM = 'aes-256-gcm';

/**
 * Get the encryption key from env. Lazily evaluated so tests can set the var.
 * Key must be 64 hex chars (32 bytes).
 */
function getKey(): Buffer {
  const keyHex = process.env.SSN_ENCRYPTION_KEY;
  if (!keyHex || keyHex.length !== 64) {
    throw new Error('SSN_ENCRYPTION_KEY must be 64 hex chars (32 bytes)');
  }
  return Buffer.from(keyHex, 'hex');
}

/**
 * Encrypt a SSN using AES-256-GCM.
 * Format: iv(12 bytes) + tag(16 bytes) + ciphertext — stored as hex string.
 * Never log the return value or the input.
 */
export function encryptSSN(ssn: string): string {
  const key = getKey();
  const iv = randomBytes(12); // 96 bits — recommended for GCM
  const cipher = createCipheriv(ALGORITHM, key, iv);
  const encrypted = Buffer.concat([cipher.update(ssn, 'utf8'), cipher.final()]);
  const tag = cipher.getAuthTag();
  // Format: iv(12 bytes) + tag(16 bytes) + ciphertext
  return Buffer.concat([iv, tag, encrypted]).toString('hex');
}

/**
 * Decrypt a stored SSN hex string.
 * Extracts iv[0:12], tag[12:28], ciphertext[28:] and reverses AES-256-GCM.
 */
export function decryptSSN(stored: string): string {
  const key = getKey();
  const buf = Buffer.from(stored, 'hex');
  const iv = buf.subarray(0, 12);
  const tag = buf.subarray(12, 28);
  const ciphertext = buf.subarray(28);
  const decipher = createDecipheriv(ALGORITHM, key, iv);
  decipher.setAuthTag(tag);
  return decipher.update(ciphertext) + decipher.final('utf8');
}

/**
 * Extract the last 4 digits from a SSN string.
 * Strips all non-digit characters before slicing.
 */
export function extractLast4(ssn: string): string {
  return ssn.replace(/\D/g, '').slice(-4);
}
