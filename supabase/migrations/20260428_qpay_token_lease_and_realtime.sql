-- Patches the QPay foundation that's already applied in prod:
--   1. Adds qpay_tokens.lock_until column (lease for serializing token refresh)
--   2. Replaces the (claimed-but-not-implemented) "SELECT FOR UPDATE" pattern
--      with two RPCs: qpay_acquire_token + qpay_persist_token, using
--      pg_advisory_xact_lock + lock_until lease so the serialization can span
--      the QPay HTTP roundtrip.
--   3. Adds public.qpay_payments to the supabase_realtime publication so the
--      Flutter client's .stream() actually receives status updates.

begin;

alter table public.qpay_tokens
  add column if not exists lock_until timestamptz;

create or replace function public.qpay_acquire_token(
  p_buffer_seconds integer default 60,
  p_lease_seconds integer default 30
)
returns table (
  access_token text,
  refresh_token text,
  expires_at timestamptz,
  refresh_expires_at timestamptz,
  needs_refresh boolean,
  lease_acquired boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_now timestamptz := now();
  v_row record;
  v_needs boolean;
begin
  perform pg_advisory_xact_lock(hashtext('qpay_token_lease'));

  select t.access_token,
         t.refresh_token,
         t.expires_at,
         t.refresh_expires_at,
         t.lock_until
    into v_row
  from public.qpay_tokens t
  where t.id = true;

  v_needs := v_row.access_token is null
          or v_row.expires_at is null
          or v_row.expires_at <= v_now + make_interval(secs => p_buffer_seconds);

  if not v_needs then
    return query select v_row.access_token,
                        v_row.refresh_token,
                        v_row.expires_at,
                        v_row.refresh_expires_at,
                        false,
                        false;
    return;
  end if;

  if v_row.lock_until is not null and v_row.lock_until > v_now then
    return query select v_row.access_token,
                        v_row.refresh_token,
                        v_row.expires_at,
                        v_row.refresh_expires_at,
                        true,
                        false;
    return;
  end if;

  update public.qpay_tokens
  set lock_until = v_now + make_interval(secs => p_lease_seconds)
  where id = true;

  return query select v_row.access_token,
                      v_row.refresh_token,
                      v_row.expires_at,
                      v_row.refresh_expires_at,
                      true,
                      true;
end;
$$;

create or replace function public.qpay_persist_token(
  p_access_token text,
  p_refresh_token text,
  p_expires_at timestamptz,
  p_refresh_expires_at timestamptz
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.qpay_tokens
  set access_token = p_access_token,
      refresh_token = p_refresh_token,
      expires_at = p_expires_at,
      refresh_expires_at = p_refresh_expires_at,
      lock_until = null,
      updated_at = now()
  where id = true;
end;
$$;

revoke all on function public.qpay_acquire_token(integer, integer) from public, anon, authenticated;
revoke all on function public.qpay_persist_token(text, text, timestamptz, timestamptz) from public, anon, authenticated;

grant execute on function public.qpay_acquire_token(integer, integer) to service_role;
grant execute on function public.qpay_persist_token(text, text, timestamptz, timestamptz) to service_role;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'qpay_payments'
  ) then
    execute 'alter publication supabase_realtime add table public.qpay_payments';
  end if;
end$$;

commit;
