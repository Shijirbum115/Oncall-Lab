"use client";

import { useActionState, useEffect, useState } from "react";
import { AlertCircle, Loader2, Plus } from "lucide-react";
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
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  createService,
  updateService,
  type ServiceFormState,
} from "@/app/(dashboard)/services/actions";
import type { CategoryRow, ServiceRow } from "@/components/services-table";

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

export function ServiceFormDialog({
  service,
  categories,
  open,
  onOpenChange,
}: {
  service?: ServiceRow | null;
  categories: CategoryRow[];
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const isEdit = !!service;
  const action = isEdit ? updateService.bind(null, service.id) : createService;
  const [state, formAction, pending] = useActionState<ServiceFormState, FormData>(
    action,
    null,
  );
  // Callers remount this dialog (via key) when the target service changes,
  // so initializing from props here stays correct.
  const [categoryId, setCategoryId] = useState(service?.category_id ?? "");

  useEffect(() => {
    if (state && "success" in state && open) {
      toast.success(isEdit ? "Service updated" : "Service created");
      onOpenChange(false);
    }
  }, [state, isEdit, open, onOpenChange]);

  const price = service?.laboratory_services?.[0]?.price_mnt;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-h-[90svh] overflow-y-auto sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>{isEdit ? "Edit service" : "Add service"}</DialogTitle>
          <DialogDescription>
            {isEdit
              ? "Update catalog details and price."
              : "Adds a bookable service to the catalog with its price."}
          </DialogDescription>
        </DialogHeader>

        <form
          action={formAction}
          className="space-y-4"
          key={service?.id ?? "new"}
        >
          <Field label="Category">
            <input type="hidden" name="category_id" value={categoryId} />
            <Select
              value={categoryId}
              onValueChange={(value) => setCategoryId(value ?? "")}
            >
              <SelectTrigger>
                <SelectValue placeholder="Choose a category…" />
              </SelectTrigger>
              <SelectContent>
                {categories.map((c) => (
                  <SelectItem key={c.id} value={c.id}>
                    {c.name_mn ? `${c.name_mn} · ${c.name}` : c.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </Field>

          <div className="grid grid-cols-2 gap-3">
            <Field label="Name (English)">
              <Input name="name" defaultValue={service?.name ?? ""} required />
            </Field>
            <Field label="Name (Монгол)">
              <Input name="name_mn" defaultValue={service?.name_mn ?? ""} />
            </Field>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <Field label="Price (MNT)">
              <Input
                name="price_mnt"
                type="number"
                min={1000}
                step={500}
                defaultValue={price ?? ""}
                required
              />
            </Field>
            <Field label="Duration (minutes)">
              <Input
                name="estimated_duration_minutes"
                type="number"
                min={5}
                defaultValue={service?.estimated_duration_minutes ?? 30}
              />
            </Field>
          </div>

          <Field label="Sample type (optional)">
            <Input
              name="sample_type"
              placeholder="Blood, urine…"
              defaultValue={service?.sample_type ?? ""}
            />
          </Field>

          <Field label="Description (English, optional)">
            <Input
              name="description"
              defaultValue={service?.description ?? ""}
            />
          </Field>
          <Field label="Description (Монгол, optional)">
            <Input
              name="description_mn"
              defaultValue={service?.description_mn ?? ""}
            />
          </Field>

          <Field label="Preparation instructions (optional)">
            <Input
              name="preparation_instructions"
              placeholder="8–12 цаг өлөн байх…"
              defaultValue={service?.preparation_instructions ?? ""}
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
              {isEdit ? "Save changes" : "Create service"}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}

export function AddServiceButton({ categories }: { categories: CategoryRow[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>
        <Plus className="size-4" /> Add service
      </Button>
      <ServiceFormDialog
        categories={categories}
        open={open}
        onOpenChange={setOpen}
      />
    </>
  );
}
