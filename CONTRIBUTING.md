# Contributing to OnCall Lab

Welcome! This guide gets a new collaborator from a fresh clone to a running app and shipping their first PR.

---

## 1. Prerequisites

- Flutter SDK 3.10+ — verify with `flutter --version`
- Dart (bundled with Flutter)
- Git
- Android Studio (Android emulator) and/or Xcode (iOS simulator, macOS only)
- A code editor: VS Code, Android Studio, or IntelliJ
- Supabase project access (ask the project owner for the URL + anon key)

Optional:
- Firebase CLI (for push notifications — the app boots without it)

---

## 2. First-time setup

```bash
# 1. Clone and enter the repo
git clone https://github.com/Shijirbum115/Oncall-Lab.git
cd Oncall-Lab

# 2. Install Flutter packages
flutter pub get

# 3. Generate code (MobX stores, Freezed models, JSON serializers)
dart run build_runner build --delete-conflicting-outputs
```

### 2a. Configure Supabase

The mobile app and admin panel each need a local Supabase config file. Both are gitignored.

**Mobile app** (`lib/core/constants/supabase_config.dart`):
```bash
cp lib/core/constants/supabase_config.dart.example lib/core/constants/supabase_config.dart
# edit the file and fill in supabaseUrl + supabaseAnonKey
```

**Admin panel** (`admin_panel_web/lib/config/supabase_config.dart`):
```bash
cp admin_panel_web/lib/config/supabase_config.dart.example admin_panel_web/lib/config/supabase_config.dart
# edit and fill in the same values
```

### 2b. Configure environment variables

```bash
cp .env.example .env
# edit .env and fill in real values (Supabase, QPay, etc.)
```

The `.env` file is **never** committed. Ask the project owner for the actual values.

---

## 3. Run the app

```bash
# List connected devices/emulators
flutter devices

# Run on the first available device
flutter run

# Run on a specific device by ID
flutter run -d <device-id>
```

In an active Flutter session:
- `r` — hot reload
- `R` — hot restart
- `q` — quit

### Code-gen watch mode

If you're editing MobX stores, Freezed models, or routes, run this in a second terminal so generated files stay in sync:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## 4. Branch & commit workflow

### Branches

- `main` — stable. Never push directly. PRs only.
- `feature/<short-name>` — new features (e.g. `feature/qpay-refund`)
- `fix/<short-name>` — bug fixes (e.g. `fix/login-crash`)
- `chore/<short-name>` — refactors, deps, tooling

```bash
# Start a new feature
git checkout main
git pull origin main
git checkout -b feature/my-thing

# ...edit, commit...

git push -u origin feature/my-thing
# then open a Pull Request on GitHub
```

### Commit messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add patient address picker on booking screen
fix: resolve crash when QPay invoice times out
chore: bump supabase_flutter to 2.5.0
docs: clarify build_runner usage in CONTRIBUTING
refactor: extract DoctorCard rating into widget
```

Keep the subject line under ~72 chars. Use the body for *why*, not *what*.

---

## 5. Before pushing

```bash
# Static analysis must pass
flutter analyze

# Tests must pass
flutter test

# Format your code
dart format lib/ test/
```

If you added/modified MobX stores or Freezed models, also run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

…and commit the regenerated `*.g.dart` and `*.freezed.dart` files alongside.

---

## 6. Project structure (where things live)

```
lib/
├── core/          # constants, services (Supabase), utils
├── data/          # models (Freezed), repositories
├── stores/        # MobX stores
└── ui/
    ├── auth/      # login / register
    ├── patient/   # patient screens
    ├── doctor/    # doctor / lab tech screens
    ├── admin/     # admin (mobile-side)
    ├── payment/   # QPay flow
    └── shared/    # theme, reusable widgets

admin_panel_web/   # separate Flutter web app for admin
supabase/
├── migrations/    # ordered SQL migrations (run in order)
├── functions/     # Supabase edge functions
└── storage_policies.sql  # one-off bucket RLS setup
docs/              # all documentation
```

For more detail see `docs/FILE_STRUCTURE_GUIDE.md`.

---

## 7. Secrets — what NOT to commit

Already in `.gitignore`:
- `.env` and `.env.*` (except `.env.example`)
- `lib/core/constants/supabase_config.dart`
- `admin_panel_web/lib/config/supabase_config.dart`
- `*.keystore`

If you add any new file containing keys, tokens, or passwords:
1. Add the path to `.gitignore` *before* committing
2. Create a `<file>.example` template with placeholder values
3. Document it in this file

---

## 8. Where to learn more

- `README.md` — project overview (Mongolian)
- `CLAUDE.md` — guidance for AI-assisted development
- `docs/BACKEND_SETUP.md` — Supabase backend setup
- `docs/QPAY_READY.md` — QPay payment integration
- `docs/REALTIME_IMPLEMENTATION_GUIDE.md` — realtime updates
- `docs/LOCALIZATION_GUIDE.md` — mn/en localization

---

## 9. Getting help

- GitHub Issues — bugs and feature requests
- Project owner — Shijirbum (shijirbum.b@mcs.mn)
