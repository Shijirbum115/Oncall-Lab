# Flutter Integration Guide

This guide shows how to integrate your Flutter app with the Supabase backend.

## Initial Setup

### 1. Install Dependencies

Already in `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0
  mobx: ^2.2.0
  flutter_mobx: ^2.1.0
  get_it: ^7.7.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  auto_route: ^7.8.0

dev_dependencies:
  build_runner: ^2.4.6
  mobx_codegen: ^2.4.0
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  auto_route_generator: ^7.3.0
```

Run: `flutter pub get`

### 2. Initialize Supabase

Create `lib/core/services/supabase_service.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oncall_lab/core/constants/supabase_config.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

// Convenient global access
final supabase = SupabaseService.client;
```

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnCall Lab',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF665ACF),
      ),
      home: const SplashScreen(),
    );
  }
}
```

### 3. Get Supabase Credentials

Run this command to get your anon key:

```bash
# This will print your project URL and anon key
echo "Project URL: https://zrwtugcgimaocrhjdtob.supabase.co"
```

Or visit: https://supabase.com/dashboard/project/zrwtugcgimaocrhjdtob/settings/api

## Authentication Implementation

### Phone Number Authentication

Create `lib/stores/auth_store.dart`:

```dart
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/profile_model.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  @observable
  User? currentUser;

  @observable
  ProfileModel? currentProfile;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get isAuthenticated => currentUser != null;

  @computed
  UserRole? get userRole => currentProfile?.role;

  @action
  Future<void> sendOTP(String phoneNumber) async {
    isLoading = true;
    errorMessage = null;

    try {
      await supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: true,
      );
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> verifyOTP({
    required String phoneNumber,
    required String token,
    String? fullName,
    UserRole role = UserRole.patient,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final response = await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: token,
        type: OtpType.sms,
      );

      currentUser = response.user;

      // Check if profile exists
      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (profileData == null) {
        // Create new profile
        final newProfile = await supabase
            .from('profiles')
            .insert({
              'id': response.user!.id,
              'phone_number': phoneNumber,
              'full_name': fullName ?? 'User',
              'role': role.name,
            })
            .select()
            .single();

        currentProfile = ProfileModel.fromJson(newProfile);

        // If doctor, create doctor profile
        if (role == UserRole.doctor) {
          await supabase.from('doctor_profiles').insert({
            'id': response.user!.id,
            'license_number': 'TEMP-${DateTime.now().millisecondsSinceEpoch}',
            'is_available': false, // Set to false until verified
          });
        }
      } else {
        currentProfile = ProfileModel.fromJson(profileData);
      }
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadCurrentProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    currentUser = user;

    try {
      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      currentProfile = ProfileModel.fromJson(profileData);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> signOut() async {
    await supabase.auth.signOut();
    currentUser = null;
    currentProfile = null;
  }
}
```

### Authentication UI Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+976 99123456',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            if (_otpSent) ...[
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP Code',
                  hintText: '123456',
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text('Verify OTP'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _sendOTP,
                child: const Text('Send OTP'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _sendOTP() async {
    try {
      await authStore.sendOTP(_phoneController.text);
      setState(() => _otpSent = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your phone')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _verifyOTP() async {
    try {
      await authStore.verifyOTP(
        phoneNumber: _phoneController.text,
        token: _otpController.text,
        fullName: 'User Name', // Get from registration form
      );
      if (mounted) {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
```

## Data Models with Freezed

### Profile Model

Create `lib/data/models/profile_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

enum UserRole {
  @JsonValue('patient')
  patient,
  @JsonValue('doctor')
  doctor,
  @JsonValue('admin')
  admin,
}

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required UserRole role,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_verified') required bool isVerified,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
```

### Test Request Model

Create `lib/data/models/test_request_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_request_model.freezed.dart';
part 'test_request_model.g.dart';

enum RequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('on_the_way')
  onTheWay,
  @JsonValue('sample_collected')
  sampleCollected,
  @JsonValue('delivered_to_lab')
  deliveredToLab,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class TestRequestModel with _$TestRequestModel {
  const factory TestRequestModel({
    required String id,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'doctor_id') String? doctorId,
    @JsonKey(name: 'laboratory_id') String? laboratoryId,
    @JsonKey(name: 'test_type_id') required String testTypeId,
    required RequestStatus status,
    @JsonKey(name: 'scheduled_date') required DateTime scheduledDate,
    @JsonKey(name: 'scheduled_time_slot') String? scheduledTimeSlot,
    @JsonKey(name: 'patient_address') required String patientAddress,
    @JsonKey(name: 'patient_latitude') double? patientLatitude,
    @JsonKey(name: 'patient_longitude') double? patientLongitude,
    @JsonKey(name: 'patient_notes') String? patientNotes,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
    @JsonKey(name: 'on_the_way_at') DateTime? onTheWayAt,
    @JsonKey(name: 'sample_collected_at') DateTime? sampleCollectedAt,
    @JsonKey(name: 'delivered_to_lab_at') DateTime? deliveredToLabAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'price_mnt') required int priceMnt,
    @JsonKey(name: 'doctor_commission_mnt') int? doctorCommissionMnt,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'cancelled_by') String? cancelledBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _TestRequestModel;

  factory TestRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TestRequestModelFromJson(json);
}
```

Run: `dart run build_runner build --delete-conflicting-outputs`

## Repository Pattern

Create `lib/data/repositories/test_request_repository.dart`:

```dart
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/test_request_model.dart';

class TestRequestRepository {
  // Create a new test request
  Future<TestRequestModel> createRequest({
    required String testTypeId,
    required DateTime scheduledDate,
    required String scheduledTimeSlot,
    required String patientAddress,
    double? latitude,
    double? longitude,
    String? notes,
    required int priceMnt,
  }) async {
    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('test_requests')
        .insert({
          'patient_id': userId,
          'test_type_id': testTypeId,
          'scheduled_date': scheduledDate.toIso8601String(),
          'scheduled_time_slot': scheduledTimeSlot,
          'patient_address': patientAddress,
          'patient_latitude': latitude,
          'patient_longitude': longitude,
          'patient_notes': notes,
          'price_mnt': priceMnt,
          'status': 'pending',
        })
        .select()
        .single();

    return TestRequestModel.fromJson(data);
  }

  // Get all requests for current user
  Future<List<TestRequestModel>> getMyRequests() async {
    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('test_requests')
        .select()
        .eq('patient_id', userId)
        .order('created_at', ascending: false);

    return data.map((json) => TestRequestModel.fromJson(json)).toList();
  }

  // Doctor: Get pending requests
  Future<List<TestRequestModel>> getPendingRequests() async {
    final data = await supabase
        .rpc('get_pending_requests_for_doctor')
        .select();

    return data.map((json) => TestRequestModel.fromJson(json)).toList();
  }

  // Doctor: Accept a request
  Future<TestRequestModel> acceptRequest(String requestId) async {
    final doctorId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('test_requests')
        .update({
          'status': 'accepted',
          'doctor_id': doctorId,
        })
        .eq('id', requestId)
        .eq('status', 'pending') // Optimistic locking
        .select()
        .single();

    return TestRequestModel.fromJson(data);
  }

  // Update request status
  Future<TestRequestModel> updateStatus(
    String requestId,
    RequestStatus newStatus,
  ) async {
    final data = await supabase
        .from('test_requests')
        .update({'status': newStatus.name})
        .eq('id', requestId)
        .select()
        .single();

    return TestRequestModel.fromJson(data);
  }

  // Cancel request
  Future<TestRequestModel> cancelRequest(
    String requestId,
    String reason,
  ) async {
    final data = await supabase
        .from('test_requests')
        .update({
          'status': 'cancelled',
          'cancellation_reason': reason,
        })
        .eq('id', requestId)
        .select()
        .single();

    return TestRequestModel.fromJson(data);
  }
}
```

## MobX Store for Test Requests

Create `lib/stores/test_request_store.dart`:

```dart
import 'package:mobx/mobx.dart';
import 'package:oncall_lab/data/models/test_request_model.dart';
import 'package:oncall_lab/data/repositories/test_request_repository.dart';

part 'test_request_store.g.dart';

class TestRequestStore = _TestRequestStore with _$TestRequestStore;

abstract class _TestRequestStore with Store {
  final TestRequestRepository _repository = TestRequestRepository();

  @observable
  ObservableList<TestRequestModel> requests = ObservableList<TestRequestModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadMyRequests() async {
    isLoading = true;
    errorMessage = null;

    try {
      final data = await _repository.getMyRequests();
      requests = ObservableList.of(data);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createRequest({
    required String testTypeId,
    required DateTime scheduledDate,
    required String scheduledTimeSlot,
    required String patientAddress,
    double? latitude,
    double? longitude,
    String? notes,
    required int priceMnt,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final request = await _repository.createRequest(
        testTypeId: testTypeId,
        scheduledDate: scheduledDate,
        scheduledTimeSlot: scheduledTimeSlot,
        patientAddress: patientAddress,
        latitude: latitude,
        longitude: longitude,
        notes: notes,
        priceMnt: priceMnt,
      );

      requests.insert(0, request);
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateStatus(String requestId, RequestStatus newStatus) async {
    try {
      final updated = await _repository.updateStatus(requestId, newStatus);

      final index = requests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        requests[index] = updated;
      }
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<void> cancelRequest(String requestId, String reason) async {
    try {
      final updated = await _repository.cancelRequest(requestId, reason);

      final index = requests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        requests[index] = updated;
      }
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    }
  }
}
```

Run: `dart run build_runner build --delete-conflicting-outputs`

## Real-time Subscriptions

### Subscribe to Request Updates

```dart
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeTestRequestStore {
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  void subscribeToMyRequests(String userId) {
    _subscription = supabase
        .from('test_requests')
        .stream(primaryKey: ['id'])
        .eq('patient_id', userId)
        .listen((data) {
          // Update your observable list
          final requests = data.map((json) => TestRequestModel.fromJson(json)).toList();
          // Update store...
        });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
```

### Subscribe to Notifications

```dart
class NotificationStore {
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  void subscribeToNotifications(String userId) {
    _subscription = supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .eq('is_read', false)
        .listen((data) {
          // Show notification UI
          final unreadCount = data.length;
          // Update badge...
        });
  }

  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        })
        .eq('id', notificationId);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
```

## Error Handling

### Global Error Handler

```dart
class SupabaseErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid OTP code. Please try again.';
        case 'User already registered':
          return 'This phone number is already registered.';
        default:
          return error.message;
      }
    } else if (error is PostgrestException) {
      return 'Database error: ${error.message}';
    } else {
      return error.toString();
    }
  }
}
```

## Dependency Injection with GetIt

Create `lib/core/di/service_locator.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:oncall_lab/data/repositories/auth_repository.dart';
import 'package:oncall_lab/data/repositories/doctor_repository.dart';
import 'package:oncall_lab/data/repositories/laboratory_repository.dart';
import 'package:oncall_lab/data/repositories/service_repository.dart';
import 'package:oncall_lab/data/repositories/test_request_repository.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/doctor_request_store.dart';
import 'package:oncall_lab/stores/home_store.dart';
import 'package:oncall_lab/stores/locale_store.dart';
import 'package:oncall_lab/stores/service_store.dart';
import 'package:oncall_lab/stores/test_request_store.dart';

final locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  locator.registerLazySingleton<DoctorRepository>(() => DoctorRepository());
  locator.registerLazySingleton<LaboratoryRepository>(
    () => LaboratoryRepository(),
  );
  locator.registerLazySingleton<ServiceRepository>(() => ServiceRepository());
  locator.registerLazySingleton<TestRequestRepository>(
    () => TestRequestRepository(),
  );

  // Stores
  locator.registerLazySingleton<LocaleStore>(() => LocaleStore());
  locator.registerLazySingleton<AuthStore>(
    () => AuthStore(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<HomeStore>(
    () => HomeStore(
      locator<ServiceRepository>(),
      locator<DoctorRepository>(),
    ),
  );
  locator.registerLazySingleton<ServiceStore>(
    () => ServiceStore(locator<ServiceRepository>()),
  );
  locator.registerLazySingleton<TestRequestStore>(
    () => TestRequestStore(locator<TestRequestRepository>()),
  );
  locator.registerLazySingleton<DoctorRequestStore>(
    () => DoctorRequestStore(locator<TestRequestRepository>()),
  );
}
```

Expose helpers where needed so UI code can simply call `authStore`/`homeStore`:

```dart
final GetIt _getIt = GetIt.instance;

AuthStore get authStore => _getIt<AuthStore>();
HomeStore get homeStore => _getIt<HomeStore>();
```

Update `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  await SupabaseService.initialize();

  runApp(const MyApp());
}
```

## Testing

### Unit Test Example

Create `test/stores/auth_store_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:oncall_lab/stores/auth_store.dart';

void main() {
  group('AuthStore', () {
    late AuthStore authStore;

    setUp(() {
      authStore = AuthStore(_FakeAuthRepository());
    });

    test('initial state should be unauthenticated', () {
      expect(authStore.isAuthenticated, false);
      expect(authStore.currentUser, null);
    });
  });
}

class _FakeAuthRepository extends AuthRepository {
  @override
  User? get currentUser => null;
}
```

## Best Practices

1. **Always use RLS-protected queries** - Never bypass RLS with service role key in client
2. **Handle auth state changes** - Listen to `supabase.auth.onAuthStateChange`
3. **Implement retry logic** - For network failures
4. **Cache data locally** - Use `hive` or `shared_preferences` for offline support
5. **Validate inputs** - Before sending to backend
6. **Use transactions** - For critical multi-step operations
7. **Monitor real-time connections** - Clean up subscriptions to avoid memory leaks
8. **Log errors** - Use proper error tracking (Sentry, Firebase Crashlytics)

## Next Steps

1. Implement remaining screens (patient dashboard, doctor dashboard, admin panel)
2. Add location services for GPS coordinates
3. Implement push notifications
4. Add file upload for doctor licenses/certifications
5. Implement payment integration
6. Add analytics tracking
7. Set up CI/CD pipeline

## Resources

- Supabase Flutter Docs: https://supabase.com/docs/reference/dart/introduction
- MobX Tutorial: https://pub.dev/packages/mobx
- Freezed Guide: https://pub.dev/packages/freezed
- AutoRoute Setup: https://pub.dev/packages/auto_route
