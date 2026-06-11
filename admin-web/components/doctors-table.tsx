"use client";

import { useState, useTransition } from "react";
import {
  BadgeCheck,
  BadgeX,
  Eye,
  KeyRound,
  MoreHorizontal,
  Pencil,
  Star,
  Trash2,
  UserCheck,
  UserX,
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
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Separator } from "@/components/ui/separator";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { formatDate, initials } from "@/lib/format";
import {
  deleteDoctor,
  setDoctorActive,
  setDoctorVerified,
} from "@/app/(dashboard)/doctors/actions";
import { DoctorFormDialog } from "@/components/doctor-form-dialog";
import { ResetPasswordDialog } from "@/components/reset-password-dialog";

export type DoctorRow = {
  id: string;
  full_name: string | null;
  phone_number: string;
  email: string | null;
  avatar_url: string | null;
  is_active: boolean | null;
  is_verified: boolean | null;
  created_at: string | null;
  doctor_profiles: {
    profession: string | null;
    license_number: string | null;
    academic_degree: string | null;
    work_experience_years: number | null;
    professional_development: string | null;
    photo_url: string | null;
    rating: number | null;
    total_reviews: number | null;
    total_completed_requests: number | null;
    is_available: boolean | null;
  } | null;
};

function DetailRow({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="flex items-start justify-between gap-4 py-2">
      <span className="text-sm text-muted-foreground">{label}</span>
      <span className="text-right text-sm font-medium">{value ?? "—"}</span>
    </div>
  );
}

