# App Store Deployment Notes

> **Last updated:** 2026-03-01 | **Branch:** `unauth-screens`

---

## ✅ Critical Fixes Completed

### 1. PrivacyInfo.xcprivacy (Apple Privacy Manifest)
- **File created:** `ios/Runner/PrivacyInfo.xcprivacy`
- **Registered in:** `ios/Runner.xcodeproj/project.pbxproj`
- Declares: NSPrivacyTracking=false, collected data types (location, phone, name, photos, health, device ID), accessed API types (UserDefaults, FileTimestamp, SystemBootTime, DiskSpace)

### 2. `.env` Removed from Bundled Assets
- **Removed** `- .env` from `pubspec.yaml` assets section
- Prevents shipping Supabase/QPay secrets inside the app binary

### 3. Debug Print Cleanup
- All `print()` and `debugPrint()` calls wrapped with `if (kDebugMode)` guards
- Files modified: `main.dart`, `auth_store.dart`, `auth_repository.dart`, `push_notification_service.dart`, `all_lab_services_screen.dart`, `profile_avatar.dart`, `booking_confirmation_screen.dart`, `doctor_detail_screen.dart`, `location_picker_screen.dart`

---

## ⚠️ CRITICAL: `.env` Config for Release Builds

**This must be resolved before building for App Store.**

Since `.env` was removed from `pubspec.yaml` assets, the app's `dotenv.load()` call in `main.dart` will silently fail in release builds (it's in a try/catch). However, these config classes will **throw at runtime** if values are missing:

- `lib/core/constants/supabase_config.dart` — uses `dotenv.env['SUPABASE_URL']` and `dotenv.env['SUPABASE_ANON_KEY']` with `_throwError()` fallback
- QPay config — similarly uses dotenv

### Recommended Solutions (pick one):

#### Option A: `--dart-define` at build time (recommended)
```bash
flutter build ios \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=QPAY_INVOICE_CODE=your-code \
  --dart-define=QPAY_USERNAME=your-username \
  --dart-define=QPAY_PASSWORD=your-password
```
Then update `supabase_config.dart` to read from:
```dart
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
```

#### Option B: Keep `.env` in assets but use `.env.production`
Re-add a production-safe `.env` to assets (with only the anon key, not service key).

#### Option C: Hardcode production values
Create `lib/core/constants/supabase_config_prod.dart` with compile-time constants and use conditional imports.

---

## 🟡 Remaining Important Issues (Not Yet Fixed)

### 4. Android Release Signing
- `android/app/build.gradle.kts` uses `signingConfig = signingConfigs.getByName("debug")` for release builds
- **Must** create a release keystore and configure `signingConfigs.release` before Play Store submission
- See: https://docs.flutter.dev/deployment/android#signing-the-app

### 5. iOS Deployment Target & Podfile
- iOS deployment target is 13.0 — acceptable but verify all pods support it
- `Podfile` has the platform line commented out — uncomment and set: `platform :ios, '13.0'`

### 6. App Version
- Currently `1.0.0+1` in `pubspec.yaml`
- Each App Store upload requires a unique build number (`+N`)
- Increment before each upload: `1.0.0+2`, `1.0.0+3`, etc.

### 7. App Icons
- Verify all required icon sizes are present in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Missing sizes will cause App Store rejection

### 8. Launch Screen / Splash
- Verify `ios/Runner/Base.lproj/LaunchScreen.storyboard` looks correct
- Consider using `flutter_native_splash` package for consistency

### 9. App Store Metadata (manual)
- Screenshots (6.7", 6.5", 5.5" for iPhone; 12.9" for iPad)
- App description, keywords, privacy policy URL, support URL
- App category: Medical / Health & Fitness

---

## 📋 Pre-Submission Checklist

- [ ] Resolve `.env` / secrets for release builds (see section above)
- [ ] Run `flutter analyze` — zero warnings
- [ ] Run `flutter test` — all tests pass
- [ ] Run `dart run build_runner build --delete-conflicting-outputs` — codegen up to date
- [ ] Increment version in `pubspec.yaml`
- [ ] Configure Android release signing
- [ ] Uncomment Podfile platform line
- [ ] Verify app icons for all sizes
- [ ] Test release build: `flutter build ios --release`
- [ ] Archive in Xcode and upload to App Store Connect
- [ ] Fill in App Store metadata, screenshots, privacy policy
- [ ] Submit for review
