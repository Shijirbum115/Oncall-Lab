# 🔔 Push Notification System Setup Guide

## Overview

The OnCall Lab (BUGAMED) notification system is now fully implemented on the backend with:
- ✅ FCM token storage in database
- ✅ User notification preferences
- ✅ Supabase Edge Function for sending push notifications
- ✅ Database triggers for automatic notification creation
- ✅ RLS policies for security

## Architecture

```
[App Event] → [DB Trigger] → [Create Notification] → [Edge Function] → [FCM] → [User Device]
     ↓              ↓                    ↓                    ↓
  Status      notify_on_     notifications      send-push-      Firebase
  Change      request_       table              notification    Cloud
              status_                           Edge Fn         Messaging
              change()
```

---

## 🔥 Firebase Setup (Required)

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Name: **BUGAMED** or **OnCall Lab**
4. Enable Google Analytics (optional)
5. Create project

### Step 2: Add Android App

1. Click "Add app" → Android icon
2. **Android package name:** `com.bugamed.app` (or your package name)
3. Download `google-services.json`
4. Place in: `android/app/google-services.json`

### Step 3: Add iOS App

1. Click "Add app" → iOS icon
2. **iOS bundle ID:** `com.bugamed.app` (or your bundle ID)
3. Download `GoogleService-Info.plist`
4. Place in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Get FCM Server Key

#### Option A: Legacy Server Key (Easier, but deprecated)
1. Go to Project Settings → Cloud Messaging
2. Under "Cloud Messaging API (Legacy)", enable it
3. Copy **Server Key**
4. Save for Supabase configuration

#### Option B: Service Account Key (Recommended)
1. Go to Project Settings → Service Accounts
2. Click "Generate new private key"
3. Download JSON file
4. Extract the following:
   - `project_id`
   - `private_key`
   - `client_email`
5. Save for Supabase configuration

---

## ⚙️ Supabase Configuration

### Step 1: Set Environment Variables

Go to your Supabase project dashboard:
1. Navigate to **Project Settings** → **Edge Functions**
2. Add the following secrets:

#### If using Legacy Server Key:
```bash
FCM_SERVER_KEY=<Your FCM Server Key>
FCM_PROJECT_ID=<Your Firebase Project ID>
```

#### If using Service Account (OAuth 2.0):
```bash
FCM_PROJECT_ID=<Your Firebase Project ID>
FCM_PRIVATE_KEY=<Your Service Account Private Key>
FCM_CLIENT_EMAIL=<Your Service Account Email>
```

### Step 2: Enable pg_net Extension (Optional)

If you want automatic push notifications via triggers:

```sql
-- Enable pg_net extension for HTTP requests
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Set Supabase URL and service role key for triggers
ALTER DATABASE postgres SET app.settings.supabase_url = 'https://your-project.supabase.co';
ALTER DATABASE postgres SET app.settings.service_role_key = 'your-service-role-key';
```

⚠️ **Security Note:** Keep service role key secure. This is only for internal trigger usage.

### Step 3: Verify Edge Function

Test the Edge Function is deployed:
```bash
curl -X POST https://your-project.supabase.co/functions/v1/send-push-notification \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "notification_id": "test-id",
    "user_id": "test-user",
    "title": "Test Notification",
    "message": "This is a test",
    "fcm_token": "test-token"
  }'
```

---

## 📱 Flutter Setup (Frontend - Next Phase)

> **Note:** We'll implement this in the frontend phase, but here's what's needed:

### Required Packages
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.3.0
```

### Key Implementation Files (To be created)
- `lib/core/services/push_notification_service.dart`
- `lib/data/repositories/notification_repository.dart`
- `lib/stores/notification_store.dart`
- `lib/ui/patient/notifications_screen.dart`
- `lib/ui/doctor/notifications_screen.dart`

---

## 🗃️ Database Schema

### Tables Created

#### 1. **profiles** (Extended)
```sql
- fcm_token: TEXT -- Device FCM token
- fcm_token_updated_at: TIMESTAMPTZ -- Last token update
```

#### 2. **notification_preferences** (New)
```sql
- user_id: UUID (FK to profiles)
- push_enabled: BOOLEAN -- Master toggle
- request_created_enabled: BOOLEAN
- request_accepted_enabled: BOOLEAN
- request_updated_enabled: BOOLEAN
- status_changed_enabled: BOOLEAN
- system_alert_enabled: BOOLEAN
- quiet_hours_enabled: BOOLEAN
- quiet_hours_start: TIME
- quiet_hours_end: TIME
```

### Functions Created

#### Core Functions
1. **`update_fcm_token(user_id, token)`** - Update user's FCM token
2. **`get_users_for_push_notification(type)`** - Get eligible users for push
3. **`mark_notification_as_sent(notification_id)`** - Mark as sent
4. **`get_unread_notification_count(user_id)`** - Get badge count
5. **`mark_all_notifications_read(user_id)`** - Bulk mark as read
6. **`delete_old_notifications(days_old)`** - Cleanup old notifications

#### Trigger Functions
7. **`send_push_notification_async()`** - Auto-send push on notification insert
8. **`create_default_notification_preferences()`** - Auto-create preferences for new users

---

## 🔐 Security (RLS Policies)

All tables have Row Level Security enabled:

### notification_preferences
- ✅ Users can view/update their own preferences
- ✅ Admins can view/update all preferences
- ✅ Auto-created for new users

### notifications (Existing)
- ✅ Users can view their own notifications
- ✅ System can create notifications
- ✅ Admins can view all notifications

---

## 🧪 Testing the System

### 1. Test Notification Creation

```sql
-- Create a test notification for a user
SELECT create_notification(
  p_user_id := '<user-uuid>',
  p_type := 'system_alert',
  p_title := 'Test Notification',
  p_message := 'This is a test push notification',
  p_related_request_id := NULL,
  p_metadata := NULL
);
```

### 2. Test FCM Token Update

```sql
-- Update FCM token for a user
SELECT update_fcm_token(
  '<user-uuid>',
  'test-fcm-token-123'
);
```

### 3. Test Notification Preferences

```sql
-- View user preferences
SELECT * FROM notification_preferences WHERE user_id = '<user-uuid>';

