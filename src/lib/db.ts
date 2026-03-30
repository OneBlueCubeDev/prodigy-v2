import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { logAuditEvent } from '@/lib/audit';

/**
 * Prisma client singleton stored on globalThis to prevent connection pool
 * exhaustion during Next.js hot reload in development.
 * Always import `db` from this file — never create new PrismaClient() instances.
 */
const globalForPrisma = global as unknown as { prisma: PrismaClient };

function createPrismaClient(): PrismaClient {
  const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL! });
  return new PrismaClient({ adapter });
}

export const basePrisma: PrismaClient =
  globalForPrisma.prisma ?? createPrismaClient();

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = basePrisma;
}

/**
 * Create a site-scoped Prisma client that automatically injects `site_id`
 * on all read queries. Use for Site role users to enforce data isolation.
 * Returns basePrisma if siteId is null (for Admin/Central roles).
 */
export function createScopedDb(siteId: string | null) {
  if (!siteId) return basePrisma;
  return basePrisma.$extends({
    query: {
      $allModels: {
        async findMany({
          args,
          query,
        }: {
          args: Record<string, unknown>;
          query: (args: Record<string, unknown>) => Promise<unknown>;
        }) {
          args.where = { ...(args.where as Record<string, unknown>), site_id: siteId };
          return query(args);
        },
        async findFirst({
          args,
          query,
        }: {
          args: Record<string, unknown>;
          query: (args: Record<string, unknown>) => Promise<unknown>;
        }) {
          args.where = { ...(args.where as Record<string, unknown>), site_id: siteId };
          return query(args);
        },
      },
    },
  });
}

/**
 * Default database client with audit extension.
 * All write operations (create, update, delete, upsert, *Many) are automatically
 * logged to the audit_log table via logAuditEvent (fire-and-forget).
 * Use this for all database writes throughout the application.
 */
export const db = basePrisma.$extends({
  query: {
    $allModels: {
      async $allOperations({
        model,
        operation,
        args,
        query,
      }: {
        model: string;
        operation: string;
        args: unknown;
        query: (args: unknown) => Promise<unknown>;
      }) {
        const writeOps = [
          'create',
          'update',
          'delete',
          'upsert',
          'createMany',
          'updateMany',
          'deleteMany',
        ];
        if (!writeOps.includes(operation)) return query(args);
        const result = await query(args);
        // logAuditEvent is fire-and-forget — do not await to avoid latency
        logAuditEvent(model, operation, args, result).catch(console.error);
        return result;
      },
    },
  },
});

export default db;
