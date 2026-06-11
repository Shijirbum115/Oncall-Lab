import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

/**
 * Resolve the signed-in admin's profile or redirect away.
 * The proxy guarantees a session exists; this adds the role gate.
 */
export async function requireAdmin() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("profiles")
    .select("id, full_name, phone_number, role, avatar_url")
    .eq("id", user.id)
    .single();

  if (!profile || profile.role !== "admin") {
    await supabase.auth.signOut();
    redirect("/login?error=not_admin");
  }

  return profile;
}
