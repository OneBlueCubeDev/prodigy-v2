import { getAuthContext } from '@/lib/auth';
import { Badge } from '@/components/ui/badge';
import { UserButton } from '@clerk/nextjs';
import type { Role } from '@/types/globals';

/**
 * Returns the badge variant based on user role per UI-SPEC:
 * - admin: default (primary blue)
 * - central: secondary
 * - site: outline
 */
function getRoleBadgeVariant(
  role: Role | undefined,
): 'default' | 'secondary' | 'outline' {
  switch (role) {
    case 'admin':
      return 'default';
    case 'central':
      return 'secondary';
    case 'site':
      return 'outline';
    default:
      return 'secondary';
  }
}

/**
 * Returns a display label for the role badge.
 */
function getRoleLabel(role: Role | undefined): string {
  switch (role) {
    case 'admin':
      return 'Admin';
    case 'central':
      return 'Central';
    case 'site':
      return 'Site';
    default:
      return 'User';
  }
}

/**
 * App header — sticky 56px top bar with role badge and user menu.
 * Server component. Calls getAuthContext for role display.
 */
export async function AppHeader() {
  const { role } = await getAuthContext();

  return (
    <header className="sticky top-0 z-40 flex h-14 items-center justify-between border-b bg-background px-4 md:px-6">
      {/* Left: spacer for mobile hamburger + page title slot */}
      <div className="flex items-center gap-3">
        {/* Mobile hamburger is rendered by AppSidebar — leave space here on mobile */}
        <span className="pl-10 md:pl-0 text-sm font-medium text-muted-foreground">
          Prodigy
        </span>
      </div>

      {/* Right: role badge + user avatar */}
      <div className="flex items-center gap-3">
        <Badge variant={getRoleBadgeVariant(role)}>{getRoleLabel(role)}</Badge>
        <UserButton />
      </div>
    </header>
  );
}

export default AppHeader;
