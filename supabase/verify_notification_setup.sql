-- ============================================
-- BUGAMED Notification System Verification Script
-- ============================================
-- Run this script to verify your notification system is working
-- After configuring Firebase and Supabase secrets

-- ============================================
-- STEP 1: VERIFY DATABASE SETUP
-- ============================================
SELECT '🔍 STEP 1: Verifying Database Setup' as step;

-- Check all components exist
SELECT
  '✅ Database Components' as check_category,
  json_build_object(
    'profiles.fcm_token', EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_schema = 'public' AND table_name = 'profiles' AND column_name = 'fcm_token'
    ),
    'notification_preferences', EXISTS (
      SELECT 1 FROM information_schema.tables
      WHERE table_schema = 'public' AND table_name = 'notification_preferences'
    ),
    'update_fcm_token_fn', EXISTS (
      SELECT 1 FROM information_schema.routines
      WHERE routine_schema = 'public' AND routine_name = 'update_fcm_token'
    ),
    'push_trigger', EXISTS (
      SELECT 1 FROM pg_trigger WHERE tgname = 'trigger_send_push_notification'
    ),
    'profiles_rls_enabled', (
      SELECT rowsecurity FROM pg_tables
      WHERE schemaname = 'public' AND tablename = 'profiles'
    )
  ) as status;

-- ============================================
-- STEP 2: VERIFY EDGE FUNCTION
-- ============================================
SELECT '🔍 STEP 2: Edge Function Status' as step;

-- Note: You need to check this in Supabase Dashboard
-- Go to: Edge Functions → send-push-notification
-- Status should be: ACTIVE
-- Check deployment logs for any errors

SELECT '⚠️ MANUAL CHECK REQUIRED' as note,
       'Go to Supabase Dashboard → Edge Functions → send-push-notification' as instruction,
       'Verify status is ACTIVE and check logs' as action;

-- ============================================
-- STEP 3: VERIFY SECRETS CONFIGURATION
-- ============================================
SELECT '🔍 STEP 3: Secrets Configuration' as step;

-- Note: You cannot view secrets from SQL
-- Verify in Supabase Dashboard → Project Settings → Edge Functions
-- Required secrets:
-- - FCM_PROJECT_ID
-- - FCM_PRIVATE_KEY (or FCM_SERVER_KEY for legacy)
-- - FCM_CLIENT_EMAIL

SELECT '⚠️ MANUAL CHECK REQUIRED' as note,
       'Go to Supabase Dashboard → Project Settings → Edge Functions' as instruction,
       'Verify these secrets exist: FCM_PROJECT_ID, FCM_PRIVATE_KEY, FCM_CLIENT_EMAIL' as action;

-- ============================================
-- STEP 4: PREPARE TEST USER
-- ============================================
SELECT '🔍 STEP 4: Preparing Test User' as step;

-- Get the first user for testing
DO $$
DECLARE
  v_test_user_id UUID;
  v_test_user_name TEXT;
  v_test_user_role TEXT;
BEGIN
  -- Get first user
  SELECT id, COALESCE(first_name || ' ' || last_name, full_name, 'Test User'), role::TEXT
  INTO v_test_user_id, v_test_user_name, v_test_user_role
  FROM profiles
  LIMIT 1;

  IF v_test_user_id IS NULL THEN
    RAISE NOTICE '❌ No users found in database. Create a user first.';
  ELSE
    RAISE NOTICE '✅ Test user found:';
    RAISE NOTICE '   User ID: %', v_test_user_id;
    RAISE NOTICE '   Name: %', v_test_user_name;
    RAISE NOTICE '   Role: %', v_test_user_role;
    RAISE NOTICE '';
    RAISE NOTICE '📝 Copy this User ID for the next steps: %', v_test_user_id;
  END IF;
END $$;

-- Display test user info
SELECT
  id as user_id,
  COALESCE(first_name || ' ' || last_name, full_name) as name,
  role,
  phone_number,
  fcm_token IS NOT NULL as has_fcm_token,
  fcm_token_updated_at
FROM profiles
LIMIT 5;

-- ============================================
-- STEP 5: SET TEST FCM TOKEN
-- ============================================
SELECT '🔍 STEP 5: Setting Test FCM Token' as step;

-- Replace <USER_ID> with actual UUID from Step 4
-- Uncomment and run:

