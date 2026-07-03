# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CallCare (repo name "OnCall Lab") is a home healthcare platform for Ulaanbaatar, Mongolia: verified nurses/doctors/lab technicians visit patients at home for **urgent treatments (IV drips — "Дусал залгах", injections, nursing care)** and **scheduled lab sample collection**. It replaces the current practice of finding nurses through Facebook groups. Providers receive medical supplies (kits, needles, IV systems) from CallCare itself — the supply chain is the business moat, not just logistics.

**⚠️ Before building any feature, read `docs/PRODUCT_VISION.md`** — it contains the founding insight, actor flows, the honest gap analysis (the urgent-treatment use case is NOT yet served as of June 2026), edge-case policies, and the prioritized roadmap. The mobile apps are Flutter (`lib/`); the admin dashboard is Next.js (`admin-web/`); the old `admin_panel_web/` is superseded.

## Non-negotiable repo rules

This project is developed on two machines (Mac + Windows) and has lost work to sync drift before. Therefore:

1. **Pull before starting, push before stopping.** Never leave work uncommitted overnight.
2. **Every database change gets a migration file in `supabase/migrations/`, committed to git** — even if you apply it through the Supabase dashboard. In June 2026, 15 dashboard-applied migrations had to be reconstructed from `supabase_migrations.schema_migrations` because the files were never committed. Don't repeat that.
3. The **live Supabase DB is the source of truth for schema**; the migration files in this repo mirror it. If in doubt whether the repo is current, check `supabase_migrations.schema_migrations` in the live DB.
4. Secrets never go in git: Supabase creds live in the gitignored `lib/core/constants/supabase_config.dart` (copy from `.example`), QPay credentials live **only** in Supabase Edge Function secrets.

## Tech Stack (actual, verified July 2026)

