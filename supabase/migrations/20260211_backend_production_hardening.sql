begin;

-- ============================================
-- 1) SECURITY HARDENING FOR HELPER FUNCTIONS
-- ============================================

revoke execute on function public.is_admin(uuid) from anon;
revoke execute on function public.doctor_can_view_profile(uuid, uuid) from anon;
grant execute on function public.is_admin(uuid) to authenticated;
grant execute on function public.doctor_can_view_profile(uuid, uuid) to authenticated;

-- ============================================
-- 2) PATIENT ADDRESSES INTEGRITY + POLICY FIX
-- ============================================

-- Ensure only one default address per user (actual uniqueness, not just best-effort trigger)
create unique index if not exists uniq_patient_addresses_single_default
  on public.patient_addresses (user_id)
  where is_default = true;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'patient_addresses_latitude_range'
      and conrelid = 'public.patient_addresses'::regclass
  ) then
    alter table public.patient_addresses
      add constraint patient_addresses_latitude_range
      check (latitude >= -90 and latitude <= 90);
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conname = 'patient_addresses_longitude_range'
      and conrelid = 'public.patient_addresses'::regclass
  ) then
    alter table public.patient_addresses
      add constraint patient_addresses_longitude_range
      check (longitude >= -180 and longitude <= 180);
  end if;
end
$$;

drop policy if exists "Doctors can view patient addresses for their requests" on public.patient_addresses;

create policy "Doctors can view patient addresses for their requests"
  on public.patient_addresses
  for select
  using (
    exists (
      select 1
      from public.test_requests tr
      join public.profiles p on p.id = auth.uid()
      where tr.patient_id = patient_addresses.user_id
        and tr.doctor_id = auth.uid()
        and p.role = 'doctor'
        and tr.status in ('accepted', 'on_the_way', 'sample_collected', 'delivered_to_lab', 'completed')
    )
  );

-- ============================================
-- 3) PAYMENTS SCHEMA COMPATIBILITY LAYER
-- ============================================

-- Keep both legacy/new column names in sync to avoid runtime breakage across app/backend versions.
alter table public.payments
  add column if not exists patient_id uuid,
  add column if not exists user_id uuid,
  add column if not exists payment_status text,
  add column if not exists status text,
  add column if not exists transaction_id text,
  add column if not exists transaction_reference text,
  add column if not exists metadata jsonb default '{}'::jsonb,
  add column if not exists failed_at timestamptz,
  add column if not exists refunded_at timestamptz,
  add column if not exists cancelled_at timestamptz,
  add column if not exists failure_reason text,
  add column if not exists refund_reason text,
  add column if not exists cancellation_reason text;

update public.payments
set patient_id = coalesce(patient_id, user_id)
where patient_id is null;

update public.payments
set user_id = coalesce(user_id, patient_id)
where user_id is null;

update public.payments
set payment_status = coalesce(
  payment_status,
  case status
    when 'paid' then 'completed'
    else status
  end
)
where payment_status is null;

update public.payments
set status = coalesce(
  status,
  case payment_status
    when 'completed' then 'paid'
    else payment_status
  end
)
where status is null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'payments_patient_fk'
      and conrelid = 'public.payments'::regclass
  ) then
    alter table public.payments
      add constraint payments_patient_fk
      foreign key (patient_id) references public.profiles(id) on delete cascade;
  end if;
end
$$;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'payments_payment_status_chk'
      and conrelid = 'public.payments'::regclass
  ) then
    alter table public.payments
      add constraint payments_payment_status_chk
      check (payment_status in ('pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded'));
  end if;
end
$$;

create index if not exists idx_payments_patient_id on public.payments(patient_id);
create index if not exists idx_payments_payment_status on public.payments(payment_status);

create or replace function public.sync_payment_compat_columns()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.patient_id := coalesce(new.patient_id, new.user_id);
  new.user_id := coalesce(new.user_id, new.patient_id);

  if new.payment_status is null and new.status is not null then
    new.payment_status := case new.status when 'paid' then 'completed' else new.status end;
  end if;

  if new.status is null and new.payment_status is not null then
    new.status := case new.payment_status when 'completed' then 'paid' else new.payment_status end;
  end if;

  if new.status = 'paid' then
    new.payment_status := 'completed';
  elsif new.payment_status = 'completed' then
    new.status := 'paid';
  end if;

  if new.status = 'failed' and new.failed_at is null then
    new.failed_at := now();
  end if;
  if new.status = 'cancelled' and new.cancelled_at is null then
    new.cancelled_at := now();
  end if;
  if new.status = 'refunded' and new.refunded_at is null then
    new.refunded_at := now();
  end if;
  if new.status = 'paid' and new.paid_at is null then
    new.paid_at := now();
  end if;

  return new;
