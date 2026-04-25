begin;

-- ============================================
-- 1) TABLES
-- ============================================

create table if not exists public.provider_bank_accounts (
  id uuid primary key default gen_random_uuid(),
  provider_profile_id uuid not null references public.profiles(id) on delete cascade,
  holder_name text not null check (length(trim(holder_name)) > 0),
  bank_name text not null check (length(trim(bank_name)) > 0),
  account_number text not null check (length(trim(account_number)) > 0),
  iban text,
  branch_name text,
  is_active boolean not null default true,
  is_primary boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists uniq_provider_primary_bank_account
  on public.provider_bank_accounts (provider_profile_id)
  where is_primary = true;

create index if not exists idx_provider_bank_accounts_provider
  on public.provider_bank_accounts (provider_profile_id);

create table if not exists public.manual_payments (
  id uuid primary key default gen_random_uuid(),
  test_request_id uuid not null references public.test_requests(id) on delete cascade,
  patient_id uuid not null references public.profiles(id) on delete cascade,
  provider_profile_id uuid not null references public.profiles(id) on delete cascade,
  provider_bank_account_id uuid not null references public.provider_bank_accounts(id),
  amount_mnt integer not null check (amount_mnt > 0),
  status text not null check (
    status in ('awaiting_transfer', 'proof_submitted', 'verified', 'rejected', 'cancelled')
  ),
  transfer_reference text,
  proof_file_path text,
  proof_submitted_at timestamptz,
  verified_at timestamptz,
  verified_by uuid references public.profiles(id),
  rejection_reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (test_request_id)
);

create index if not exists idx_manual_payments_patient
  on public.manual_payments (patient_id);

create index if not exists idx_manual_payments_provider
  on public.manual_payments (provider_profile_id);

create index if not exists idx_manual_payments_status
  on public.manual_payments (status);

create table if not exists public.manual_payment_status_history (
  id uuid primary key default gen_random_uuid(),
  manual_payment_id uuid not null references public.manual_payments(id) on delete cascade,
  old_status text,
  new_status text not null,
  changed_by uuid not null references public.profiles(id),
  reason text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_manual_payment_history_payment
  on public.manual_payment_status_history (manual_payment_id, created_at desc);

-- ============================================
-- 2) REQUEST PAYMENT STATUS LINK
-- ============================================

alter table public.test_requests
  add column if not exists payment_status text;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'test_requests_payment_status_check'
      and conrelid = 'public.test_requests'::regclass
  ) then
    alter table public.test_requests
      add constraint test_requests_payment_status_check
      check (payment_status in (
        'payment_pending',
        'payment_review',
        'paid',
        'payment_rejected',
        'refunded',
        'cancelled'
      ));
  end if;
end
$$;

update public.test_requests
set payment_status = coalesce(payment_status, 'payment_pending');

create index if not exists idx_test_requests_payment_status
  on public.test_requests (payment_status);

-- ============================================
-- 3) TRIGGERS + HELPERS
-- ============================================

create or replace function public.update_manual_payment_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_manual_payments_updated_at on public.manual_payments;
create trigger trg_manual_payments_updated_at
before update on public.manual_payments
for each row
execute function public.update_manual_payment_updated_at();

create or replace function public.update_provider_bank_accounts_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_provider_bank_accounts_updated_at on public.provider_bank_accounts;
create trigger trg_provider_bank_accounts_updated_at
before update on public.provider_bank_accounts
for each row
execute function public.update_provider_bank_accounts_updated_at();

create or replace function public.ensure_single_primary_bank_account()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.is_primary is true then
    update public.provider_bank_accounts
    set is_primary = false,
        updated_at = now()
    where provider_profile_id = new.provider_profile_id
      and id <> new.id
      and is_primary = true;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_provider_single_primary on public.provider_bank_accounts;
create trigger trg_provider_single_primary
before insert or update on public.provider_bank_accounts
for each row
execute function public.ensure_single_primary_bank_account();

