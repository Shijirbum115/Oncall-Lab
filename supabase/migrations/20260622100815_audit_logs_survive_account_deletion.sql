-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- Account self-deletion failed because deleting a profile (a) is blocked by existing
-- audit_logs rows referencing it, and (b) fires audit triggers that INSERT a new
-- audit row referencing the just-deleted profile. Fix both: SET NULL the actor on
-- delete, and have each audit trigger record a NULL actor when the profile is gone.

alter table public.audit_logs
  drop constraint if exists audit_logs_user_id_fkey,
  add constraint audit_logs_user_id_fkey
    foreign key (user_id) references public.profiles(id) on delete set null;

create or replace function public.log_profile_changes()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
declare
  v_actor uuid := (select id from public.profiles where id = auth.uid());
begin
  if tg_op = 'UPDATE' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'UPDATE', 'profiles', NEW.id, to_jsonb(OLD), to_jsonb(NEW));
  elsif tg_op = 'DELETE' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'DELETE', 'profiles', OLD.id, to_jsonb(OLD), NULL);
    return OLD;
  elsif tg_op = 'INSERT' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'INSERT', 'profiles', NEW.id, NULL, to_jsonb(NEW));
  end if;
  return NEW;
end;
$function$;

create or replace function public.log_doctor_profile_changes()
returns trigger
language plpgsql
set search_path to 'public', 'pg_temp'
as $function$
declare
  v_actor uuid := (select id from public.profiles where id = auth.uid());
begin
  if tg_op = 'UPDATE' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'UPDATE', 'doctor_profiles', NEW.id, to_jsonb(OLD), to_jsonb(NEW));
  elsif tg_op = 'DELETE' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'DELETE', 'doctor_profiles', OLD.id, to_jsonb(OLD), NULL);
    return OLD;
  elsif tg_op = 'INSERT' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'INSERT', 'doctor_profiles', NEW.id, NULL, to_jsonb(NEW));
  end if;
  return NEW;
end;
$function$;

create or replace function public.log_test_request_changes()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
declare
  v_actor uuid := (select id from public.profiles where id = auth.uid());
begin
  if tg_op = 'INSERT' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'INSERT', 'test_requests', NEW.id, NULL, to_jsonb(NEW));
  elsif tg_op = 'UPDATE' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'UPDATE', 'test_requests', NEW.id, to_jsonb(OLD), to_jsonb(NEW));
  elsif tg_op = 'DELETE' then
    insert into audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    values (v_actor, 'DELETE', 'test_requests', OLD.id, to_jsonb(OLD), NULL);
    return OLD;
  end if;
  return NEW;
end;
$function$;
