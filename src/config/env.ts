import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),
  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY: z.string().min(1, 'Clerk publishable key is required'),
  CLERK_SECRET_KEY: z.string().min(1, 'Clerk secret key is required'),
  SSN_ENCRYPTION_KEY: z.string().length(64, 'Must be 64 hex chars (32 bytes)'),
  METABASE_URL: z.url().optional(),
  METABASE_SECRET_KEY: z.string().optional(),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
});

// Validate environment variables at startup — fails fast if required vars are missing.
export const env = envSchema.parse(process.env);
