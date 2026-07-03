-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- Admin dashboard analytics. Revenue = qpay payments with status 'paid'
-- plus manual payments with status 'verified'.

create or replace function public.get_admin_dashboard_stats()
returns jsonb
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
declare
  v_month_start date := date_trunc('month', now())::date;
begin
  if not is_admin() then
    raise exception 'Admin access required';
  end if;

  return jsonb_build_object(
    'users', jsonb_build_object(
      'total_patients', (select count(*) from profiles where role = 'patient'),
      'total_doctors', (select count(*) from profiles where role = 'doctor'),
      'verified_doctors', (select count(*) from profiles where role = 'doctor' and is_verified = true),
      'active_doctors', (select count(*) from profiles p join doctor_profiles dp on dp.id = p.id
                         where p.role = 'doctor' and p.is_active and p.is_verified and dp.is_available),
      'total_laboratories', (select count(*) from laboratories where is_active = true)
    ),
    'requests', jsonb_build_object(
      'total', (select count(*) from test_requests),
      'by_status', (select coalesce(jsonb_object_agg(status, cnt), '{}'::jsonb)
                    from (select status::text, count(*) cnt from test_requests group by status) s),
      'this_month_total', (select count(*) from test_requests where created_at >= v_month_start),
      'this_month_completed', (select count(*) from test_requests
                               where completed_at >= v_month_start)
    ),
    'revenue', jsonb_build_object(
      'total_paid_mnt',
        coalesce((select sum(amount_mnt) from qpay_payments where status = 'paid'), 0)
        + coalesce((select sum(amount_mnt) from manual_payments where status = 'verified'), 0),
      'this_month_paid_mnt',
        coalesce((select sum(amount_mnt) from qpay_payments where status = 'paid' and paid_at >= v_month_start), 0)
        + coalesce((select sum(amount_mnt) from manual_payments where status = 'verified' and verified_at >= v_month_start), 0),
      'pending_qpay', (select count(*) from qpay_payments where status = 'pending'),
      'pending_manual_review', (select count(*) from manual_payments where status = 'proof_submitted')
    ),
    'generated_at', now()
  );
end;
$function$;

create or replace function public.get_admin_monthly_stats(p_months integer default 6)
returns table (
  month date,
  requests_created bigint,
  requests_completed bigint,
  revenue_mnt bigint
)
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
begin
  if not is_admin() then
    raise exception 'Admin access required';
  end if;

  return query
  with months as (
    select date_trunc('month', now())::date - (interval '1 month' * g) as m
    from generate_series(0, greatest(p_months, 1) - 1) g
  )
  select
    months.m::date,
    (select count(*) from test_requests tr
     where date_trunc('month', tr.created_at)::date = months.m),
    (select count(*) from test_requests tr
     where tr.completed_at is not null
       and date_trunc('month', tr.completed_at)::date = months.m),
    coalesce((select sum(qp.amount_mnt) from qpay_payments qp
              where qp.status = 'paid'
                and date_trunc('month', qp.paid_at)::date = months.m), 0)
    + coalesce((select sum(mp.amount_mnt) from manual_payments mp
                where mp.status = 'verified'
                  and date_trunc('month', mp.verified_at)::date = months.m), 0)
  from months
  order by months.m;
end;
$function$;

create or replace function public.get_admin_payment_history(
  p_limit integer default 50,
  p_offset integer default 0
)
returns table (
  payment_id uuid,
  source text,
  test_request_id uuid,
  patient_id uuid,
  patient_name varchar,
  amount_mnt integer,
  status text,
  created_at timestamptz,
  paid_at timestamptz
)
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
begin
  if not is_admin() then
    raise exception 'Admin access required';
  end if;

  return query
  select u.payment_id, u.source, u.test_request_id, u.patient_id,
         p.full_name, u.amount_mnt, u.status, u.created_at, u.paid_at
  from (
    select qp.id as payment_id, 'qpay'::text as source, qp.test_request_id,
           qp.patient_id, qp.amount_mnt, qp.status, qp.created_at, qp.paid_at
    from qpay_payments qp
    union all
    select mp.id, 'manual'::text, mp.test_request_id,
           mp.patient_id, mp.amount_mnt, mp.status, mp.created_at, mp.verified_at
    from manual_payments mp
  ) u
  left join profiles p on p.id = u.patient_id
  order by u.created_at desc
  limit least(greatest(p_limit, 1), 200)
  offset greatest(p_offset, 0);
end;
$function$;

revoke execute on function public.get_admin_dashboard_stats() from public, anon;
revoke execute on function public.get_admin_monthly_stats(integer) from public, anon;
revoke execute on function public.get_admin_payment_history(integer, integer) from public, anon;
grant execute on function public.get_admin_dashboard_stats() to authenticated;
grant execute on function public.get_admin_monthly_stats(integer) to authenticated;
grant execute on function public.get_admin_payment_history(integer, integer) to authenticated;