- **Flutter 3.10+**, Dart package name `bugamed`, app name **CallCare**, bundle id `com.bugamed.app`
- **State**: MobX + codegen (`lib/stores/*_store.dart` + generated `.g.dart`)
- **DI**: GetIt (`lib/core/di/service_locator.dart`)
- **Models**: Freezed + json_serializable (`lib/data/models/`)
- **Navigation**: plain `Navigator.push` with **`CupertinoPageRoute`** for iOS-feel transitions. **AutoRoute is NOT used** (it's still in pubspec but there is no router config — don't add one without discussion, and don't "fix" navigation to AutoRoute).
- **Backend**: Supabase (project ref `zrwtugcgimaocrhjdtob`) — auth, Postgres + RLS, realtime, storage, edge functions
- **Push**: Firebase FCM + flutter_local_notifications (app degrades gracefully if Firebase init fails)
- **Localization**: flutter gen-l10n, ARB files in `lib/l10n/` (`app_en.arb`, `app_mn.arb`). Mongolian is the primary market language — every user-facing string must exist in both ARB files.
- **Admin dashboard**: Next.js in `admin-web/` (`npm run dev` / `npm run build`), Supabase SSR

## Setup & Commands

```bash
# One-time machine setup
cp lib/core/constants/supabase_config.dart.example lib/core/constants/supabase_config.dart
# ...then paste the real anon key from the Supabase dashboard

flutter pub get

# Run (Shijka's iPhone device id: 00008110-001C702E0E40401E)
flutter run -d <device-id>

# After changing any store, Freezed model, or @JsonSerializable class:
dart run build_runner build --delete-conflicting-outputs

# After changing ARB files:
flutter gen-l10n

flutter analyze          # must stay at zero errors
flutter test
```

## Architecture

```
lib/
├── core/
│   ├── constants/       # app_colors.dart (brand + status colors), app_strings, supabase_config (gitignored)
│   ├── di/              # GetIt service locator
│   ├── services/        # supabase_service, push_notification_service, storage_service
│   └── utils/           # error_handler (global friendly-error handlers), navigation_helper (global navigatorKey)
├── data/
│   ├── models/          # Freezed models
│   └── repositories/    # One repository per domain; return models, not raw rows
├── stores/              # MobX: auth, home, locale, notification, service, test_request, doctor_request
├── l10n/                # ARB files + generated localizations
├── ui/
│   ├── design_system/   # THE styling source of truth: app_theme.dart (theme + AppSpacing/AppRadius/AppPadding tokens), app_shadows.dart, widgets/ (AppCard, AppButton, AppTextField, AppBadge, AppEmptyState, AppBottomSheet, AppIconButton, AppSegmentedFilter, StatusTimeline, BlurBubble)
│   ├── auth/            # login, patient/doctor registration
│   ├── patient/         # home, booking, requests, labs, profile, ai_assistant/
│   ├── doctor/          # dashboard, request detail, earnings, profile
│   ├── payment/         # QPay payment UI
│   └── shared/          # splash, notifications, misc widgets (some legacy)
└── main.dart            # dotenv (optional) → Firebase (optional) → GetIt → Supabase → AuthGate
```

**Flow pattern**: Screen → MobX store (`@observable`/`@action`) → repository → Supabase. Stores expose `isLoading`/`errorMessage`; screens observe via `Observer`.

**AuthGate** (`main.dart`): unauthenticated users browse the patient experience freely; login is demanded only at booking/payment. Authenticated users route by role: patient → `MainPage`, doctor → `DoctorMainPage`, admin → placeholder (admins use `admin-web/`).

**Auth convention**: phone-number login; phone is converted to a synthetic email `{phone}@bugamed.dev` for Supabase auth. No OTP or self-service password recovery yet (admin resets).

**Roles**: `patient`, `doctor` (with `doctor_type`: nurse | general | lab_technician | diagnostic_specialist), `admin`. `profiles.role` changes are blocked by the `guard_profile_role_change` DB trigger unless the actor is admin/service_role.

### Request status workflow

pending → accepted → on_the_way → sample_collected → delivered_to_lab → completed (lab collection)
pending → accepted → on_the_way → completed (direct/treatment services, allowed by DB transition rules)
Any state → cancelled. Transitions are **validated in the DB** (`validate_status_transition`), so client hacks can't skip states.

**Accepting a request must go through the `accept_test_request` RPC** (atomic, closes the two-doctors-accept-simultaneously race) — never a raw status UPDATE to `accepted`.

## Design System

- **Brand**: scarlet red `#E3243B` primary (`AppColors.primary`), crimson gradients, pure white surfaces with outline-bordered cards. The purple era is dead; if you see purple, it's a bug.
- **Typeface**: Inter via google_fonts (chosen for full Mongolian Cyrillic coverage).
- **Tokens**: use `AppSpacing`/`AppRadius`/`AppPadding` from `lib/ui/design_system/app_theme.dart` — no hardcoded paddings/radii.
- **Widgets**: prefer `lib/ui/design_system/widgets/` (AppCard has scale-down + haptic feedback; AppEmptyState shows the deer mascot at 50% opacity). `CustomButton`/`CustomTextField` were deleted — don't reintroduce them.
- Status colors for the request workflow live in `lib/core/constants/app_colors.dart`.

## Supabase Backend

**Edge functions** (`supabase/functions/`): `qpay-create-invoice`, `qpay-check-payment`, `qpay-callback` (QPay v2 payment flow; see `supabase/functions/QPAY_README.md`), `callcare-ai-chat` (Anthropic-backed AI assistant — API key stays server-side), `send-push-notification` (FCM). Deploy with `supabase functions deploy <name>`.

**Payments**: QPay v2 invoice flow through the edge functions (never call QPay from the client), plus a manual bank-transfer path reviewed in admin-web. Legacy client-side payment chain was removed — `lib/core/constants/qpay_config.dart` is dead code.

**Notifications**: DB triggers create bilingual (`title_mn`/`message_mn`) notifications on status changes and fan out push via FCM to targeted doctors. Pipeline is enabled DB-side; FCM service-account secrets must be present in edge function secrets for delivery.

**Account deletion**: `delete_my_account()` RPC exists in prod (App Store requirement). Check whether the Flutter UI for it exists before assuming.

## Testing

Effectively none exists (`test/widget_test.dart` is the Flutter default). When touching payment, auth, or the status workflow, add tests for the logic you change — that's where regressions hurt the most.

## Known legacy / gotchas

- `lib/core/constants/test_types.dart` and `qpay_config.dart`: dead, nothing imports them (test catalog now lives in the DB `services` table — 116 entries, prices in MNT).
- `lib/ui/shared/theme/` is an empty leftover directory; the real theme is `lib/ui/design_system/app_theme.dart`.
- `admin_panel_web/` is superseded by `admin-web/`.
- `laboratory_detail_screen_new.dart` coexists with `laboratory_detail_screen.dart` — check which one is actually routed to before editing.
- `.env` is loaded in `main.dart` but optional; the app reads Supabase creds from `supabase_config.dart`, not dotenv.
- pubspec still lists `auto_route` but it is completely unused (manual navigation everywhere). Iconsax is still used widely for general UI icons; medical *category* icons specifically were replaced with Healthicons-style SVGs.
