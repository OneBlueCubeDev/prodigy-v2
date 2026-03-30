"use client";

import Link from 'next/link';

import { buttonVariants } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { YouthPagination } from '@/components/youth/youth-pagination';

interface YouthRow {
  id: string;
  first_name: string;
  last_name: string;
  date_of_birth: Date;
  ssn_last4: string | null;
  created_at: Date;
}

interface YouthListTableProps {
  youth: YouthRow[];
  total: number;
  page: number;
  pageSize: number;
  query?: string;
}

/**
 * Format a UTC Date to MM/DD/YYYY without timezone offset shifting.
 * Uses UTC methods so 1990-05-15T00:00:00Z renders as 05/15/1990.
 */
function formatDate(date: Date): string {
  return new Intl.DateTimeFormat('en-US', {
    timeZone: 'UTC',
    month: '2-digit',
    day: '2-digit',
    year: 'numeric',
  }).format(date);
}

/**
 * Mask SSN — display ***-**-{last4} or N/A when unavailable.
 */
function maskSSN(last4: string | null): string {
  if (!last4) return 'N/A';
  return `***-**-${last4}`;
}

/**
 * Youth list table with empty states and pagination.
 * Receives server-fetched data as props — no client-side data fetching.
 */
export function YouthListTable({
  youth,
  total,
  page,
  pageSize,
  query,
}: YouthListTableProps) {
  const totalPages = Math.ceil(total / pageSize);
  const hasResults = youth.length > 0;
  const isSearching = Boolean(query);

  if (!hasResults) {
    return (
      <div className="rounded-lg border border-dashed py-16 text-center">
        {isSearching ? (
          <>
            <p className="text-lg font-semibold">
              No results for &ldquo;{query}&rdquo;
            </p>
            <p className="mt-1 text-sm text-muted-foreground">
              Try a different name, date of birth, or SSN last 4.
            </p>
          </>
        ) : (
          <>
            <p className="text-lg font-semibold">No youth registered yet</p>
            <p className="mt-1 text-sm text-muted-foreground">
              Get started by registering the first youth in the system.
            </p>
            <Link
              href="/youth/new"
              className={cn(buttonVariants(), 'mt-4')}
            >
              Register Youth
            </Link>
          </>
        )}
      </div>
    );
  }

  return (
    <div>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Name</TableHead>
            <TableHead>Date of Birth</TableHead>
            <TableHead>SSN</TableHead>
            <TableHead>Registered</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {youth.map((y) => (
            <TableRow key={y.id} className="hover:bg-muted/50">
              <TableCell>
                <Link
                  href={`/youth/${y.id}`}
                  className="font-medium hover:underline"
                >
                  {y.last_name}, {y.first_name}
                </Link>
              </TableCell>
              <TableCell>{formatDate(y.date_of_birth)}</TableCell>
              <TableCell className="font-mono text-muted-foreground">
                {maskSSN(y.ssn_last4)}
              </TableCell>
              <TableCell>{formatDate(y.created_at)}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      <YouthPagination currentPage={page} totalPages={totalPages} />
    </div>
  );
}
