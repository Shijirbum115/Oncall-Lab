-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- changed_by must allow NULL: status can change from service-role jobs,
-- admin tooling, or SQL where auth.uid() is NULL.
alter table public.request_status_history alter column changed_by drop not null;

-- Drop the duplicate history logger (every transition was logged twice).
drop trigger if exists trigger_log_request_status_changes on public.test_requests;
drop function if exists public.log_request_status_changes();

-- Drop the duplicate generic patient notifier (every transition produced
-- two notifications).
drop trigger if exists trigger_notify_patient_status_change on public.test_requests;
drop function if exists public.notify_patient_status_change();

-- Two triggers both ran update_updated_at_column; one is enough.
drop trigger if exists trigger_update_test_requests_timestamp on public.test_requests;

-- Canonical history logger: keep timestamp/counter behavior, absorb the
-- change_reason capture from the dropped duplicate.
create or replace function public.log_request_status_change()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
begin
  if (tg_op = 'UPDATE' and old.status is distinct from new.status) then
    insert into request_status_history (
      request_id,
      old_status,
      new_status,
      changed_by,
      change_reason,
      metadata
    ) values (
      new.id,
      old.status,
      new.status,
      auth.uid(),
      case when new.status = 'cancelled' then new.cancellation_reason else null end,
      jsonb_build_object(
        'changed_at', now(),
        'operation', tg_op
      )
    );

    case new.status
      when 'accepted' then
        new.accepted_at = now();
      when 'on_the_way' then
        new.on_the_way_at = now();
      when 'sample_collected' then
        new.sample_collected_at = now();
      when 'delivered_to_lab' then
        new.delivered_to_lab_at = now();
      when 'completed' then
        new.completed_at = now();
        update doctor_profiles
        set total_completed_requests = total_completed_requests + 1
        where id = new.doctor_id;
      when 'cancelled' then
        new.cancelled_at = now();
        new.cancelled_by = coalesce(auth.uid(), new.cancelled_by);
      else
        -- no timestamp column for this status
    end case;
  end if;

  return new;
end;
$function$;