-- Update preferences
UPDATE notification_preferences
SET
  push_enabled = true,
  quiet_hours_enabled = true,
  quiet_hours_start = '22:00:00',
  quiet_hours_end = '08:00:00'
WHERE user_id = '<user-uuid>';
```

### 4. Test Unread Count

```sql
-- Get unread notification count
SELECT get_unread_notification_count('<user-uuid>');
```

### 5. Test Mark All Read

```sql
-- Mark all notifications as read
SELECT mark_all_notifications_read('<user-uuid>');
```

---

## 🔄 Notification Flow Examples

### Example 1: New Request Created

```
1. Patient creates test request
   ↓
2. trigger_notify_doctors_new_request() fires
   ↓
3. create_notification() called for all available doctors
   ↓
4. Notification inserted into notifications table
   ↓
5. trigger_send_push_notification() fires
   ↓
6. Checks user preferences & FCM token
   ↓
7. Calls send-push-notification Edge Function
   ↓
8. Edge Function sends to Firebase FCM
   ↓
9. FCM delivers to doctor's device
```

### Example 2: Request Status Changed

```
1. Doctor updates request status to "on_the_way"
   ↓
2. trigger_validate_status_transition() validates
   ↓
3. notify_on_request_status_change() fires
   ↓
4. create_notification() for patient
   ↓
5. Push notification sent to patient
   ↓
6. Patient sees: "Doctor is on the way!"
```

---

## 🎯 Notification Types & Triggers

| Event | Trigger Function | Notification Type | Recipients |
|-------|-----------------|-------------------|------------|
| New request created | `notify_doctors_new_request` | `request_created` | All available doctors |
| Doctor accepts | `notify_doctor_assignment` | `request_accepted` | Patient |
| Status changed | `notify_patient_status_change` | `status_changed` | Patient |
| Request cancelled | `notify_request_cancellation` | `request_updated` | Doctor & Patient |

---

## 🐛 Troubleshooting

### Push notifications not sending?

1. **Check FCM token exists:**
   ```sql
   SELECT id, fcm_token FROM profiles WHERE id = '<user-id>';
   ```

2. **Check notification preferences:**
   ```sql
   SELECT * FROM notification_preferences WHERE user_id = '<user-id>';
   ```

3. **Check Edge Function logs:**
   - Go to Supabase Dashboard → Edge Functions → Logs
   - Look for errors in `send-push-notification`

4. **Verify FCM credentials:**
   - Ensure `FCM_SERVER_KEY` is set correctly
   - Ensure `FCM_PROJECT_ID` matches your Firebase project

5. **Check notification was created:**
   ```sql
   SELECT * FROM notifications
   WHERE user_id = '<user-id>'
   ORDER BY created_at DESC
   LIMIT 10;
   ```

### Token is invalid?

The Edge Function automatically clears invalid tokens:
```sql
-- This happens automatically when FCM returns INVALID_ARGUMENT
UPDATE profiles SET fcm_token = NULL WHERE id = '<user-id>';
```

---

## 📊 Monitoring & Maintenance

### Cleanup Old Notifications

Run periodically (e.g., via cron or pg_cron):
```sql
-- Delete notifications older than 90 days that have been read
SELECT delete_old_notifications(90);
```

### Monitor Notification Stats

```sql
-- Total notifications
SELECT COUNT(*) FROM notifications;

-- Unread notifications per user
SELECT user_id, COUNT(*) as unread_count
FROM notifications
WHERE is_read = false
GROUP BY user_id;

-- Notifications sent via push
SELECT COUNT(*) FROM notifications
WHERE metadata->>'push_sent' = 'true';
```

---

## 🚀 Next Steps (Frontend Implementation)

After backend is complete, we'll implement:

1. **Firebase SDK Integration**
   - Initialize Firebase in Flutter app
   - Request notification permissions
   - Get FCM token on app start

2. **Token Management**
   - Save FCM token to Supabase on login
   - Update token on refresh
   - Clear token on logout

3. **Notification UI**
   - Notification bell icon with badge
   - Notifications screen (list)
   - Notification detail screen
   - Settings screen for preferences

4. **Local Notifications**
   - Show notifications when app is in foreground
   - Handle notification taps
   - Navigate to relevant screens

---

## 📝 Summary

**Backend Status: ✅ COMPLETE**

- ✅ Database schema extended
- ✅ Notification preferences table
- ✅ All management functions
- ✅ RLS policies
- ✅ Edge Function deployed
- ✅ Triggers configured
- ⏳ Frontend implementation (next phase)

**What's Working:**
- Notifications are created in database
- Triggers fire on request events
- User preferences are respected
- FCM tokens can be stored
- Edge Function is ready to send push notifications

**What's Needed:**
- Firebase project setup (your action)
- Environment variables configured (your action)
- Flutter integration (next development phase)

---

## 🔗 Useful Links

- [Firebase Console](https://console.firebase.google.com/)
- [FCM Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Flutter Firebase Messaging](https://firebase.flutter.dev/docs/messaging/overview/)

---

**Ready for Firebase setup?** Follow the steps above and provide the credentials! 🚀
