import { z } from 'zod';

/** Required fields for creating a new youth record (D-02). */
export const createYouthSchema = z.object({
  // Required
  firstName: z.string().min(1, 'First name is required'),
  lastName: z.string().min(1, 'Last name is required'),
  dateOfBirth: z.string().min(1, 'Date of birth is required'),
  guardianName: z.string().min(1, 'Guardian name is required'),

  // Optional demographics
  genderId: z.string().optional(),
  raceId: z.string().optional(),
  ethnicityId: z.string().optional(),

  // Optional SSN — must be 9 digits if provided; empty string is treated as absent
  ssn: z
    .string()
    .regex(/^\d{9}$/, 'SSN must be 9 digits')
    .optional()
    .or(z.literal('')),

  // Optional address
  address: z.string().optional(),
  city: z.string().optional(),
  state: z.string().optional(),
  zip: z.string().optional(),
  phone: z.string().optional(),

  // Optional guardian contact
  guardianPhone: z.string().optional(),
  guardianRelation: z.string().optional(),
});

/** All fields optional except id for partial updates. */
export const updateYouthSchema = createYouthSchema.partial().extend({
  id: z.string().min(1, 'Youth ID is required'),
});

/** Search/filter input for the youth list page. */
export const searchYouthSchema = z.object({
  q: z.string().optional(),
  page: z.coerce.number().min(1).default(1),
});

/** Duplicate detection input — name+DOB match, optional SSN last-4 match. */
export const checkDuplicateSchema = z.object({
  firstName: z.string(),
  lastName: z.string(),
  dateOfBirth: z.string(),
  ssnLast4: z.string().length(4).optional(),
});

export type CreateYouthInput = z.infer<typeof createYouthSchema>;
export type UpdateYouthInput = z.infer<typeof updateYouthSchema>;
export type SearchYouthInput = z.infer<typeof searchYouthSchema>;
export type CheckDuplicateInput = z.infer<typeof checkDuplicateSchema>;
