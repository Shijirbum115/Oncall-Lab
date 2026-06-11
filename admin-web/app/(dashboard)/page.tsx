import Link from "next/link";
import {
  Activity,
  BadgeCheck,
  CreditCard,
  Stethoscope,
  TestTubes,
  Users,
  Wallet,
} from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { StatCard } from "@/components/stat-card";
import {
  RequestsChart,
  RevenueChart,
  type MonthlyStat,
} from "@/components/charts/monthly-charts";
import { createClient } from "@/lib/supabase/server";
import { formatDateTime, formatMnt } from "@/lib/format";
import { requestStatusStyles, statusStyle } from "@/lib/status";

type DashboardStats = {
  users: {
    total_patients: number;
    total_doctors: number;
    verified_doctors: number;
    active_doctors: number;
    total_laboratories: number;
  };
  requests: {
    total: number;
    by_status: Record<string, number>;
    this_month_total: number;
    this_month_completed: number;
  };
  revenue: {
    total_paid_mnt: number;
    this_month_paid_mnt: number;
    pending_qpay: number;
    pending_manual_review: number;
  };
};

export default async function DashboardPage() {
  const supabase = await createClient();

  const [statsRes, monthlyRes, recentRes, pendingDoctorsRes] =
    await Promise.all([
      supabase.rpc("get_admin_dashboard_stats"),
      supabase.rpc("get_admin_monthly_stats", { p_months: 6 }),
      supabase
        .from("test_requests")
        .select(
          "id, status, price_mnt, payment_status, created_at, patient:profiles!test_requests_patient_id_fkey(full_name)",
        )
        .order("created_at", { ascending: false })
        .limit(8),
      supabase
        .from("profiles")
        .select("id", { count: "exact", head: true })
        .eq("role", "doctor")
        .eq("is_verified", false),
    ]);

  const stats = statsRes.data as DashboardStats | null;
  const monthly = (monthlyRes.data ?? []) as MonthlyStat[];
  const recent = (recentRes.data ?? []) as unknown as Array<{
    id: string;
    status: string;
    price_mnt: number;
    payment_status: string | null;
    created_at: string | null;
    patient: { full_name: string | null } | null;
  }>;
  const pendingDoctors = pendingDoctorsRes.count ?? 0;

  return (
    <>
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Dashboard</h1>
          <p className="text-sm text-muted-foreground">
            CallCare operations at a glance
          </p>
        </div>
      </div>

      {pendingDoctors > 0 ? (
        <Card className="border-amber-500/30 bg-amber-500/5">
          <CardContent className="flex items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <BadgeCheck className="size-5 text-amber-400" />
              <div>
                <p className="text-sm font-medium">
                  {pendingDoctors} doctor registration
                  {pendingDoctors > 1 ? "s" : ""} awaiting verification
                </p>
                <p className="text-xs text-muted-foreground">
                  Review license details before approving.
                </p>
              </div>
            </div>
            <Button
              size="sm"
              variant="outline"
              render={<Link href="/doctors?tab=pending" />}
            >
              Review
            </Button>
          </CardContent>
        </Card>
      ) : null}

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard
          title="Revenue this month"
          value={formatMnt(stats?.revenue.this_month_paid_mnt ?? 0)}
          hint={`All-time ${formatMnt(stats?.revenue.total_paid_mnt ?? 0)}`}
          icon={Wallet}
        />
        <StatCard
          title="Requests this month"
          value={stats?.requests.this_month_total ?? 0}
          hint={`${stats?.requests.this_month_completed ?? 0} completed · ${stats?.requests.total ?? 0} all-time`}
          icon={TestTubes}
        />
        <StatCard
          title="Doctors"
          value={`${stats?.users.verified_doctors ?? 0}/${stats?.users.total_doctors ?? 0}`}
          hint={`${stats?.users.active_doctors ?? 0} available now`}
          icon={Stethoscope}
        />
        <StatCard
          title="Patients"
          value={stats?.users.total_patients ?? 0}
          hint={`${stats?.users.total_laboratories ?? 0} partner laboratories`}
          icon={Users}
        />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <RevenueChart data={monthly} />
        <RequestsChart data={monthly} />
      </div>

      <div className="grid gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle>Recent requests</CardTitle>
            <CardDescription>Latest activity across all patients</CardDescription>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Patient</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Price</TableHead>
                  <TableHead className="text-right">Created</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {recent.length === 0 ? (
                  <TableRow>
                    <TableCell
                      colSpan={4}
                      className="py-8 text-center text-muted-foreground"
                    >
                      No requests yet.
                    </TableCell>
                  </TableRow>
                ) : (
                  recent.map((r) => {
                    const s = statusStyle(requestStatusStyles, r.status);
                    return (
                      <TableRow key={r.id}>
                        <TableCell className="font-medium">
                          {r.patient?.full_name ?? "—"}
                        </TableCell>
                        <TableCell>
                          <Badge variant="outline" className={s.className}>
                            {s.label}
                          </Badge>
                        </TableCell>
                        <TableCell className="font-mono">
                          {formatMnt(r.price_mnt)}
                        </TableCell>
                        <TableCell className="text-right text-muted-foreground">
                          {formatDateTime(r.created_at)}
                        </TableCell>
                      </TableRow>
                    );
                  })
                )}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Pipeline</CardTitle>
            <CardDescription>Requests by status</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            {Object.entries(stats?.requests.by_status ?? {}).map(
              ([status, count]) => {
                const s = statusStyle(requestStatusStyles, status);
                return (
                  <div
                    key={status}
                    className="flex items-center justify-between"
                  >
                    <Badge variant="outline" className={s.className}>
                      {s.label}
                    </Badge>
                    <span className="font-mono text-sm">{count}</span>
                  </div>
                );
              },
            )}
            <div className="flex items-center justify-between border-t pt-3">
              <span className="flex items-center gap-2 text-sm text-muted-foreground">
                <CreditCard className="size-4" /> Pending QPay
              </span>
              <span className="font-mono text-sm">
                {stats?.revenue.pending_qpay ?? 0}
              </span>
            </div>
            <div className="flex items-center justify-between">
              <span className="flex items-center gap-2 text-sm text-muted-foreground">
                <Activity className="size-4" /> Manual review
              </span>
              <span className="font-mono text-sm">
                {stats?.revenue.pending_manual_review ?? 0}
              </span>
            </div>
          </CardContent>
        </Card>
      </div>
    </>
  );
}
