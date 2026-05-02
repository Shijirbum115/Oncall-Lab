import { getServiceClient } from "../_shared/db.ts";
import { qpayCheckByInvoice } from "../_shared/qpay.ts";

// Per QPay V2 spec the callback MUST always reply with HTTP 200 and body
// "SUCCESS". Any other response is forbidden. We log errors instead of
// surfacing them, and rely on user-triggered "I've paid" rechecks as a
// secondary recovery path.
const SUCCESS_RESPONSE = new Response("SUCCESS", {
  status: 200,
  headers: { "Content-Type": "text/plain" },
});

Deno.serve(async (req) => {
  const url = new URL(req.url);
  const localId = url.searchParams.get("local_id");

  if (!localId) {
    console.warn("qpay-callback missing local_id", { url: url.toString() });
    return SUCCESS_RESPONSE;
  }

  try {
    const admin = getServiceClient();

    const { data: row, error: rowError } = await admin
      .from("qpay_payments")
      .select("id, amount_mnt, status, qpay_invoice_id")
      .eq("id", localId)
      .single();

    if (rowError || !row) {
      console.error("qpay-callback: row not found", { localId, rowError });
      return SUCCESS_RESPONSE;
    }
    if (row.status === "paid") {
      // Duplicate callback — already processed.
      return SUCCESS_RESPONSE;
    }
    if (!row.qpay_invoice_id) {
      console.error("qpay-callback: row has no qpay_invoice_id", { localId });
      return SUCCESS_RESPONSE;
    }

    // Verify against QPay using the documented V2 path: POST /v2/payment/check
    // with object_type=INVOICE. This avoids depending on a {qpay_payment_id}
    // placeholder substitution that's not documented in the V2 spec.
    const check = await qpayCheckByInvoice(row.qpay_invoice_id);

    const partialRow = check.rows?.find((r) => r.payment_status === "PARTIAL");
    if (partialRow) {
      console.warn("qpay-callback: PARTIAL payment received", {
        localId,
        qpayInvoiceId: row.qpay_invoice_id,
        partial: partialRow,
      });
      return SUCCESS_RESPONSE;
    }

    const paidRow = check.rows?.find((r) => r.payment_status === "PAID");
    if (!paidRow) {
      console.warn("qpay-callback: no PAID row in check response", {
        localId,
        rows: check.rows?.map((r) => r.payment_status),
      });
      return SUCCESS_RESPONSE;
    }

    const paidAmount = Number(paidRow.payment_amount);
    if (!Number.isFinite(paidAmount) || paidAmount !== row.amount_mnt) {
      console.error("qpay-callback: amount mismatch", {
        localId,
        expected: row.amount_mnt,
        got: paidAmount,
      });
      return SUCCESS_RESPONSE;
    }

    const { error: rpcError } = await admin.rpc("mark_qpay_payment_paid", {
      p_local_id: localId,
      p_qpay_payment_id: paidRow.payment_id,
      p_amount_mnt: row.amount_mnt,
      p_metadata: {
        source: "callback",
        payment_currency: (paidRow as { payment_currency?: string })
          .payment_currency,
        payment_date: (paidRow as { payment_date?: string }).payment_date,
      },
    });
    if (rpcError) {
      console.error("qpay-callback: rpc error", rpcError);
    }
  } catch (e) {
    console.error("qpay-callback unhandled error", e);
  }

  return SUCCESS_RESPONSE;
});
