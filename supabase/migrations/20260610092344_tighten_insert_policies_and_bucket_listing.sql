-- Reconstructed 2026-07-03 from supabase_migrations.schema_migrations
-- (original file was on the Windows machine and never committed).

-- These trigger functions insert into notifications/audit_logs. Make them
-- SECURITY DEFINER (owner bypasses RLS) so the permissive always-true
-- INSERT policies below can be dropped without breaking the triggers.
alter function public.notify_doctors_new_request() security definer;
alter function public.notify_doctor_assignment() security definer;
alter function public.notify_request_cancellation() security definer;
alter function public.log_profile_changes() security definer;
alter function public.log_test_request_changes() security definer;

-- Always-true INSERT policies: any authenticated user could insert
-- arbitrary notifications/audit rows for ANY user (phishing vector).
drop policy if exists "System can create notifications" on public.notifications;
drop policy if exists "Allow authenticated users to insert audit logs via triggers" on public.audit_logs;
drop policy if exists "Allow authenticated users to insert status history via triggers" on public.request_status_history;

-- Public buckets serve objects by URL without SELECT policies; the broad
-- SELECT policies only enabled listing every file in the bucket.
drop policy if exists "Public can view post media" on storage.objects;
drop policy if exists "Public profile photos are viewable by everyone" on storage.objects;
