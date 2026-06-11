"use client";

import { useState, useTransition } from "react";
import { CheckCircle2, ExternalLink, Loader2, XCircle } from "lucide-react";
import { toast } from "sonner";
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
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { formatDateTime, formatMnt } from "@/lib/format";
import {
  rejectManualPayment,
  verifyManualPayment,
} from "@/app/(dashboard)/payments/actions";

export type ManualReviewItem = {
  id: string;
  amount_mnt: number;
  status: string;
  transfer_reference: string | null;
  proof_submitted_at: string | null;
  created_at: string;
  patient_name: string | null;
  provider_name: string | null;
  proof_url: string | null;
};

export function ManualReviewList({ items }: { items: ManualReviewItem[] }) {
  const [rejecting, setRejecting] = useState<ManualReviewItem | null>(null);
  const [reason, setReason] = useState("");
  const [isPending, startTransition] = useTransition();

  if (items.length === 0) return null;

  function runVerify(item: ManualReviewItem) {
    startTransition(async () => {
      const res = await verifyManualPayment(item.id);
      if (res.error) toast.error(`Verify failed: ${res.error}`);
      else toast.success(`Payment of ${formatMnt(item.amount_mnt)} verified`);
    });
  }

  function runReject() {
    const item = rejecting;
    if (!item) return;
    startTransition(async () => {
      const res = await rejectManualPayment(item.id, reason);
      if (res.error) {
        toast.error(`Reject failed: ${res.error}`);
      } else {
        toast.success("Payment rejected — the patient will see the reason");
        setRejecting(null);
        setReason("");
      }
    });
  }

  return (
    <>
      <Card className="border-amber-500/30 bg-amber-500/5">
        <CardHeader>
          <CardTitle className="text-base">
            Manual transfers awaiting review ({items.length})
          </CardTitle>
          <CardDescription>
            Patients have sent bank transfers and are waiting for confirmation.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-3">
          {items.map((item) => (
            <div
              key={item.id}
              className="flex flex-wrap items-center justify-between gap-3 rounded-lg border bg-card p-3"
            >
              <div className="space-y-0.5">
                <p className="text-sm font-medium">
                  {item.patient_name ?? "Unknown patient"}
                  <span className="mx-2 font-mono text-base">
                    {formatMnt(item.amount_mnt)}
                  </span>
                  <Badge variant="outline" className="align-middle">
                    → {item.provider_name ?? "provider"}
                  </Badge>
                </p>
                <p className="text-xs text-muted-foreground">
                  Ref:{" "}
                  <span className="font-mono">
                    {item.transfer_reference ?? "—"}
                  </span>
                  {" · submitted "}
                  {formatDateTime(item.proof_submitted_at ?? item.created_at)}
                </p>
              </div>
              <div className="flex items-center gap-2">
                {item.proof_url ? (
                  <Button
                    variant="outline"
                    size="sm"
                    render={
                      <a
                        href={item.proof_url}
                        target="_blank"
                        rel="noreferrer"
                      />
                    }
                  >
                    <ExternalLink className="size-4" /> Proof
                  </Button>
                ) : (
                  <span className="text-xs text-muted-foreground">
                    no proof file
                  </span>
                )}
                <Button
                  size="sm"
                  disabled={isPending}
                  onClick={() => runVerify(item)}
                >
                  <CheckCircle2 className="size-4" /> Verify
                </Button>
                <Button
                  size="sm"
                  variant="destructive"
                  disabled={isPending}
                  onClick={() => setRejecting(item)}
                >
                  <XCircle className="size-4" /> Reject
                </Button>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>

      <Dialog
        open={!!rejecting}
        onOpenChange={(open) => {
          if (!open) {
            setRejecting(null);
            setReason("");
          }
        }}
      >
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Reject manual payment</DialogTitle>
            <DialogDescription>
              {rejecting
                ? `${formatMnt(rejecting.amount_mnt)} from ${rejecting.patient_name ?? "patient"}. The reason is shown to the patient.`
                : null}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-2">
            <Label htmlFor="reject-reason">Reason</Label>
            <Input
              id="reject-reason"
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder="e.g. Amount does not match the invoice"
            />
          </div>
          <div className="flex justify-end gap-2">
            <Button
              variant="outline"
              onClick={() => {
                setRejecting(null);
                setReason("");
              }}
            >
              Cancel
            </Button>
            <Button
              variant="destructive"
              disabled={isPending || !reason.trim()}
              onClick={runReject}
            >
              {isPending ? <Loader2 className="size-4 animate-spin" /> : null}
              Reject payment
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
