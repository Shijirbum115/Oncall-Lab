import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import type { Database } from "@/lib/database.types";

/**
 * Service-role client for Auth admin operations (creating/deleting logins).
 * Requires SUPABASE_SECRET_KEY in .env.local — server-only, never expose
 * with NEXT_PUBLIC_.
 */
export function createAdminClient() {
  const key = process.env.SUPABASE_SECRET_KEY;
  if (!key) {
    throw new Error(
      "SUPABASE_SECRET_KEY is not set. Paste the service_role key from the Supabase dashboard (Settings → API keys) into admin-web/.env.local and restart.",
    );
  }
  return createSupabaseClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    key,
    { auth: { persistSession: false, autoRefreshToken: false } },
  );
}