end;
$$;

drop trigger if exists trigger_sync_payment_compat_columns on public.payments;
create trigger trigger_sync_payment_compat_columns
before insert or update on public.payments
for each row
execute function public.sync_payment_compat_columns();

-- Normalize existing RLS policies into one clear ruleset.
drop policy if exists "Users can view their own payments" on public.payments;
drop policy if exists "Users can create their own payments" on public.payments;
drop policy if exists "Users can update their own pending payments" on public.payments;
drop policy if exists "Admins can view all payments" on public.payments;
drop policy if exists "Admins can update all payments" on public.payments;

create policy "Payments select own_or_admin"
  on public.payments
  for select
  using (auth.uid() = patient_id or public.is_admin(auth.uid()));

create policy "Payments insert own_or_admin"
  on public.payments
  for insert
  with check (auth.uid() = patient_id or public.is_admin(auth.uid()));

create policy "Payments update_own_pending_or_admin"
  on public.payments
  for update
  using (
    public.is_admin(auth.uid())
    or (
      auth.uid() = patient_id
      and payment_status in ('pending', 'processing')
    )
  )
  with check (
    public.is_admin(auth.uid())
    or auth.uid() = patient_id
  );

-- ============================================
-- 4) MISSING PAYMENT RPCS USED BY THE APP
-- ============================================

create or replace function public.complete_payment(
  p_payment_id uuid,
  p_transaction_id text default null,
  p_transaction_reference text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request_id uuid;
begin
  update public.payments
  set
    payment_status = 'completed',
    status = 'paid',
    transaction_id = coalesce(p_transaction_id, transaction_id),
    transaction_reference = coalesce(p_transaction_reference, transaction_reference),
    paid_at = coalesce(paid_at, now()),
    updated_at = now()
  where id = p_payment_id
    and (patient_id = auth.uid() or public.is_admin(auth.uid()))
    and payment_status in ('pending', 'processing')
  returning test_request_id into v_request_id;

  if not found then
    return false;
  end if;

  if v_request_id is not null then
    update public.test_requests
    set payment_status = 'paid',
        updated_at = now()
    where id = v_request_id;
  end if;

  return true;
end;
$$;

create or replace function public.fail_payment(
  p_payment_id uuid,
  p_failure_reason text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.payments
  set
    payment_status = 'failed',
    status = 'failed',
    failure_reason = coalesce(p_failure_reason, failure_reason),
    failed_at = coalesce(failed_at, now()),
    updated_at = now()
  where id = p_payment_id
    and (patient_id = auth.uid() or public.is_admin(auth.uid()))
    and payment_status in ('pending', 'processing');

  return found;
end;
$$;

create or replace function public.cancel_payment(
  p_payment_id uuid,
  p_cancellation_reason text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.payments
  set
    payment_status = 'cancelled',
    status = 'cancelled',
    cancellation_reason = coalesce(p_cancellation_reason, cancellation_reason),
    cancelled_at = coalesce(cancelled_at, now()),
    updated_at = now()
  where id = p_payment_id
    and (patient_id = auth.uid() or public.is_admin(auth.uid()))
    and payment_status in ('pending', 'processing');

  return found;
end;
$$;

create or replace function public.get_user_payment_history(
  p_patient_id uuid default auth.uid(),
  p_limit integer default 50,
  p_offset integer default 0
)
returns setof public.payments
language sql
security definer
set search_path = public
as $$
  select *
  from public.payments
  where patient_id = p_patient_id
    and (auth.uid() = p_patient_id or public.is_admin(auth.uid()))
  order by created_at desc
  limit greatest(1, coalesce(p_limit, 50))
  offset greatest(0, coalesce(p_offset, 0));
$$;

grant execute on function public.complete_payment(uuid, text, text) to authenticated;
grant execute on function public.fail_payment(uuid, text) to authenticated;
grant execute on function public.cancel_payment(uuid, text) to authenticated;
grant execute on function public.get_user_payment_history(uuid, integer, integer) to authenticated;

commit;
