-- ============================================
-- BUGAMED Notification System Test Script
-- ============================================
-- This script helps you test the notification system
-- Run these queries in Supabase SQL Editor

-- ============================================
-- 1. CHECK CURRENT NOTIFICATION SYSTEM STATUS
-- ============================================

-- View all notification-related tables
SELECT
  'Notifications' as table_name,
  COUNT(*) as count
FROM notifications
UNION ALL
SELECT
  'Notification Preferences',
  COUNT(*)
FROM notification_preferences
UNION ALL
SELECT
  'Users with FCM Tokens',
  COUNT(*)
FROM profiles
WHERE fcm_token IS NOT NULL;

-- ============================================
-- 2. VIEW EXISTING NOTIFICATIONS
-- ============================================

-- See latest 10 notifications
SELECT
  n.id,
  n.type,
  n.title,
  n.message,
  n.is_read,
  n.created_at,
  p.first_name || ' ' || p.last_name as user_name,
  p.role,
  n.metadata->>'push_sent' as push_sent
FROM notifications n
JOIN profiles p ON n.user_id = p.id
ORDER BY n.created_at DESC
LIMIT 10;

-- ============================================
-- 3. VIEW USER NOTIFICATION PREFERENCES
-- ============================================

-- See all users' notification preferences
SELECT
  p.id,
  p.first_name || ' ' || p.last_name as user_name,
  p.role,
  p.fcm_token IS NOT NULL as has_fcm_token,
  np.push_enabled,
  np.request_created_enabled,
  np.status_changed_enabled,
  np.quiet_hours_enabled,
  np.quiet_hours_start,
  np.quiet_hours_end
FROM profiles p
LEFT JOIN notification_preferences np ON p.id = np.user_id
ORDER BY p.created_at DESC;

-- ============================================
-- 4. TEST: CREATE A TEST NOTIFICATION
-- ============================================

-- First, get a user ID to test with
-- Copy a user_id from the results below:
SELECT
  id as user_id,
  first_name || ' ' || p.last_name as name,
  role,
  fcm_token IS NOT NULL as has_token
FROM profiles p
LIMIT 5;

-- Then create a test notification (replace <USER_ID> with actual ID from above)
DO $$
DECLARE
  v_user_id UUID := '<USER_ID>'; -- REPLACE THIS
BEGIN
  PERFORM create_notification(
    p_user_id := v_user_id,
    p_type := 'system_alert',
    p_title := 'Test Notification',
    p_message := 'This is a test push notification from BUGAMED system',
    p_related_request_id := NULL,
    p_metadata := jsonb_build_object('test', true, 'timestamp', NOW())
  );

  RAISE NOTICE 'Test notification created for user %', v_user_id;
END $$;

-- Verify the notification was created
SELECT * FROM notifications
WHERE title = 'Test Notification'
ORDER BY created_at DESC
LIMIT 1;

-- ============================================
-- 5. TEST: UPDATE FCM TOKEN
-- ============================================

-- Set a test FCM token for a user (replace <USER_ID>)
DO $$
DECLARE
  v_user_id UUID := '<USER_ID>'; -- REPLACE THIS
  v_test_token TEXT := 'test-fcm-token-' || FLOOR(RANDOM() * 1000)::TEXT;
BEGIN
  PERFORM update_fcm_token(v_user_id, v_test_token);
  RAISE NOTICE 'FCM token updated for user % with token %', v_user_id, v_test_token;
END $$;

-- Verify token was updated
SELECT
  id,
  first_name,
  fcm_token,
  fcm_token_updated_at
FROM profiles
WHERE fcm_token LIKE 'test-fcm-token%';

-- ============================================
-- 6. TEST: UPDATE NOTIFICATION PREFERENCES
-- ============================================

-- Update preferences for a user (replace <USER_ID>)
DO $$
DECLARE
  v_user_id UUID := '<USER_ID>'; -- REPLACE THIS
BEGIN
  -- Update or insert preferences
  INSERT INTO notification_preferences (
    user_id,
    push_enabled,
    request_created_enabled,
    request_accepted_enabled,
    status_changed_enabled,
    quiet_hours_enabled,
    quiet_hours_start,
    quiet_hours_end
  ) VALUES (
    v_user_id,
    true,  -- push enabled
    true,  -- request created enabled
    true,  -- request accepted enabled
    true,  -- status changed enabled
    true,  -- quiet hours enabled
    '22:00:00'::TIME,  -- quiet hours start (10 PM)
    '08:00:00'::TIME   -- quiet hours end (8 AM)
  )
  ON CONFLICT (user_id)
  DO UPDATE SET
    push_enabled = EXCLUDED.push_enabled,
    quiet_hours_enabled = EXCLUDED.quiet_hours_enabled,
    quiet_hours_start = EXCLUDED.quiet_hours_start,
    quiet_hours_end = EXCLUDED.quiet_hours_end,
    updated_at = NOW();

  RAISE NOTICE 'Notification preferences updated for user %', v_user_id;
END $$;

-- Verify preferences were updated
SELECT * FROM notification_preferences
WHERE user_id = '<USER_ID>'; -- REPLACE THIS

-- ============================================
-- 7. TEST: GET UNREAD COUNT
-- ============================================

-- Get unread notification count for a user (replace <USER_ID>)
SELECT get_unread_notification_count('<USER_ID>') as unread_count;

-- ============================================
-- 8. TEST: MARK ALL AS READ
-- ============================================

