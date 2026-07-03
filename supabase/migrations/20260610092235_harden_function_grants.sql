-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- A: app RPCs for logged-in users only — strip PUBLIC/anon, keep authenticated.
do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as sig
    from pg_proc p
    where p.pronamespace = 'public'::regnamespace
      and p.proname in (
        'accept_test_request','create_payment','get_payment_by_request',
        'get_pending_direct_requests_for_doctor','get_pending_lab_requests',
        'get_pending_requests_for_doctor','get_unread_notification_count',
        'mark_all_notifications_read','update_fcm_token',
        'can_patient_review_doctor','create_default_notification_preferences',
        'get_user_role'
      )
  loop
    execute format('revoke all on function %s from public', r.sig);
    execute format('revoke all on function %s from anon', r.sig);
    execute format('grant execute on function %s to authenticated', r.sig);
    execute format('grant execute on function %s to service_role', r.sig);
  end loop;
end $$;

-- B: trigger bodies and service-side utilities — no direct client execution
-- at all. Triggers do not require caller EXECUTE; edge functions use
-- service_role.
do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as sig
    from pg_proc p
    where p.pronamespace = 'public'::regnamespace
      and p.proname in (
        'create_notification','delete_old_notifications',
        'get_users_for_push_notification','mark_notification_as_sent',
        'send_push_notification_async','handle_new_user',
        'guard_profile_role_change','log_request_status_change',
        'notify_on_request_status_change','notify_doctors_new_request',
        'notify_doctor_assignment','notify_request_cancellation',
        'log_profile_changes','log_test_request_changes'
      )
  loop
    execute format('revoke all on function %s from public', r.sig);
    execute format('revoke all on function %s from anon', r.sig);
    execute format('revoke all on function %s from authenticated', r.sig);
    execute format('grant execute on function %s to service_role', r.sig);
  end loop;
end $$;
