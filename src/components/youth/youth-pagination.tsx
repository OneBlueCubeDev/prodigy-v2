'use client';

import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import { Button } from '@/components/ui/button';

interface YouthPaginationProps {
  currentPage: number;
  totalPages: number;
}

/**
 * Numbered page pagination with Previous/Next buttons.
 * Updates ?page URL param on click. Shows at most 5 numbered pages
 * around the current page with ellipsis for large page counts.
 */
export function YouthPagination({
  currentPage,
  totalPages,
}: YouthPaginationProps) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  if (totalPages <= 1) {
    return null;
  }

  function navigateTo(page: number) {
    const params = new URLSearchParams(searchParams.toString());
    params.set('page', String(page));
    router.push(pathname + '?' + params.toString());
  }

  /**
   * Compute the visible page numbers (up to 5 around currentPage).
   * Returns an array of numbers and null values (null = ellipsis).
   */
  function getPageNumbers(): (number | null)[] {
    const delta = 2;
    const range: number[] = [];
    const rangeWithEllipsis: (number | null)[] = [];

    const start = Math.max(2, currentPage - delta);
    const end = Math.min(totalPages - 1, currentPage + delta);

    // Always include first page
    range.push(1);

    if (start > 2) {
      rangeWithEllipsis.push(1, null);
    } else {
      rangeWithEllipsis.push(1);
    }

    for (let i = start; i <= end; i++) {
      if (i !== 1 && i !== totalPages) {
        rangeWithEllipsis.push(i);
      }
    }

    if (end < totalPages - 1) {
      rangeWithEllipsis.push(null, totalPages);
    } else if (totalPages > 1) {
      rangeWithEllipsis.push(totalPages);
    }

    // Deduplicate (handles totalPages === 2 edge case)
    const seen = new Set<number | null>();
    return rangeWithEllipsis.filter((item) => {
      if (item === null) return true;
      if (seen.has(item)) return false;
      seen.add(item);
      return true;
    });
  }

  const pages = getPageNumbers();

  return (
    <nav
      aria-label="Pagination"
      className="mt-4 flex items-center justify-center gap-1"
    >
      <Button
        variant="ghost"
        size="sm"
        onClick={() => navigateTo(currentPage - 1)}
        disabled={currentPage <= 1}
        aria-label="Go to previous page"
      >
        Previous
      </Button>

      {pages.map((page, index) => {
        if (page === null) {
          return (
            <span
              key={`ellipsis-${index}`}
              className="px-2 py-1 text-sm text-muted-foreground"
              aria-hidden="true"
            >
              &hellip;
            </span>
          );
        }

        const isActive = page === currentPage;
        return (
          <Button
            key={page}
            variant="ghost"
            size="sm"
            onClick={() => navigateTo(page)}
            aria-current={isActive ? 'page' : undefined}
            className={
              isActive
                ? 'bg-primary text-primary-foreground hover:bg-primary/80 hover:text-primary-foreground'
                : undefined
            }
          >
            {page}
          </Button>
        );
      })}

      <Button
        variant="ghost"
        size="sm"
        onClick={() => navigateTo(currentPage + 1)}
        disabled={currentPage >= totalPages}
        aria-label="Go to next page"
      >
        Next
      </Button>
    </nav>
  );
}
