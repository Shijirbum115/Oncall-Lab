"use client";

import { useActionState, useEffect, useState } from "react";
import { AlertCircle, FolderCog, Loader2, Pencil, Plus } from "lucide-react";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
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
  createCategory,
  updateCategory,
  type ServiceFormState,
} from "@/app/(dashboard)/services/actions";
import type { CategoryRow } from "@/components/services-table";

const TYPE_LABELS: Record<string, string> = {
  lab_test: "Lab test",
  diagnostic_procedure: "Diagnostic",
  nursing_care: "Nursing / treatment",
};

function CategoryForm({
  category,
  onDone,
}: {
  category?: CategoryRow | null;
  onDone: () => void;
}) {
  const isEdit = !!category;
  const action = isEdit ? updateCategory.bind(null, category.id) : createCategory;
  const [state, formAction, pending] = useActionState<ServiceFormState, FormData>(
    action,
    null,
  );
  const [type, setType] = useState(category?.type ?? "lab_test");

  useEffect(() => {
    if (state && "success" in state) {
      toast.success(isEdit ? "Category updated" : "Category created");
      onDone();
    }
  }, [state, isEdit, onDone]);

  return (
    <form
      action={formAction}
      className="space-y-3 rounded-lg border p-3"
      key={category?.id ?? "new"}
    >
      <p className="text-sm font-medium">
        {isEdit ? `Edit “${category.name}”` : "New category"}
      </p>
      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1.5">
          <Label className="text-xs text-muted-foreground">Name (English)</Label>
          <Input name="name" defaultValue={category?.name ?? ""} required />
        </div>
        <div className="space-y-1.5">
          <Label className="text-xs text-muted-foreground">Name (Монгол)</Label>
          <Input name="name_mn" defaultValue={category?.name_mn ?? ""} />
        </div>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1.5">
          <Label className="text-xs text-muted-foreground">Type</Label>
          <input type="hidden" name="type" value={type} />
          <Select
            value={type}
            onValueChange={(value) => setType(value ?? "lab_test")}
          >
            <SelectTrigger>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {Object.entries(TYPE_LABELS).map(([value, label]) => (
                <SelectItem key={value} value={value}>
                  {label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-1.5">
          <Label className="text-xs text-muted-foreground">
            Icon name (optional)
          </Label>
          <Input name="icon_name" defaultValue={category?.icon_name ?? ""} />
        </div>
      </div>

      {state && "error" in state ? (
        <div className="flex items-start gap-2 rounded-md border border-destructive/30 bg-destructive/10 px-3 py-2 text-sm text-destructive">
          <AlertCircle className="mt-0.5 size-4 shrink-0" />
          {state.error}
        </div>
      ) : null}

      <div className="flex justify-end gap-2">
        <Button type="button" variant="outline" size="sm" onClick={onDone}>
          Cancel
        </Button>
        <Button type="submit" size="sm" disabled={pending}>
          {pending ? <Loader2 className="size-4 animate-spin" /> : null}
          {isEdit ? "Save" : "Create"}
        </Button>
      </div>
    </form>
  );
}

export function ManageCategoriesButton({
  categories,
}: {
  categories: CategoryRow[];
}) {
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<CategoryRow | null>(null);
  const [adding, setAdding] = useState(false);

  const closeForm = () => {
    setEditing(null);
    setAdding(false);
  };

  return (
    <>
      <Button variant="outline" onClick={() => setOpen(true)}>
        <FolderCog className="size-4" /> Categories
      </Button>
      <Dialog
        open={open}
        onOpenChange={(o) => {
          setOpen(o);
          if (!o) closeForm();
        }}
      >
        <DialogContent className="max-h-[90svh] overflow-y-auto sm:max-w-lg">
          <DialogHeader>
            <DialogTitle>Service categories</DialogTitle>
            <DialogDescription>
              Categories group services in the patient app. Use the
              “Nursing / treatment” type for home-treatment services.
            </DialogDescription>
          </DialogHeader>

          {adding || editing ? (
            <CategoryForm category={editing} onDone={closeForm} />
          ) : (
            <Button
              variant="outline"
              className="w-full"
              onClick={() => setAdding(true)}
            >
              <Plus className="size-4" /> Add category
            </Button>
          )}

          <div className="space-y-1">
            {categories.map((c) => (
              <div
                key={c.id}
                className="flex items-center justify-between gap-2 rounded-md border px-3 py-2"
              >
                <div className="grid leading-tight">
                  <span className="text-sm font-medium">
                    {c.name_mn ?? c.name}
                  </span>
                  <span className="text-xs text-muted-foreground">{c.name}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Badge variant="outline">
                    {TYPE_LABELS[c.type] ?? c.type}
                  </Badge>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="size-7"
                    onClick={() => {
                      setAdding(false);
                      setEditing(c);
                    }}
                  >
                    <Pencil className="size-3.5" />
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