create or replace function public.log_manual_payment_status_change()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.manual_payment_status_history (
      manual_payment_id,
      old_status,
      new_status,
      changed_by,
      metadata
    )
    values (
      new.id,
      null,
      new.status,
      coalesce(auth.uid(), new.patient_id),
      jsonb_build_object('source', 'create_manual_payment')
    );
    return new;
  end if;

  if tg_op = 'UPDATE' and old.status is distinct from new.status then
    insert into public.manual_payment_status_history (
      manual_payment_id,
      old_status,
      new_status,
      changed_by,
      reason,
      metadata
    )
    values (
      new.id,
      old.status,
      new.status,
      coalesce(auth.uid(), coalesce(new.verified_by, new.patient_id)),
      case when new.status = 'rejected' then new.rejection_reason else null end,
      jsonb_build_object('source', 'manual_payment_status_update')
    );
  end if;

  return new;
end;
$$;

drop trigger if exists trg_log_manual_payment_status_change on public.manual_payments;
create trigger trg_log_manual_payment_status_change
after insert or update on public.manual_payments
for each row
execute function public.log_manual_payment_status_change();

create or replace function public.sync_request_payment_status()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  update public.test_requests
  set payment_status = case new.status
    when 'awaiting_transfer' then 'payment_pending'
    when 'proof_submitted' then 'payment_review'
    when 'verified' then 'paid'
    when 'rejected' then 'payment_rejected'
    when 'cancelled' then 'cancelled'
    else payment_status
  end,
  updated_at = now()
  where id = new.test_request_id;

  return new;
end;
$$;

drop trigger if exists trg_sync_request_payment_status on public.manual_payments;
create trigger trg_sync_request_payment_status
after insert or update of status on public.manual_payments
for each row
execute function public.sync_request_payment_status();

-- ============================================
-- 4) RLS POLICIES
-- ============================================

alter table public.provider_bank_accounts enable row level security;
alter table public.manual_payments enable row level security;
alter table public.manual_payment_status_history enable row level security;

drop policy if exists "Provider bank accounts select" on public.provider_bank_accounts;
create policy "Provider bank accounts select"
  on public.provider_bank_accounts
  for select
  to authenticated
  using (
    auth.uid() = provider_profile_id
    or public.is_admin()
    or exists (
      select 1
      from public.manual_payments mp
      where mp.provider_bank_account_id = provider_bank_accounts.id
        and mp.patient_id = auth.uid()
    )
  );

drop policy if exists "Provider bank accounts insert own" on public.provider_bank_accounts;
create policy "Provider bank accounts insert own"
  on public.provider_bank_accounts
  for insert
  to authenticated
  with check (
    auth.uid() = provider_profile_id
    or public.is_admin()
  );

drop policy if exists "Provider bank accounts update own" on public.provider_bank_accounts;
create policy "Provider bank accounts update own"
  on public.provider_bank_accounts
  for update
  to authenticated
  using (
    auth.uid() = provider_profile_id
    or public.is_admin()
  )
  with check (
    auth.uid() = provider_profile_id
    or public.is_admin()
  );

drop policy if exists "Provider bank accounts delete own" on public.provider_bank_accounts;
create policy "Provider bank accounts delete own"
  on public.provider_bank_accounts
  for delete
  to authenticated
  using (
    auth.uid() = provider_profile_id
    or public.is_admin()
  );

drop policy if exists "Manual payments select" on public.manual_payments;
create policy "Manual payments select"
  on public.manual_payments
  for select
  to authenticated
  using (
    auth.uid() = patient_id
    or auth.uid() = provider_profile_id
    or public.is_admin()
  );

drop policy if exists "Manual payments insert patient_or_admin" on public.manual_payments;
create policy "Manual payments insert patient_or_admin"
  on public.manual_payments
  for insert
  to authenticated
  with check (
    auth.uid() = patient_id
    or public.is_admin()
  );

