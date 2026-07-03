-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- Rewrite the status notifier: bilingual (en + mn), correct doctor-name
-- fallbacks (the old copy produced "Dr. A doctor"), inserts directly so
-- title_mn/message_mn are populated.
create or replace function public.notify_on_request_status_change()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
declare
  v_patient_name varchar(255);
  v_doctor_name varchar(255);
  v_doctor_en text;
  v_doctor_mn text;
begin
  if (tg_op = 'UPDATE' and old.status is distinct from new.status) then
    select full_name into v_patient_name from profiles where id = new.patient_id;

    if new.doctor_id is not null then
      select full_name into v_doctor_name from profiles where id = new.doctor_id;
    end if;

    -- Display names with honorific only when we actually have a name
    v_doctor_en := coalesce('Dr. ' || v_doctor_name, 'A specialist');
    v_doctor_mn := coalesce(v_doctor_name || ' эмч', 'Мэргэжилтэн');

    case new.status
      when 'accepted' then
        insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id, metadata)
        values (
          new.patient_id, 'request_accepted',
          'Request accepted',
          v_doctor_en || ' accepted your request and will arrive at the scheduled time.',
          'Хүсэлт баталгаажлаа',
          v_doctor_mn || ' таны хүсэлтийг хүлээн авлаа. Товлосон цагтаа очно.',
          new.id, jsonb_build_object('doctor_id', new.doctor_id)
        );

        if new.doctor_id is not null then
          insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id, metadata)
          values (
            new.doctor_id, 'request_accepted',
            'Request accepted',
            'You accepted a request from ' || coalesce(v_patient_name, 'a patient') || '.',
            'Хүсэлт хүлээн авлаа',
            coalesce(v_patient_name, 'Үйлчлүүлэгч') || '-ийн хүсэлтийг хүлээн авлаа.',
            new.id, jsonb_build_object('patient_id', new.patient_id)
          );
        end if;

      when 'on_the_way' then
        insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
        values (
          new.patient_id, 'status_changed',
          'Specialist on the way',
          v_doctor_en || ' is on the way to your location.',
          'Эмч гарлаа',
          v_doctor_mn || ' таны байршил руу явж байна.',
          new.id
        );

      when 'sample_collected' then
        insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
        values (
          new.patient_id, 'status_changed',
          'Sample collected',
          'Your sample was collected successfully and is on its way to the laboratory.',
          'Сорьц авагдлаа',
          'Таны сорьцыг амжилттай авч, лаборатори руу хүргэж байна.',
          new.id
        );

      when 'delivered_to_lab' then
        insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
        values (
          new.patient_id, 'status_changed',
          'Sample delivered to lab',
          'Your sample arrived at the laboratory and testing has started.',
          'Сорьц лабораторид хүрлээ',
          'Таны сорьц лабораторид хүрч, шинжилгээ эхэллээ.',
          new.id
        );

      when 'completed' then
        insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
        values (
          new.patient_id, 'status_changed',
          'Results ready',
          'Your lab results are ready. Open the app to view them.',
          'Шинжилгээний хариу гарлаа',
          'Таны шинжилгээний хариу бэлэн боллоо. Аппликейшнээс харна уу.',
          new.id
        );

        if new.doctor_id is not null then
          insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
          values (
            new.doctor_id, 'status_changed',
            'Request completed',
            'Request for ' || coalesce(v_patient_name, 'a patient') || ' has been completed.',
            'Захиалга дууслаа',
            coalesce(v_patient_name, 'Үйлчлүүлэгч') || '-ийн захиалга амжилттай дууслаа.',
            new.id
          );
        end if;

      when 'cancelled' then
        insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
        values (
          new.patient_id, 'status_changed',
          'Request cancelled',
          'Your request was cancelled.' || coalesce(' Reason: ' || new.cancellation_reason, ''),
          'Захиалга цуцлагдлаа',
          'Таны захиалга цуцлагдлаа.' || coalesce(' Шалтгаан: ' || new.cancellation_reason, ''),
          new.id
        );

        if new.doctor_id is not null then
          insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
          values (
            new.doctor_id, 'status_changed',
            'Request cancelled',
            'Request from ' || coalesce(v_patient_name, 'a patient') || ' was cancelled.',
            'Захиалга цуцлагдлаа',
            coalesce(v_patient_name, 'Үйлчлүүлэгч') || '-ийн захиалга цуцлагдлаа.',
            new.id
          );
        end if;

      else
        insert into notifications (user_id, type, title, message, title_mn, message_mn, related_request_id)
        values (
          new.patient_id, 'status_changed',
          'Request updated',
          'Your request status changed to: ' || new.status,
          'Захиалгын төлөв шинэчлэгдлээ',
          'Таны захиалгын төлөв шинэчлэгдлээ.',
          new.id
        );
    end case;
  end if;

  return new;
end;
$function$;
