# QPay V2 Edge Functions

## Required secrets

Set on the Supabase project (do not commit):

```bash
supabase secrets set \
  QPAY_USERNAME=CALL_CARE \
  QPAY_PASSWORD=HV5oKBBG \
  QPAY_INVOICE_CODE=CALL_CARE_INVOICE \
  QPAY_BASE_URL=https://merchant.qpay.mn \
  QPAY_CALLBACK_URL=https://<project-ref>.supabase.co/functions/v1/qpay-callback
```

`SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY` are
provided automatically by the Supabase Edge Function runtime.

## Deploy

```bash
# Apply schema first
supabase db push

# Authenticated (user JWT required)
supabase functions deploy qpay-create-invoice
supabase functions deploy qpay-check-payment

# Public (QPay calls this without a JWT) — must pass --no-verify-jwt
supabase functions deploy qpay-callback --no-verify-jwt
```

## Endpoints

| Function | Method | Auth | Caller |
|---|---|---|---|
| `qpay-create-invoice` | POST | User JWT | Flutter app |
| `qpay-callback` | GET | none | QPay servers |
| `qpay-check-payment` | POST | User JWT | Flutter app (manual recheck) |

## How it fits together

1. App calls `qpay-create-invoice` with `test_request_id`.
2. Function reserves a `qpay_payments` row, calls QPay `/v2/invoice` with a
   callback URL containing the row id, then attaches the QR data.
3. App shows the QR / deeplinks. App subscribes to the `qpay_payments` row via
   Supabase Realtime to detect payment completion.
4. User pays in their bank app. QPay GETs the callback URL with
   `?qpay_payment_id=<id>&local_id=<row id>`.
5. `qpay-callback` verifies the payment via QPay `/v2/payment/{id}`, marks the
   row paid (which triggers `test_requests.payment_status = 'paid'`), and
   returns `200 SUCCESS`.
6. If the callback is missed, the user can tap a "Refresh" button which calls
   `qpay-check-payment` (uses `/v2/payment/check` once — never on a schedule).

## Testing

QPay only issued production credentials. Either:
- Ask QPay for sandbox credentials and set `QPAY_BASE_URL=https://merchant-sandbox.qpay.mn`, or
- Test against prod with low amounts and refund via `/v2/payment/refund` (admin tool TBD).
