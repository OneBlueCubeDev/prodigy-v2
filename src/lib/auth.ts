import { auth } from '@clerk/nextjs/server';
import type { Role } from '@/types/globals';

/**
 * Check if the current user has the specified role.
 * Role is stored in Clerk publicMetadata and injected via custom session claims.
 * Requires Clerk Dashboard -> Sessions -> Customize session token ->
 * Add: { "metadata": "{{user.public_metadata}}" }
 */
export async function checkRole(role: Role): Promise<boolean> {
  const { sessionClaims } = await auth();
  return sessionClaims?.metadata.role === role;
}

/**
 * Get the full auth context for the current request.
 * Returns userId, role, and siteId from Clerk session claims.
 * Used in Server Components and Server Actions for role-based rendering.
 */
export async function getAuthContext(): Promise<{
  userId: string | null;
  role: Role | undefined;
  siteId: string | undefined;
}> {
  const { userId, sessionClaims } = await auth();
  return {
    userId,
    role: sessionClaims?.metadata.role,
    siteId: sessionClaims?.metadata.site_id,
  };
}

/**
 * Require authentication for a Server Action.
 * Returns the auth context if the user is authenticated.
 * Call at the top of every Server Action (CVE-2025-29927 mitigation — AUTH-04).
 * Throws an error with an ActionResult-compatible message if not authenticated.
 */
export async function requireAuth(): Promise<{
  userId: string;
  role: Role | undefined;
  siteId: string | undefined;
}> {
  const { userId, sessionClaims } = await auth();
  if (!userId) {
    throw new Error('Unauthorized');
  }
  return {
    userId,
    role: sessionClaims?.metadata.role,
    siteId: sessionClaims?.metadata.site_id,
  };
}
