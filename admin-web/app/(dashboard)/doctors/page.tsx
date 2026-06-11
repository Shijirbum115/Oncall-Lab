import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { DoctorsTable, type DoctorRow } from "@/components/doctors-table";
import { AddDoctorButton } from "@/components/doctor-form-dialog";
import { SearchForm } from "@/components/search-form";
import { createClient } from "@/lib/supabase/server";

const TABS = [
  { value: "all", label: "All" },
  { value: "pending", label: "Pending verification" },
  { value: "verified", label: "Verified" },
] as const;

export default async function DoctorsPage({
  searchParams,
}: {
  searchParams: Promise<{ tab?: string; q?: string }>;
}) {
  const { tab = "all", q = "" } = await searchParams;
  const supabase = await createClient();

  let query = supabase
    .from("profiles")
    .select(
      "id, full_name, phone_number, email, avatar_url, is_active, is_verified, created_at, doctor_profiles(profession, license_number, academic_degree, work_experience_years, professional_development, photo_url, rating, total_reviews, total_completed_requests, is_available)",
    )
    .eq("role", "doctor")
    .order("created_at", { ascending: false });

  if (tab === "pending") query = query.eq("is_verified", false);
  if (tab === "verified") query = query.eq("is_verified", true);

  const term = q.trim().replaceAll(",", " ");
  if (term) {
    query = query.or(
      `full_name.ilike.%${term}%,phone_number.ilike.%${term}%,email.ilike.%${term}%`,
    );
  }

  const { data } = await query;
  const doctors = (data ?? []) as unknown as DoctorRow[];

  return (
    <>
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Doctors</h1>
          <p className="text-sm text-muted-foreground">
            Review registrations, verify licenses, manage accounts
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <SearchForm
            defaultValue={q}
            placeholder="Name, phone, or email…"
            extraParams={{ tab: tab === "all" ? "" : tab }}
          />
          <Tabs value={tab}>
            <TabsList>
              {TABS.map((t) => (
                <TabsTrigger
                  key={t.value}
                  value={t.value}
                  render={
                    <Link
                      href={{
                        pathname: "/doctors",
                        query: {
                          ...(t.value === "all" ? {} : { tab: t.value }),
                          ...(q ? { q } : {}),
                        },
                      }}
                    />
                  }
                >
                  {t.label}
                </TabsTrigger>
              ))}
            </TabsList>
          </Tabs>
          <AddDoctorButton />
        </div>
      </div>

      <Card>
        <CardContent>
          <DoctorsTable doctors={doctors} />
        </CardContent>
      </Card>
    </>
  );
}
