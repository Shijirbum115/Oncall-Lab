# OnCall Lab - File Structure Guide

This guide shows the complete file structure for integrating the UI template with Supabase backend.

## ✅ Already Created

```
oncall_lab/
├── assets/
│   └── images/                    ✅ Assets copied from template
│       ├── hand.png
│       ├── dizzy.png
│       ├── headache.png
│       ├── snuffle.png
│       └── temperature.png
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart    ✅ Updated with template colors
│   │   │   ├── app_strings.dart   ✅ Exists
│   │   │   ├── test_types.dart    ✅ Exists
│   │   │   └── supabase_config.dart ✅ With your credentials
│   └── ui/patient/                 ✅ Core patient experience
│       ├── main_page.dart          ✅ Bottom navigation (Home, Laboratory, Requests, Profile)
│       ├── home_screen.dart        ✅ Patient dashboard pulling Supabase data
│       ├── laboratories_screen.dart ✅ New laboratory directory list
│       ├── laboratory_detail_screen.dart ✅ Detailed view for a selected laboratory
│       ├── requests_screen.dart    ✅ My requests screen
│       └── profile_screen.dart     ✅ Profile and sign-out screen
└── docs/
    ├── BACKEND_SETUP.md              ✅ Backend setup & quick start
    ├── ADMIN_PANEL_SETUP.md          ✅ Admin panel
    ├── FILE_STRUCTURE_GUIDE.md       ✅ This file
    ├── LOCALIZATION_GUIDE.md         ✅ mn/en localization
    ├── QPAY_READY.md                 ✅ QPay payment integration
    ├── REALTIME_IMPLEMENTATION_GUIDE.md  ✅ Realtime implementation
    ├── MOBILE_APP_REALTIME.md        ✅ Mobile realtime usage
    └── STORAGE_SETUP_GUIDE.md        ✅ Supabase Storage setup
```

## 🔨 Files to Create

Follow the code in `docs/UI_TEMPLATE_INTEGRATION.md` to create these files:

### 1. Core Services
```
lib/core/services/
└── supabase_service.dart          🔨 Create this - Supabase initialization
```

### 2. Patient UI (Priority 1)
```
lib/ui/patient/
├── main_page.dart                 🔨 Bottom navigation (Code provided)
├── home_screen.dart               🔨 Patient dashboard (Code provided)
├── requests_screen.dart           🔨 My requests screen (Code provided)
└── profile_screen.dart            🔨 Profile screen (Code provided)
```

### 3. Update main.dart
```
lib/
└── main.dart                      🔨 Update with provided code
```

## 📋 Future Files (Build After Core Works)

### Authentication
```
lib/ui/auth/
├── login_screen.dart              📋 Phone number login
├── otp_verification_screen.dart   📋 OTP input
└── registration_screen.dart       📋 New user registration
```

### Patient Features
```
lib/ui/patient/
├── doctor_detail_screen.dart      📋 View doctor profile
├── request_test_screen.dart       📋 Multi-step test request form
└── request_detail_screen.dart     📋 View request details
```

### Doctor UI
```
lib/ui/doctor/
├── doctor_main_page.dart          📋 Doctor dashboard
├── pending_requests_screen.dart   📋 View & accept requests
├── active_requests_screen.dart    📋 Manage active requests
└── update_status_screen.dart      📋 Update request status
```

### Admin UI
```
lib/ui/admin/
├── admin_dashboard.dart           📋 Admin overview
├── manage_users_screen.dart       📋 User management
└── manage_doctors_screen.dart     📋 Doctor verification
```

### Shared Widgets
```
lib/ui/shared/widgets/
├── doctor_card.dart               📋 Reusable doctor card
├── request_card.dart              📋 Reusable request card
├── status_badge.dart              📋 Status indicator
├── custom_button.dart             📋 Branded button
└── custom_text_field.dart         📋 Form input
```

### Data Layer
```
lib/data/
├── models/                        📋 Freezed models
│   ├── profile_model.dart
│   ├── doctor_model.dart
│   ├── test_type_model.dart
│   ├── test_request_model.dart
│   └── notification_model.dart
└── repositories/                  📋 Data access
    ├── auth_repository.dart
    ├── doctor_repository.dart
    ├── test_request_repository.dart
    └── notification_repository.dart
```

