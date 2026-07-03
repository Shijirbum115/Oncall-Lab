import {
  authenticateRequest,
  corsHeaders,
  getServiceClient,
} from "../_shared/db.ts";
import {
  loadQpayConfig,
  qpayCreateInvoice,
} from "../_shared/qpay.ts";

interface RequestBody {
  test_request_id: string;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function buildSenderInvoiceNo(localId: string): string {
  // QPay's V2 spec forbids special characters in sender_invoice_no
  // ("тусгай тэмдэгт ашиглаж болохгүй"). Stick to alphanumerics: prefix + UUID hex.
  return `oncall${localId.replace(/-/g, "")}`;
}

function buildCallbackUrl(base: string, localId: string): string {
  // We only need local_id to look the row up; the callback handler then calls
  // QPay's /v2/payment/check by qpay_invoice_id, which is the documented V2
  // verification path. We deliberately do NOT rely on a {qpay_payment_id}
  // placeholder substitution — that pattern is from the V1 docs and is not
  // documented in V2 (xlsx 2026.3.17). Carrying it forward risks the callback
  // receiving the literal string `{qpay_payment_id}`.
  const url = new URL(base);
  url.searchParams.set("local_id", localId);
  return url.toString();
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return jsonResponse({ error: "Missing Authorization header" }, 401);
    }
    const auth = await authenticateRequest(authHeader);
    if ("error" in auth) {
      return jsonResponse({ error: `Invalid session: ${auth.error}` }, 401);
    }
    const userId = auth.userId;

    let body: RequestBody;
    try {
      body = await req.json();
    } catch {
      return jsonResponse({ error: "Invalid JSON body" }, 400);
    }
    if (!body.test_request_id) {
      return jsonResponse({ error: "test_request_id is required" }, 400);
    }

    const admin = getServiceClient();
    const { data: request, error: reqError } = await admin
      .from("test_requests")
      .select("id, patient_id, price_mnt, payment_status")
      .eq("id", body.test_request_id)
      .single();
    if (reqError || !request) {
      return jsonResponse({ error: "Request not found" }, 404);
    }
    if (request.patient_id !== userId) {
      return jsonResponse({ error: "Forbidden" }, 403);
    }
    if (request.payment_status === "paid") {
      return jsonResponse({ error: "Request already paid" }, 409);
    }
    const amount = Number(request.price_mnt);
    if (!Number.isFinite(amount) || amount <= 0) {
      return jsonResponse({ error: "Invalid request amount" }, 422);
    }

    const localId = crypto.randomUUID();
    const senderInvoiceNo = buildSenderInvoiceNo(localId);

    const { error: reserveError } = await admin.rpc(
      "reserve_qpay_invoice_slot",
      {
        p_local_id: localId,
        p_request_id: request.id,
        p_patient_id: userId,
        p_amount_mnt: amount,
        p_sender_invoice_no: senderInvoiceNo,
      },
    );
    if (reserveError) {
      return jsonResponse(
        { error: `Could not reserve invoice slot: ${reserveError.message}` },
        500,
      );
    }

    const cfg = loadQpayConfig();
    const callbackUrl = buildCallbackUrl(cfg.callbackBase, localId);

    let qpay;
    try {
      qpay = await qpayCreateInvoice({
        invoice_code: cfg.invoiceCode,
        sender_invoice_no: senderInvoiceNo,
        invoice_receiver_code: userId,
        // V2 spec forbids special characters in invoice_description; previously
        // we used "Oncall Lab #..." but `#` may be rejected. Stick to alnum + space.
        invoice_description: `Oncall Lab ${request.id.slice(0, 8)}`,
        amount,
        callback_url: callbackUrl,
      });
    } catch (e) {
      await admin.rpc("mark_qpay_payment_status", {
        p_local_id: localId,
        p_status: "failed",
        p_metadata: { error: (e as Error).message },
      });
      throw e;
    }

    const { error: attachError } = await admin.rpc("attach_qpay_invoice_data", {
      p_local_id: localId,
      p_qpay_invoice_id: qpay.invoice_id,
      p_qr_text: qpay.qr_text,
      p_qr_image: qpay.qr_image,
      p_short_url: qpay.qPay_shortUrl,
      p_deeplinks: qpay.qPay_deeplink ?? qpay.urls ?? [],
    });
    if (attachError) {
      return jsonResponse(
        { error: `Could not attach invoice data: ${attachError.message}` },
        500,
      );
    }

    return jsonResponse({
      qpay_payment_local_id: localId,
      qpay_invoice_id: qpay.invoice_id,
      qr_text: qpay.qr_text,
      qr_image: qpay.qr_image,
      short_url: qpay.qPay_shortUrl,
      deeplinks: qpay.qPay_deeplink ?? qpay.urls ?? [],
      amount_mnt: amount,
    });
  } catch (e) {
    console.error("qpay-create-invoice error", e);
    return jsonResponse({ error: (e as Error).message }, 500);
  }
});
