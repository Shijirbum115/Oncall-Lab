-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

create or replace function public.sync_request_payment_status_manual()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
begin
  if new.status = 'verified' and old.status is distinct from new.status then
    update public.test_requests
    set payment_status = 'paid',
        updated_at = now()
    where id = new.test_request_id;
  end if;

  return new;
end;
$function$;

drop trigger if exists trg_sync_request_payment_status_manual on public.manual_payments;
create trigger trg_sync_request_payment_status_manual
  after update on public.manual_payments
  for each row
  execute function public.sync_request_payment_status_manual();
