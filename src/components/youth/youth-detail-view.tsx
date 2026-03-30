'use client';

import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { toast } from 'sonner';

import { updateYouthSchema, type UpdateYouthInput } from '@/schemas/youth';
import { updateYouth } from '@/actions/youth';

import {
  Card,
  CardHeader,
  CardTitle,
  CardContent,
} from '@/components/ui/card';
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
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from '@/components/ui/select';

interface YouthDetailViewProps {
  youth: {
    id: string;
    firstName: string;
    lastName: string;
    dateOfBirth: string;
    guardianName: string;
    genderId: string;
    raceId: string;
    ethnicityId: string;
    address: string;
    city: string;
    state: string;
    zip: string;
    phone: string;
    guardianPhone: string;
    guardianRelation: string;
    displaySSN: string;
    ssnLast4: string | null;
    createdAt: Date;
  };
  isAdmin: boolean;
}

/**
 * Format a YYYY-MM-DD date string as MM/DD/YYYY (UTC) for display.
 * Uses UTC to prevent timezone-based day shifts on stored UTC dates.
 */
function formatDOB(isoDate: string): string {
  const date = new Date(isoDate + 'T00:00:00Z');
  return new Intl.DateTimeFormat('en-US', {
    timeZone: 'UTC',
    month: '2-digit',
    day: '2-digit',
    year: 'numeric',
  }).format(date);
}

/**
 * Youth detail/edit page component.
 * Defaults to read-only view with three Card sections.
 * "Edit Youth" button toggles to form input mode (D-10).
 * Save calls updateYouth server action; Discard resets form.
 * No enrollment/attendance sections (D-11). No audit trail (D-12).
 */
export function YouthDetailView({ youth, isAdmin }: YouthDetailViewProps) {
  const [isEditing, setIsEditing] = useState(false);

  const form = useForm<UpdateYouthInput>({
    resolver: zodResolver(updateYouthSchema),
    defaultValues: {
      id: youth.id,
      firstName: youth.firstName,
      lastName: youth.lastName,
      dateOfBirth: youth.dateOfBirth,
      guardianName: youth.guardianName,
      genderId: youth.genderId,
      raceId: youth.raceId,
      ethnicityId: youth.ethnicityId,
      address: youth.address,
      city: youth.city,
      state: youth.state,
      zip: youth.zip,
      phone: youth.phone,
      guardianPhone: youth.guardianPhone,
      guardianRelation: youth.guardianRelation,
    },
  });

  const onSave = async (data: UpdateYouthInput) => {
    // data.id comes from the RHF defaultValues — no need to spread it again
    const result = await updateYouth(data);
    if (result.success) {
      setIsEditing(false);
      toast.success('Changes saved.');
    } else {
      toast.error('Could not save changes. Please try again.');
    }
  };

  const onDiscard = () => {
    setIsEditing(false);
    form.reset();
  };

  const { isSubmitting } = form.formState;

  // Helper to render a read-only field row
  const ReadField = ({
    label,
    value,
  }: {
    label: string;
    value: string | null | undefined;
  }) => (
    <div>
      <p className="text-sm text-muted-foreground">{label}</p>
      <p className="text-sm">{value || '—'}</p>
    </div>
  );

  return (
    <div>
      {/* Page header */}
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-semibold">
          {youth.firstName} {youth.lastName}
        </h1>
        {!isEditing && (
          <Button variant="outline" onClick={() => setIsEditing(true)}>
            Edit Youth
          </Button>
        )}
      </div>

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSave)} className="space-y-6">

          {/* Demographics Card */}
          <Card>
            <CardHeader>
              <CardTitle>Demographics</CardTitle>
            </CardHeader>
            <CardContent>
              {isEditing ? (
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
                  {/* SSN is read-only in edit mode — no re-entry to avoid complexity (D-03) */}
                  <div>
                    <p className="text-sm text-muted-foreground">
                      Social Security Number
                    </p>
                    <p className="text-sm">{youth.displaySSN}</p>
                    {isAdmin && (
                      <p className="text-xs text-muted-foreground mt-1">
                        SSN cannot be updated here. Contact system admin to reissue.
                      </p>
                    )}
                  </div>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <ReadField label="First Name" value={youth.firstName} />
                  <ReadField label="Last Name" value={youth.lastName} />
                  <ReadField
                    label="Date of Birth"
                    value={formatDOB(youth.dateOfBirth)}
                  />
                  <ReadField
                    label="Gender"
                    value={youth.genderId || undefined}
                  />
                  <ReadField label="Race" value={youth.raceId || undefined} />
                  <ReadField
                    label="Ethnicity"
                    value={youth.ethnicityId || undefined}
                  />
                  <div>
                    <p className="text-sm text-muted-foreground">
                      Social Security Number
                    </p>
                    <p className="text-sm">{youth.displaySSN}</p>
                  </div>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Guardian Card */}
          <Card>
            <CardHeader>
              <CardTitle>Guardian</CardTitle>
            </CardHeader>
            <CardContent>
              {isEditing ? (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <FormField
                    control={form.control}
                    name="guardianName"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Guardian Name *</FormLabel>
                        <FormControl>
                          <Input
                            placeholder="Guardian full name"
                            {...field}
                          />
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
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <ReadField
                    label="Guardian Name"
                    value={youth.guardianName}
                  />
                  <ReadField
                    label="Guardian Phone"
                    value={youth.guardianPhone || undefined}
                  />
                  <ReadField
                    label="Relation to Youth"
                    value={youth.guardianRelation || undefined}
                  />
                </div>
              )}
            </CardContent>
          </Card>

          {/* Address & Phone Card */}
          <Card>
            <CardHeader>
              <CardTitle>Address &amp; Phone</CardTitle>
            </CardHeader>
            <CardContent>
              {isEditing ? (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <FormField
                    control={form.control}
                    name="address"
                    render={({ field }) => (
                      <FormItem className="col-span-1 md:col-span-2">
                        <FormLabel>Address</FormLabel>
                        <FormControl>
                          <Input
                            placeholder="Street address"
                            {...field}
                          />
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
                          <Input
                            placeholder="State"
                            maxLength={2}
                            {...field}
                          />
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
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <ReadField
                    label="Address"
                    value={youth.address || undefined}
                  />
                  <ReadField label="City" value={youth.city || undefined} />
                  <ReadField label="State" value={youth.state || undefined} />
                  <ReadField label="Zip Code" value={youth.zip || undefined} />
                  <ReadField label="Phone" value={youth.phone || undefined} />
                </div>
              )}
            </CardContent>
          </Card>

          {/* Action row — only shown in edit mode */}
          {isEditing && (
            <div className="flex items-center gap-3 justify-end pt-2">
              <Button
                type="button"
                variant="ghost"
                onClick={onDiscard}
                disabled={isSubmitting}
              >
                Discard Changes
              </Button>
              <Button type="submit" disabled={isSubmitting}>
                {isSubmitting ? 'Saving...' : 'Save Changes'}
              </Button>
            </div>
          )}
        </form>
      </Form>
    </div>
  );
}
