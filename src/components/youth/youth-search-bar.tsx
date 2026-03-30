'use client';

import { useEffect, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import { Search as SearchIcon } from 'lucide-react';

import { Input } from '@/components/ui/input';

interface YouthSearchBarProps {
  defaultValue?: string;
}

/**
 * Debounced search input that updates ?q and ?page URL params.
 * Used on the youth list page to filter by name, DOB, or SSN last 4.
 */
export function YouthSearchBar({ defaultValue }: YouthSearchBarProps) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [value, setValue] = useState(defaultValue ?? '');

  useEffect(() => {
    const timer = setTimeout(() => {
      const params = new URLSearchParams(searchParams.toString());
      if (value) {
        params.set('q', value);
      } else {
        params.delete('q');
      }
      // Reset to page 1 on new search
      params.set('page', '1');
      router.push(pathname + '?' + params.toString());
    }, 300);

    return () => clearTimeout(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [value]);

  return (
    <div className="relative">
      <SearchIcon
        className="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground"
        aria-hidden="true"
      />
      <Input
        type="search"
        placeholder="Search by name, date of birth, or SSN last 4..."
        aria-label="Search youth by name, date of birth, or SSN last 4"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        className="h-11 pl-10"
      />
    </div>
  );
}
