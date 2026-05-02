import { getServiceClient } from "./db.ts";

interface QpayTokenLeaseRow {
  access_token: string | null;
  refresh_token: string | null;
  expires_at: string | null;
  refresh_expires_at: string | null;
  needs_refresh: boolean;
  lease_acquired: boolean;
}

interface QpayTokenResponse {
  token_type: string;
  access_token: string;
  refresh_token: string;
  expires_in: number; // unix timestamp (seconds), per V2 spec
  refresh_expires_in: number;
}

export interface QpayConfig {
  baseUrl: string;
  username: string;
  password: string;
  invoiceCode: string;
  callbackBase: string;
}

export function loadQpayConfig(): QpayConfig {
  const baseUrl = Deno.env.get("QPAY_BASE_URL") ?? "https://merchant.qpay.mn";
  const username = Deno.env.get("QPAY_USERNAME");
  const password = Deno.env.get("QPAY_PASSWORD");
  const invoiceCode = Deno.env.get("QPAY_INVOICE_CODE");
  const callbackBase = Deno.env.get("QPAY_CALLBACK_URL");
  if (!username || !password || !invoiceCode || !callbackBase) {
    throw new Error(
      "QPAY_USERNAME, QPAY_PASSWORD, QPAY_INVOICE_CODE, QPAY_CALLBACK_URL must all be set",
    );
  }
  return { baseUrl, username, password, invoiceCode, callbackBase };
}

const REFRESH_BUFFER_MS = 60_000;

async function fetchFreshToken(cfg: QpayConfig): Promise<QpayTokenResponse> {
  const basic = btoa(`${cfg.username}:${cfg.password}`);
  const res = await fetch(`${cfg.baseUrl}/v2/auth/token`, {
    method: "POST",
    headers: { Authorization: `Basic ${basic}` },
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`QPay /auth/token failed (${res.status}): ${text}`);
  }
  return await res.json();
}

async function fetchRefreshedToken(
  cfg: QpayConfig,
  refreshToken: string,
): Promise<QpayTokenResponse> {
  const res = await fetch(`${cfg.baseUrl}/v2/auth/refresh`, {
    method: "POST",
    headers: { Authorization: `Bearer ${refreshToken}` },
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`QPay /auth/refresh failed (${res.status}): ${text}`);
  }
  return await res.json();
}

async function persistToken(token: QpayTokenResponse): Promise<void> {
  const supabase = getServiceClient();
  const { error } = await supabase.rpc("qpay_persist_token", {
    p_access_token: token.access_token,
    p_refresh_token: token.refresh_token,
    p_expires_at: new Date(token.expires_in * 1000).toISOString(),
    p_refresh_expires_at: new Date(token.refresh_expires_in * 1000).toISOString(),
  });
  if (error) throw new Error(`Failed to persist QPay token: ${error.message}`);
}

const LEASE_RETRY_INTERVAL_MS = 500;
const LEASE_MAX_RETRIES = 20; // ~10 s upper bound, well under the 30 s lease.

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export async function getQpayAccessToken(): Promise<string> {
  const cfg = loadQpayConfig();
  const supabase = getServiceClient();

  for (let attempt = 0; attempt < LEASE_MAX_RETRIES; attempt++) {
    const { data, error } = await supabase.rpc("qpay_acquire_token", {
      p_buffer_seconds: Math.floor(REFRESH_BUFFER_MS / 1000),
      p_lease_seconds: 30,
    });
    if (error) {
      throw new Error(`qpay_acquire_token failed: ${error.message}`);
    }

    // RPC returns SETOF; supabase-js gives us the array.
    const row = (Array.isArray(data) ? data[0] : data) as
      | QpayTokenLeaseRow
      | undefined;
    if (!row) {
      throw new Error("qpay_acquire_token returned no row");
    }

    if (!row.needs_refresh && row.access_token) {
      return row.access_token;
    }

    if (!row.lease_acquired) {
      // Another invocation is refreshing; wait and re-read the cache.
      await sleep(LEASE_RETRY_INTERVAL_MS);
      continue;
    }

    // We hold the lease — perform the HTTP refresh and persist (which clears
    // the lease). If the call throws, the lease auto-expires after p_lease_seconds.
    const now = Date.now();
    const refreshExpiresMs = row.refresh_expires_at
      ? Date.parse(row.refresh_expires_at)
      : 0;

    let token: QpayTokenResponse;
    if (row.refresh_token && refreshExpiresMs - now > REFRESH_BUFFER_MS) {
      try {
        token = await fetchRefreshedToken(cfg, row.refresh_token);
      } catch (_e) {
        token = await fetchFreshToken(cfg);
      }
    } else {
      token = await fetchFreshToken(cfg);
    }

    await persistToken(token);
    return token.access_token;
  }

  throw new Error(
    "qpay_acquire_token: timed out waiting for another caller to refresh",
  );
}

