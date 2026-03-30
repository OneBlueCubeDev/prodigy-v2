import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

// Seed scripts run outside Next.js runtime — standalone PrismaClient is the
// Prisma-documented pattern. See CLAUDE.md exception note in 00-02-PLAN.md.
const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL! });
const prisma = new PrismaClient({ adapter });

async function main() {
  // --- Lookup tables (LOOK-02) ---

  const races = [
    'American Indian or Alaska Native',
    'Asian',
    'Black or African American',
    'Native Hawaiian or Other Pacific Islander',
    'White',
    'Two or More Races',
  ];
  for (const name of races) {
    await prisma.race.upsert({
      where: { name },
      update: {},
      create: { name },
    });
  }

  const ethnicities = ['Hispanic or Latino', 'Not Hispanic or Latino'];
  for (const name of ethnicities) {
    await prisma.ethnicity.upsert({
      where: { name },
      update: {},
      create: { name },
    });
  }

  const genders = [
    'Male',
    'Female',
    'Non-Binary',
    'Other',
    'Prefer Not to Say',
  ];
  for (const name of genders) {
    await prisma.gender.upsert({
      where: { name },
      update: {},
      create: { name },
    });
  }

  const floridaCounties = [
    'Alachua', 'Baker', 'Bay', 'Bradford', 'Brevard', 'Broward', 'Calhoun',
    'Charlotte', 'Citrus', 'Clay', 'Collier', 'Columbia', 'DeSoto', 'Dixie',
    'Duval', 'Escambia', 'Flagler', 'Franklin', 'Gadsden', 'Gilchrist',
    'Glades', 'Gulf', 'Hamilton', 'Hardee', 'Hendry', 'Hernando', 'Highlands',
    'Hillsborough', 'Holmes', 'Indian River', 'Jackson', 'Jefferson',
    'Lafayette', 'Lake', 'Lee', 'Leon', 'Levy', 'Liberty', 'Madison',
    'Manatee', 'Marion', 'Martin', 'Miami-Dade', 'Monroe', 'Nassau',
    'Okaloosa', 'Okeechobee', 'Orange', 'Osceola', 'Palm Beach', 'Pasco',
    'Pinellas', 'Polk', 'Putnam', 'Santa Rosa', 'Sarasota', 'Seminole',
    'St. Johns', 'St. Lucie', 'Sumter', 'Suwannee', 'Taylor', 'Union',
    'Volusia', 'Wakulla', 'Walton', 'Washington',
  ];
  for (const name of floridaCounties) {
    await prisma.county.upsert({
      where: { name },
      update: {},
      create: { name },
    });
  }

  const enrollmentTypes = ['New', 'Returning', 'Transfer'];
  for (const name of enrollmentTypes) {
    await prisma.enrollmentType.upsert({
      where: { name },
      update: {},
      create: { name },
    });
  }

  const enrollmentStatuses = ['Active', 'Inactive', 'Released', 'Transferred'];
  for (const name of enrollmentStatuses) {
    await prisma.enrollmentStatus.upsert({
      where: { name },
      update: {},
      create: { name },
    });
  }

  // --- Sites ---
  const siteNames = [
    'UACDC Main Campus',
    'Marvell Site',
    'Elaine Site',
    'Helena Site',
  ];
  const sites = [];
  for (const name of siteNames) {
    const site = await prisma.site.upsert({
      where: { name },
      update: {},
      create: { name },
    });
    sites.push(site);
  }

  // --- Programs (test data for AUTH-03 program selector) ---
  const programData = [
    {
      name: '21st Century Community Learning Centers',
      description:
        'After-school and summer programs for academic enrichment and youth development activities.',
    },
    {
      name: 'Delta Youth Scholars',
      description:
        'College preparation and scholarship support for Delta region youth.',
    },
    {
      name: 'Summer Arts Academy',
      description:
        'Summer intensive arts program including visual arts, music, and performing arts.',
    },
  ];

  for (const p of programData) {
    const program = await prisma.program.upsert({
      where: { name: p.name },
      update: {},
      create: p,
    });

    // Link each program to all sites
    for (const site of sites) {
      await prisma.programSite.upsert({
        where: {
          program_id_site_id: {
            program_id: program.id,
            site_id: site.id,
          },
        },
        update: {},
        create: {
          program_id: program.id,
          site_id: site.id,
        },
      });
    }
  }

  console.log('Seed complete: lookups, sites, and programs created.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