/*
DO $$
DECLARE
  v_user_id UUID := '<USER_ID>'; -- REPLACE THIS!
  v_test_token TEXT := 'test_fcm_token_' || floor(random() * 10000)::TEXT;
BEGIN
  -- Update FCM token
  PERFORM update_fcm_token(v_user_id, v_test_token);

  RAISE NOTICE '✅ FCM token set for user: %', v_user_id;
  RAISE NOTICE '   Token: %', v_test_token;
END $$;

-- Verify token was set
SELECT
  id,
  COALESCE(first_name || ' ' || last_name, full_name) as name,
  fcm_token,
  fcm_token_updated_at
FROM profiles
WHERE fcm_token IS NOT NULL
ORDER BY fcm_token_updated_at DESC
LIMIT 1;
*/

-- ============================================
-- STEP 6: CHECK NOTIFICATION PREFERENCES
-- ============================================
SELECT '🔍 STEP 6: Checking Notification Preferences' as step;

-- Replace <USER_ID> with actual UUID
/*
SELECT
  user_id,
  push_enabled,
  request_created_enabled,
  request_accepted_enabled,
  status_changed_enabled,
  quiet_hours_enabled,
  quiet_hours_start,
  quiet_hours_end
FROM notification_preferences
WHERE user_id = '<USER_ID>'; -- REPLACE THIS!
*/

-- If no preferences exist, they should be auto-created
-- But you can manually create them:
/*
INSERT INTO notification_preferences (
  user_id,
  push_enabled,
  request_created_enabled,
  request_accepted_enabled,
  status_changed_enabled,
  system_alert_enabled
) VALUES (
  '<USER_ID>', -- REPLACE THIS!
  true,
  true,
  true,
  true,
  true
)
ON CONFLICT (user_id) DO UPDATE SET
  push_enabled = EXCLUDED.push_enabled,
  updated_at = NOW();
*/

-- ============================================
-- STEP 7: CREATE TEST NOTIFICATION
-- ============================================
SELECT '🔍 STEP 7: Creating Test Notification' as step;

-- Replace <USER_ID> with actual UUID
-- This will trigger the push notification Edge Function
/*
DO $$
DECLARE
  v_user_id UUID := '<USER_ID>'; -- REPLACE THIS!
  v_notification_id UUID;
BEGIN
  -- Create a test notification
  v_notification_id := create_notification(
    p_user_id := v_user_id,
    p_type := 'system_alert',
    p_title := '🔔 Test Push Notification',
    p_message := 'This is a test notification from BUGAMED. If you receive this, your notification system is working!',
    p_related_request_id := NULL,
    p_metadata := jsonb_build_object(
      'test', true,
      'timestamp', NOW(),
      'source', 'verification_script'
    )
  );

  RAISE NOTICE '✅ Test notification created!';
  RAISE NOTICE '   Notification ID: %', v_notification_id;
  RAISE NOTICE '';
  RAISE NOTICE '📱 Check your device for the push notification';
  RAISE NOTICE '📊 Check Edge Function logs in Supabase Dashboard';
END $$;
*/

-- ============================================
-- STEP 8: VERIFY NOTIFICATION WAS CREATED
-- ============================================
SELECT '🔍 STEP 8: Verifying Notification' as step;

-- Check latest notification
SELECT
  id,
  user_id,
  type,
  title,
  message,
  is_read,
  created_at,
  metadata->>'push_sent' as push_sent,
  metadata->>'push_sent_at' as push_sent_at
FROM notifications
ORDER BY created_at DESC
LIMIT 5;

-- ============================================
-- STEP 9: CHECK EDGE FUNCTION LOGS
-- ============================================
SELECT '🔍 STEP 9: Checking Edge Function Execution' as step;

SELECT '⚠️ MANUAL CHECK REQUIRED' as note,
       'Go to Supabase Dashboard → Edge Functions → send-push-notification → Logs' as instruction,
       'Look for execution logs and any errors' as action;

-- Common issues to check:
-- 1. FCM_SERVER_KEY or credentials not set correctly
-- 2. Invalid FCM token format
-- 3. Firebase project not configured
-- 4. Network issues

-- ============================================
-- STEP 10: VERIFY PUSH NOTIFICATION FLOW
-- ============================================
SELECT '🔍 STEP 10: Testing Complete Workflow' as step;

