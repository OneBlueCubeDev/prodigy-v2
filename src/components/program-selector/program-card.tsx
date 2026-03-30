'use client';

import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { selectProgram } from '@/actions/program';

interface ProgramCardProps {
  program: {
    id: string;
    name: string;
    description?: string | null;
  };
}

/**
 * Program selector card — displays a program with CTA to continue.
 * Minimum touch target height 44px (accessibility per UI-SPEC).
 */
export function ProgramCard({ program }: ProgramCardProps) {
  return (
    <Card className="flex flex-col hover:shadow-md transition-shadow duration-200">
      <CardHeader>
        <CardTitle className="text-base">{program.name}</CardTitle>
        {program.description && (
          <CardDescription className="line-clamp-2">
            {program.description}
          </CardDescription>
        )}
      </CardHeader>
      <CardContent className="flex-1" />
      <CardFooter>
        <form
          action={
            selectProgram.bind(null, program.id) as unknown as (
              formData: FormData,
            ) => void | Promise<void>
          }
          className="w-full"
        >
          <Button
            type="submit"
            className="w-full min-h-[44px]"
          >
            Continue to Dashboard
          </Button>
        </form>
      </CardFooter>
    </Card>
  );
}

export default ProgramCard;
