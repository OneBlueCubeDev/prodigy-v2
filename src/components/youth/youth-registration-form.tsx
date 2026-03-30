'use client';

import { useState, useEffect, useRef } from 'react';
import { useForm, useWatch } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { useRouter } from 'next/navigation';
import { toast } from 'sonner';
import { ChevronDownIcon } from 'lucide-react';

import type { ChangeEvent } from 'react';
import { createYouthSchema, type CreateYouthInput } from '@/schemas/youth';

/** Format a raw digit string as (XXX) XXX-XXXX */
function formatPhone(value: string): string {
  const digits = value.replace(/\D/g, '').slice(0, 10);
  if (digits.length <= 3) return digits;
  if (digits.length <= 6) return `(${digits.slice(0, 3)}) ${digits.slice(3)}`;
  return `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6)}`;
}

/** Compute age in years from a date string (YYYY-MM-DD) */
function computeAge(dob: string): number | null {
  if (!dob) return null;
  const birth = new Date(dob + 'T00:00:00');
  if (isNaN(birth.getTime())) return null;
  const today = new Date();
  let age = today.getFullYear() - birth.getFullYear();
  const monthDiff = today.getMonth() - birth.getMonth();
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  return age >= 0 ? age : null;
}

interface CountyOption {
  id: string;
  name: string;
}

/** Strip to digits only, capped at maxLen */
function digitsOnly(value: string, maxLen: number): string {
  return value.replace(/\D/g, '').slice(0, maxLen);
}
import {
  createYouth,
  checkDuplicate,
  logDuplicateOverride,
} from '@/actions/youth';
import type { Youth } from '@prisma/client';

