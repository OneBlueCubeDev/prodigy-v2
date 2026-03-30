import { Skeleton } from '@/components/ui/skeleton';

/**
 * Loading skeleton for the youth list page.
 * Mirrors the page header, search bar, and table structure.
 */
export default function YouthLoading() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-8 md:px-6">
      {/* Page header skeleton */}
      <div className="flex items-center justify-between mb-6">
        <Skeleton className="h-8 w-40" />
        <Skeleton className="h-9 w-36" />
      </div>

      {/* Search bar skeleton */}
      <Skeleton className="mb-6 h-11 w-full" />

      {/* Table header skeleton */}
      <div className="rounded-lg border">
        <div className="border-b px-2 py-2.5">
          <div className="flex gap-4">
            <Skeleton className="h-5 w-40" />
            <Skeleton className="h-5 w-28" />
            <Skeleton className="h-5 w-24" />
            <Skeleton className="h-5 w-24" />
          </div>
        </div>

        {/* Table rows skeleton — 5 rows */}
        {Array.from({ length: 5 }).map((_, i) => (
          <div key={i} className="flex gap-4 border-b px-2 py-3 last:border-0">
            <Skeleton className="h-5 w-44" />
            <Skeleton className="h-5 w-28" />
            <Skeleton className="h-5 w-28" />
            <Skeleton className="h-5 w-24" />
          </div>
        ))}
      </div>
    </div>
  );
}
