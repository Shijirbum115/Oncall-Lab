"use client";

import { useState, useTransition } from "react";
import {
  CircleCheck,
  CircleOff,
  MoreHorizontal,
  Pencil,
  Trash2,
} from "lucide-react";
import { toast } from "sonner";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { formatMnt } from "@/lib/format";
import {
  deleteService,
  setServiceActive,
} from "@/app/(dashboard)/services/actions";
import { ServiceFormDialog } from "@/components/service-form-dialog";

export type CategoryRow = {
  id: string;
  name: string;
  name_mn: string | null;
  type: string;
  icon_name: string | null;
};

export type ServiceRow = {
  id: string;
  category_id: string;
  name: string;
  name_mn: string | null;
  description: string | null;
  description_mn: string | null;
  sample_type: string | null;
  preparation_instructions: string | null;
  estimated_duration_minutes: number | null;
  is_active: boolean | null;
  service_categories: { name: string; name_mn: string | null } | null;
  laboratory_services: { price_mnt: number }[];
};

export function ServicesTable({
  services,
  categories,
}: {
  services: ServiceRow[];
  categories: CategoryRow[];
}) {
  const [editing, setEditing] = useState<ServiceRow | null>(null);
  const [confirmDelete, setConfirmDelete] = useState<ServiceRow | null>(null);
  const [isPending, startTransition] = useTransition();

  const runToggleActive = (s: ServiceRow, active: boolean) => {
    startTransition(async () => {
      const { error } = await setServiceActive(s.id, active);
      if (error) toast.error(error);
      else toast.success(active ? "Service activated" : "Service deactivated");
    });
  };

  const runDelete = (s: ServiceRow) => {
    startTransition(async () => {
      const { error } = await deleteService(s.id);
      if (error) toast.error(error);
      else toast.success("Service deleted");
      setConfirmDelete(null);
    });
  };

  if (!services.length) {
    return (
      <p className="py-10 text-center text-sm text-muted-foreground">
        No services match the current filter.
      </p>
    );
  }

  return (
    <>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Service</TableHead>
            <TableHead>Category</TableHead>
            <TableHead className="text-right">Price</TableHead>
            <TableHead className="text-right">Duration</TableHead>
            <TableHead>Status</TableHead>
            <TableHead className="w-10" />
          </TableRow>
        </TableHeader>
        <TableBody>
          {services.map((s) => {
            const price = s.laboratory_services?.[0]?.price_mnt;
            return (
              <TableRow key={s.id}>
                <TableCell>
                  <div className="grid leading-tight">
                    <span className="font-medium">{s.name_mn ?? s.name}</span>
                    {s.name_mn ? (
                      <span className="text-xs text-muted-foreground">
                        {s.name}
                      </span>
                    ) : null}
                  </div>
                </TableCell>
                <TableCell className="text-muted-foreground">
                  {s.service_categories?.name_mn ??
                    s.service_categories?.name ??
                    "—"}
                </TableCell>
                <TableCell className="text-right font-medium">
                  {formatMnt(price)}
                </TableCell>
                <TableCell className="text-right text-muted-foreground">
                  {s.estimated_duration_minutes
                    ? `${s.estimated_duration_minutes} min`
                    : "—"}
                </TableCell>
                <TableCell>
                  {s.is_active === false ? (
                    <Badge
                      variant="outline"
                      className="border-red-500/30 bg-red-500/15 text-red-400"
                    >
                      Inactive
                    </Badge>
                  ) : (
                    <Badge
                      variant="outline"
                      className="border-emerald-500/30 bg-emerald-500/15 text-emerald-400"
                    >
                      Active
                    </Badge>
                  )}
                </TableCell>
                <TableCell>
                  <DropdownMenu>
                    <DropdownMenuTrigger
                      render={
                        <Button variant="ghost" size="icon" className="size-8" />
                      }
                    >
                      <MoreHorizontal className="size-4" />
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end" className="w-48">
                      <DropdownMenuItem onClick={() => setEditing(s)}>
                        <Pencil className="size-4" /> Edit service
                      </DropdownMenuItem>
                      {s.is_active === false ? (
                        <DropdownMenuItem
                          disabled={isPending}
                          onClick={() => runToggleActive(s, true)}
                        >
                          <CircleCheck className="size-4" /> Activate
                        </DropdownMenuItem>
                      ) : (
                        <DropdownMenuItem
                          disabled={isPending}
                          onClick={() => runToggleActive(s, false)}
                        >
                          <CircleOff className="size-4" /> Deactivate
                        </DropdownMenuItem>
                      )}
                      <DropdownMenuSeparator />
                      <DropdownMenuItem
                        variant="destructive"
                        disabled={isPending}
                        onClick={() => setConfirmDelete(s)}
                      >
                        <Trash2 className="size-4" /> Delete
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>

      <ServiceFormDialog
        key={editing?.id ?? "new"}
        service={editing}
        categories={categories}
        open={!!editing}
        onOpenChange={(open) => {
          if (!open) setEditing(null);
        }}
      />

      <AlertDialog
        open={!!confirmDelete}
        onOpenChange={(open) => {
          if (!open) setConfirmDelete(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete this service?</AlertDialogTitle>
            <AlertDialogDescription>
              “{confirmDelete?.name_mn ?? confirmDelete?.name}” will be removed
              from the catalog. If patients have already booked it, deletion
              will fail — deactivate instead to hide it from the app.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              disabled={isPending}
              onClick={() => confirmDelete && runDelete(confirmDelete)}
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}
