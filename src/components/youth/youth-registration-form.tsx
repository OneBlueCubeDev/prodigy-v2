'use client';

import { useState, useEffect, useRef } from 'react';
import { useForm, useWatch } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { useRouter } from 'next/navigation';
import { toast } from 'sonner';
import { ChevronDownIcon } from 'lucide-react';

import { createYouthSchema, type CreateYouthInput } from '@/schemas/youth';
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
export function YouthRegistrationForm() {
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
      ssn: '',
      address: '',
      city: '',
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
  const ssnValue = useWatch({ control: form.control, name: 'ssn' });

  // 500ms debounced duplicate detection — fires when first+last+DOB are all filled
  useEffect(() => {
    if (!firstName || !lastName || !dateOfBirth) {
      return;
    }

    const requestId = ++latestRequestRef.current;

    const timer = setTimeout(async () => {
      // Extract SSN last 4 digits if available
      const ssnDigits = (ssnValue ?? '').replace(/\D/g, '');
      const ssnLast4 =
        ssnDigits.length >= 4 ? ssnDigits.slice(-4) : undefined;

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
  }, [firstName, lastName, dateOfBirth, ssnValue]);

  const handleDismissDuplicates = async () => {
    if (duplicates.length > 0) {
      const firstId = duplicates[0].id;
      const allIds = duplicates.map((d) => d.id);
      await logDuplicateOverride(firstId, allIds);
    }
    setDuplicates([]);
  };

  const onSubmit = async (data: CreateYouthInput) => {
    // Strip non-digit characters from SSN before submit
    const cleanedData: CreateYouthInput = {
      ...data,
      ssn: data.ssn ? data.ssn.replace(/\D/g, '') : '',
    };

    const result = await createYouth(cleanedData);

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
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Date of Birth *</FormLabel>
                      <FormControl>
                        <Input type="date" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
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
                          placeholder="(555) 000-0000"
                          {...field}
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
                          placeholder="00000"
                          maxLength={10}
                          {...field}
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
                          placeholder="(555) 000-0000"
                          {...field}
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
                  name="ssn"
                  render={({ field }) => (
                    <FormItem className="col-span-1 md:col-span-2">
                      <FormLabel>Social Security Number</FormLabel>
                      <FormControl>
                        <Input
                          type="text"
                          inputMode="numeric"
                          maxLength={11}
                          placeholder="XXX-XX-XXXX"
                          {...field}
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
            </CollapsibleContent>
          </Collapsible>

          {/* Submit */}
          <div className="flex justify-end pt-2">
            <Button type="submit" disabled={isSubmitting} size="lg">
              {isSubmitting ? 'Registering...' : 'Register Youth'}
            </Button>
          </div>
        </form>
      </Form>
    </div>
  );
}
