import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  ServicesTable,
  type CategoryRow,
  type ServiceRow,
} from "@/components/services-table";
import { AddServiceButton } from "@/components/service-form-dialog";
import { ManageCategoriesButton } from "@/components/category-manager";
import { SearchForm } from "@/components/search-form";
import { createClient } from "@/lib/supabase/server";

const TABS = [
  { value: "all", label: "All" },
  { value: "active", label: "Active" },
  { value: "inactive", label: "Inactive" },
] as const;

export default async function ServicesPage({
  searchParams,
}: {
  searchParams: Promise<{ tab?: string; q?: string; category?: string }>;
}) {
  const { tab = "all", q = "", category = "" } = await searchParams;
  const supabase = await createClient();

  const { data: categoryData } = await supabase
    .from("service_categories")
    .select("id, name, name_mn, type, icon_name")
    .order("name");
  const categories = (categoryData ?? []) as CategoryRow[];

  let query = supabase
    .from("services")
    .select(
      "id, category_id, name, name_mn, description, description_mn, sample_type, preparation_instructions, estimated_duration_minutes, is_active, service_categories(name, name_mn), laboratory_services(price_mnt)",
    )
    .order("name");

  if (tab === "active") query = query.eq("is_active", true);
  if (tab === "inactive") query = query.eq("is_active", false);
  if (category) query = query.eq("category_id", category);

  const term = q.trim().replaceAll(",", " ");
  if (term) {
    query = query.or(`name.ilike.%${term}%,name_mn.ilike.%${term}%`);
  }

  const { data } = await query;
  const services = (data ?? []) as unknown as ServiceRow[];

  return (
    <>
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Services</h1>
          <p className="text-sm text-muted-foreground">
            Manage the bookable catalog: names, prices, categories
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <SearchForm
            defaultValue={q}
            placeholder="Service name…"
            extraParams={{
              tab: tab === "all" ? "" : tab,
              category,
            }}
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
                        pathname: "/services",
                        query: {
                          ...(t.value === "all" ? {} : { tab: t.value }),
                          ...(q ? { q } : {}),
                          ...(category ? { category } : {}),
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
          <ManageCategoriesButton categories={categories} />
          <AddServiceButton categories={categories} />
        </div>
      </div>

      <div className="flex flex-wrap gap-1.5">
        <CategoryChip
          label="All categories"
          href={{ tab, q }}
          active={!category}
        />
        {categories.map((c) => (
          <CategoryChip
            key={c.id}
            label={c.name_mn ?? c.name}
            href={{ tab, q, category: c.id }}
            active={category === c.id}
          />
        ))}
      </div>

      <Card>
        <CardContent>
          <ServicesTable services={services} categories={categories} />
        </CardContent>
      </Card>
    </>
  );
}

function CategoryChip({
  label,
  href,
  active,
}: {
  label: string;
  href: { tab?: string; q?: string; category?: string };
  active: boolean;
}) {
  const query: Record<string, string> = {};
  if (href.tab && href.tab !== "all") query.tab = href.tab;
  if (href.q) query.q = href.q;
  if (href.category) query.category = href.category;

  return (
    <Link
      href={{ pathname: "/services", query }}
      className={`rounded-full border px-3 py-1 text-xs transition-colors ${
        active
          ? "border-primary bg-primary text-primary-foreground"
          : "text-muted-foreground hover:bg-accent"
      }`}
    >
      {label}
    </Link>
  );
}
