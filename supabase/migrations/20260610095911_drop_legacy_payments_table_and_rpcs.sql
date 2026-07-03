-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- The payments table was superseded by qpay_payments + manual_payments.
-- It has 0 rows and the only client code path referencing it is dead
-- (QPayPaymentWidget is never instantiated). Removing the table and its RPCs.
drop function if exists public.create_payment(uuid, uuid, integer, public.payment_method, text, text, jsonb);
drop function if exists public.complete_payment(uuid, text, text);
drop function if exists public.fail_payment(uuid, text);
drop function if exists public.cancel_payment(uuid, text);
drop function if exists public.get_payment_by_request(uuid);
drop function if exists public.get_user_payment_history(uuid, integer, integer);
drop table if exists public.payments;
