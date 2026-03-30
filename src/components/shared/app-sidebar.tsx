'use client';

import Image from 'next/image';
import { HomeIcon } from 'lucide-react';
import Link from 'next/link';
import { UserButton } from '@clerk/nextjs';
import { Separator } from '@/components/ui/separator';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import { Button } from '@/components/ui/button';
import { MenuIcon } from 'lucide-react';
import { cn } from '@/lib/utils';

interface AppSidebarProps {
  currentProgram?: string;
}

function SidebarContent({ currentProgram }: AppSidebarProps) {
  return (
    <div className="flex h-full flex-col">
      {/* Logo / App name */}
      <div className="flex h-14 items-center px-4">
        <Image
          src="/logos/prodigy.png"
          alt="Prodigy"
          width={120}
          height={40}
          className="object-contain"
        />
      </div>

      <Separator />

      {/* Nav items */}
      <nav className="flex-1 space-y-1 px-3 py-4">
        <Link
          href="/"
          className={cn(
            'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium',
            'text-foreground hover:bg-secondary transition-colors',
          )}
        >
          <HomeIcon className="h-4 w-4" />
          Dashboard
        </Link>
      </nav>

      {/* Program indicator */}
      {currentProgram && (
        <>
          <Separator />
          <div className="px-6 py-3">
            <p className="text-xs font-medium text-muted-foreground uppercase tracking-wider mb-1">
              Current Program
            </p>
            <p className="text-sm font-medium truncate">{currentProgram}</p>
          </div>
        </>
      )}

      <Separator />

      {/* User info + sign-out */}
      <div className="flex items-center gap-3 px-6 py-4">
        <UserButton />
        <span className="text-sm text-muted-foreground">Account</span>
      </div>
    </div>
  );
}

/**
 * App sidebar — fixed 240px on desktop, Sheet overlay on mobile.
 * Contains app name, nav items, program indicator, and user sign-out.
 */
export function AppSidebar({ currentProgram }: AppSidebarProps) {
  return (
    <>
      {/* Desktop sidebar — hidden on mobile */}
      <aside className="hidden md:flex w-60 flex-col border-r bg-secondary/50 min-h-screen">
        <SidebarContent currentProgram={currentProgram} />
      </aside>

      {/* Mobile sidebar — Sheet overlay */}
      <Sheet>
        <SheetTrigger
          render={
            <Button
              variant="ghost"
              size="icon"
              className="md:hidden fixed top-3 left-3 z-50 h-9 w-9"
              aria-label="Open navigation menu"
            />
          }
        >
          <MenuIcon className="h-5 w-5" />
        </SheetTrigger>
        <SheetContent side="left" className="w-60 p-0">
          <SidebarContent currentProgram={currentProgram} />
        </SheetContent>
      </Sheet>
    </>
  );
}

export default AppSidebar;
