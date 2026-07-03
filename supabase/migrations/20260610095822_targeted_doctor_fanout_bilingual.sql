-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- When a patient picked a specific doctor, notify only that doctor.
-- Otherwise fan out to all active + verified + available doctors.
-- All notifications now carry Mongolian text like the status-change ones.
create or replace function public.notify_doctors_new_request()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
declare
  v_service_en text;
  v_service_mn text;
begin
  if new.request_type = 'lab_service' then
    v_service_en := 'lab service';
    v_service_mn := 'шинжилгээний';
  else
    v_service_en := 'direct service';
    v_service_mn := 'үйлчилгээний';
  end if;

  if new.doctor_id is not null then
    -- Targeted request: only the chosen doctor needs to know
    insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id, metadata)
    values (
      new.doctor_id,
      'request_created',
      'New request for you',
      'A patient requested you for a ' || v_service_en || ' on ' || to_char(new.scheduled_date, 'Mon DD') || '.',
      'Танд шинэ хүсэлт ирлээ',
      'Үйлчлүүлэгч таныг ' || to_char(new.scheduled_date, 'MM/DD') || '-нд ' || v_service_mn || ' үйлчилгээнд хүссэн байна.',
      new.id,
      jsonb_build_object(
        'request_id', new.id,
        'request_type', new.request_type,
        'scheduled_date', new.scheduled_date,
        'price_mnt', new.price_mnt,
        'targeted', true
      )
    );
  else
    -- Open request: fan out to every doctor who can take it
    insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id, metadata)
    select
      p.id,
      'request_created',
      'New request available',
      'A new ' || v_service_en || ' request is available for ' || to_char(new.scheduled_date, 'Mon DD') || '.',
      'Шинэ хүсэлт нэмэгдлээ',
      to_char(new.scheduled_date, 'MM/DD') || '-нд ' || v_service_mn || ' шинэ хүсэлт нэмэгдлээ.',
      new.id,
      jsonb_build_object(
        'request_id', new.id,
        'request_type', new.request_type,
        'scheduled_date', new.scheduled_date,
        'price_mnt', new.price_mnt,
        'targeted', false
      )
    from profiles p
    inner join doctor_profiles dp on p.id = dp.id
    where p.role = 'doctor'
      and p.is_active = true
      and p.is_verified = true
      and dp.is_available = true;
  end if;

  return new;
end;
$function$;
