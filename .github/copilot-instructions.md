# Copilot / AI assistant quick instructions for OnCall-Lab

This file gives focused, actionable guidance to an AI coding assistant working in this repository.
Keep responses short and apply changes directly when possible. Reference files shown here.

---

1) Big picture (what this repo is)
- Mobile app (Flutter) for home laboratory services (patient, doctor, admin roles).
- Backend uses Supabase (Postgres + Realtime + Edge Functions). There is a separate admin web panel at `admin_panel_web/`.

Key entry points:
- App entry: `lib/main.dart` (initializes dotenv, Firebase optional, Supabase, DI and stores)
- DI / service locator: `lib/core/di/service_locator.dart`
- Supabase wrapper: `lib/core/services/supabase_service.dart`
- Stores (state): `lib/stores/` (MobX)
- Models and repositories: `lib/data/` (`models/`, `repositories/`)
- Shared UI & theme: `lib/ui/shared/` and `lib/core/constants/` (colors, test types)

2) Developer workflows & commands (exact)
- Install deps: `flutter pub get`
- Run app: `flutter run` (device/emulator must be available)
- Analyze: `flutter analyze`
- Tests: `flutter test` or `flutter test test/widget_test.dart`
- Code generation (mandatory after changing models/stores/routes):
  - One-time / CI: `dart run build_runner build --delete-conflicting-outputs`
  - Watch mode while developing: `dart run build_runner watch --delete-conflicting-outputs`

Notes:
- Codegen is required for MobX (`*_store.g.dart`), Freezed (`*.freezed.dart`, `*.g.dart`), and AutoRoute (`*.gr.dart`).
- `.env` is used for Supabase/Firebase keys. Do NOT commit secrets.

3) Project-specific conventions you must follow (concrete)
- MobX stores live in `lib/stores/` and are named `{name}_store.dart` with generated `{name}_store.g.dart`.
- Freezed models live in `lib/data/models/` and follow `{name}_model.dart` producing `*.freezed.dart` and `*.g.dart`.
- Repositories live in `lib/data/repositories/` and return domain models (not raw JSON/maps).
- Central DI via `setupServiceLocator()` in `lib/core/di/service_locator.dart` — add new services/stores here.
- Supabase init/usage: call `SupabaseService.initialize()` before using repositories/stores (see `main.dart`).

4) Integration & external dependencies (what to watch for)
- Supabase: requires project URL and anon key (usually provided via `.env` / `lib/core/constants/supabase_config.dart` locally).
  - SQL schema & migrations in `supabase/migrations/` and setup docs in `docs/BACKEND_SETUP.md` and `docs/`.
- Firebase (optional): used only for push notifications. `main.dart` attempts to initialize Firebase and falls back gracefully if it fails.
- Push tokens: `profiles.fcm_token` on Supabase – push flows are implemented server-side; frontend needs FCM config to fully enable push.

5) Typical edit cycle (explicit checklist)
- Add/modify model/store/route → update source file.
- Run: `dart run build_runner build --delete-conflicting-outputs` (or watch mode).
- Run app and verify role-specific flows (see `AuthGate` logic in `lib/main.dart`).

6) Quick pointers & examples (code snippets in repo)
- To find them: `lib/core/constants/app_colors.dart` (status colors), `lib/core/constants/test_types.dart` (test catalog).
- Navigation & notification pattern: `navigatorKey` is used (`lib/core/utils/navigation_helper.dart`) so background notifications can open screens.
- Push initialization (safe pattern): `main.dart` wraps Firebase init in try/catch and continues without push if config is missing.

7) Safety & repo hygiene
- Never add Supabase anon or service keys to the repo. `.env` and `lib/core/constants/supabase_config.dart` are local-only.
- Keep generated files out of manual edits. Only change the source and rerun build_runner.

8) Where to look first when investigating a feature/bug
- Authentication and role logic: `lib/stores/auth_store.dart` and `lib/main.dart` (AuthGate)
- Request lifecycle and status colors: `lib/data/models/test_request_model.dart` and `lib/core/constants/app_colors.dart`
- Realtime flows: Supabase subscriptions in `lib/core/services/supabase_service.dart` and stores that subscribe in `lib/stores/`

9) CI / Lint / Tests
- This repo uses `flutter_lints`. Run `flutter analyze` and `flutter test` locally before creating a PR.

10) When adding a new feature (minimal runnable PR)
- Include: small README or docs/ note (if backend changes required), updated migrations if DB changes, and CI-friendly codegen step (e.g., include generated files or add build_runner to CI).

---
If any section is unclear or you'd like examples added (small snippets or exact file references for a specific feature), tell me which area to expand and I'll update this file.
