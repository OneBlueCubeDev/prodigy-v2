'use server';

import { revalidatePath } from 'next/cache';
import { requireAuth } from '@/lib/auth';
import { db } from '@/lib/db';
import { encryptSSN, extractLast4 } from '@/lib/ssn-encryption';
import logger from '@/lib/logger';
import {
  createYouthSchema,
  updateYouthSchema,
  searchYouthSchema,
  checkDuplicateSchema,
} from '@/schemas/youth';
import type { ActionResult } from '@/types/action-result';
import type { Youth } from '@prisma/client';

const PAGE_SIZE = 20;

/**
 * Create a new youth record.
 * Encrypts SSN if provided before storage. Calls requireAuth first.
 * Returns ActionResult<Youth> — never throws.
 */
export async function createYouth(
  input: unknown,
): Promise<ActionResult<Youth>> {
  try {
    const { userId } = await requireAuth();
    const data = createYouthSchema.parse(input);

    // SSN handling — never log the SSN value
    let ssnEncrypted: string | null = null;
    let ssnLast4: string | null = null;
    if (data.ssn && data.ssn.length === 9) {
      ssnEncrypted = encryptSSN(data.ssn);
      ssnLast4 = extractLast4(data.ssn);
    }

    const youth = await db.youth.create({
      data: {
        first_name: data.firstName,
        last_name: data.lastName,
        date_of_birth: new Date(data.dateOfBirth),
        ssn: ssnEncrypted,
        ssn_last4: ssnLast4,
        gender_id: data.genderId ?? null,
        race_id: data.raceId ?? null,
        ethnicity_id: data.ethnicityId ?? null,
        address: data.address ?? null,
        city: data.city ?? null,
        state: data.state ?? null,
        zip: data.zip ?? null,
        phone: data.phone ?? null,
        guardian_name: data.guardianName,
        guardian_phone: data.guardianPhone ?? null,
        guardian_relation: data.guardianRelation ?? null,
      },
    });

    logger.info({ youth_id: youth.id, user_id: userId }, 'Youth created');
    revalidatePath('/youth');
    return { success: true, data: youth };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    logger.error({ error: message }, 'createYouth failed');
    return { success: false, error: message };
  }
}

/**
 * Update an existing youth record by ID.
 * Only updates provided fields. Re-encrypts SSN if included.
 * Calls requireAuth first.
 */
export async function updateYouth(
  input: unknown,
): Promise<ActionResult<Youth>> {
  try {
    const { userId } = await requireAuth();
    const { id, ...data } = updateYouthSchema.parse(input);

    // Build update payload — only include explicitly provided fields
    const updateData: Record<string, unknown> = {};

    if (data.firstName !== undefined) updateData.first_name = data.firstName;
    if (data.lastName !== undefined) updateData.last_name = data.lastName;
    if (data.dateOfBirth !== undefined)
      updateData.date_of_birth = new Date(data.dateOfBirth);
    if (data.genderId !== undefined)
      updateData.gender_id = data.genderId || null;
    if (data.raceId !== undefined) updateData.race_id = data.raceId || null;
    if (data.ethnicityId !== undefined)
      updateData.ethnicity_id = data.ethnicityId || null;
    if (data.address !== undefined) updateData.address = data.address || null;
    if (data.city !== undefined) updateData.city = data.city || null;
    if (data.state !== undefined) updateData.state = data.state || null;
    if (data.zip !== undefined) updateData.zip = data.zip || null;
    if (data.phone !== undefined) updateData.phone = data.phone || null;
    if (data.guardianName !== undefined)
      updateData.guardian_name = data.guardianName || null;
    if (data.guardianPhone !== undefined)
      updateData.guardian_phone = data.guardianPhone || null;
    if (data.guardianRelation !== undefined)
      updateData.guardian_relation = data.guardianRelation || null;

    // SSN re-encryption when updated — never log the value
    if (data.ssn !== undefined) {
      if (data.ssn && data.ssn.length === 9) {
        updateData.ssn = encryptSSN(data.ssn);
        updateData.ssn_last4 = extractLast4(data.ssn);
      } else {
        updateData.ssn = null;
        updateData.ssn_last4 = null;
      }
    }

    const youth = await db.youth.update({
      where: { id },
      data: updateData,
    });

    logger.info({ youth_id: id, user_id: userId }, 'Youth updated');
    revalidatePath('/youth');
    revalidatePath(`/youth/${id}`);
    return { success: true, data: youth };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    logger.error({ error: message }, 'updateYouth failed');
    return { success: false, error: message };
  }
}

/**
 * Search youth records with optional full-text query.
 * Searches across first_name, last_name, and ssn_last4.
 * Returns paginated results with total count.
 */
export async function searchYouth(
  input: unknown,
): Promise<ActionResult<{ youth: Youth[]; total: number }>> {
  try {
    await requireAuth();
    const { q, page } = searchYouthSchema.parse(input);
    const skip = (page - 1) * PAGE_SIZE;

    const where = q
      ? {
          OR: [
            { first_name: { contains: q, mode: 'insensitive' as const } },
            { last_name: { contains: q, mode: 'insensitive' as const } },
            { ssn_last4: q },
          ],
        }
      : {};

    const [youth, total] = await Promise.all([
      db.youth.findMany({
        where,
        skip,
        take: PAGE_SIZE,
        orderBy: { created_at: 'desc' },
      }),
      db.youth.count({ where }),
    ]);

    return { success: true, data: { youth, total } };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    return { success: false, error: message };
  }
}

/**
 * Check for potential duplicate youth records before registration.
 * Matches on (firstName + lastName + DOB) OR (ssnLast4) if provided.
 * Returns up to 5 matches so staff can decide whether to proceed.
 */
export async function checkDuplicate(
  input: unknown,
): Promise<ActionResult<Youth[]>> {
  try {
    await requireAuth();
    const { firstName, lastName, dateOfBirth, ssnLast4 } =
      checkDuplicateSchema.parse(input);

    const dob = new Date(dateOfBirth);

    const matches = await db.youth.findMany({
      where: {
        OR: [
          {
            first_name: { equals: firstName, mode: 'insensitive' },
            last_name: { equals: lastName, mode: 'insensitive' },
            date_of_birth: dob,
          },
          ...(ssnLast4 ? [{ ssn_last4: ssnLast4 }] : []),
        ],
      },
      take: 5,
    });

    return { success: true, data: matches };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    return { success: false, error: message };
  }
}

/**
 * Fetch a single youth record by ID.
 * Returns not-found error if the youth doesn't exist.
 */
export async function getYouthById(id: string): Promise<ActionResult<Youth>> {
  try {
    await requireAuth();
    const youth = await db.youth.findUnique({ where: { id } });
    if (!youth) {
      return { success: false, error: 'Youth not found' };
    }
    return { success: true, data: youth };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    return { success: false, error: message };
  }
}

/**
 * Log when a staff member dismisses a duplicate match and proceeds with
 * registration. Creates an audit trail for compliance review.
 * Logs as a warning so it's easy to surface in monitoring.
 */
export async function logDuplicateOverride(
  youthId: string,
  matchedYouthIds: string[],
): Promise<ActionResult<void>> {
  try {
    const { userId } = await requireAuth();
    logger.warn(
      { user_id: userId, youth_id: youthId, matched_ids: matchedYouthIds },
      'Staff dismissed duplicate match and proceeded with registration',
    );
    return { success: true, data: undefined };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    return { success: false, error: message };
  }
}
