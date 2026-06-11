"use client";

import { useState, useTransition } from "react";
import { KeyRound, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { resetUserPassword } from "@/app/(dashboard)/patients/actions";

export function ResetPasswordDialog({
  userId,
  userName,
  open,
  onOpenChange,
}: {
  userId: string | null;
  userName: string | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const [password, setPassword] = useState("");
  const [isPending, startTransition] = useTransition();

  function close() {
    onOpenChange(false);
    setPassword("");
  }

  function runReset() {
    if (!userId) return;
    startTransition(async () => {
      const res = await resetUserPassword(userId, password);
      if (res.error) {
        toast.error(`Reset failed: ${res.error}`);
      } else {
        toast.success(
          `Password updated — share it with ${userName ?? "the user"} securely`,
        );
        close();
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={(o) => (o ? onOpenChange(o) : close())}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>
            <span className="flex items-center gap-2">
              <KeyRound className="size-4" /> Reset password
            </span>
          </DialogTitle>
          <DialogDescription>
            Sets a new password for {userName ?? "this user"}. They sign in
            with their phone number and this password.
          </DialogDescription>
        </DialogHeader>
        <div className="space-y-2">
          <Label htmlFor="new-password">New password</Label>
          <Input
            id="new-password"
            type="text"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="At least 6 characters"
            minLength={6}
          />
        </div>
        <div className="flex justify-end gap-2">
          <Button variant="outline" onClick={close}>
            Cancel
          </Button>
          <Button
            disabled={isPending || password.length < 6}
            onClick={runReset}
          >
            {isPending ? <Loader2 className="size-4 animate-spin" /> : null}
            Set password
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