drop policy if exists "Manual payments update participant_or_admin" on public.manual_payments;
create policy "Manual payments update participant_or_admin"
  on public.manual_payments
  for update
  to authenticated
  using (
    auth.uid() = patient_id
    or auth.uid() = provider_profile_id
    or public.is_admin()
  )
  with check (
    auth.uid() = patient_id
    or auth.uid() = provider_profile_id
    or public.is_admin()
  );

drop policy if exists "Manual payments delete admin_only" on public.manual_payments;
create policy "Manual payments delete admin_only"
  on public.manual_payments
  for delete
  to authenticated
  using (public.is_admin());

drop policy if exists "Manual payment history select" on public.manual_payment_status_history;
create policy "Manual payment history select"
  on public.manual_payment_status_history
  for select
  to authenticated
  using (
    public.is_admin()
    or exists (
      select 1
      from public.manual_payments mp
      where mp.id = manual_payment_status_history.manual_payment_id
        and (mp.patient_id = auth.uid() or mp.provider_profile_id = auth.uid())
    )
  );

drop policy if exists "Manual payment history insert participants" on public.manual_payment_status_history;
create policy "Manual payment history insert participants"
  on public.manual_payment_status_history
  for insert
  to authenticated
  with check (
    public.is_admin()
    or changed_by = auth.uid()
  );

-- ============================================
-- 5) RPCS
-- ============================================