interface QpayInvoiceCreateRequest {
  invoice_code: string;
  sender_invoice_no: string;
  invoice_receiver_code: string;
  invoice_description: string;
  amount: number;
  callback_url: string;
}

export interface QpayInvoiceCreateResponse {
  invoice_id: string;
  qr_text: string;
  qr_image: string;
  qPay_shortUrl: string;
  qPay_deeplink: Array<{
    name: string;
    description: string;
    logo: string;
    link: string;
  }>;
}

export async function qpayCreateInvoice(
  body: QpayInvoiceCreateRequest,
): Promise<QpayInvoiceCreateResponse> {
  const cfg = loadQpayConfig();
  const token = await getQpayAccessToken();
  const res = await fetch(`${cfg.baseUrl}/v2/invoice`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(body),
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`QPay /v2/invoice failed (${res.status}): ${text}`);
  }
  return await res.json();
}

export interface QpayPaymentGetResponse {
  payment_id: string;
  payment_status: "NEW" | "FAILED" | "PAID" | "PARTIAL" | "REFUNDED";
  payment_amount: string | number;
  payment_currency: string;
  payment_date?: string;
  object_type?: string;

  object_id?: string;
  [k: string]: unknown;
}

export async function qpayGetPayment(
  paymentId: string,
): Promise<QpayPaymentGetResponse> {
  const cfg = loadQpayConfig();
  const token = await getQpayAccessToken();
  const res = await fetch(
    `${cfg.baseUrl}/v2/payment/${encodeURIComponent(paymentId)}`,
    { headers: { Authorization: `Bearer ${token}` } },
  );
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`QPay /v2/payment failed (${res.status}): ${text}`);
  }
  return await res.json();
}

export interface QpayPaymentCheckResponse {
  count: number;
  paid_amount?: number;
  rows: Array<{
    payment_id: string;
    payment_status: string;
    payment_amount: string | number;
    [k: string]: unknown;
  }>;
}

export async function qpayCheckByInvoice(
  qpayInvoiceId: string,
): Promise<QpayPaymentCheckResponse> {
  const cfg = loadQpayConfig();
  const token = await getQpayAccessToken();
  const res = await fetch(`${cfg.baseUrl}/v2/payment/check`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      object_type: "INVOICE",
      object_id: qpayInvoiceId,
      offset: { page_number: 1, page_limit: 100 },
    }),
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`QPay /v2/payment/check failed (${res.status}): ${text}`);
  }
  return await res.json();
}

export async function qpayCancelInvoice(qpayInvoiceId: string): Promise<void> {
  const cfg = loadQpayConfig();
  const token = await getQpayAccessToken();
  const res = await fetch(
    `${cfg.baseUrl}/v2/invoice/${encodeURIComponent(qpayInvoiceId)}`,
    {
      method: "DELETE",
      headers: { Authorization: `Bearer ${token}` },
    },
  );
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`QPay invoice cancel failed (${res.status}): ${text}`);
  }
}
