# Real-Time Updates Implementation Guide 🚀

## ✅ What Has Been Implemented (Backend)

### Database Triggers Created:

1. **✅ Notification Triggers** - Auto-create notifications for:
   - New requests created → Notify all available doctors
   - Request status changes → Notify patient
   - Doctor assignment → Notify assigned doctor
   - Request cancellation → Notify affected parties

2. **✅ Audit Log Triggers** - Auto-track all changes to:
   - `profiles` table (user updates, verifications)
   - `doctor_profiles` table (doctor info changes)
   - `test_requests` table (all request changes)
   - `request_status_history` table (status transitions)

3. **✅ Statistics Triggers** - Auto-update:
   - Doctor `total_completed_requests` count
   - `updated_at` timestamps on all tables
   - Status transition validation (workflow integrity)

4. **✅ Realtime Enabled** on tables:
   - `test_requests` ✓
   - `notifications` ✓
   - `doctor_profiles` ✓
   - `doctor_availability` ✓
   - `profiles` ✓
   - `request_status_history` ✓

---

## 🎯 What Needs Implementation (Mobile App)

### Current Issue:
- ❌ NO real-time subscriptions in Flutter app
- ❌ Users must manually refresh to see updates
- ❌ Doctors don't see new requests instantly
- ❌ Patients don't see status updates instantly

### Solution:
Add Supabase real-time subscriptions to the mobile app!

---

## 📱 Implementation Steps

### Step 1: Update `test_request_repository.dart`

Add a stream method for real-time request updates:

```dart
// lib/data/repositories/test_request_repository.dart

import 'dart:async';

class TestRequestRepository {
  // ... existing methods ...

  /// Stream of pending requests (for doctors)
  Stream<List<TestRequestModel>> streamPendingRequests({
    RequestType? requestType,
    String? serviceId,
  }) {
    var query = supabase
        .from('test_requests')
        .stream(primaryKey: ['id'])
        .eq('status', 'pending')
        .isFilter('doctor_id', null);

    if (requestType != null) {
      query = query.eq('request_type', requestType.dbValue);
    }

    if (serviceId != null) {
      query = query.eq('service_id', serviceId);
    }

    return query
        .order('created_at', ascending: true)
        .map((data) => (data as List)
            .map((json) => TestRequestModel.fromJson(json))
            .toList());
  }

  /// Stream of patient's own requests
  Stream<List<TestRequestModel>> streamPatientRequests(String patientId) {
    return supabase
        .from('test_requests')
        .stream(primaryKey: ['id'])
        .eq('patient_id', patientId)
        .order('created_at', ascending: false)
        .map((data) => (data as List)
            .map((json) => TestRequestModel.fromJson(json))
            .toList());
  }

  /// Stream of doctor's active requests
  Stream<List<TestRequestModel>> streamDoctorActiveRequests(String doctorId) {
    return supabase
        .from('test_requests')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', doctorId)
        .inFilter('status', [
          'accepted',
          'on_the_way',
          'sample_collected',
          'delivered_to_lab'
        ])
        .order('scheduled_date', ascending: true)
        .map((data) => (data as List)
            .map((json) => TestRequestModel.fromJson(json))
            .toList());
  }

  /// Stream of notifications for a user
  Stream<List<Map<String, dynamic>>> streamUserNotifications(String userId) {
    return supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
  }
}
```

---

### Step 2: Update `test_request_store.dart`

Replace manual loading with real-time streams:

```dart
// lib/stores/test_request_store.dart

import 'dart:async';

abstract class _TestRequestStore with Store {
  final TestRequestRepository _repository = TestRequestRepository();

  StreamSubscription? _requestsSubscription;
  StreamSubscription? _notificationsSubscription;

  @observable
  ObservableList<TestRequestModel> patientRequests =
      ObservableList<TestRequestModel>();

  // ... other observables ...

  /// Subscribe to real-time patient requests
  @action
  void subscribeToPatientRequests(String patientId) {
    _requestsSubscription?.cancel();

    _requestsSubscription = _repository
        .streamPatientRequests(patientId)
        .listen(
          (requests) {
            patientRequests = ObservableList.of(requests);
            isLoading = false;
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
          },
        );
  }

  /// Unsubscribe from requests
  @action
  void unsubscribeFromRequests() {
    _requestsSubscription?.cancel();
    _requestsSubscription = null;
  }

  /// Clean up when store is disposed
  void dispose() {
    _requestsSubscription?.cancel();
    _notificationsSubscription?.cancel();
  }
}
```

---

### Step 3: Update `doctor_request_store.dart`

Add real-time subscriptions for doctors:

```dart
// lib/stores/doctor_request_store.dart

import 'dart:async';

abstract class _DoctorRequestStore with Store {
  final TestRequestRepository _repository = TestRequestRepository();

  StreamSubscription? _availableRequestsSubscription;
  StreamSubscription? _activeRequestsSubscription;

  @observable
  ObservableList<TestRequestModel> availableRequests =
      ObservableList<TestRequestModel>();

  @observable
  ObservableList<TestRequestModel> myActiveRequests =
      ObservableList<TestRequestModel>();

  /// Subscribe to available pending requests (real-time)
  @action
  void subscribeToAvailableRequests({
    RequestType? requestType,
    String? serviceId,
  }) {
    _availableRequestsSubscription?.cancel();

    _availableRequestsSubscription = _repository
        .streamPendingRequests(
          requestType: requestType,
          serviceId: serviceId,
        )
        .listen(
          (requests) {
            availableRequests = ObservableList.of(requests);
            isLoading = false;
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
          },
        );
  }

  /// Subscribe to doctor's active requests (real-time)
  @action
  void subscribeToMyActiveRequests(String doctorId) {
    _activeRequestsSubscription?.cancel();

    _activeRequestsSubscription = _repository
        .streamDoctorActiveRequests(doctorId)
        .listen(
          (requests) {
            myActiveRequests = ObservableList.of(requests);
            isLoading = false;
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
          },
        );
  }

  /// Clean up subscriptions
  void dispose() {
    _availableRequestsSubscription?.cancel();
    _activeRequestsSubscription?.cancel();
  }
}
```

---

### Step 4: Update UI Screens

Replace manual loading with subscriptions:

**Patient Screen Example:**
```dart
// In your patient requests screen

@override
void initState() {
  super.initState();
  final userId = context.read<AuthStore>().currentUser?.id;
  if (userId != null) {
    // OLD: testRequestStore.loadPatientRequests(userId);
    // NEW: Subscribe to real-time updates
    testRequestStore.subscribeToPatientRequests(userId);
  }
}

@override
void dispose() {
  testRequestStore.unsubscribeFromRequests();
  super.dispose();
}
```

**Doctor Screen Example:**
```dart
// In your doctor available requests screen

@override
void initState() {
  super.initState();
  // Subscribe to real-time available requests
  doctorRequestStore.subscribeToAvailableRequests();
}

@override
void dispose() {
  doctorRequestStore.dispose();
  super.dispose();
}
```

---

## 🎁 Bonus: Notifications Screen

Create a new notifications screen:

```dart
// lib/ui/shared/screens/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;

  const NotificationsScreen({super.key, required this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('notifications')
            .stream(primaryKey: ['id'])
            .eq('user_id', widget.userId)
            .order('created_at', ascending: false)
            .limit(50),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!;

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: Icon(
                  _getIconForType(notification['type']),
                  color: notification['is_read']
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                ),
                title: Text(
                  notification['title'],
                  style: TextStyle(
                    fontWeight: notification['is_read']
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notification['message']),
                trailing: Text(
                  _formatTime(notification['created_at']),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () => _markAsRead(notification['id']),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'request_created':
        return Icons.add_circle;
      case 'status_changed':
        return Icons.update;
      case 'request_accepted':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  Future<void> _markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
        .eq('id', notificationId);
  }
}
```

---

## ✨ Benefits After Implementation

### For Doctors:
- ✅ **Instant notification** when new requests arrive
- ✅ **No manual refresh needed** - requests appear automatically
- ✅ **Live status updates** on their active requests
- ✅ **Better user experience** - feels modern and responsive

### For Patients:
- ✅ **Instant updates** when doctor accepts request
- ✅ **Live tracking** of request status (on the way, collected, etc.)
- ✅ **Push-like notifications** within the app
- ✅ **No need to keep refreshing** the screen

### For Everyone:
- ✅ **Notifications stored in database** (triggered automatically)
- ✅ **Audit trail** of all changes (automatic logging)
- ✅ **Doctor statistics auto-update** when requests complete
- ✅ **Data consistency** ensured by database triggers
- ✅ **Professional, modern app experience**

---

## 🔧 Testing

After implementation:

1. **Test new request notification:**
   - Patient creates request → Doctors should see it instantly

2. **Test status updates:**
   - Doctor accepts → Patient sees instant update
   - Doctor updates status → Patient sees live progress

3. **Test notifications:**
   - Check notifications table has entries
   - Open notifications screen → Should see all events

---

## 📊 Performance Notes

- ✅ Real-time subscriptions use WebSocket (efficient)
- ✅ Only sends changes (not full data refetch)
- ✅ Automatically reconnects on network issues
- ✅ RLS policies enforce security (users only see their data)

---

## 🚀 Next Steps

1. Implement the stream methods in repositories ✓
2. Update stores to use subscriptions ✓
3. Update UI screens to subscribe/unsubscribe ✓
4. Add notifications screen (bonus) ✓
5. Test thoroughly with multiple users
6. Deploy and enjoy instant updates! 🎉

**Estimated Implementation Time:** 2-4 hours for a Flutter developer

Your backend is now fully set up and ready for real-time! 🔥
