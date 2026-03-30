import { NextResponse } from 'next/server';
import db from '@/lib/db';

/**
 * Health check endpoint.
 * Verifies database connectivity by running SELECT 1.
 * Returns { status: 'ok' } on success, { status: 'error', message: ... } on failure.
 * This route is public — listed in proxy.ts isPublicRoute matcher.
 */
export async function GET() {
  try {
    await db.$queryRaw`SELECT 1`;
    return NextResponse.json({ status: 'ok' }, { status: 200 });
  } catch {
    return NextResponse.json(
      { status: 'error', message: 'Database unavailable' },
      { status: 503 },
    );
  }
}
