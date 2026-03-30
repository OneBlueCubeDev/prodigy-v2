"use client";

import Link from "next/link";
import { PlusIcon } from "lucide-react";

import { buttonVariants } from "@/components/ui/button";
import { cn } from "@/lib/utils";

export function RegisterYouthLink() {
  return (
    <Link href="/youth/new" className={cn(buttonVariants(), "gap-1.5")}>
      <PlusIcon className="size-4" />
      Register Youth
    </Link>
  );
}
