import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { RequestActions } from "@/components/request-actions";
import { SearchForm } from "@/components/search-form";
import { createClient } from "@/lib/supabase/server";
import { formatDate, formatDateTime, formatMnt } from "@/lib/format";
import {
  paymentStatusStyles,
  requestStatusStyles,
  statusStyle,
} from "@/lib/status";

type RequestRow = {
  id: string;
  status: string;
  request_type: string | null;
  price_mnt: number;
  payment_status: string | null;
  scheduled_date: string;
  scheduled_time_slot: string | null;
  patient_address: string;
  created_at: string | null;
  patient: { full_name: string | null; phone_number: string } | null;
  doctor: { full_name: string | null } | null;
};

export default async function RequestsPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string }>;
}) {
  const { q = "" } = await searchParams;
  const supabase = await createClient();

  let query = supabase
    .from("test_requests")
    .select(
      "id,status,request_type,price_mnt,payment_status,scheduled_date,scheduled_time_slot,patient_address,created_at,patient:profiles!test_requests_patient_id_fkey(full_name,phone_number),doctor:profiles!test_requests_doctor_id_fkey(full_name)",
    )
    .order("created_at", { ascending: false })
    .limit(200);

  // Search runs as a separate profile lookup: embedding the same table twice
  // with !inner breaks PostgREST relationship resolution.
  const term = q.trim().replaceAll(",", " ");
  let noMatches = false;
  if (term) {
    const { data: matches } = await supabase
      .from("profiles")
      .select("id")
      .eq("role", "patient")
      .or(`full_name.ilike.%${term}%,phone_number.ilike.%${term}%`)
      .limit(100);
    const ids = (matches ?? []).map((m) => m.id);
    if (ids.length === 0) noMatches = true;
    else query = query.in("patient_id", ids);
  }

  const { data, error } = noMatches
    ? { data: [], error: null }
    : await query;
  const requests = (data ?? []) as unknown as RequestRow[];

  return (
    <>
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Requests</h1>
          <p className="text-sm text-muted-foreground">
            {term
              ? `${requests.length} matching “${term}”`
              : `Latest ${requests.length} test requests across all patients`}
          </p>
        </div>
        <SearchForm defaultValue={q} placeholder="Patient name or phone…" />
      </div>

      {error ? (
        <Card className="border-destructive/30 bg-destructive/5">
          <CardContent className="text-sm text-destructive">
            Failed to load requests: {error.message}
          </CardContent>
        </Card>
      ) : null}

      <Card>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Patient</TableHead>
                <TableHead>Doctor</TableHead>
                <TableHead>Type</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Payment</TableHead>
                <TableHead>Price</TableHead>
                <TableHead>Scheduled</TableHead>
                <TableHead className="text-right">Created</TableHead>
                <TableHead className="w-12" />
              </TableRow>
            </TableHeader>
            <TableBody>
              {requests.length === 0 ? (
                <TableRow>
                  <TableCell
                    colSpan={9}
                    className="py-10 text-center text-muted-foreground"
                  >
                    No requests yet.
                  </TableCell>
                </TableRow>
              ) : (
                requests.map((r) => {
                  const s = statusStyle(requestStatusStyles, r.status);
                  const p = statusStyle(paymentStatusStyles, r.payment_status);
                  const ageHours = r.created_at
                    ? (Date.now() - new Date(r.created_at).getTime()) / 36e5
                    : 0;
                  const isStale =
                    (r.status === "pending" || r.status === "accepted") &&
                    ageHours > 24;
                  return (
                    <TableRow key={r.id}>
                      <TableCell>
                        <div className="grid leading-tight">
                          <span className="font-medium">
                            {r.patient?.full_name ?? "—"}
                          </span>
                          <span className="font-mono text-xs text-muted-foreground">
                            {r.patient?.phone_number ?? ""}
                          </span>
                        </div>
                      </TableCell>
                      <TableCell>{r.doctor?.full_name ?? "Unassigned"}</TableCell>
                      <TableCell className="text-muted-foreground">
                        {r.request_type === "lab_service" ? "Lab" : "Direct"}
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center gap-1.5">
                          <Badge variant="outline" className={s.className}>
                            {s.label}
                          </Badge>
                          {isStale ? (
                            <Badge
                              variant="outline"
                              className="border-red-500/30 bg-red-500/15 text-red-400"
                              title="No progress for over 24 hours"
                            >
                              {Math.floor(ageHours)}h
                            </Badge>
                          ) : null}
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline" className={p.className}>
                          {p.label}
                        </Badge>
                      </TableCell>
                      <TableCell className="font-mono">
                        {formatMnt(r.price_mnt)}
                      </TableCell>
                      <TableCell className="text-muted-foreground">
                        {formatDate(r.scheduled_date)}
                        {r.scheduled_time_slot ? ` · ${r.scheduled_time_slot}` : ""}
                      </TableCell>
                      <TableCell className="text-right text-muted-foreground">
                        {formatDateTime(r.created_at)}
                      </TableCell>
                      <TableCell>
                        <RequestActions
                          requestId={r.id}
                          patientName={r.patient?.full_name ?? null}
                          status={r.status}
                        />
                      </TableCell>
                    </TableRow>
                  );
                })
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </>
  );
}
