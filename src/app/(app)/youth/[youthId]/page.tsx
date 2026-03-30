import { notFound } from 'next/navigation';

import { requireAuth, getAuthContext } from '@/lib/auth';
import { db } from '@/lib/db';
import { YouthDetailView } from '@/components/youth/youth-detail-view';

/**
 * Youth detail page — server-rendered with SSN masking by role (D-03).
 * Admin sees full decrypted SSN; all other roles see masked ***-**-XXXX.
 * Renders read-only view by default; inline edit mode via YouthDetailView (D-10).
 */
export default async function YouthDetailPage({
  params,
}: {
  params: Promise<{ youthId: string }>;
}) {
  // CVE-2025-29927 mitigation — call requireAuth before any data access
  await requireAuth();

  const { youthId } = await params;
  const { role } = await getAuthContext();

  const [youth, counties] = await Promise.all([
    db.youth.findUnique({ where: { id: youthId }, include: { county: true } }),
    db.county.findMany({ orderBy: { name: 'asc' }, select: { id: true, name: true } }),
  ]);

  if (!youth) {
    notFound();
  }

  // SSN display — only last 4 stored
  const displaySSN = youth.ssn_last4
    ? `***-**-${youth.ssn_last4}`
    : 'Not provided';

  // Map DB record to form-compatible camelCase shape for YouthDetailView
  const youthData = {
    id: youth.id,
    firstName: youth.first_name,
    lastName: youth.last_name,
    dateOfBirth: youth.date_of_birth.toISOString().split('T')[0],
    guardianName: youth.guardian_name ?? '',
    genderId: youth.gender_id ?? '',
    raceId: youth.race_id ?? '',
    ethnicityId: youth.ethnicity_id ?? '',
    address: youth.address ?? '',
    city: youth.city ?? '',
    county: youth.county_id ?? '',
    countyName: youth.county?.name ?? '',
    state: youth.state ?? '',
    zip: youth.zip ?? '',
    phone: youth.phone ?? '',
    guardianPhone: youth.guardian_phone ?? '',
    guardianRelation: youth.guardian_relation ?? '',
    displaySSN,
    ssnLast4: youth.ssn_last4,
    createdAt: youth.created_at,
  };

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 md:px-6">
      <YouthDetailView youth={youthData} isAdmin={role === 'admin'} counties={counties} />
    </div>
  );
}
