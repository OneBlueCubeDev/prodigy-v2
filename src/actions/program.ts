'use server';

import { auth } from '@clerk/nextjs/server';
import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import type { ActionResult } from '@/types/action-result';

/**
 * Server Action to select a program and set the selected_program cookie.
 * AUTH-04: Calls auth() independently to validate session.
 * Redirects to /dashboard after setting the cookie.
 */
export async function selectProgram(
  programId: string,
): Promise<ActionResult<void>> {
  const { userId } = await auth(); // AUTH-04 compliance
  if (!userId) {
    return { success: false, error: 'Unauthorized' };
  }

  const cookieStore = await cookies();
  cookieStore.set('selected_program', programId, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 60 * 60 * 24 * 30, // 30 days
  });

  redirect('/dashboard');
}
