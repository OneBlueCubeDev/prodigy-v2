import Image from 'next/image';

/**
 * Dashboard placeholder page.
 * Will be expanded with widgets and data in later phases.
 */
export default function DashboardPage() {
  return (
    <div className="flex flex-col items-center justify-center py-16">
      <Image
        src="/logos/prodigy.png"
        alt="Prodigy Cultural Arts Program"
        width={200}
        height={200}
        className="object-contain mb-8"
      />
      <h1 className="text-xl font-semibold">Dashboard</h1>
      <p className="text-muted-foreground mt-2">
        Welcome to Prodigy. Select a section from the sidebar to get started.
      </p>
    </div>
  );
}
