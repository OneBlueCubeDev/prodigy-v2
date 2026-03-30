import { Prisma } from '@prisma/client';
import logger from '@/lib/logger';

/** Type-safe extraction of `where` clause from Prisma args. */
function extractWhere(args: unknown): Record<string, unknown> | null {
  if (args && typeof args === 'object' && 'where' in args) {
    return (args as Record<string, unknown>).where as Record<string, unknown>;
  }
  return null;
}

/** Type-safe extraction of `id` field from Prisma result. */
function extractRecordId(result: unknown): string | null {
  if (result && typeof result === 'object' && 'id' in result) {
    return String((result as { id: unknown }).id);
  }
  return null;
}

/**
 * Log a database mutation to the audit_log table.
 * Uses basePrisma (lazy import) to avoid recursive extension calls.
 * Fire-and-forget — do not await from the audit extension.
 * Never log sensitive data (SSN, passwords, tokens).
 */
export async function logAuditEvent(
  model: string,
  operation: string,
  args: unknown,
  result: unknown,
  userId?: string,
): Promise<void> {
  // Import basePrisma lazily to avoid circular dependency
  const { basePrisma } = await import('@/lib/db');
  try {
    await basePrisma.auditLog.create({
      data: {
        model,
        record_id: extractRecordId(result) ?? 'unknown',
        operation,
        before: operation === 'update'
          ? (extractWhere(args) as Prisma.InputJsonValue)
          : Prisma.JsonNull,
        after: result
          ? (JSON.parse(JSON.stringify(result)) as Prisma.InputJsonValue)
          : Prisma.JsonNull,
        user_id: userId ?? 'system',
      },
    });
  } catch (error) {
    logger.error({ error, model, operation }, 'Failed to write audit log');
  }
}
