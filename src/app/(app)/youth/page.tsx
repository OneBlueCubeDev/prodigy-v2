import Link from 'next/link';
import { PlusIcon } from 'lucide-react';

import { requireAuth } from '@/lib/auth';
import db from '@/lib/db';
import { buttonVariants } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import { YouthListTable } from '@/components/youth/youth-list-table';
import { YouthSearchBar } from '@/components/youth/youth-search-bar';

const PAGE_SIZE = 20;

/**
 * Youth list page — server-rendered with search and pagination.
 * URL params: ?q (search query) and ?page (current page, 1-indexed).
 * Default view: all youth sorted by created_at descending (D-08).
 */
export default async function YouthPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; page?: string }>;
}) {
  await requireAuth();

  const { q, page } = await searchParams;
  const currentPage = Math.max(1, parseInt(page ?? '1', 10));
  const skip = (currentPage - 1) * PAGE_SIZE;

  // Build Prisma where clause — search across name fields and SSN last 4
  const where = q
    ? {
        OR: [
          { first_name: { contains: q, mode: 'insensitive' as const } },
          { last_name: { contains: q, mode: 'insensitive' as const } },
          { ssn_last4: { equals: q } },
        ],
      }
    : {};

  const [youth, total] = await Promise.all([
    db.youth.findMany({
      where,
      skip,
      take: PAGE_SIZE,
      orderBy: { created_at: 'desc' },
      select: {
        id: true,
        first_name: true,
        last_name: true,
        date_of_birth: true,
        ssn_last4: true,
        created_at: true,
      },
    }),
    db.youth.count({ where }),
  ]);

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 md:px-6">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-semibold">Youth Records</h1>
        <Link href="/youth/new" className={cn(buttonVariants(), 'gap-1.5')}>
          <PlusIcon className="size-4" />
          Register Youth
        </Link>
      </div>

      <div className="mb-6">
        <YouthSearchBar defaultValue={q} />
      </div>

      <YouthListTable
        youth={youth}
        total={total}
        page={currentPage}
        pageSize={PAGE_SIZE}
        query={q}
      />
    </div>
  );
}
