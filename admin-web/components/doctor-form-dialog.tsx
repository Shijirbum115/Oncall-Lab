"use client";

import { useActionState, useEffect, useState } from "react";
import { AlertCircle, Loader2, UserPlus } from "lucide-react";
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
import {
  createDoctor,
  updateDoctor,
  type DoctorFormState,
} from "@/app/(dashboard)/doctors/actions";
import type { DoctorRow } from "@/components/doctors-table";

function Field({
  label,
  children,
  className,
}: {
  label: string;
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div className={`space-y-1.5 ${className ?? ""}`}>
      <Label className="text-xs text-muted-foreground">{label}</Label>
      {children}
    </div>
  );
}

export function DoctorFormDialog({
  doctor,
  open,
  onOpenChange,
}: {
  doctor?: DoctorRow | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const isEdit = !!doctor;
  const action = isEdit ? updateDoctor.bind(null, doctor.id) : createDoctor;
  const [state, formAction, pending] = useActionState<DoctorFormState, FormData>(
    action,
    null,
  );

  useEffect(() => {
    if (state && "success" in state && open) {
      toast.success(isEdit ? "Doctor updated" : "Doctor created");
      onOpenChange(false);
    }
  }, [state, isEdit, open, onOpenChange]);

  const dp = doctor?.doctor_profiles;
  const [first = "", ...rest] = (doctor?.full_name ?? "").split(" ");

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[90svh] overflow-y-auto sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{isEdit ? "Edit doctor" : "Add doctor"}</DialogTitle>
          <DialogDescription>
            {isEdit
              ? "Update profile and professional details."
              : "Creates the doctor's login and verified profile."}
          </DialogDescription>
        </DialogHeader>

        <form action={formAction} className="space-y-4" key={doctor?.id ?? "new"}>
          <div className="grid grid-cols-2 gap-3">
            <Field label="First name">
              <Input name="first_name" defaultValue={first} required />
            </Field>
            <Field label="Last name">
              <Input name="last_name" defaultValue={rest.join(" ")} required />
            </Field>
          </div>

          {!isEdit ? (
            <div className="grid grid-cols-2 gap-3">
              <Field label="Phone (login)">
                <Input
                  name="phone"
                  inputMode="tel"
                  placeholder="99123456"
                  required
                />
              </Field>
              <Field label="Temporary password">
                <Input name="password" type="text" minLength={6} required />
              </Field>
            </div>
          ) : null}

          <Field label="Email (optional)">
            <Input
              name="email"
              type="email"
              defaultValue={doctor?.email ?? ""}
            />
          </Field>

          <div className="grid grid-cols-2 gap-3">
            <Field label="Profession">
              <Input
                name="profession"
                defaultValue={dp?.profession ?? ""}
                placeholder="General practitioner"
                required
              />
            </Field>
            <Field label="License number">
              <Input
                name="license_number"
                defaultValue={dp?.license_number ?? ""}
                required
              />
            </Field>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <Field label="Academic degree (optional)">
              <Input
                name="academic_degree"
                defaultValue={dp?.academic_degree ?? ""}
              />
            </Field>
            <Field label="Experience (years)">
              <Input
                name="work_experience_years"
                type="number"
                min={0}
                max={60}
                defaultValue={dp?.work_experience_years ?? ""}
              />
            </Field>
          </div>

          <Field label="Professional development (optional)">
            <Input
              name="professional_development"
              defaultValue={dp?.professional_development ?? ""}
            />
          </Field>

          {state && "error" in state ? (
            <div className="flex items-start gap-2 rounded-md border border-destructive/30 bg-destructive/10 px-3 py-2 text-sm text-destructive">
              <AlertCircle className="mt-0.5 size-4 shrink-0" />
              {state.error}
            </div>
          ) : null}

          <div className="flex justify-end gap-2">
            <Button
              type="button"
              variant="outline"
              onClick={() => onOpenChange(false)}
            >
              Cancel
            </Button>
            <Button type="submit" disabled={pending}>
              {pending ? <Loader2 className="size-4 animate-spin" /> : null}
              {isEdit ? "Save changes" : "Create doctor"}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}

export function AddDoctorButton() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>
        <UserPlus className="size-4" /> Add doctor
      </Button>
      <DoctorFormDialog open={open} onOpenChange={setOpen} />
    </>
  );
}
