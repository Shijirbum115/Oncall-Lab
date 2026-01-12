# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

OnCall Lab (BUGAMED) is a Flutter mobile application for home laboratory test sample collection in Ulaanbaatar, Mongolia. The app connects patients with doctors/lab technicians for at-home sample collection and direct medical services (ultrasound, ECG, nursing, etc.).

**Tech Stack:**
- Flutter 3.10+ (Dart)
- Supabase (PostgreSQL, Auth, Real-time, RLS)
- MobX for state management
- GetIt for dependency injection
- Freezed + json_serializable for models
- Firebase Cloud Messaging for push notifications
- QPay payment integration

**Three User Roles:**
- **Patient**: Books lab tests and direct services, tracks requests
- **Doctor/Lab Technician**: Accepts requests, updates status, collects samples
- **Admin**: Manages users, doctors (approval workflow), and views all requests

## Development Commands

### Essential Commands

```powershell
# Install dependencies
flutter pub get

# Run the app
flutter run

# Check connected devices/emulators
flutter devices

# Analyze code
flutter analyze

# Run tests
flutter test

# Run a specific test file
flutter test test\widget_test.dart
```

### Code Generation (Critical)

This project heavily uses code generation for MobX stores, Freezed models, and json_serializable. **Always run build_runner after modifying:**
- MobX stores (`*_store.dart`)
- Freezed models (`*_model.dart`)
- JSON serializable models

```powershell
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# Clean build artifacts
flutter clean
```

### Firebase Setup (Optional - for Push Notifications)

Push notifications require Firebase configuration. If not configured, the app runs without notifications.

```powershell
# Configure Firebase (requires Firebase CLI)
flutterfire configure
```

## Architecture

### State Management Pattern (MobX)

All application state is managed through MobX stores in `lib/stores/`:

- **AuthStore**: User authentication, current profile, role checks
- **HomeStore**: Home screen data (services, doctors)
- **ServiceStore**: Service listings and details
- **TestRequestStore**: Patient's test requests (CRUD operations)
- **DoctorRequestStore**: Doctor's request management
- **NotificationStore**: Real-time notifications with FCM integration
- **PaymentStore**: QPay payment processing
- **LocaleStore**: Localization (Mongolian/English)

**Usage Pattern:**
```dart
// Access stores via GetIt
final authStore = locator<AuthStore>();

// Observe state in widgets
Observer(
  builder: (_) => Text(authStore.currentProfile?.fullName ?? ''),
)
```

### Data Layer Architecture

**Models** (`lib/data/models/`):
- Use `@freezed` annotation for immutability
- Implement `fromJson`/`toJson` for Supabase integration
- Generated files: `*_model.freezed.dart`, `*_model.g.dart`

**Repositories** (`lib/data/repositories/`):
- Abstract Supabase data access
- All database operations go through repositories
- Return domain models, not raw JSON

**Key Models:**
- `ProfileModel`: User profiles
- `DoctorProfileModel`: Extended doctor information
- `TestRequestModel`: Test/service requests (main workflow entity)
- `ServiceModel`: Available services
- `LaboratoryModel`: Laboratory facilities
- `NotificationModel`: User notifications

### Request Workflow (Critical)

The core business logic revolves around `test_requests` table with this status flow:

```
pending → accepted → on_the_way → sample_collected → delivered_to_lab → completed
                                                                        ↓
                                                                    cancelled
```

**Request Types:**
- `lab_service`: Patient books lab test from a specific laboratory
- `direct_service`: Patient books direct medical service (ultrasound, ECG, nursing)

**Status Updates:**
- Each status change updates corresponding timestamp field (e.g., `accepted_at`, `completed_at`)
- Triggers automatic notifications to patient and doctor
- Logged in `request_status_history` for audit trail

### Dependency Injection (GetIt)

All services, repositories, and stores are registered in `lib/core/di/service_locator.dart`:

```dart
// Access registered instances
final repository = locator<TestRequestRepository>();
final store = locator<AuthStore>();
```

**Registration happens in `main.dart` before app launch:**
```dart
await setupServiceLocator();
```

### Supabase Integration

**Configuration:**
- Supabase URL and anon key are stored in `lib/core/constants/supabase_config.dart` (git-ignored)
- Use `.env` file for environment variables (git-ignored)
- Copy `.env.example` to `.env` and fill in credentials

**Real-time Subscriptions:**
- `test_requests`: Live status updates
- `notifications`: Instant notification delivery
- `doctor_profiles`: Live availability status

**Row Level Security (RLS):**
- All tables have RLS enabled
- Patients can only access their own data
- Doctors can access their assigned requests and patient info
- Admins have full access

**Database Functions:**
Available as RPC calls:
- `get_available_doctors(p_scheduled_date)`: Returns available verified doctors
- `get_pending_requests_for_doctor()`: Returns requests doctors can accept
- `create_notification(...)`: Creates user notifications

### UI Structure

```
lib/ui/
├── patient/               # Patient app screens
│   ├── main_page.dart     # Bottom navigation (Home, Laboratory, Requests, Profile)
│   ├── screens/           # Core patient screens
│   ├── booking/           # Booking flow widgets
│   ├── location/          # Location picker, address management
│   └── widgets/           # Patient-specific widgets
├── doctor/                # Doctor app screens
│   ├── doctor_main_page.dart  # Doctor dashboard with tabs
│   └── widgets/           # Doctor-specific widgets
├── auth/                  # Login, OTP verification, registration
├── admin/                 # Admin interface (placeholder)
├── payment/               # QPay payment screens
├── design_system/         # App theme (AppTheme.light())
└── shared/                # Shared widgets, splash screen
```

