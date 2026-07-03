-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- 1. Install pg_net so triggers can make async HTTP calls
create extension if not exists pg_net with schema extensions;

-- 2. Store project URL + anon key in Vault (idempotent)
do $$
begin
  if not exists (select 1 from vault.secrets where name = 'project_url') then
    perform vault.create_secret('https://zrwtugcgimaocrhjdtob.supabase.co', 'project_url');
  end if;
  if not exists (select 1 from vault.secrets where name = 'anon_key') then
    perform vault.create_secret('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpyd3R1Z2NnaW1hb2NyaGpkdG9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMxODQyNzksImV4cCI6MjA3ODc2MDI3OX0.KPZrMcWKUrU_pqqen8vi_176lcmQvZaWgFm_K4Wi4Zo', 'anon_key');
  end if;
end $$;

-- 3. Rewrite the push dispatch trigger: vault-based config, working pg_net call,
--    Mongolian-preferred text, overnight-safe quiet hours
create or replace function public.send_push_notification_async()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'pg_temp'
as $function$
declare
  v_fcm_token text;
  v_push_enabled boolean;
  v_type_enabled boolean;
  v_quiet_enabled boolean;
  v_quiet_start time;
  v_quiet_end time;
  v_url text;
  v_anon_key text;
  v_title text;
  v_message text;
begin
  if tg_op != 'INSERT' then
    return new;
  end if;

  select p.fcm_token,
         coalesce(np.push_enabled, true),
         case
           when new.type = 'request_created' then coalesce(np.request_created_enabled, true)
           when new.type = 'request_accepted' then coalesce(np.request_accepted_enabled, true)
           when new.type = 'request_updated' then coalesce(np.request_updated_enabled, true)
           when new.type = 'status_changed' then coalesce(np.status_changed_enabled, true)
           when new.type = 'system_alert' then coalesce(np.system_alert_enabled, true)
           else true
         end,
         coalesce(np.quiet_hours_enabled, false),
         np.quiet_hours_start,
         np.quiet_hours_end
  into v_fcm_token, v_push_enabled, v_type_enabled, v_quiet_enabled, v_quiet_start, v_quiet_end
  from profiles p
  left join notification_preferences np on p.id = np.user_id
  where p.id = new.user_id;

  if v_fcm_token is null or v_fcm_token = '' then
    return new;
  end if;

  if not v_push_enabled or not v_type_enabled then
    return new;
  end if;

  -- Quiet hours: handle ranges that wrap past midnight (e.g. 22:00-08:00)
  if v_quiet_enabled and v_quiet_start is not null and v_quiet_end is not null then
    if v_quiet_start <= v_quiet_end then
      if current_time between v_quiet_start and v_quiet_end then
        return new;
      end if;
    else
      if current_time >= v_quiet_start or current_time <= v_quiet_end then
        return new;
      end if;
    end if;
  end if;

  select decrypted_secret into v_url from vault.decrypted_secrets where name = 'project_url';
  select decrypted_secret into v_anon_key from vault.decrypted_secrets where name = 'anon_key';

  if v_url is null or v_anon_key is null then
    raise warning 'Push notification skipped: project_url/anon_key missing from vault';
    return new;
  end if;

  -- Mongolian-first market: prefer the localized text when present
  v_title := coalesce(nullif(new.title_mn, ''), new.title);
  v_message := coalesce(nullif(new.message_mn, ''), new.message);

  perform net.http_post(
    url := v_url || '/functions/v1/send-push-notification',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || v_anon_key,
      'apikey', v_anon_key
    ),
    body := jsonb_build_object(
      'notification_id', new.id::text,
      'user_id', new.user_id::text,
      'title', v_title,
      'message', v_message,
      'fcm_token', v_fcm_token,
      'data', jsonb_build_object(
        'type', new.type::text,
        'related_request_id', coalesce(new.related_request_id::text, '')
      )
    )
  );

  return new;
exception
  when others then
    raise warning 'Failed to send push notification: %', sqlerrm;
    return new;
end;
$function$;
