begin;

-- ============================================
-- 1) TABLES
-- ============================================

-- Single-row token cache. Concurrent edge function invocations must not
-- double-fetch from QPay (the spec forbids repeatedly issuing tokens within a
-- validity window). Serialization is enforced via the qpay_acquire_token RPC,
-- which combines pg_advisory_xact_lock with a `lock_until` lease so the lease
-- can span the QPay HTTP call without holding a Postgres transaction open.
create table if not exists public.qpay_tokens (
  id boolean primary key default true,
  access_token text,
  refresh_token text,
  expires_at timestamptz,
  refresh_expires_at timestamptz,
  lock_until timestamptz,
  updated_at timestamptz not null default now(),
  constraint qpay_tokens_singleton check (id = true)
);

-- Backfill column when migration is re-applied on an environment that already
-- has the table (idempotent).
alter table public.qpay_tokens
  add column if not exists lock_until timestamptz;

insert into public.qpay_tokens (id) values (true)
  on conflict (id) do nothing;

create table if not exists public.qpay_payments (
  id uuid primary key default gen_random_uuid(),
  test_request_id uuid not null references public.test_requests(id) on delete cascade,
  patient_id uuid not null references public.profiles(id) on delete cascade,
  amount_mnt integer not null check (amount_mnt > 0),
  sender_invoice_no text not null unique,
  qpay_invoice_id text,
  qpay_payment_id text,
  status text not null check (
    status in ('pending', 'paid', 'failed', 'cancelled', 'refunded', 'expired')
  ),
  qr_text text,
  qr_image text,
  short_url text,
  deeplinks jsonb not null default '[]'::jsonb,
  paid_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Only one active (pending) invoice per request. New attempts must cancel the
-- prior pending row first.
create unique index if not exists uniq_qpay_payments_active_per_request
  on public.qpay_payments (test_request_id)
  where status = 'pending';

create index if not exists idx_qpay_payments_patient
  on public.qpay_payments (patient_id);

create index if not exists idx_qpay_payments_request
  on public.qpay_payments (test_request_id);

create index if not exists idx_qpay_payments_qpay_invoice
  on public.qpay_payments (qpay_invoice_id);

create index if not exists idx_qpay_payments_status
  on public.qpay_payments (status);

-- ============================================
-- 2) TRIGGERS
-- ============================================

create or replace function public.update_qpay_payments_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_qpay_payments_updated_at on public.qpay_payments;
create trigger trg_qpay_payments_updated_at
before update on public.qpay_payments
for each row
execute function public.update_qpay_payments_updated_at();

create or replace function public.update_qpay_tokens_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_qpay_tokens_updated_at on public.qpay_tokens;
create trigger trg_qpay_tokens_updated_at
before update on public.qpay_tokens
for each row
execute function public.update_qpay_tokens_updated_at();

-- Mirror QPay payment status onto test_requests.payment_status, matching the
-- semantics used by manual_payments (payment_pending / paid / cancelled).
create or replace function public.sync_request_payment_status_qpay()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_target_status text;
begin
  v_target_status := case new.status
    when 'pending'   then 'payment_pending'
    when 'paid'      then 'paid'
    when 'failed'    then 'payment_rejected'
    when 'cancelled' then 'cancelled'
    when 'expired'   then 'cancelled'
    when 'refunded'  then 'refunded'
    else null
  end;

  if v_target_status is null then
    return new;
  end if;

  update public.test_requests
  set payment_status = v_target_status,
      updated_at = now()
  where id = new.test_request_id;

  return new;
end;
$$;

drop trigger if exists trg_sync_request_payment_status_qpay on public.qpay_payments;
create trigger trg_sync_request_payment_status_qpay
after insert or update of status on public.qpay_payments
for each row
execute function public.sync_request_payment_status_qpay();

-- ============================================
-- 3) RLS
-- ============================================

alter table public.qpay_tokens enable row level security;
alter table public.qpay_payments enable row level security;

-- qpay_tokens has no policies on purpose. Only service_role (used by edge
-- functions) bypasses RLS and can read/write the token cache. The anon and
-- authenticated roles must never see merchant credentials.

drop policy if exists "Qpay payments select participant_or_admin" on public.qpay_payments;
create policy "Qpay payments select participant_or_admin"
  on public.qpay_payments
  for select
  to authenticated
  using (
    auth.uid() = patient_id
    or public.is_admin()
  );

-- All writes go through SECURITY DEFINER RPCs called by edge functions; no
-- direct insert/update/delete from clients.

-- ============================================
-- 4) RPCs (service-role surface for edge functions)
-- ============================================

