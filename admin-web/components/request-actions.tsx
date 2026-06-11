"use client";

import { useState, useTransition } from "react";
import { Loader2, MoreHorizontal, XCircle } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cancelRequest } from "@/app/(dashboard)/requests/actions";

export function RequestActions({
  requestId,
  patientName,
  status,
}: {
  requestId: string;
  patientName: string | null;
  status: string;
}) {
  const [open, setOpen] = useState(false);
  const [reason, setReason] = useState("");
  const [isPending, startTransition] = useTransition();

  const cancellable = status !== "completed" && status !== "cancelled";
  if (!cancellable) return null;

  function runCancel() {
    startTransition(async () => {
      const res = await cancelRequest(requestId, reason);
      if (res.error) {
        toast.error(`Cancel failed: ${res.error}`);
      } else {
        toast.success("Request cancelled — patient and doctor notified");
        setOpen(false);
        setReason("");
      }
    });
  }

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger
          render={<Button variant="ghost" size="icon" className="size-8" />}
        >
          <MoreHorizontal className="size-4" />
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end" className="w-44">
          <DropdownMenuItem variant="destructive" onClick={() => setOpen(true)}>
            <XCircle className="size-4" /> Cancel request
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>

      <Dialog
        open={open}
        onOpenChange={(o) => {
          setOpen(o);
          if (!o) setReason("");
        }}
      >
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Cancel request</DialogTitle>
            <DialogDescription>
              {patientName ?? "The patient"} and the assigned doctor will be
              notified with the reason below.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-2">
            <Label htmlFor="cancel-reason">Reason</Label>
            <Input
              id="cancel-reason"
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder="e.g. Doctor unavailable, rescheduling required"
            />
          </div>
          <div className="flex justify-end gap-2">
            <Button variant="outline" onClick={() => setOpen(false)}>
              Keep request
            </Button>
            <Button
              variant="destructive"
              disabled={isPending || !reason.trim()}
              onClick={runCancel}
            >
              {isPending ? <Loader2 className="size-4 animate-spin" /> : null}
              Cancel request
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
