import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server';

/**
 * Public routes that do not require authentication.
 * All other routes are protected by Clerk authentication.
 * Note: auth() must still be called independently in every Server Action
 * per CVE-2025-29927 (AUTH-04) — middleware is not the security boundary.
 */
const isPublicRoute = createRouteMatcher([
  '/sign-in(.*)',
  '/sign-up(.*)',
  '/api/health',
]);

/**
 * Clerk proxy middleware (replaces middleware.ts in Next.js 16).
 * Validates the Clerk session and protects non-public routes.
 */
export default clerkMiddleware(async (auth, req) => {
  if (!isPublicRoute(req)) {
    await auth.protect();
  }
});

export const config = {
  matcher: [
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    '/(api|trpc)(.*)',
  ],
};
