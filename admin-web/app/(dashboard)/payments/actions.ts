"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { requireAdmin } from "@/lib/auth";

export async function verifyManualPayment(manualPaymentId: string) {
  await requireAdmin();
  const supabase = await createClient();

  const { data, error } = await supabase.rpc("verify_manual_payment", {
    p_manual_payment_id: manualPaymentId,
  });

  if (error) return { error: error.message };
  if (!data) return { error: "Payment was not in a reviewable state." };

  revalidatePath("/payments");
  revalidatePath("/");
  return { error: null };
}

export async function rejectManualPayment(
  manualPaymentId: string,
  reason: string,
) {
  await requireAdmin();
  if (!reason.trim()) return { error: "A rejection reason is required." };

  const supabase = await createClient();

  const { data, error } = await supabase.rpc("reject_manual_payment", {
    p_manual_payment_id: manualPaymentId,
    p_reason: reason.trim(),
  });

  if (error) return { error: error.message };
  if (!data) return { error: "Payment was not in a reviewable state." };

  revalidatePath("/payments");
  revalidatePath("/");
  return { error: null };
}
