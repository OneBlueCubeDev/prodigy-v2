import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

/**
 * Merge Tailwind CSS class names with conflict resolution.
 * Used by shadcn/ui components and throughout the application.
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