import {
  Form,
  FormField,
  FormItem,
  FormLabel,
  FormControl,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import {
  Collapsible,
  CollapsibleTrigger,
  CollapsibleContent,
} from '@/components/ui/collapsible';
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from '@/components/ui/select';
import { DuplicateWarningBanner } from '@/components/youth/duplicate-warning-banner';

/**
 * Youth registration form with four collapsible sections, RHF+Zod validation,
 * 500ms debounced duplicate detection, and SSN input with formatting strip.
 */
export function YouthRegistrationForm({ counties }: { counties: CountyOption[] }) {
  const router = useRouter();
  const [duplicates, setDuplicates] = useState<Youth[]>([]);
  const latestRequestRef = useRef<number>(0);

  const form = useForm<CreateYouthInput>({
    resolver: zodResolver(createYouthSchema),
    defaultValues: {
      firstName: '',
      lastName: '',
      dateOfBirth: '',
      guardianName: '',
      genderId: '',
      raceId: '',
      ethnicityId: '',
      ssnLast4: '',
      address: '',
      city: '',
      county: '',
      state: '',
      zip: '',
      phone: '',
      guardianPhone: '',
      guardianRelation: '',
    },
  });

  const firstName = useWatch({ control: form.control, name: 'firstName' });
  const lastName = useWatch({ control: form.control, name: 'lastName' });
  const dateOfBirth = useWatch({ control: form.control, name: 'dateOfBirth' });
  const ssnLast4Value = useWatch({ control: form.control, name: 'ssnLast4' });

  // 500ms debounced duplicate detection — fires when first+last+DOB are all filled
  useEffect(() => {
    if (!firstName || !lastName || !dateOfBirth) {
      return;
    }

    const requestId = ++latestRequestRef.current;

    const timer = setTimeout(async () => {
      const ssnLast4 =
        ssnLast4Value && ssnLast4Value.length === 4 ? ssnLast4Value : undefined;

      const result = await checkDuplicate({
        firstName,
        lastName,
        dateOfBirth,
        ssnLast4,
      });

      // Only apply result if no newer request has been issued (race condition guard)
      if (requestId !== latestRequestRef.current) return;

      if (result.success && result.data.length > 0) {
        setDuplicates(result.data);
      } else {
        setDuplicates([]);
      }
    }, 500);

    return () => clearTimeout(timer);
  }, [firstName, lastName, dateOfBirth, ssnLast4Value]);

  const handleDismissDuplicates = async () => {
    if (duplicates.length > 0) {
      const firstId = duplicates[0].id;
      const allIds = duplicates.map((d) => d.id);
      await logDuplicateOverride(firstId, allIds);
    }
    setDuplicates([]);
  };

  const onSubmit = async (data: CreateYouthInput) => {
    const result = await createYouth(data);

    if (result.success) {
      toast.success('Youth registered successfully.');
      router.push('/youth/' + result.data.id);
    } else {
      toast.error('Registration failed. Please try again or contact support.');
    }
  };

  const { isSubmitting } = form.formState;

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 md:px-6">
      <h1 className="text-2xl font-semibold mb-6">Register Youth</h1>

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">

          {/* Section 1: Demographics */}
          <Collapsible defaultOpen={true}>
            <CollapsibleTrigger className="flex w-full items-center justify-between py-2 border-b border-border">
              <span className="text-lg font-semibold">Demographics</span>
              <ChevronDownIcon className="size-4 text-muted-foreground" />
            </CollapsibleTrigger>
            <CollapsibleContent className="pt-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="firstName"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>First Name *</FormLabel>
                      <FormControl>
                        <Input placeholder="First name" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="lastName"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Last Name *</FormLabel>
                      <FormControl>
                        <Input placeholder="Last name" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="dateOfBirth"
                  render={({ field }) => {
                    const age = computeAge(field.value);
                    return (
                      <FormItem>
                        <FormLabel>Date of Birth *</FormLabel>
                        <div className="flex items-center gap-3">
                          <FormControl>
                            <Input type="date" {...field} />
                          </FormControl>
                          {age !== null && (
                            <span className="text-sm text-muted-foreground whitespace-nowrap">
                              Age: {age}
                            </span>
                          )}
                        </div>
                        <FormMessage />
                      </FormItem>
                    );
                  }}
                />
                <FormField
                  control={form.control}
                  name="genderId"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Gender</FormLabel>
                      <FormControl>
                        <Select
                          value={field.value ?? ''}
                          onValueChange={field.onChange}
                        >
                          <SelectTrigger className="w-full">
                            <SelectValue placeholder="Select gender" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="male">Male</SelectItem>
                            <SelectItem value="female">Female</SelectItem>
                            <SelectItem value="nonbinary">Non-binary</SelectItem>
                            <SelectItem value="other">Other</SelectItem>
                            <SelectItem value="prefer_not_to_say">
                              Prefer not to say
                            </SelectItem>
                          </SelectContent>
                        </Select>
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="raceId"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Race</FormLabel>
                      <FormControl>
                        <Select
                          value={field.value ?? ''}
                          onValueChange={field.onChange}
                        >
                          <SelectTrigger className="w-full">
                            <SelectValue placeholder="Select race" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="american_indian">
                              American Indian or Alaska Native
                            </SelectItem>
                            <SelectItem value="asian">Asian</SelectItem>
                            <SelectItem value="black">
                              Black or African American
                            </SelectItem>
                            <SelectItem value="pacific_islander">
                              Native Hawaiian or Pacific Islander
                            </SelectItem>
                            <SelectItem value="white">White</SelectItem>
                            <SelectItem value="multiracial">
                              Two or More Races
                            </SelectItem>
                            <SelectItem value="other">Other</SelectItem>
                          </SelectContent>
                        </Select>
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="ethnicityId"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Ethnicity</FormLabel>
                      <FormControl>
                        <Select
                          value={field.value ?? ''}
                          onValueChange={field.onChange}
                        >
                          <SelectTrigger className="w-full">
                            <SelectValue placeholder="Select ethnicity" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="hispanic">
                              Hispanic or Latino
                            </SelectItem>
                            <SelectItem value="not_hispanic">
                              Not Hispanic or Latino
                            </SelectItem>
                          </SelectContent>
                        </Select>
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
            </CollapsibleContent>
          </Collapsible>

          {/* Duplicate Warning Banner — renders between Demographics and Guardian */}
          {duplicates.length > 0 && (
            <DuplicateWarningBanner
              duplicates={duplicates}
              onDismiss={handleDismissDuplicates}
            />
          )}

          {/* Section 2: Guardian */}
          <Collapsible defaultOpen={true}>
            <CollapsibleTrigger className="flex w-full items-center justify-between py-2 border-b border-border">
              <span className="text-lg font-semibold">Guardian</span>
              <ChevronDownIcon className="size-4 text-muted-foreground" />
            </CollapsibleTrigger>
            <CollapsibleContent className="pt-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="guardianName"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Guardian Name *</FormLabel>
                      <FormControl>
                        <Input placeholder="Guardian full name" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="guardianPhone"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Guardian Phone</FormLabel>
                      <FormControl>
                        <Input
                          type="tel"
                          inputMode="numeric"
                          placeholder="(555) 000-0000"
                          maxLength={14}
                          {...field}
                          onChange={(e: ChangeEvent<HTMLInputElement>) =>
                            field.onChange(formatPhone(e.target.value))
                          }
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="guardianRelation"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Relation to Youth</FormLabel>
                      <FormControl>
                        <Select
                          value={field.value ?? ''}
                          onValueChange={field.onChange}
                        >
                          <SelectTrigger className="w-full">
                            <SelectValue placeholder="Select relation" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="parent">Parent</SelectItem>
                            <SelectItem value="grandparent">
                              Grandparent
                            </SelectItem>
                            <SelectItem value="aunt_uncle">
                              Aunt/Uncle
                            </SelectItem>
                            <SelectItem value="sibling">Sibling</SelectItem>
                            <SelectItem value="other">Other</SelectItem>
                          </SelectContent>
                        </Select>
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
            </CollapsibleContent>
          </Collapsible>

          {/* Section 3: Address & Phone */}
          <Collapsible defaultOpen={true}>
            <CollapsibleTrigger className="flex w-full items-center justify-between py-2 border-b border-border">
              <span className="text-lg font-semibold">Address &amp; Phone</span>
              <ChevronDownIcon className="size-4 text-muted-foreground" />
            </CollapsibleTrigger>
            <CollapsibleContent className="pt-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="address"
                  render={({ field }) => (
                    <FormItem className="col-span-1 md:col-span-2">
                      <FormLabel>Address</FormLabel>
                      <FormControl>
                        <Input placeholder="Street address" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="city"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>City</FormLabel>
                      <FormControl>
                        <Input placeholder="City" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="county"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>County</FormLabel>
                      <FormControl>
                        <Select
                          value={field.value ?? ''}
                          onValueChange={field.onChange}
                        >
                          <SelectTrigger className="w-full">
                            <SelectValue placeholder="Select county" />
                          </SelectTrigger>
                          <SelectContent>
                            {counties.map((c) => (
                              <SelectItem key={c.id} value={c.id}>
                                {c.name}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="state"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>State</FormLabel>
                      <FormControl>
                        <Input placeholder="State" maxLength={2} {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="zip"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Zip Code</FormLabel>
                      <FormControl>
                        <Input
                          inputMode="numeric"
                          placeholder="00000"
                          maxLength={5}
                          {...field}
                          onChange={(e: ChangeEvent<HTMLInputElement>) =>
                            field.onChange(digitsOnly(e.target.value, 5))
                          }
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="phone"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Phone</FormLabel>
                      <FormControl>
                        <Input
                          type="tel"
                          inputMode="numeric"
                          placeholder="(555) 000-0000"
                          maxLength={14}
                          {...field}
                          onChange={(e: ChangeEvent<HTMLInputElement>) =>
                            field.onChange(formatPhone(e.target.value))
                          }
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
            </CollapsibleContent>
          </Collapsible>

          {/* Section 4: SSN */}
          <Collapsible defaultOpen={true}>
            <CollapsibleTrigger className="flex w-full items-center justify-between py-2 border-b border-border">
              <span className="text-lg font-semibold">SSN</span>
              <ChevronDownIcon className="size-4 text-muted-foreground" />
            </CollapsibleTrigger>
            <CollapsibleContent className="pt-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="ssnLast4"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>SSN (Last 4)</FormLabel>
                      <FormControl>
                        <Input
                          type="text"
                          inputMode="numeric"
                          maxLength={4}
                          placeholder="0000"
                          {...field}
                          onChange={(e: ChangeEvent<HTMLInputElement>) =>
                            field.onChange(digitsOnly(e.target.value, 4))
                          }
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
            </CollapsibleContent>
          </Collapsible>

          {/* Actions */}
          <div className="flex items-center justify-end gap-3 pt-2">
            <Button
              type="button"
              variant="ghost"
              disabled={isSubmitting}
              onClick={() => router.push('/youth')}
            >
              Cancel
            </Button>
            <Button type="submit" disabled={isSubmitting} size="lg">
              {isSubmitting ? 'Registering...' : 'Register Youth'}
            </Button>
          </div>
        </form>
      </Form>
    </div>
  );
}