### Localization

- Supports Mongolian (mn) and English (en)
- Uses Flutter's built-in l10n with ARB files
- Generate localizations: configured in `l10n.yaml`
- Access: `AppLocalizations.of(context)`
- Managed by `LocaleStore`

## Common Development Tasks

### Adding a New MobX Store

1. Create `lib/stores/my_store.dart`:
```dart
import 'package:mobx/mobx.dart';

part 'my_store.g.dart';

class MyStore = _MyStore with _$MyStore;

abstract class _MyStore with Store {
  @observable
  String value = '';

  @action
  void setValue(String newValue) {
    value = newValue;
  }
}
```

2. Register in `service_locator.dart`:
```dart
locator.registerLazySingleton<MyStore>(() => MyStore());
```

3. Run code generation:
```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Adding a New Freezed Model

1. Create `lib/data/models/my_model.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

2. Run code generation:
```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Querying Supabase

```dart
// Import the global client
import 'package:oncall_lab/core/services/supabase_service.dart';

// Simple query
final data = await supabase
  .from('profiles')
  .select()
  .eq('id', userId)
  .single();

// RPC function call
final doctors = await supabase
  .rpc('get_available_doctors', params: {'p_scheduled_date': '2025-11-20'});

// Real-time subscription
final subscription = supabase
  .from('test_requests')
  .stream(primaryKey: ['id'])
  .eq('patient_id', userId)
  .listen((data) {
    // Handle updates
  });
```

### Creating a Test Request

Use `TestRequestRepository` methods:
- `createLabServiceRequest()`: For laboratory tests
- `createDirectServiceRequest()`: For direct medical services

Both methods handle proper data insertion and return a `TestRequestModel`.

## Backend Architecture (Supabase)

### Key Database Tables

- `profiles`: All user profiles (patient/doctor/admin role)
- `doctor_profiles`: Extended doctor information (specialization, license, rating)
- `laboratories`: Laboratory facilities in Ulaanbaatar
- `services`: Available services (lab tests, diagnostic, nursing)
- `laboratory_services`: Services offered by each laboratory
- `doctor_services`: Services offered by each doctor
- `test_requests`: Main workflow table (requests with status flow)
- `notifications`: In-app and push notifications
- `request_status_history`: Audit trail for status changes
- `payments`: QPay payment transactions

### Database Migrations

Located in `supabase/migrations/`:
- `202411151001_fix_profiles_rls.sql`: Critical RLS policies
- `20241221_create_payments_table.sql`: Payment system
- `20251129_add_patient_addresses.sql`: Saved addresses
- `20251201_drop_test_types_table.sql`: Schema refactoring

Apply migrations in Supabase SQL Editor.

### Push Notification System

**Backend**: Fully implemented with Edge Function `send-push-notification`
**Setup**: Requires Firebase FCM credentials in Supabase Edge Function secrets

**Database Components:**
- `profiles.fcm_token`: Stores Firebase device tokens
- `notification_preferences`: User notification settings
- Automatic triggers on request status changes

See `docs/NOTIFICATION_SYSTEM_SETUP.md` for full setup guide.

## Admin Panel (Web)

Separate Flutter web application in `admin_panel_web/`:

```powershell
cd admin_panel_web
flutter pub get
flutter run -d chrome
```

**Features:**
- Dashboard with statistics and 30-day request trend chart
- User management (CRUD operations)
- Doctor approval workflow (verify license, activate doctors)
- Requests viewing with filters

## Important Files & Documentation

- `README.md`: Project overview, setup instructions (Mongolian)
- `CLAUDE.md`: Development commands, architecture patterns
- `docs/BACKEND_ARCHITECTURE.md`: Complete database schema, RLS policies, functions
- `docs/FLUTTER_INTEGRATION.md`: Flutter-Supabase integration examples
- `FILE_STRUCTURE_GUIDE.md`: File organization guide
- `ADMIN_PANEL_SETUP.md`: Admin panel features and setup

## Critical Security Notes

**NEVER commit these files to git (already in `.gitignore`):**
- `lib/core/constants/supabase_config.dart`: Supabase credentials
- `.env`: Environment variables (Supabase URL/key, QPay credentials)
- Any file containing API keys, tokens, or secrets

**Always use `.env.example` as template** and create local `.env` file.

## Testing

- Test files in `test/` directory
- Run all tests: `flutter test`
- Run specific test: `flutter test test\widget_test.dart`
- Use `flutter analyze` to check for code issues

## Code Style Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Private**: Prefix with `_`

**Import Order:**
1. Dart/Flutter imports
2. Package imports
3. Project imports (prefixed with `package:oncall_lab/`)

## Hot Reload & Hot Restart

During development with `flutter run`:
- Press `r` for hot reload (preserves state)
- Press `R` for hot restart (resets state)

## Platform-Specific Notes

### Windows (Current Environment)

- Use PowerShell commands
- File paths use backslashes (`\`)
- Emulator: Android Studio emulator or physical device via USB debugging

### Common Issues

1. **Build runner conflicts**: Use `--delete-conflicting-outputs` flag
2. **Supabase not initialized**: Ensure `supabase_config.dart` exists with valid credentials
3. **Firebase errors**: Optional; app runs without it if not configured
4. **Code generation errors**: Run `flutter clean` then regenerate

## Git Workflow

The repository uses standard Git with `main` branch. When making changes:

1. Create feature branch: `git checkout -b feature/my-feature`
2. Make changes and commit
3. Test thoroughly
4. Push and create pull request

**Commit Co-authoring:**
When making commits, include co-author line:
```
Co-Authored-By: Warp <agent@warp.dev>
```
