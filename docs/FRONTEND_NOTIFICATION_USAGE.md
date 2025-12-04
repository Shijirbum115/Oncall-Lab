# Frontend Notification System - Usage Guide

## ✅ What's Implemented

The notification system frontend is now complete and ready to use:

### Components Created:
1. **Push Notification Service** (`lib/core/services/push_notification_service.dart`)
   - Handles Firebase Cloud Messaging initialization
   - Requests notification permissions
   - Gets and manages FCM tokens
   - Displays foreground notifications
   - Handles notification taps

2. **Notification Repository** (`lib/data/repositories/notification_repository.dart`)
   - Fetches notifications from Supabase
   - Marks notifications as read
   - Updates FCM tokens in backend
   - Real-time notification subscriptions

3. **Notification Store** (`lib/stores/notification_store.dart`)
   - MobX state management for notifications
   - Tracks unread count
   - Real-time updates
   - Simple API for UI components

4. **Notification UI**
   - `lib/ui/shared/notifications_screen.dart` - Full notifications list screen
   - `lib/ui/shared/widgets/notification_bell.dart` - Reusable bell icon with badge

5. **Dependency Injection**
   - All services registered in GetIt
   - Ready to use throughout the app

---

## 🚀 How to Use

### 1. Add Notification Bell to AppBar

Simply import and add the `NotificationBell` widget to any screen's AppBar:

```dart
import 'package:oncall_lab/ui/shared/widgets/notification_bell.dart';

AppBar(
  title: const Text('Home'),
  actions: const [
    NotificationBell(), // That's it!
  ],
)
```

The bell will automatically:
- Show unread count badge
- Navigate to notifications screen on tap
- Update in real-time

### 2. Navigate to Notifications Screen Programmatically

```dart
import 'package:oncall_lab/ui/shared/notifications_screen.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NotificationsScreen(),
  ),
);
```

### 3. Access Notification Store (Advanced)

If you need to access the notification store directly:

```dart
import 'package:get_it/get_it.dart';
import 'package:oncall_lab/stores/notification_store.dart';

final notificationStore = GetIt.I<NotificationStore>();

// Get unread count
int unread = notificationStore.unreadCount;

// Mark all as read
await notificationStore.markAllAsRead(userId);

// Load notifications
await notificationStore.loadNotifications(userId);
```

---

## 🔧 Firebase Configuration Required

Before the app can send/receive push notifications, you need to configure Firebase for your platforms:

### Android Setup

1. Place your `google-services.json` file in:
   ```
   android/app/google-services.json
   ```

2. Ensure `android/build.gradle` has:
   ```gradle
   dependencies {
     classpath 'com.google.gms:google-services:4.4.0'
   }
   ```

3. Ensure `android/app/build.gradle` has:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

### iOS Setup

1. Place your `GoogleService-Info.plist` file in:
   ```
   ios/Runner/GoogleService-Info.plist
   ```

2. Update `ios/Runner/Info.plist` to request notification permissions

### Testing Without Firebase Files

The app will compile and run without these files, but:
- Firebase initialization will fail
- You'll see errors in console
- Push notifications won't work
- **Backend notifications will still be created in database**

---

## 📱 How It Works

### Flow Diagram

```
User Action (e.g., Request Created)
    ↓
Supabase Trigger Creates Notification
    ↓
Edge Function Sends FCM Push
    ↓
Firebase Delivers to Device
    ↓
PushNotificationService Handles Message
    ↓
Local Notification Displayed
    ↓
User Taps Notification
    ↓
App Opens NotificationsScreen
```

### Automatic Initialization

The system automatically initializes when the app starts:

1. **Firebase** initializes in `main.dart`
2. **Push permissions** requested automatically
3. **FCM token** retrieved and saved to backend
4. **Notification store** initialized with user's notifications
5. **Real-time subscription** set up for new notifications

### On User Login

When a user logs in, the system automatically:
- Gets FCM token from device
- Saves token to Supabase backend
- Loads user's notifications
- Sets up real-time updates

### On User Logout

When a user logs out:
- FCM token is cleared from backend
- Local token is deleted
- Notification subscription is cancelled

---

## 🎨 UI Features

### NotificationsScreen

