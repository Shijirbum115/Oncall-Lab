begin;

-- 1) Remove globally permissive payment update access
drop policy if exists "System can update payment status" on public.payments;

-- 2) Harden payment RPCs with ownership checks
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
begin
  update public.payments
  set
    payment_status = 'completed',
    paid_at = coalesce(paid_at, now()),
    transaction_id = coalesce(p_transaction_id, transaction_id),
    transaction_reference = coalesce(p_transaction_reference, transaction_reference),
    updated_at = now()
  where id = p_payment_id
    and payment_status in ('pending', 'processing')
    and (
      auth.role() = 'service_role'
      or patient_id = auth.uid()
      or public.is_admin()
    );

  return found;
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
    failed_at = coalesce(failed_at, now()),
    failure_reason = coalesce(p_failure_reason, failure_reason),
    updated_at = now()
  where id = p_payment_id
    and payment_status in ('pending', 'processing')
    and (
      auth.role() = 'service_role'
      or patient_id = auth.uid()
      or public.is_admin()
    );

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
    cancelled_at = coalesce(cancelled_at, now()),
    cancellation_reason = coalesce(p_cancellation_reason, cancellation_reason),
    updated_at = now()
  where id = p_payment_id
    and payment_status in ('pending', 'processing')
    and (
      auth.role() = 'service_role'
      or patient_id = auth.uid()
      or public.is_admin()
    );

  return found;
end;
$$;

-- Return full payment rows so Flutter PaymentModel deserialization succeeds.
drop function if exists public.get_user_payment_history(uuid, integer, integer);
create function public.get_user_payment_history(
  p_patient_id uuid default auth.uid(),
  p_limit integer default 50,
  p_offset integer default 0
)
returns setof public.payments
language sql
security definer
set search_path = public
as $$
  select p.*
  from public.payments p
  where p.patient_id = p_patient_id
    and (
      auth.role() = 'service_role'
      or auth.uid() = p_patient_id
      or public.is_admin()
    )
  order by p.created_at desc
  limit greatest(1, coalesce(p_limit, 50))
  offset greatest(0, coalesce(p_offset, 0));
$$;

-- Remove anonymous/public execute access from sensitive RPCs.
revoke all on function public.complete_payment(uuid, text, text) from public, anon;
revoke all on function public.fail_payment(uuid, text) from public, anon;
revoke all on function public.cancel_payment(uuid, text) from public, anon;
revoke all on function public.get_user_payment_history(uuid, integer, integer) from public, anon;

grant execute on function public.complete_payment(uuid, text, text) to authenticated, service_role;
grant execute on function public.fail_payment(uuid, text) to authenticated, service_role;
grant execute on function public.cancel_payment(uuid, text) to authenticated, service_role;
grant execute on function public.get_user_payment_history(uuid, integer, integer) to authenticated, service_role;

-- 3) Add missing increment RPC used by Flutter app (posts/reviews counters only)
create or replace function public.increment(
  table_name text,
  column_name text,
  row_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null and auth.role() <> 'service_role' then
    raise exception 'Authentication required';
  end if;

  if table_name = 'posts' and column_name = 'view_count' then
    update public.posts
    set view_count = coalesce(view_count, 0) + 1,
        updated_at = now()
    where id = row_id and is_published = true;
    return;
  end if;

  if table_name = 'posts' and column_name = 'share_count' then
    update public.posts
    set share_count = coalesce(share_count, 0) + 1,
        updated_at = now()
    where id = row_id and is_published = true;
    return;
  end if;

  if table_name = 'doctor_reviews' and column_name = 'helpful_count' then
    update public.doctor_reviews
    set helpful_count = coalesce(helpful_count, 0) + 1,
        updated_at = now()
    where id = row_id and is_visible = true;
    return;
  end if;

  if table_name = 'doctor_reviews' and column_name = 'not_helpful_count' then
    update public.doctor_reviews
    set not_helpful_count = coalesce(not_helpful_count, 0) + 1,
        updated_at = now()
    where id = row_id and is_visible = true;
    return;
  end if;

  raise exception 'Unsupported increment target %.%', table_name, column_name;
end;
$$;

revoke all on function public.increment(text, text, uuid) from public, anon;
grant execute on function public.increment(text, text, uuid) to authenticated, service_role;

-- 4) Address integrity hardening
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

-- 5) Resolve advisor warning for security-definer view
do $$
begin
  execute 'alter view public.admin_dashboard_stats set (security_invoker = true)';
exception
  when others then
    raise notice 'Could not set security_invoker on admin_dashboard_stats: %', sqlerrm;
end
$$;

commit;