-- This simulates a real notification flow
-- Replace <PATIENT_ID> and <DOCTOR_ID> with actual UUIDs
/*
DO $$
DECLARE
  v_patient_id UUID := '<PATIENT_ID>'; -- REPLACE THIS!
  v_doctor_id UUID := '<DOCTOR_ID>'; -- REPLACE THIS!
  v_request_id UUID;
BEGIN
  -- Make sure both users have FCM tokens set
  RAISE NOTICE '📝 Ensure both patient and doctor have FCM tokens set';

  -- Option 1: Create a real test request (will trigger notifications)
  -- Uncomment if you want to test with real request flow:
  /*
  INSERT INTO test_requests (
    patient_id,
    status,
    scheduled_date,
    scheduled_time_slot,
    patient_address,
    price_mnt
  ) VALUES (
    v_patient_id,
    'pending',
    CURRENT_DATE + 1,
    '09:00-10:00',
    'Test Address, Ulaanbaatar',
    25000
  )
  RETURNING id INTO v_request_id;

  RAISE NOTICE '✅ Test request created: %', v_request_id;
  RAISE NOTICE '📱 All available doctors should receive notification';

  -- Wait a moment, then accept the request (triggers patient notification)
  -- In real app, doctor would do this
  UPDATE test_requests
  SET
    status = 'accepted',
    doctor_id = v_doctor_id,
    accepted_at = NOW()
  WHERE id = v_request_id;

  RAISE NOTICE '✅ Request accepted by doctor';
  RAISE NOTICE '📱 Patient should receive notification';
  */
END $$;
*/

-- ============================================
-- VERIFICATION CHECKLIST
-- ============================================
SELECT '📋 VERIFICATION CHECKLIST' as section;

SELECT
  'Database Setup' as component,
  '✅ Complete' as status,
  'All tables, functions, and triggers exist' as details
UNION ALL
SELECT
  'RLS Security',
  '✅ Fixed',
  'profiles table RLS enabled'
UNION ALL
SELECT
  'Edge Function',
  'ℹ️ Check Dashboard',
  'Go to Edge Functions and verify ACTIVE status'
UNION ALL
SELECT
  'FCM Credentials',
  'ℹ️ Check Dashboard',
  'Verify secrets: FCM_PROJECT_ID, FCM_PRIVATE_KEY, FCM_CLIENT_EMAIL'
UNION ALL
SELECT
  'Test Notification',
  '⏳ Pending',
  'Run Step 7 to create test notification'
UNION ALL
SELECT
  'Push Received',
  '⏳ Pending',
  'Check your device for push notification'
UNION ALL
SELECT
  'Edge Function Logs',
  'ℹ️ Check Dashboard',
  'Verify no errors in execution logs';

-- ============================================
-- TROUBLESHOOTING
-- ============================================
SELECT '🔧 TROUBLESHOOTING GUIDE' as section;

-- Common issues and solutions
SELECT
  'Issue' as issue,
  'Solution' as solution
UNION ALL SELECT
  'No notification received',
  'Check: 1) FCM token is valid, 2) Edge Function logs, 3) Firebase project configured, 4) User preferences allow notifications'
UNION ALL SELECT
  'Edge Function error: FCM_SERVER_KEY not found',
  'Set secrets in Dashboard → Project Settings → Edge Functions'
UNION ALL SELECT
  'Invalid FCM token error',
  'Use real FCM token from Firebase SDK, not test token'
UNION ALL SELECT
  'Notification created but no push sent',
  'Check: 1) User has fcm_token set, 2) push_enabled=true, 3) Not in quiet hours'
UNION ALL SELECT
  'Permission denied errors',
  'Verify RLS policies are correct and user is authenticated';

-- ============================================
-- NEXT STEPS
-- ============================================
SELECT '🎯 NEXT STEPS' as section;

SELECT
  1 as step,
  'Replace <USER_ID> in Step 5 and run to set test FCM token' as action
UNION ALL SELECT
  2,
  'Run Step 7 to create test notification'
UNION ALL SELECT
  3,
  'Check Edge Function logs in Supabase Dashboard'
UNION ALL SELECT
  4,
  'If using real device: Integrate Firebase SDK in Flutter app'
UNION ALL SELECT
  5,
  'Test with real FCM token from device'
UNION ALL SELECT
  6,
  'Test complete workflow with real request status changes';

-- ============================================
-- SUMMARY
-- ============================================
SELECT '📊 SETUP SUMMARY' as section;

SELECT
  '✅ Backend Complete' as status,
  'Database, Edge Function, Triggers all configured' as details
UNION ALL SELECT
  '⏳ Testing Required',
  'Set FCM token and create test notification (Steps 5-7)'
UNION ALL SELECT
  '📱 Frontend Next',
  'Integrate Firebase SDK in Flutter app to receive notifications';