-- Mark all notifications as read for a user (replace <USER_ID>)
SELECT mark_all_notifications_read('<USER_ID>') as notifications_marked_read;

-- Verify they were marked as read
SELECT COUNT(*) as remaining_unread
FROM notifications
WHERE user_id = '<USER_ID>' AND is_read = false;

-- ============================================
-- 9. TEST: SIMULATE REQUEST STATUS CHANGE
-- ============================================

-- This will trigger notification creation automatically
-- First, get a test request (replace <REQUEST_ID> and <DOCTOR_ID>)

-- View available test requests
SELECT
  id as request_id,
  patient_id,
  doctor_id,
  status,
  scheduled_date
FROM test_requests
WHERE status = 'pending'
LIMIT 5;

-- Accept a request (this will trigger notification)
-- Replace <REQUEST_ID> and <DOCTOR_ID>
DO $$
DECLARE
  v_request_id UUID := '<REQUEST_ID>'; -- REPLACE THIS
  v_doctor_id UUID := '<DOCTOR_ID>'; -- REPLACE THIS
BEGIN
  UPDATE test_requests
  SET
    status = 'accepted',
    doctor_id = v_doctor_id,
    accepted_at = NOW(),
    updated_at = NOW()
  WHERE id = v_request_id;

  RAISE NOTICE 'Request % accepted by doctor %', v_request_id, v_doctor_id;
END $$;

-- Check if notification was created for the patient
SELECT * FROM notifications
WHERE type = 'request_accepted'
ORDER BY created_at DESC
LIMIT 1;

-- ============================================
-- 10. CLEANUP TEST DATA (Optional)
-- ============================================

-- Delete test notifications
DELETE FROM notifications
WHERE title = 'Test Notification' OR metadata->>'test' = 'true';

-- Reset test FCM tokens
UPDATE profiles
SET fcm_token = NULL, fcm_token_updated_at = NULL
WHERE fcm_token LIKE 'test-fcm-token%';

-- ============================================
-- 11. VIEW NOTIFICATION STATISTICS
-- ============================================

-- Overall statistics
SELECT
  COUNT(*) as total_notifications,
  COUNT(*) FILTER (WHERE is_read = true) as read_notifications,
  COUNT(*) FILTER (WHERE is_read = false) as unread_notifications,
  COUNT(*) FILTER (WHERE metadata->>'push_sent' = 'true') as push_sent,
  COUNT(DISTINCT user_id) as unique_users
FROM notifications;

-- Notifications by type
SELECT
  type,
  COUNT(*) as count,
  COUNT(*) FILTER (WHERE is_read = true) as read_count,
  COUNT(*) FILTER (WHERE is_read = false) as unread_count
FROM notifications
GROUP BY type
ORDER BY count DESC;

-- Notifications by user
SELECT
  p.first_name || ' ' || p.last_name as user_name,
  p.role,
  COUNT(*) as total_notifications,
  COUNT(*) FILTER (WHERE n.is_read = false) as unread_count
FROM notifications n
JOIN profiles p ON n.user_id = p.id
GROUP BY p.id, p.first_name, p.last_name, p.role
ORDER BY total_notifications DESC
LIMIT 10;

-- ============================================
-- 12. MAINTENANCE: CLEANUP OLD NOTIFICATIONS
-- ============================================

-- Preview what would be deleted (90 days old and read)
SELECT COUNT(*) as notifications_to_delete
FROM notifications
WHERE created_at < NOW() - INTERVAL '90 days'
AND is_read = true;

-- Actually delete old notifications (uncomment to run)
-- SELECT delete_old_notifications(90);

-- ============================================
-- 13. VIEW ALL TRIGGERS & FUNCTIONS
-- ============================================

-- View notification-related functions
SELECT
  routine_name,
  routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND (
  routine_name LIKE '%notification%'
  OR routine_name LIKE '%fcm%'
)
ORDER BY routine_name;

-- View notification-related triggers
SELECT
  tgname as trigger_name,
  tgrelid::regclass as table_name,
  proname as function_name
FROM pg_trigger t
JOIN pg_proc p ON t.tgfoid = p.oid
WHERE tgname LIKE '%notif%'
ORDER BY tgname;

-- ============================================
-- SUMMARY
-- ============================================

SELECT
  '✅ Notification System Status' as check_item,
  CASE
    WHEN EXISTS (SELECT 1 FROM notification_preferences LIMIT 1) THEN '✓ Active'
    ELSE '✗ Not Set Up'
  END as status
UNION ALL
SELECT
  '📱 Users with FCM Tokens',
  COUNT(*)::TEXT || ' users'
FROM profiles
WHERE fcm_token IS NOT NULL
UNION ALL
SELECT
  '🔔 Total Notifications',
  COUNT(*)::TEXT || ' notifications'
FROM notifications
UNION ALL
SELECT
  '👥 Total Users',
  COUNT(*)::TEXT || ' users'
FROM profiles;

-- ============================================
-- END OF TEST SCRIPT
-- ============================================

-- 📝 NOTES:
-- 1. Replace all <USER_ID>, <REQUEST_ID>, <DOCTOR_ID> with actual UUIDs
-- 2. Run sections one by one, don't run the entire script at once
-- 3. Check Edge Function logs in Supabase Dashboard for push notification status
-- 4. Ensure Firebase credentials are configured in Edge Function secrets