- ✅ List of all notifications (newest first)
- ✅ Unread notifications highlighted
- ✅ Pull-to-refresh
- ✅ Empty state when no notifications
- ✅ "Mark all read" button
- ✅ Tap notification to mark as read
- ✅ Beautiful icons for each notification type
- ✅ Relative timestamps (e.g., "5m ago", "2h ago")

### NotificationBell

- ✅ Bell icon in AppBar
- ✅ Red badge with unread count
- ✅ Shows "99+" if more than 99 unread
- ✅ Auto-updates in real-time
- ✅ Badge disappears when no unread

---

## 🔔 Notification Types

The system handles these notification types:

| Type | Icon | Color | Example |
|------|------|-------|---------|
| `request_created` | ➕ Add Circle | Blue | "New test request from patient" |
| `request_accepted` | ✅ Check Circle | Green | "Doctor accepted your request" |
| `request_updated` | 🔄 Update | Orange | "Request details updated" |
| `status_changed` | ⇄ Swap | Purple | "Doctor is on the way" |
| `system_alert` | ℹ️ Info | Red | "System maintenance notice" |

---

## 🧪 Testing Locally

### Test Without Real Devices

1. **Create test notification in Supabase SQL Editor:**
   ```sql
   SELECT create_notification(
     p_user_id := 'YOUR-USER-ID',
     p_type := 'system_alert',
     p_title := 'Test Notification',
     p_message := 'This is a test!',
     p_related_request_id := NULL,
     p_metadata := NULL
   );
   ```

2. **App should:**
   - Show notification in NotificationsScreen
   - Update unread badge
   - Display notification via real-time subscription

### Test With Real Devices

1. Set up Firebase configuration files (see above)
2. Run app on real device
3. Check console for FCM token
4. Verify token is saved in Supabase `profiles` table
5. Create notification in backend
6. Device should receive push notification

---

## 🛠️ Troubleshooting

### "Firebase not initialized" error
**Solution:** Add `google-services.json` (Android) or `GoogleService-Info.plist` (iOS)

### No FCM token in console
**Solution:** Ensure notification permissions granted. Check device settings.

### Notifications not appearing in list
**Solution:** Check if user is authenticated. Verify `user_id` in SQL queries.

### Push notifications not received
**Solution:**
1. Verify Firebase configuration files present
2. Check Edge Function logs in Supabase
3. Ensure FCM token saved in backend
4. Test with notification creation SQL query

### Badge not updating
**Solution:** Notification store uses real-time subscriptions. Ensure Supabase connection is active.

---

## ✨ Next Steps

### Recommended Enhancements (Optional)

1. **Deep Linking**: Navigate to specific screens based on notification type
   - Request notification → Open request detail
   - Status change → Open tracking screen

2. **Notification Settings**: Add preferences screen
   - Toggle notification types on/off
   - Set quiet hours
   - (Backend already supports this!)

3. **Rich Notifications**: Add images and action buttons
   - Quick reply
   - Accept/Decline buttons
   - Request images

4. **Sound & Vibration**: Custom notification sounds
   - Different sounds for different types
   - Vibration patterns

5. **Notification Grouping**: Group related notifications
   - Stack notifications by request
   - Expandable notification groups

---

## 📋 Summary

✅ **Completed:**
- Firebase integration
- FCM token management
- Notification UI screens
- Real-time updates
- MobX state management
- GetIt dependency injection
- Simple, clean API

⏳ **Required (Your Action):**
- Add Firebase configuration files for Android/iOS

🎯 **Ready to Use:**
- Just add `NotificationBell()` to your AppBar
- Everything else is automatic!

---

## 📂 Files Summary

### Created Files:
- `lib/core/services/push_notification_service.dart`
- `lib/data/models/notification_model.dart`
- `lib/data/repositories/notification_repository.dart`
- `lib/stores/notification_store.dart`
- `lib/ui/shared/notifications_screen.dart`
- `lib/ui/shared/widgets/notification_bell.dart`

### Modified Files:
- `pubspec.yaml` - Added Firebase packages
- `lib/main.dart` - Initialize Firebase and notifications
- `lib/core/di/service_locator.dart` - Register notification services

### Generated Files (by build_runner):
- `lib/data/models/notification_model.freezed.dart`
- `lib/data/models/notification_model.g.dart`
- `lib/stores/notification_store.g.dart`

---

**The notification system is simple, complete, and ready to use!** 🎉
