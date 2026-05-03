import {
  corsHeaders,
  getServiceClient,
  getUserClient,
} from "../_shared/db.ts";
import { qpayCheckByInvoice } from "../_shared/qpay.ts";

interface RequestBody {
  qpay_payment_local_id: string;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
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

    const userClient = getUserClient(authHeader);
    const { data: userData, error: userError } = await userClient.auth.getUser();
    if (userError || !userData.user) {
      return jsonResponse({ error: "Invalid session" }, 401);
    }
    const userId = userData.user.id;

    let body: RequestBody;
    try {
      body = await req.json();
    } catch {
      return jsonResponse({ error: "Invalid JSON body" }, 400);
    }
    if (!body.qpay_payment_local_id) {
      return jsonResponse({ error: "qpay_payment_local_id is required" }, 400);
    }

    const admin = getServiceClient();
    const { data: row, error: rowError } = await admin
      .from("qpay_payments")
      .select("id, patient_id, amount_mnt, status, qpay_invoice_id")
      .eq("id", body.qpay_payment_local_id)
      .single();
    if (rowError || !row) {
      return jsonResponse({ error: "Invoice not found" }, 404);
    }
    if (row.patient_id !== userId) {
      return jsonResponse({ error: "Forbidden" }, 403);
    }
    if (row.status === "paid") {
      return jsonResponse({ status: "paid" });
    }
    if (!row.qpay_invoice_id) {
      return jsonResponse(
        { error: "QPay invoice not yet attached to this row" },
        409,
      );
    }

    const check = await qpayCheckByInvoice(row.qpay_invoice_id);

    // Spec defines payment_status: NEW | FAILED | PAID | PARTIAL | REFUNDED.
    // Surface PARTIAL explicitly so the client can show "you've paid only X
    // of Y" instead of treating it as not-paid.
    const partialRow = check.rows?.find((r) => r.payment_status === "PARTIAL");
    if (partialRow) {
      return jsonResponse({
        status: row.status,
        qpay_status: "PARTIAL",
        paid_amount: Number(partialRow.payment_amount),
        expected_amount: row.amount_mnt,
      });
    }

    const paidRow = check.rows?.find((r) => r.payment_status === "PAID");
    if (!paidRow) {
      return jsonResponse({ status: row.status, qpay_status: "NOT_PAID" });
    }

    const paidAmount = Number(paidRow.payment_amount);
    if (!Number.isFinite(paidAmount) || paidAmount !== row.amount_mnt) {
      return jsonResponse(
        {
          error: "Amount mismatch",
          expected: row.amount_mnt,
          got: paidAmount,
        },
        409,
      );
    }

    const { error: rpcError } = await admin.rpc("mark_qpay_payment_paid", {
      p_local_id: row.id,
      p_qpay_payment_id: paidRow.payment_id,
      p_amount_mnt: row.amount_mnt,
      p_metadata: { source: "user_check" },
    });
    if (rpcError) {
      return jsonResponse(
        { error: `Failed to mark paid: ${rpcError.message}` },
        500,
      );
    }

    return jsonResponse({ status: "paid" });
  } catch (e) {
    console.error("qpay-check-payment error", e);
    return jsonResponse({ error: (e as Error).message }, 500);
  }
});
