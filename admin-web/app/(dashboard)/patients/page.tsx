import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { PatientActions } from "@/components/patient-actions";
import { SearchForm } from "@/components/search-form";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { createClient } from "@/lib/supabase/server";
import { formatDate, initials } from "@/lib/format";

export default async function PatientsPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string }>;
}) {
  const { q = "" } = await searchParams;
  const supabase = await createClient();

  let query = supabase
    .from("profiles")
    .select(
      "id, full_name, phone_number, email, avatar_url, age, gender, is_active, created_at",
    )
    .eq("role", "patient")
    .order("created_at", { ascending: false })
    .limit(200);

  const term = q.trim().replaceAll(",", " ");
  if (term) {
    query = query.or(
      `full_name.ilike.%${term}%,phone_number.ilike.%${term}%,email.ilike.%${term}%`,
    );
  }

  const { data } = await query;
  const patients = data ?? [];

  return (
    <>
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Patients</h1>
          <p className="text-sm text-muted-foreground">
            {term
              ? `${patients.length} matching “${term}”`
              : `${patients.length} registered patients`}
          </p>
        </div>
        <SearchForm defaultValue={q} placeholder="Name, phone, or email…" />
      </div>

      <Card>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Patient</TableHead>
                <TableHead>Email</TableHead>
                <TableHead>Age</TableHead>
                <TableHead>Gender</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Registered</TableHead>
                <TableHead className="w-12" />
              </TableRow>
            </TableHeader>
            <TableBody>
              {patients.length === 0 ? (
                <TableRow>
                  <TableCell
                    colSpan={7}
                    className="py-10 text-center text-muted-foreground"
                  >
                    No patients yet.
                  </TableCell>
                </TableRow>
              ) : (
                patients.map((p) => (
                  <TableRow key={p.id}>
                    <TableCell>
                      <div className="flex items-center gap-3">
                        <Avatar className="size-8">
                          <AvatarImage src={p.avatar_url ?? undefined} />
                          <AvatarFallback>{initials(p.full_name)}</AvatarFallback>
                        </Avatar>
                        <div className="grid leading-tight">
                          <span className="font-medium">
                            {p.full_name ?? "—"}
                          </span>
                          <span className="font-mono text-xs text-muted-foreground">
                            {p.phone_number}
                          </span>
                        </div>
                      </div>
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {p.email ?? "—"}
                    </TableCell>
                    <TableCell>{p.age ?? "—"}</TableCell>
                    <TableCell className="capitalize">
                      {p.gender ?? "—"}
                    </TableCell>
                    <TableCell>
                      {p.is_active === false ? (
                        <Badge
                          variant="outline"
                          className="border-red-500/30 bg-red-500/15 text-red-400"
                        >
                          Disabled
                        </Badge>
                      ) : (
                        <Badge
                          variant="outline"
                          className="border-emerald-500/30 bg-emerald-500/15 text-emerald-400"
                        >
                          Active
                        </Badge>
                      )}
                    </TableCell>
                    <TableCell className="text-right text-muted-foreground">
                      {formatDate(p.created_at)}
                    </TableCell>
                    <TableCell>
                      <PatientActions
                        patientId={p.id}
                        patientName={p.full_name}
                        isActive={p.is_active !== false}
                      />
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </>
  );
}
