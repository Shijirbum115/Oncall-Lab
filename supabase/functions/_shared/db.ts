import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

let cached: SupabaseClient | null = null;

export function getServiceClient(): SupabaseClient {
  if (cached) return cached;
  const url = Deno.env.get("SUPABASE_URL");
  const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !key) {
    throw new Error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set");
  }
  cached = createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  return cached;
}

export function getUserClient(authHeader: string): SupabaseClient {
  const url = Deno.env.get("SUPABASE_URL");
  const anon = Deno.env.get("SUPABASE_ANON_KEY");
  if (!url || !anon) {
    throw new Error("SUPABASE_URL and SUPABASE_ANON_KEY must be set");
  }
  return createClient(url, anon, {
    global: { headers: { Authorization: authHeader } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
}

export function extractJwt(authHeader: string): string {
  return authHeader.replace(/^Bearer\s+/i, "").trim();
}

export async function authenticateRequest(
  authHeader: string,
): Promise<{ userId: string; client: SupabaseClient } | { error: string }> {
  const client = getUserClient(authHeader);
  const jwt = extractJwt(authHeader);
  const { data, error } = await client.auth.getUser(jwt);
  if (error || !data.user) {
    return { error: error?.message ?? "no user" };
  }
  return { userId: data.user.id, client };
}

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, POST, DELETE, OPTIONS",
};
