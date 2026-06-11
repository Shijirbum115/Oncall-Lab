"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { phoneToEmail } from "@/lib/format";

export type LoginState = { error: string } | null;

export async function login(
  _prev: LoginState,
  formData: FormData,
): Promise<LoginState> {
  const phone = String(formData.get("phone") ?? "").trim();
  const password = String(formData.get("password") ?? "");

  if (!phone || !password) {
    return { error: "Phone number and password are required." };
  }

  const supabase = await createClient();

  const { error } = await supabase.auth.signInWithPassword({
    email: phoneToEmail(phone),
    password,
  });

  if (error) {
    return { error: "Invalid phone number or password." };
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user!.id)
    .single();

  if (profile?.role !== "admin") {
    await supabase.auth.signOut();
    return { error: "This account does not have admin access." };
  }

  redirect("/");
}

export async function logout() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}
