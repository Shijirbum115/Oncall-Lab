export const requestStatusStyles: Record<
  string,
  { label: string; className: string }
> = {
  pending: {
    label: "Pending",
    className: "bg-amber-500/15 text-amber-400 border-amber-500/30",
  },
  accepted: {
    label: "Accepted",
    className: "bg-blue-500/15 text-blue-400 border-blue-500/30",
  },
  on_the_way: {
    label: "On the way",
    className: "bg-violet-500/15 text-violet-400 border-violet-500/30",
  },
  sample_collected: {
    label: "Sample collected",
    className: "bg-cyan-500/15 text-cyan-400 border-cyan-500/30",
  },
  delivered_to_lab: {
    label: "Delivered to lab",
    className: "bg-sky-500/15 text-sky-400 border-sky-500/30",
  },
  completed: {
    label: "Completed",
    className: "bg-emerald-500/15 text-emerald-400 border-emerald-500/30",
  },
  cancelled: {
    label: "Cancelled",
    className: "bg-zinc-500/15 text-zinc-400 border-zinc-500/30",
  },
};

export const paymentStatusStyles: Record<
  string,
  { label: string; className: string }
> = {
  pending: {
    label: "Pending",
    className: "bg-amber-500/15 text-amber-400 border-amber-500/30",
  },
  payment_pending: {
    label: "Awaiting payment",
    className: "bg-amber-500/15 text-amber-400 border-amber-500/30",
  },
  awaiting_transfer: {
    label: "Awaiting transfer",
    className: "bg-amber-500/15 text-amber-400 border-amber-500/30",
  },
  proof_submitted: {
    label: "Proof submitted",
    className: "bg-blue-500/15 text-blue-400 border-blue-500/30",
  },
  payment_review: {
    label: "In review",
    className: "bg-blue-500/15 text-blue-400 border-blue-500/30",
  },
  paid: {
    label: "Paid",
    className: "bg-emerald-500/15 text-emerald-400 border-emerald-500/30",
  },
  verified: {
    label: "Verified",
    className: "bg-emerald-500/15 text-emerald-400 border-emerald-500/30",
  },
  failed: {
    label: "Failed",
    className: "bg-red-500/15 text-red-400 border-red-500/30",
  },
  payment_rejected: {
    label: "Rejected",
    className: "bg-red-500/15 text-red-400 border-red-500/30",
  },
  rejected: {
    label: "Rejected",
    className: "bg-red-500/15 text-red-400 border-red-500/30",
  },
  expired: {
    label: "Expired",
    className: "bg-zinc-500/15 text-zinc-400 border-zinc-500/30",
  },
  cancelled: {
    label: "Cancelled",
    className: "bg-zinc-500/15 text-zinc-400 border-zinc-500/30",
  },
  refunded: {
    label: "Refunded",
    className: "bg-purple-500/15 text-purple-400 border-purple-500/30",
  },
};

export function statusStyle(
  map: Record<string, { label: string; className: string }>,
  status: string | null | undefined,
) {
  if (!status) {
    return { label: "—", className: "bg-muted text-muted-foreground" };
  }
  return (
    map[status] ?? {
      label: status,
      className: "bg-muted text-muted-foreground",
    }
  );
}
