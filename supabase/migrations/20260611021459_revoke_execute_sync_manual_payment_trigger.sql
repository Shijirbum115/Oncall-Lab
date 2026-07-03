-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

revoke execute on function public.sync_request_payment_status_manual() from anon, authenticated, public;
