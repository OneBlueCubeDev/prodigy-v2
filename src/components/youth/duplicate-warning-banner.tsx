'use client';

import { AlertTriangleIcon } from 'lucide-react';
import {
  Alert,
  AlertTitle,
  AlertDescription,
  AlertAction,
} from '@/components/ui/alert';
import { Button } from '@/components/ui/button';

interface DuplicateWarningBannerProps {
  duplicates: Array<{
    id: string;
    first_name: string;
    last_name: string;
    date_of_birth: Date | string;
  }>;
  onDismiss: () => void;
}

const dateFormatter = new Intl.DateTimeFormat('en-US', {
  timeZone: 'UTC',
  month: '2-digit',
  day: '2-digit',
  year: 'numeric',
});

/**
 * Yellow inline banner shown when duplicate youth records are detected
 * during registration. Staff can dismiss with "Not a Match" to proceed.
 */
export function DuplicateWarningBanner({
  duplicates,
  onDismiss,
}: DuplicateWarningBannerProps) {
  return (
    <Alert
      role="alert"
      className="bg-yellow-50 border-yellow-400 text-yellow-900 dark:bg-yellow-950 dark:border-yellow-600 dark:text-yellow-100"
    >
      <AlertTriangleIcon className="text-yellow-600 dark:text-yellow-400" />
      <AlertTitle className="text-yellow-900 dark:text-yellow-100">
        Possible duplicate found
      </AlertTitle>
      <AlertDescription className="text-yellow-800 dark:text-yellow-200">
        {duplicates.map((duplicate) => {
          const dob =
            duplicate.date_of_birth instanceof Date
              ? duplicate.date_of_birth
              : new Date(duplicate.date_of_birth);
          const formattedDob = dateFormatter.format(dob);
          return (
            <p key={duplicate.id}>
              {duplicate.first_name} {duplicate.last_name}, born {formattedDob}{' '}
              &mdash; already in the system. Confirm this is a different person
              before registering.
            </p>
          );
        })}
      </AlertDescription>
      <AlertAction>
        <Button
          variant="ghost"
          size="sm"
          aria-label="Dismiss duplicate warning and continue registration"
          onClick={onDismiss}
          className="text-yellow-900 hover:bg-yellow-100 dark:text-yellow-100 dark:hover:bg-yellow-900"
        >
          Not a Match
        </Button>
      </AlertAction>
    </Alert>
  );
}
