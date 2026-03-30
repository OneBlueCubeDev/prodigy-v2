import { AppSidebar } from '@/components/shared/app-sidebar';
import { AppHeader } from '@/components/shared/app-header';

/**
 * App shell layout — wraps all authenticated routes.
 * Structure: sidebar (240px fixed on desktop) + main content (header + page).
 */
export default function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen">
      <AppSidebar />
      <div className="flex flex-1 flex-col">
        <AppHeader />
        <main className="flex-1 p-4">{children}</main>
      </div>
    </div>
  );
}