create or replace function public.reserve_qpay_invoice_slot(
  p_local_id uuid,
  p_request_id uuid,
  p_patient_id uuid,
  p_amount_mnt integer,
  p_sender_invoice_no text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request_patient uuid;
begin
  select patient_id into v_request_patient
  from public.test_requests
  where id = p_request_id;

  if not found then
    raise exception 'Request not found';
  end if;

  if v_request_patient is distinct from p_patient_id then
    raise exception 'Patient does not own this request';
  end if;

  -- Cancel any previously pending invoice for this request so the partial
  -- unique index allows a new active row.
  update public.qpay_payments
  set status = 'cancelled',
      updated_at = now()
  where test_request_id = p_request_id
    and status = 'pending';

  insert into public.qpay_payments (
    id,
    test_request_id,
    patient_id,
    amount_mnt,
    sender_invoice_no,
    status
  )
  values (
    p_local_id,
    p_request_id,
    p_patient_id,
    p_amount_mnt,
    p_sender_invoice_no,
    'pending'
  );

  return p_local_id;
end;
$$;

create or replace function public.attach_qpay_invoice_data(
  p_local_id uuid,
  p_qpay_invoice_id text,
  p_qr_text text,
  p_qr_image text,
  p_short_url text,
  p_deeplinks jsonb
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.qpay_payments
  set qpay_invoice_id = p_qpay_invoice_id,
      qr_text = p_qr_text,
      qr_image = p_qr_image,
      short_url = p_short_url,
      deeplinks = coalesce(p_deeplinks, '[]'::jsonb),
      updated_at = now()
  where id = p_local_id
    and status = 'pending';

  return found;
end;
$$;

create or replace function public.mark_qpay_payment_paid(
  p_local_id uuid,
  p_qpay_payment_id text,
  p_amount_mnt integer,
  p_metadata jsonb default '{}'::jsonb
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_existing_amount integer;
  v_existing_status text;
begin
  select amount_mnt, status
    into v_existing_amount, v_existing_status
  from public.qpay_payments
  where id = p_local_id
  for update;

  if not found then
    return false;
  end if;

  if v_existing_status = 'paid' then
    -- Idempotent: a duplicate callback is success, not an error.
    return true;
  end if;

  if v_existing_amount is distinct from p_amount_mnt then
    raise exception 'Amount mismatch: expected %, got %', v_existing_amount, p_amount_mnt;
  end if;

  update public.qpay_payments
  set status = 'paid',
      qpay_payment_id = p_qpay_payment_id,
      paid_at = coalesce(paid_at, now()),
      metadata = coalesce(metadata, '{}'::jsonb) || coalesce(p_metadata, '{}'::jsonb),
      updated_at = now()
  where id = p_local_id;

  return true;
end;
$$;

create or replace function public.mark_qpay_payment_status(
  p_local_id uuid,
  p_status text,
  p_metadata jsonb default '{}'::jsonb
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_status not in ('cancelled', 'expired', 'failed', 'refunded') then
    raise exception 'Invalid terminal status: %', p_status;
  end if;

  update public.qpay_payments
  set status = p_status,
      metadata = coalesce(metadata, '{}'::jsonb) || coalesce(p_metadata, '{}'::jsonb),
      updated_at = now()
  where id = p_local_id
    and status <> 'paid';

  return found;
end;
$$;

-- Acquire (or skip) a lease to refresh the QPay merchant token. The advisory
-- lock serializes the read+lease decision; the lease itself is a timestamp
-- column so it can outlive the transaction (covering the QPay HTTP roundtrip).
-- Caller decides what to do based on the returned flags:
--   needs_refresh=false              => use access_token from this row
--   needs_refresh=true, lease=true   => caller MUST refresh and persist
--   needs_refresh=true, lease=false  => another caller is refreshing; wait + retry
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

-- Persist refreshed token values and clear the lease.
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

-- Lock down RPC visibility. Only service_role (used by edge functions) needs
-- to call these; clients use the SELECT policy on qpay_payments to read state.
revoke all on function public.reserve_qpay_invoice_slot(uuid, uuid, uuid, integer, text) from public, anon, authenticated;
revoke all on function public.attach_qpay_invoice_data(uuid, text, text, text, text, jsonb) from public, anon, authenticated;
revoke all on function public.mark_qpay_payment_paid(uuid, text, integer, jsonb) from public, anon, authenticated;
revoke all on function public.mark_qpay_payment_status(uuid, text, jsonb) from public, anon, authenticated;
revoke all on function public.qpay_acquire_token(integer, integer) from public, anon, authenticated;
revoke all on function public.qpay_persist_token(text, text, timestamptz, timestamptz) from public, anon, authenticated;

grant execute on function public.reserve_qpay_invoice_slot(uuid, uuid, uuid, integer, text) to service_role;
grant execute on function public.attach_qpay_invoice_data(uuid, text, text, text, text, jsonb) to service_role;
grant execute on function public.mark_qpay_payment_paid(uuid, text, integer, jsonb) to service_role;
grant execute on function public.mark_qpay_payment_status(uuid, text, jsonb) to service_role;
grant execute on function public.qpay_acquire_token(integer, integer) to service_role;
grant execute on function public.qpay_persist_token(text, text, timestamptz, timestamptz) to service_role;

-- ============================================
-- 5) REALTIME
-- ============================================

-- The Flutter client subscribes to qpay_payments via supabase-js .stream().
-- That requires the table to be in the supabase_realtime publication.
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