export function DoctorsTable({ doctors }: { doctors: DoctorRow[] }) {
  const [selected, setSelected] = useState<DoctorRow | null>(null);
  const [confirmUnverify, setConfirmUnverify] = useState<DoctorRow | null>(null);
  const [confirmDelete, setConfirmDelete] = useState<DoctorRow | null>(null);
  const [editing, setEditing] = useState<DoctorRow | null>(null);
  const [resetting, setResetting] = useState<DoctorRow | null>(null);
  const [isPending, startTransition] = useTransition();

  function runDelete(doctor: DoctorRow) {
    startTransition(async () => {
      const res = await deleteDoctor(doctor.id);
      if (res.error) {
        toast.error(`Failed to delete: ${res.error}`);
      } else {
        toast.success(`${doctor.full_name ?? "Doctor"} deleted`);
      }
    });
  }

  function runVerify(doctor: DoctorRow, verified: boolean) {
    startTransition(async () => {
      const res = await setDoctorVerified(doctor.id, verified);
      if (res.error) {
        toast.error(`Failed to update: ${res.error}`);
      } else {
        toast.success(
          verified
            ? `${doctor.full_name ?? "Doctor"} verified`
            : `${doctor.full_name ?? "Doctor"} verification revoked`,
        );
      }
    });
  }

  function runActive(doctor: DoctorRow, active: boolean) {
    startTransition(async () => {
      const res = await setDoctorActive(doctor.id, active);
      if (res.error) {
        toast.error(`Failed to update: ${res.error}`);
      } else {
        toast.success(
          `${doctor.full_name ?? "Doctor"} ${active ? "activated" : "deactivated"}`,
        );
      }
    });
  }

  return (
    <>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Doctor</TableHead>
            <TableHead>Profession</TableHead>
            <TableHead>License</TableHead>
            <TableHead>Rating</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Registered</TableHead>
            <TableHead className="w-12" />
          </TableRow>
        </TableHeader>
        <TableBody>
          {doctors.length === 0 ? (
            <TableRow>
              <TableCell
                colSpan={7}
                className="py-10 text-center text-muted-foreground"
              >
                No doctors in this view.
              </TableCell>
            </TableRow>
          ) : (
            doctors.map((d) => (
              <TableRow key={d.id}>
                <TableCell>
                  <div className="flex items-center gap-3">
                    <Avatar className="size-8">
                      <AvatarImage
                        src={d.doctor_profiles?.photo_url ?? d.avatar_url ?? undefined}
                      />
                      <AvatarFallback>{initials(d.full_name)}</AvatarFallback>
                    </Avatar>
                    <div className="grid leading-tight">
                      <span className="font-medium">{d.full_name ?? "—"}</span>
                      <span className="font-mono text-xs text-muted-foreground">
                        {d.phone_number}
                      </span>
                    </div>
                  </div>
                </TableCell>
                <TableCell>{d.doctor_profiles?.profession ?? "—"}</TableCell>
                <TableCell className="font-mono text-xs">
                  {d.doctor_profiles?.license_number ?? "—"}
                </TableCell>
                <TableCell>
                  <span className="flex items-center gap-1 font-mono text-sm">
                    <Star className="size-3.5 fill-amber-400 text-amber-400" />
                    {(d.doctor_profiles?.rating ?? 0).toFixed(1)}
                    <span className="text-xs text-muted-foreground">
                      ({d.doctor_profiles?.total_reviews ?? 0})
                    </span>
                  </span>
                </TableCell>
                <TableCell>
                  <div className="flex flex-wrap gap-1">
                    {d.is_verified ? (
                      <Badge
                        variant="outline"
                        className="border-emerald-500/30 bg-emerald-500/15 text-emerald-400"
                      >
                        Verified
                      </Badge>
                    ) : (
                      <Badge
                        variant="outline"
                        className="border-amber-500/30 bg-amber-500/15 text-amber-400"
                      >
                        Pending
                      </Badge>
                    )}
                    {d.is_active === false ? (
                      <Badge
                        variant="outline"
                        className="border-red-500/30 bg-red-500/15 text-red-400"
                      >
                        Disabled
                      </Badge>
                    ) : null}
                    {d.doctor_profiles?.is_available ? (
                      <Badge
                        variant="outline"
                        className="border-blue-500/30 bg-blue-500/15 text-blue-400"
                      >
                        Available
                      </Badge>
                    ) : null}
                  </div>
                </TableCell>
                <TableCell className="text-muted-foreground">
                  {formatDate(d.created_at)}
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
                      <DropdownMenuItem onClick={() => setSelected(d)}>
                        <Eye className="size-4" /> View details
                      </DropdownMenuItem>
                      <DropdownMenuItem onClick={() => setEditing(d)}>
                        <Pencil className="size-4" /> Edit details
                      </DropdownMenuItem>
                      <DropdownMenuItem onClick={() => setResetting(d)}>
                        <KeyRound className="size-4" /> Reset password
                      </DropdownMenuItem>
                      <DropdownMenuSeparator />
                      {d.is_verified ? (
                        <DropdownMenuItem
                          disabled={isPending}
                          onClick={() => setConfirmUnverify(d)}
                        >
                          <BadgeX className="size-4" /> Revoke verification
                        </DropdownMenuItem>
                      ) : (
                        <DropdownMenuItem
                          disabled={isPending}
                          onClick={() => runVerify(d, true)}
                        >
                          <BadgeCheck className="size-4" /> Verify doctor
                        </DropdownMenuItem>
                      )}
                      {d.is_active === false ? (
                        <DropdownMenuItem
                          disabled={isPending}
                          onClick={() => runActive(d, true)}
                        >
                          <UserCheck className="size-4" /> Enable account
                        </DropdownMenuItem>
                      ) : (
                        <DropdownMenuItem
                          disabled={isPending}
                          onClick={() => runActive(d, false)}
                        >
                          <UserX className="size-4" /> Disable account
                        </DropdownMenuItem>
                      )}
                      <DropdownMenuSeparator />
                      <DropdownMenuItem
                        variant="destructive"
                        disabled={isPending}
                        onClick={() => setConfirmDelete(d)}
                      >
                        <Trash2 className="size-4" /> Delete doctor
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </TableCell>
              </TableRow>
            ))
          )}
        </TableBody>
      </Table>

      <Sheet open={!!selected} onOpenChange={(open) => !open && setSelected(null)}>
        <SheetContent className="overflow-y-auto sm:max-w-md">
          {selected ? (
            <>
              <SheetHeader>
                <div className="flex items-center gap-3">
                  <Avatar className="size-12">
                    <AvatarImage
                      src={
                        selected.doctor_profiles?.photo_url ??
                        selected.avatar_url ??
                        undefined
                      }
                    />
                    <AvatarFallback>{initials(selected.full_name)}</AvatarFallback>
                  </Avatar>
                  <div>
                    <SheetTitle>{selected.full_name ?? "Doctor"}</SheetTitle>
                    <SheetDescription>
                      {selected.doctor_profiles?.profession ?? "Doctor"}
                    </SheetDescription>
                  </div>
                </div>
              </SheetHeader>
              <div className="space-y-1 px-4">
                <DetailRow label="Phone" value={selected.phone_number} />
                <DetailRow label="Email" value={selected.email} />
                <DetailRow
                  label="License number"
                  value={selected.doctor_profiles?.license_number}
                />
                <DetailRow
                  label="Academic degree"
                  value={selected.doctor_profiles?.academic_degree}
                />
                <DetailRow
                  label="Experience"
                  value={
                    selected.doctor_profiles?.work_experience_years != null
                      ? `${selected.doctor_profiles.work_experience_years} years`
                      : "—"
                  }
                />
                <DetailRow
                  label="Professional development"
                  value={selected.doctor_profiles?.professional_development}
                />
                <Separator className="my-2" />
                <DetailRow
                  label="Rating"
                  value={`${(selected.doctor_profiles?.rating ?? 0).toFixed(1)} (${selected.doctor_profiles?.total_reviews ?? 0} reviews)`}
                />
                <DetailRow
                  label="Completed requests"
                  value={selected.doctor_profiles?.total_completed_requests ?? 0}
                />
                <DetailRow
                  label="Registered"
                  value={formatDate(selected.created_at)}
                />
                <Separator className="my-2" />
                <div className="flex gap-2 py-3">
                  {selected.is_verified ? (
                    <Button
                      variant="outline"
                      className="flex-1"
                      disabled={isPending}
                      onClick={() => {
                        setConfirmUnverify(selected);
                        setSelected(null);
                      }}
                    >
                      <BadgeX className="size-4" /> Revoke
                    </Button>
                  ) : (
                    <Button
                      className="flex-1"
                      disabled={isPending}
                      onClick={() => {
                        runVerify(selected, true);
                        setSelected(null);
                      }}
                    >
                      <BadgeCheck className="size-4" /> Verify doctor
                    </Button>
                  )}
                </div>
              </div>
            </>
          ) : null}
        </SheetContent>
      </Sheet>

      <DoctorFormDialog
        doctor={editing}
        open={!!editing}
        onOpenChange={(open) => !open && setEditing(null)}
      />

      <ResetPasswordDialog
        userId={resetting?.id ?? null}
        userName={resetting?.full_name ?? null}
        open={!!resetting}
        onOpenChange={(open) => !open && setResetting(null)}
      />

      <AlertDialog
        open={!!confirmDelete}
        onOpenChange={(open) => !open && setConfirmDelete(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete doctor?</AlertDialogTitle>
            <AlertDialogDescription>
              This permanently removes {confirmDelete?.full_name ?? "this doctor"}
              &apos;s login, profile, and professional details. Their past
              requests and reviews remain for record-keeping. This cannot be
              undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={() => {
                if (confirmDelete) runDelete(confirmDelete);
                setConfirmDelete(null);
              }}
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog
        open={!!confirmUnverify}
        onOpenChange={(open) => !open && setConfirmUnverify(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Revoke verification?</AlertDialogTitle>
            <AlertDialogDescription>
              {confirmUnverify?.full_name ?? "This doctor"} will no longer be
              visible to patients and will be marked unavailable until verified
              again.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={() => {
                if (confirmUnverify) runVerify(confirmUnverify, false);
                setConfirmUnverify(null);
              }}
            >
              Revoke
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}