### State Management
```
lib/stores/                        📋 MobX stores
├── auth_store.dart
├── doctor_store.dart
├── test_request_store.dart
└── notification_store.dart
```

### Navigation
```
lib/routing/                       📋 AutoRoute
├── app_router.dart
└── app_router.gr.dart            (Generated)
```

## Quick Start Checklist

### Step 1: Core Setup ✅
- [x] Backend is ready (Supabase)
- [x] Assets copied
- [x] Colors configured
- [x] Dependencies in pubspec.yaml

### Step 2: Essential Files (Do This First!)
- [ ] Create `lib/core/services/supabase_service.dart`
- [ ] Update `lib/main.dart`
- [ ] Create `lib/ui/patient/main_page.dart`
- [ ] Create `lib/ui/patient/home_screen.dart`
- [ ] Create `lib/ui/patient/requests_screen.dart`
- [ ] Create `lib/ui/patient/profile_screen.dart`

### Step 3: Test It Works
```bash
flutter pub get
flutter run
```

You should see:
- Bottom navigation with 4 tabs
- Home screen showing test types and doctors from Supabase
- Requests screen (empty if no requests yet)
- Profile screen with sign out

### Step 4: Build Authentication
- [ ] Create login screen
- [ ] Create OTP verification
- [ ] Integrate with Supabase Auth
- [ ] Test phone number login

### Step 5: Complete Patient Flow
- [ ] Doctor detail screen
- [ ] Request test form
- [ ] Real-time status updates
- [ ] Notifications

### Step 6: Build Doctor Interface
- [ ] Doctor dashboard
- [ ] Accept requests
- [ ] Update status
- [ ] View patient info

## Development Workflow

1. **Start build runner (in separate terminal):**
   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Make changes** - Flutter hot reloads automatically

## Code Generation Reminders

After creating/modifying these files, run build_runner:
- MobX stores (`*_store.dart`)
- Freezed models (`*_model.dart`)
- AutoRoute router (`app_router.dart`)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## File Naming Conventions

- **Screens**: `*_screen.dart` (e.g., `home_screen.dart`)
- **Widgets**: `*_widget.dart` or descriptive name (e.g., `doctor_card.dart`)
- **Models**: `*_model.dart` (e.g., `profile_model.dart`)
- **Stores**: `*_store.dart` (e.g., `auth_store.dart`)
- **Repositories**: `*_repository.dart` (e.g., `auth_repository.dart`)
- **Services**: `*_service.dart` (e.g., `supabase_service.dart`)

## Import Organization

Order imports like this:

```dart
// 1. Dart/Flutter imports
import 'package:flutter/material.dart';

// 2. Package imports
import 'package:iconsax/iconsax.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// 3. Project imports
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
```

## Tips for Success

1. **Start Small**: Build core patient flow first (the 6 essential files above)
2. **Test Often**: Run the app after each screen to catch issues early
3. **Use Hot Reload**: Makes development much faster
4. **Follow the Examples**: All code in `UI_TEMPLATE_INTEGRATION.md` is production-ready
5. **Check Supabase Dashboard**: Verify data is being created/updated
6. **Watch Console**: Look for error messages and fix immediately

## Resources

- **Backend Docs**: `docs/BACKEND_ARCHITECTURE.md`
- **Integration Examples**: `docs/UI_TEMPLATE_INTEGRATION.md`
- **Flutter Integration**: `docs/FLUTTER_INTEGRATION.md`
- **Setup Guide**: `docs/WINDOWS_SETUP.md`
- **Template Reference**: `D:\Dev\projects\Flutter-App-Design\lib\Doctor Appoinment App\`

## Current Status

**Backend**: ✅ 100% Production Ready
**UI Design**: ✅ Assets Copied, Colors Configured
**Integration**: ⏳ Ready to build (code provided in docs)
**Next**: 🚀 Create the 6 essential files and run!

---

**Start building!** Follow `docs/UI_TEMPLATE_INTEGRATION.md` step by step, create the 6 essential files, and you'll have a working app loading real data from Supabase! 🎉
