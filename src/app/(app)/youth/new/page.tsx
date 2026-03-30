import { db } from '@/lib/db';
import { YouthRegistrationForm } from '@/components/youth/youth-registration-form';

/**
 * /youth/new — New youth registration page.
 * Fetches counties server-side and passes to client form.
 */
export default async function NewYouthPage() {
  const counties = await db.county.findMany({
    orderBy: { name: 'asc' },
    select: { id: true, name: true },
  });

  return <YouthRegistrationForm counties={counties} />;
}
