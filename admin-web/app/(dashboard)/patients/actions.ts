"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function setPatientActive(patientId: string, active: boolean) {
  await requireAdmin();
  const supabase = await createClient();

  const { error } = await supabase
    .from("profiles")
    .update({ is_active: active })
    .eq("id", patientId)
    .eq("role", "patient");

  if (error) return { error: error.message };

  revalidatePath("/patients");
  return { error: null };
}

/** Admin-side password reset — the only recovery path while logins are phone-based. */
export async function resetUserPassword(userId: string, newPassword: string) {
  await requireAdmin();

  if (newPassword.length < 6) {
    return { error: "Password must be at least 6 characters." };
  }

  let admin;
  try {
    admin = createAdminClient();
  } catch (e) {
    return { error: e instanceof Error ? e.message : "Admin key missing." };
  }

  const { error } = await admin.auth.admin.updateUserById(userId, {
    password: newPassword,
  });

  if (error) return { error: error.message };
  return { error: null };
}
