"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireAdmin } from "@/lib/auth";

export async function cancelRequest(requestId: string, reason: string) {
  const profile = await requireAdmin();
  if (!reason.trim()) return { error: "A cancellation reason is required." };

  const supabase = await createClient();

  // The status-transition trigger allows cancellation from any active status;
  // the notification triggers inform the patient (and doctor) automatically.
  const { error } = await supabase
    .from("test_requests")
    .update({
      status: "cancelled",
      cancellation_reason: reason.trim(),
      cancelled_by: profile.id,
      cancelled_at: new Date().toISOString(),
    })
    .eq("id", requestId)
    .not("status", "in", "(completed,cancelled)");

  if (error) return { error: error.message };

  revalidatePath("/requests");
  revalidatePath("/");
  return { error: null };
}
