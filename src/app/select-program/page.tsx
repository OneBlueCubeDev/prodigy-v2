import Image from 'next/image';
import { getAuthContext } from '@/lib/auth';
import { db } from '@/lib/db';
import { ProgramCard } from '@/components/program-selector/program-card';

/**
 * Program selector page (AUTH-03).
 * Full-page layout (no sidebar) with UACDC logo centered.
 * First custom screen post-login — displays program cards for user's assigned programs.
 */
export default async function SelectProgramPage() {
  let programs: Array<{
    id: string;
    name: string;
    description: string | null;
  }> = [];
  let error: string | null = null;

  try {
    const { role, userId } = await getAuthContext();

    if (!role || role === 'admin' || role === 'central') {
      programs = await db.program.findMany({
        where: { active: true },
        select: { id: true, name: true, description: true },
        orderBy: { name: 'asc' },
      });
    } else if (role === 'site' && userId) {
      const programSites = await db.programSite.findMany({
        where: {
          site: {
            user_sites: {
              some: { user_id: userId },
            },
          },
          program: { active: true },
        },
        select: {
          program: {
            select: { id: true, name: true, description: true },
          },
        },
      });

      const seen = new Set<string>();
      programs = programSites
        .map((ps) => ps.program)
        .filter((p) => {
          if (seen.has(p.id)) return false;
          seen.add(p.id);
          return true;
        })
        .sort((a, b) => a.name.localeCompare(b.name));
    }
  } catch {
    error =
      'Unable to load your programs. Refresh the page or contact support if the problem continues.';
  }

  if (error) {
    return (
      <div className="flex min-h-screen items-center justify-center px-4">
        <p className="text-destructive">{error}</p>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen flex-col items-center px-4 py-16">
      {/* UACDC Logo */}
      <div className="mb-10">
        <Image
          src="/logos/uacdc.png"
          alt="University Area CDC"
          width={180}
          height={180}
          className="object-contain"
          priority
        />
      </div>

      {/* Page heading */}
      <div className="mb-8 text-center">
        <h1 className="text-2xl font-semibold">Select a Program</h1>
        <p className="mt-2 text-muted-foreground">
          Choose the program you&apos;re working in today.
        </p>
      </div>

      {programs.length === 0 ? (
        <div className="w-full max-w-md rounded-lg border bg-secondary/50 px-6 py-12 text-center">
          <h2 className="text-base font-semibold">No programs available.</h2>
          <p className="mt-2 text-sm text-muted-foreground">
            You haven&apos;t been assigned to any programs yet. Contact your
            administrator to get access.
          </p>
        </div>
      ) : (
        <div className="grid w-full max-w-5xl grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {programs.map((program) => (
            <ProgramCard key={program.id} program={program} />
          ))}
        </div>
      )}
    </div>
  );
}
