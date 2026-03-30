'use client';

import Image from 'next/image';
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

/** Map program names (lowercase) to logo paths in /public/logos/ */
const PROGRAM_LOGOS: Record<string, string> = {
  prodigy: '/logos/prodigy.png',
};

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
  const logoSrc = PROGRAM_LOGOS[program.name.toLowerCase()];

  return (
    <Card className="flex flex-col hover:shadow-md transition-shadow duration-200">
      <CardHeader className="items-center text-center">
        {logoSrc && (
          <div className="mb-2">
            <Image
              src={logoSrc}
              alt={`${program.name} logo`}
              width={160}
              height={80}
              className="object-contain"
            />
          </div>
        )}
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