create or replace function public.create_manual_payment_for_request(
  p_request_id uuid,
  p_provider_profile_id uuid default null
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_patient_id uuid;
  v_provider_id uuid;
  v_amount integer;
  v_bank_account_id uuid;
  v_manual_payment_id uuid;
begin
  select tr.patient_id, tr.doctor_id, tr.price_mnt
    into v_patient_id, v_provider_id, v_amount
  from public.test_requests tr
  where tr.id = p_request_id;

  if not found then
    raise exception 'Request not found';
  end if;

  if auth.uid() <> v_patient_id and not public.is_admin() then
    raise exception 'Not allowed to create manual payment for this request';
  end if;

  v_provider_id := coalesce(p_provider_profile_id, v_provider_id);
  if v_provider_id is null then
    raise exception 'Provider is not assigned yet';
  end if;

  select pba.id
    into v_bank_account_id
  from public.provider_bank_accounts pba
  where pba.provider_profile_id = v_provider_id
    and pba.is_active = true
  order by pba.is_primary desc, pba.created_at asc
  limit 1;

  if v_bank_account_id is null then
    raise exception 'Provider bank account not configured';
  end if;

  insert into public.manual_payments (
    test_request_id,
    patient_id,
    provider_profile_id,
    provider_bank_account_id,
    amount_mnt,
    status
  )
  values (
    p_request_id,
    v_patient_id,
    v_provider_id,
    v_bank_account_id,
    v_amount,
    'awaiting_transfer'
  )
  on conflict (test_request_id) do update
    set provider_profile_id = excluded.provider_profile_id,
        provider_bank_account_id = excluded.provider_bank_account_id,
        amount_mnt = excluded.amount_mnt,
        updated_at = now()
  returning id into v_manual_payment_id;

  return v_manual_payment_id;
end;
$$;

create or replace function public.submit_manual_payment_proof(
  p_manual_payment_id uuid,
  p_transfer_reference text default null,
  p_proof_file_path text default null
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.manual_payments
  set
    status = 'proof_submitted',
    transfer_reference = coalesce(p_transfer_reference, transfer_reference),
    proof_file_path = coalesce(p_proof_file_path, proof_file_path),
    proof_submitted_at = coalesce(proof_submitted_at, now()),
    updated_at = now()
  where id = p_manual_payment_id
    and status = 'awaiting_transfer'
    and (
      auth.uid() = patient_id
      or public.is_admin()
    );

  return found;
end;
$$;

create or replace function public.verify_manual_payment(
  p_manual_payment_id uuid
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.manual_payments
  set
    status = 'verified',
    verified_at = coalesce(verified_at, now()),
    verified_by = coalesce(verified_by, auth.uid()),
    rejection_reason = null,
    updated_at = now()
  where id = p_manual_payment_id
    and status = 'proof_submitted'
    and (
      auth.uid() = provider_profile_id
      or public.is_admin()
    );

  return found;
end;
$$;

create or replace function public.reject_manual_payment(
  p_manual_payment_id uuid,
  p_reason text
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_reason is null or length(trim(p_reason)) = 0 then
    raise exception 'Rejection reason is required';
  end if;

  update public.manual_payments
  set
    status = 'rejected',
    rejection_reason = p_reason,
    verified_by = coalesce(verified_by, auth.uid()),
    updated_at = now()
  where id = p_manual_payment_id
    and status = 'proof_submitted'
    and (
      auth.uid() = provider_profile_id
      or public.is_admin()
    );

  return found;
end;
$$;

revoke all on function public.create_manual_payment_for_request(uuid, uuid) from public, anon;
revoke all on function public.submit_manual_payment_proof(uuid, text, text) from public, anon;
revoke all on function public.verify_manual_payment(uuid) from public, anon;
revoke all on function public.reject_manual_payment(uuid, text) from public, anon;

grant execute on function public.create_manual_payment_for_request(uuid, uuid) to authenticated, service_role;
grant execute on function public.submit_manual_payment_proof(uuid, text, text) to authenticated, service_role;
grant execute on function public.verify_manual_payment(uuid) to authenticated, service_role;
grant execute on function public.reject_manual_payment(uuid, text) to authenticated, service_role;

-- ============================================
-- 6) STORAGE POLICIES (PAYMENT PROOFS)
-- ============================================

insert into storage.buckets (id, name, public)
values ('manual-payment-proofs', 'manual-payment-proofs', false)
on conflict (id) do nothing;

drop policy if exists "Manual payment proofs patient insert own" on storage.objects;
create policy "Manual payment proofs patient insert own"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'manual-payment-proofs'
    and split_part(name, '/', 1) = 'manual-payments'
    and split_part(name, '/', 2) ~ '^[0-9a-fA-F-]{36}$'
    and exists (
      select 1
      from public.manual_payments mp
      where mp.id = split_part(name, '/', 2)::uuid
        and mp.patient_id = auth.uid()
    )
  );

drop policy if exists "Manual payment proofs participants read" on storage.objects;
create policy "Manual payment proofs participants read"
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'manual-payment-proofs'
    and split_part(name, '/', 1) = 'manual-payments'
    and split_part(name, '/', 2) ~ '^[0-9a-fA-F-]{36}$'
    and (
      public.is_admin()
      or exists (
        select 1
        from public.manual_payments mp
        where mp.id = split_part(name, '/', 2)::uuid
          and (mp.patient_id = auth.uid() or mp.provider_profile_id = auth.uid())
      )
    )
  );

drop policy if exists "Manual payment proofs patient update own" on storage.objects;
create policy "Manual payment proofs patient update own"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'manual-payment-proofs'
    and split_part(name, '/', 1) = 'manual-payments'
    and split_part(name, '/', 2) ~ '^[0-9a-fA-F-]{36}$'
    and exists (
      select 1
      from public.manual_payments mp
      where mp.id = split_part(name, '/', 2)::uuid
        and mp.patient_id = auth.uid()
    )
  )
  with check (
    bucket_id = 'manual-payment-proofs'
  );

drop policy if exists "Manual payment proofs patient delete own" on storage.objects;
create policy "Manual payment proofs patient delete own"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'manual-payment-proofs'
    and split_part(name, '/', 1) = 'manual-payments'
    and split_part(name, '/', 2) ~ '^[0-9a-fA-F-]{36}$'
    and exists (
      select 1
      from public.manual_payments mp
      where mp.id = split_part(name, '/', 2)::uuid
        and mp.patient_id = auth.uid()
    )
  );

commit;
