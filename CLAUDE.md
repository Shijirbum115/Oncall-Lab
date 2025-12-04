# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OnCall Lab is a Flutter mobile application for home laboratory test sample collection in Ulaanbaatar, Mongolia. The app connects patients with doctors/lab technicians for at-home sample collection services.

### Tech Stack
- **Framework**: Flutter 3.10+
- **State Management**: MobX (with code generation)
- **Backend**: Supabase (authentication, database, real-time subscriptions)
- **Navigation**: AutoRoute (with code generation)
- **Dependency Injection**: GetIt
- **Data Models**: Freezed + json_serializable (with code generation)
- **UI**: Google Fonts, Iconsax icons, animate_do animations

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze

# Run code generation (for MobX stores, AutoRoute, Freezed models)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Clean build artifacts
flutter clean
```

## Architecture

### Directory Structure
```
lib/
├── core/                    # Core functionality and shared utilities
│   ├── constants/          # App-wide constants (colors, strings, test types)
│   ├── services/           # Services (e.g., Supabase client, API services)
│   └── utils/              # Utility functions and helpers
├── data/                   # Data layer
│   ├── models/             # Data models (use Freezed + json_serializable)
│   └── repositories/       # Repository pattern for data access
├── stores/                 # MobX stores for state management
├── ui/                     # User interface layer
│   ├── admin/              # Admin-specific screens
│   ├── auth/               # Authentication screens (login, register)
│   ├── doctor/             # Doctor/lab technician screens
│   ├── patient/            # Patient screens
│   └── shared/             # Shared UI components
│       ├── theme/          # App theme configuration
│       └── widgets/        # Reusable widgets
└── main.dart               # Application entry point
```

### Key Architectural Patterns

**Three-Role System**: The app supports three distinct user roles:
- **Patient**: Books lab tests, tracks test requests
- **Doctor/Lab Technician**: Accepts requests, collects samples, updates status
- **Admin**: Manages system, users, and overall operations

**State Management (MobX)**:
- All stores go in `lib/stores/` and use MobX observables
- Store files follow pattern: `[name]_store.dart` with generated `[name]_store.g.dart`
- Use `@observable` for state, `@computed` for derived values, `@action` for mutations
- Always run build_runner after creating/modifying stores

**Data Models (Freezed)**:
- Models in `lib/data/models/` use Freezed for immutability and json_serializable
- Follow pattern: `[name]_model.dart` with generated `[name]_model.freezed.dart` and `[name]_model.g.dart`
- Use `@freezed` annotation and implement `fromJson`/`toJson` factories

**Navigation (AutoRoute)**:
- Define routes using AutoRoute in a router configuration file
- Router will be generated in `[name].gr.dart`
- Use type-safe navigation with generated route classes

**Repository Pattern**:
- Repositories in `lib/data/repositories/` abstract data sources
- Communicate with Supabase backend
- Return domain models, not raw API responses

**Supabase Integration**:
- Backend provides authentication, PostgreSQL database, and real-time subscriptions
- Initialize Supabase client in `lib/core/services/`
- Use environment variables for Supabase URL and anon key (not currently in repo - need to add)

### Test Request Workflow
The app centers around a multi-status test request workflow:
1. **Pending**: Patient creates request
2. **Accepted**: Doctor accepts the request
3. **On the Way**: Doctor en route to patient
4. **Sample Collected**: Doctor collects sample from patient
5. **Delivered to Lab**: Sample delivered to laboratory
6. **Completed**: Results ready
7. **Cancelled**: Request cancelled

Status colors are defined in `lib/core/constants/app_colors.dart`

### Design System

**Colors** (`lib/core/constants/app_colors.dart`):
- Primary: #665ACF (purple)
- Use semantic status colors for different request states
- Consistent with "Doctor Appointment UI" design reference

**Theme** (`lib/ui/shared/theme/app_theme.dart`):
- Google Fonts (Poppins) for typography
- Material 3 design
- Centralized theme configuration for consistency
- 12px border radius standard for cards and inputs

**Reusable Widgets** (`lib/ui/shared/widgets/`):
- `DoctorCard`: Display doctor/technician cards with avatar, rating, availability
- `StatusBadge`: Show test request status with appropriate colors
- `CustomButton`: Styled elevated button matching app theme
- `CustomTextField`: Form input field with consistent styling

## Code Generation

This project heavily uses code generation. After modifying any of the following, run build_runner:
- MobX stores (files ending in `_store.dart`)
- Freezed models (files using `@freezed`)
- JSON serializable models (files using `@JsonSerializable`)
- AutoRoute navigation (router configuration)

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Or watch mode during active development
dart run build_runner watch --delete-conflicting-outputs
```

## Lab Test Data

Common Mongolian lab tests are predefined in `lib/core/constants/test_types.dart`:
- Complete Blood Count (CBC), Blood Glucose, Lipid Profile, Liver Function, Kidney Function, Urinalysis, Thyroid Function, HbA1c
- Each test includes: name, description, price (Mongolian Tugrik), sample type, preparation instructions
- Prices range from 8,000 to 30,000 MNT

## Supabase Backend Setup

The app requires Supabase configuration:
1. Create a Supabase project at supabase.com
2. Set up authentication (email/password)
3. Create database tables for users, test_requests, test_types, etc.
4. Configure Row Level Security (RLS) policies based on user roles
5. Add Supabase URL and anon key to app (typically via environment variables or config file)

Currently, no `.env` file exists - Supabase credentials should be configured before running.

### Push Notification System (Backend Complete ✅)

The push notification system backend is fully implemented:

**Database:**
- `profiles.fcm_token` - Stores Firebase Cloud Messaging device tokens
- `notification_preferences` - User notification settings (push enabled, quiet hours, etc.)
- `notifications` - In-app notifications (already existed, now enhanced)

**Functions:**
- `update_fcm_token()` - Update user's FCM token
- `get_unread_notification_count()` - Get badge count
- `mark_all_notifications_read()` - Bulk mark as read
- `delete_old_notifications()` - Cleanup old notifications

**Edge Function:**
- `send-push-notification` - Sends push notifications via Firebase FCM
- Handles token validation and automatic cleanup
- Respects user preferences and quiet hours

**Triggers:**
- Automatic push notifications on request status changes
- Notifications sent when doctors accept requests
- Status updates trigger patient notifications
- System alerts sent to relevant users

**Setup Required:**
1. Create Firebase project and get FCM credentials
2. Add FCM_SERVER_KEY and FCM_PROJECT_ID to Supabase Edge Function secrets
3. Follow setup guide in `docs/NOTIFICATION_SYSTEM_SETUP.md`
4. Test using SQL script in `supabase/test_notification_system.sql`

**Frontend Implementation:** To be completed in next phase (Flutter Firebase integration)
