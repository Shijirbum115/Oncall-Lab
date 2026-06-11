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
import {
  ManualReviewList,
  type ManualReviewItem,
} from "@/components/manual-review";
import { createClient } from "@/lib/supabase/server";
import { formatDateTime, formatMnt } from "@/lib/format";
import { paymentStatusStyles, statusStyle } from "@/lib/status";

export default async function PaymentsPage() {
  const supabase = await createClient();

  const [{ data }, { data: reviewRows }] = await Promise.all([
    supabase.rpc("get_admin_payment_history", { p_limit: 200, p_offset: 0 }),
    supabase
      .from("manual_payments")
      .select(
        "id,amount_mnt,status,transfer_reference,proof_file_path,proof_submitted_at,created_at,patient:profiles!manual_payments_patient_id_fkey(full_name),provider:profiles!manual_payments_provider_profile_id_fkey(full_name)",
      )
      .eq("status", "proof_submitted")
      .order("proof_submitted_at", { ascending: true }),
  ]);

  const reviewItems: ManualReviewItem[] = await Promise.all(
    ((reviewRows ?? []) as unknown as Array<{
      id: string;
      amount_mnt: number;
      status: string;
      transfer_reference: string | null;
      proof_file_path: string | null;
      proof_submitted_at: string | null;
      created_at: string;
      patient: { full_name: string | null } | null;
      provider: { full_name: string | null } | null;
    }>).map(async (row) => {
      let proofUrl: string | null = null;
      if (row.proof_file_path) {
        const { data: signed } = await supabase.storage
          .from("manual-payment-proofs")
          .createSignedUrl(row.proof_file_path, 60 * 60);
        proofUrl = signed?.signedUrl ?? null;
      }
      return {
        id: row.id,
        amount_mnt: row.amount_mnt,
        status: row.status,
        transfer_reference: row.transfer_reference,
        proof_submitted_at: row.proof_submitted_at,
        created_at: row.created_at,
        patient_name: row.patient?.full_name ?? null,
        provider_name: row.provider?.full_name ?? null,
        proof_url: proofUrl,
      };
    }),
  );

  const payments = data ?? [];
  const totalPaid = payments
    .filter((p) => p.status === "paid" || p.status === "verified")
    .reduce((sum, p) => sum + (p.amount_mnt ?? 0), 0);

  return (
    <>
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">Payments</h1>
        <p className="text-sm text-muted-foreground">
          {payments.length} records · {formatMnt(totalPaid)} collected in this
          view
        </p>
      </div>

      <ManualReviewList items={reviewItems} />

      <Card>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Patient</TableHead>
                <TableHead>Method</TableHead>
                <TableHead>Amount</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Created</TableHead>
                <TableHead className="text-right">Paid</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {payments.length === 0 ? (
                <TableRow>
                  <TableCell
                    colSpan={6}
                    className="py-10 text-center text-muted-foreground"
                  >
                    No payments yet.
                  </TableCell>
                </TableRow>
              ) : (
                payments.map((p) => {
                  const s = statusStyle(paymentStatusStyles, p.status);
                  return (
                    <TableRow key={p.payment_id}>
                      <TableCell className="font-medium">
                        {p.patient_name ?? "—"}
                      </TableCell>
                      <TableCell>
                        <Badge variant="secondary" className="uppercase">
                          {p.source}
                        </Badge>
                      </TableCell>
                      <TableCell className="font-mono">
                        {formatMnt(p.amount_mnt)}
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline" className={s.className}>
                          {s.label}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-muted-foreground">
                        {formatDateTime(p.created_at)}
                      </TableCell>
                      <TableCell className="text-right text-muted-foreground">
                        {formatDateTime(p.paid_at)}
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
