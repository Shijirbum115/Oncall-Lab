"use client";

import { useState, useTransition } from "react";
import { KeyRound, MoreHorizontal, UserCheck, UserX } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { ResetPasswordDialog } from "@/components/reset-password-dialog";
import { setPatientActive } from "@/app/(dashboard)/patients/actions";

export function PatientActions({
  patientId,
  patientName,
  isActive,
}: {
  patientId: string;
  patientName: string | null;
  isActive: boolean;
}) {
  const [resetOpen, setResetOpen] = useState(false);
  const [isPending, startTransition] = useTransition();

  function runActive(active: boolean) {
    startTransition(async () => {
      const res = await setPatientActive(patientId, active);
      if (res.error) {
        toast.error(`Failed: ${res.error}`);
      } else {
        toast.success(
          `${patientName ?? "Patient"} ${active ? "enabled" : "disabled"}`,
        );
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
        <DropdownMenuContent align="end" className="w-48">
          <DropdownMenuItem onClick={() => setResetOpen(true)}>
            <KeyRound className="size-4" /> Reset password
          </DropdownMenuItem>
          {isActive ? (
            <DropdownMenuItem
              disabled={isPending}
              onClick={() => runActive(false)}
            >
              <UserX className="size-4" /> Disable account
            </DropdownMenuItem>
          ) : (
            <DropdownMenuItem
              disabled={isPending}
              onClick={() => runActive(true)}
            >
              <UserCheck className="size-4" /> Enable account
            </DropdownMenuItem>
          )}
        </DropdownMenuContent>
      </DropdownMenu>

      <ResetPasswordDialog
        userId={patientId}
        userName={patientName}
        open={resetOpen}
        onOpenChange={setResetOpen}
      />
    </>
  );
}
