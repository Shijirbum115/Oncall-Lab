# Design System Standardization

**Date:** 2026-05-05
**Status:** Approved (awaiting spec review)
**Scope:** B — Token cleanup + visual harmonization. No new design language.

## Goal

The Flutter UI in `lib/ui/` shows the wear of being touched by many hands: hardcoded radii, shadows, paddings, fonts, and colors are scattered across screens; multiple parallel components exist for the same job (two button systems, two text-field systems, two card patterns, two status-pill implementations); and screen-level patterns like headers and section titles are reinvented per file.

The goal of this work is to make the app **visually consistent and feel professional**, without redesigning it. After this pass, every screen draws from a single source of truth (`lib/ui/design_system/`), every UI primitive has exactly one canonical component, and a future contributor knows exactly which tokens and widgets to use.

## Non-goals

- Not a redesign. The brand, look, and feel stay the same.
- No new features, no routing changes, no store/repository changes, no backend changes.
- No localization changes (both `mn` and `en` are preserved).
- No app icon, splash asset, or fonts-other-than-Inter changes.

## Design tokens

All tokens live in `lib/ui/design_system/`. No screen, widget, or store outside this folder defines its own hex, radius, shadow, font, or spacing literal. **Variables only — never hardcoded values.**

### Colors (`app_colors.dart`)

**Brand**
- `primary` — `#338A68` (BUGAMED Teal, single source of truth — eventually swappable)
- `primaryDark` — `#2C7A5F` (pressed states, dark surfaces)
- `primarySoft` — `primary @ 12% alpha` (tinted backgrounds, icon containers)

**Neutrals**
- `ink` — `#1A1D1F` (primary text)
- `inkMuted` — `#6F7378` (secondary text)
- `inkSubtle` — `#A2A8B4` (placeholder, disabled)
- `border` — `#ECEEF1`
- `surface` — `#FFFFFF` (card)
- `background` — `#F7F8FA` (scaffold)

**Status (gently muted to harmonize with teal)**
- `pending` — `#E89B3C`
- `accepted` — `#3F88C5`
- `onTheWay` — `#3F88C5`
- `sampleCollected` — `#5BA86A`
- `deliveredToLab` — `#5BA86A`
- `completed` — `#338A68` (= primary)
- `cancelled` — `#D8543C`
- Each status also exposes a 12%-alpha background variant for chips.

**Semantic**
- `success`, `error`, `warning`, `info` — kept as semantic aliases of the toned palette above.

**Doctor pastels (5 colors)** — kept, slightly desaturated for harmony.

**Service category icons (10 colors)** — kept, each toned ~10% softer.

**Dropped**
- `accent` yellow `#FFB84D` — unused, removed entirely.
- Duplicate `background` / `scaffoldBackground` — collapsed to one (`background #F7F8FA`).

### Typography (`app_typography.dart`)

Font family: **Inter** (replacing SFPro). All text uses color tokens (`ink` / `inkMuted` / `inkSubtle`) — no inline color strings.

| Token | Size | Weight | Use |
|-------|------|--------|-----|
| `display` | 32 | 700 | hero headers, splash |
| `h1` | 26 | 700 | screen titles |
| `h2` | 22 | 700 | section headers |
| `h3` | 18 | 600 | card titles |
| `bodyLg` | 16 | 500 | primary body / button labels |
| `body` | 14 | 500 | default body |
| `bodySm` | 13 | 500 | secondary body |
| `caption` | 12 | 500 | captions, helpers |
| `label` | 11 | 600 | labels, uppercase chips |

### Spacing (`app_spacing.dart`)

`xs 8`, `sm 12`, `md 16`, `lg 24`, `xl 32`, `xxl 40`. The lone `xxxl 60` is removed.

### Radius (`app_radius.dart`) — collapsed to 4 values

- `sm 12` — chips, small inputs
- `md 16` — cards, buttons, text fields
- `lg 20` — hero / feature cards, bottom sheets, navbar
- `pill 999`

The current scattered values (8, 14, 18, 24, 28) are removed; everything maps to one of the four.

### Shadows (`app_shadows.dart`) — 3 named levels

- `resting` — cards in lists, default surfaces
- `raised` — hero cards, tappable feature surfaces, ad banner
- `floating` — navbar, bottom sheets, modals

All inline `BoxShadow(color: …, blurRadius: …, offset: …)` is replaced.

### Padding (`app_padding.dart`)

- `screen` — 20 (only horizontal default for all screens)
- `screenH`, `screenAll` — `EdgeInsets` helpers, kept

### Icons

**Iconsax for all icons.** Every `Icons.*` and `Icons.*_outlined` reference is replaced (a one-pass mapping). This is the foundation for the user's future 3D / themed icon swap — one library to replace, not three.

## Components

Single source: `lib/ui/design_system/widgets/`. One canonical component per UI primitive.

### Promoted (canonical)

| Widget | Use |
|--------|-----|
| `AppButton` | All buttons. 4 variants: `primary` / `secondary` / `ghost` / `danger`. Height 52. |
| `AppTextField` | All text inputs. |
| `AppSearchField` | Search box variant. |
| `AppCard` | All card surfaces. Replaces every ad-hoc `Container(decoration: BoxDecoration(...))`. |
| `AppBottomSheet` | All bottom sheets. |

`AppCard` moves from `lib/ui/shared/widgets/` to `lib/ui/design_system/widgets/` so the design system folder is the single home for canonicals.

### New canonical components

- **`AppScreenHeader`** — `{title, subtitle?, trailing?}`. Replaces ~6 bespoke header implementations across home / requests / dashboard / profile / notifications / etc. Standard padding (`AppPadding.screen`), `h1` title, `body` subtitle.
- **`AppStatusChip`** — `{status: RequestStatus}`. Pill with 12%-alpha tinted bg + bold colored text. Replaces both the inline status pill in `requests_screen.dart` and the existing `StatusBadge`.
- **`AppSectionHeader`** — `{title, onSeeAllTap?}`. Replaces the 4–5 hand-rolled "title + View all" rows.

### Refactored (kept, reworked to tokens)

- **`VisitOptionCard`** — Currently mismatched halves (filled wavy + thin outlined). Both cards become consistent: same height, same icon container size, same elevation, same radius. Clinic = `primary` background with white type; home = `surface` with subtle `border` and primary-tinted icon. The `_WavyPatternPainter` is removed (pulls weight from content; future 3D icons will own that visual role).
- **`DoctorCardTile`** — Layout kept; tokens applied; rating pill restyled.
- **`TestTypesSection`** — Auto-scroll behavior kept; cards swap to `AppCard` + tokens.
- **`AdBanner`** — Behavior kept; gradient retuned to use `primary` token; typography normalized.
- **`MascotStateWidget`** — Kept; promoted to "the way we show empty / error / loading states everywhere" (replaces bare `Icon + Text`).
- `NotificationBell`, `ProfileAvatar`, `LanguageSwitcher`, `SkeletonLoader`, `TopNotification`, `TappableCard` — kept, reskinned to use tokens.

### Deleted

- `lib/ui/shared/widgets/custom_button.dart`
- `lib/ui/shared/widgets/custom_text_field.dart`
- `lib/ui/shared/widgets/status_badge.dart` (replaced by `AppStatusChip`)
- `lib/ui/shared/widgets/doctor_card.dart` (legacy; `doctor_card_tile.dart` is the live one)
- `lib/ui/patient/laboratory_detail_screen_new.dart` (unused dupe)

### Folder layout after the pass

```
lib/ui/
├── design_system/
│   ├── app_theme.dart            # ThemeData wiring
│   ├── app_colors.dart           # color tokens
│   ├── app_typography.dart       # type scale
│   ├── app_spacing.dart          # spacing scale
│   ├── app_radius.dart           # radius scale
│   ├── app_shadows.dart          # shadow scale
│   ├── app_padding.dart          # padding helpers
│   ├── README.md                 # developer reference (new)
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart            (moved here)
│       ├── app_text_field.dart
│       ├── app_bottom_sheet.dart
│       ├── app_screen_header.dart   (new)
│       ├── app_section_header.dart  (new)
│       └── app_status_chip.dart     (new)
└── shared/widgets/                  # feature-specific only
    ├── notification_bell.dart
    ├── profile_avatar.dart
    ├── language_switcher.dart
    ├── mascot_state_widget.dart
    ├── skeleton_loader.dart
    ├── top_notification.dart
    └── tappable_card.dart
```

`lib/core/constants/app_colors.dart` is moved to `lib/ui/design_system/app_colors.dart`. (One import path update across the codebase; the design system is the single home for visual tokens.)

## Per-screen sweep

Pattern applied to every screen in `lib/ui/`:

- Hardcoded radii (12 / 14 / 18 / 20 / 24 / 28) → `AppRadius.*`
- Hardcoded paddings (15 / 16 / 20) → `AppPadding.screen`
- Inline `BoxShadow(...)` → `AppShadows.resting / raised / floating`
- Inline `TextStyle(fontSize: X, fontWeight: ...)` → `AppTypography.*`
- `Icons.*` and `Icons.*_outlined` → `Iconsax.*` (one mapping pass)
- Hand-rolled headers → `AppScreenHeader`
- Hand-rolled "Section + View all" rows → `AppSectionHeader`
- Status pills → `AppStatusChip`
- Bare `Icon + Text` empty/error states → `MascotStateWidget`
- `Container(decoration: BoxDecoration(...))` cards → `AppCard`
- Legacy `CustomButton` / `CustomTextField` / `StatusBadge` calls → canonical equivalents

### Files touched

**Patient flow**
- `home_screen.dart`, `widgets/visit_options_section.dart`, `widgets/visit_option_card.dart`, `widgets/test_types_section.dart`, `widgets/doctor_card_tile.dart`, `widgets/ad_banner.dart`, `widgets/service_category_grid.dart`, `widgets/available_doctors_section.dart`, `widgets/review_item.dart`, `widgets/schedule_item.dart`
- `requests_screen.dart`, `all_lab_services_screen.dart`, `direct_services_screen.dart`, `laboratories_screen.dart`, `laboratory_detail_screen.dart`, `profile_screen.dart`
- `booking_confirmation_screen.dart`, `booking/lab_service_booking_screen.dart`, `booking/direct_service_booking_screen.dart`, `booking/widgets/saved_address_selector.dart`
- `location/location_picker_screen.dart`
- `screens/doctor_detail_screen.dart`, `screens/schedule_screen.dart`

**Doctor flow**
- `doctor_dashboard_screen.dart`, `doctor_main_page.dart`, `doctor_profile_screen.dart`, `doctor_request_detail_screen.dart`, `widgets/location_viewer_widget.dart`

**Auth flow**
- `login_screen.dart`, `patient_registration_screen.dart`, `doctor_registration_screen.dart`, `widgets/step_progress_bar.dart`

**Payment flow**
- `payment_screen.dart`, `payment_method_screen.dart`, `payment_success_screen.dart`, `qpay_invoice_screen.dart`

**Shared**
- `splash_screen.dart`, `notifications_screen.dart`, `notification_detail_screen.dart`, `main_page.dart` (patient), all canonical and feature widgets in `shared/widgets/`

### Specific visual fix (in scope B)

The visit options section is the most visible inconsistency today (mismatched halves). It is resolved by giving both cards the same structural treatment: same height, same icon container, same elevation token, same radius. Clinic visit keeps its `primary` background with white type. Home visit becomes a `surface`-on-`border` card with primary-tinted icon. The wavy painter is removed.

## Documentation rewrite (after code changes land)

After the code pass, the following docs are updated to match reality:

### `CLAUDE.md`
- Fix wrong primary color (`#665ACF` purple → `#338A68` teal).
- Drop "Doctor Appointment UI template" framing — we are our own design system now.
- Replace the Design System subsection with a tight, accurate summary (tokens, canonical components, one-line examples, font is Inter, icons are Iconsax).
- Add a **"Adding new screens — design system rules"** section: ~10 short rules ("Always use `AppPadding.screen`", "Use `AppButton` only", "Status display = `AppStatusChip`", "Icons = Iconsax only", "No hardcoded hex / radii / shadows / fonts", etc.). Durable contract for future contributors.
- Update directory structure to reflect cleanup.
- Remove stale notes that no longer match reality.

### `README.md`
- Refresh project description, tech stack (Inter, Iconsax, design system folder).
- Confirm setup commands.
- Brief "Design system" section pointing at `lib/ui/design_system/README.md`.

### `lib/ui/design_system/README.md` (new)
- Single concise page (≤ 150 lines) developers land on when touching UI.
- Lists every token and every canonical component with a 3-line code example each.

### `CONTRIBUTING.md`
- Add a "UI changes" section pointing at the design system README and stating the no-hardcoding rule.

### `docs/notes/design_suggestions.md`
- Quick check; if stale, either delete or rewrite to point at the new design system.

### Untouched
- `WARP.md`, `.github/copilot-instructions.md` — only fix if they currently contradict the new design system.
- `docs/BACKEND_SETUP.md`, `QPAY_READY.md`, `REALTIME_*`, `STORAGE_SETUP_GUIDE.md`, `LOCALIZATION_GUIDE.md`, `FILE_STRUCTURE_GUIDE.md`, `ADMIN_PANEL_SETUP.md`, `DEPLOYMENT_NOTES.md`, `TODO.md`, `MOBILE_APP_REALTIME.md` — non-design docs.
- `admin_panel_web/*.md` — separate project.
- `supabase/functions/QPAY_README.md` — backend, leave alone.

## Success criteria

When the work is done:

1. `grep -rn "BoxShadow(" lib/ui/` finds matches only inside `lib/ui/design_system/app_shadows.dart`.
2. `grep -rEn "borderRadius:\s*BorderRadius\.circular\([0-9]" lib/ui/` finds matches only inside `lib/ui/design_system/`.
3. `grep -rn "Color(0xFF" lib/ui/` finds matches only inside `lib/ui/design_system/app_colors.dart`.
4. `grep -rn "fontFamily:" lib/ui/` finds at most one match (in `app_theme.dart`).
5. `grep -rn "Icons\." lib/ui/` returns nothing (all icons via Iconsax).
6. `lib/ui/shared/widgets/custom_button.dart`, `custom_text_field.dart`, `status_badge.dart`, `doctor_card.dart` no longer exist.
7. `lib/ui/patient/laboratory_detail_screen_new.dart` no longer exists.
8. `flutter analyze` passes.
9. The app builds and the patient home, requests, doctor dashboard, login, and one booking flow each render and behave identically to before (visual regression check by hand on iPhone simulator).
10. `CLAUDE.md` lists the correct primary color and the new design system rules.

## Risks

- **Visual regression** during the sweep — mitigated by the by-hand check (criterion 9) and by keeping scope to "swap, don't redesign".
- **Inter font rollout** — needs to be added to `pubspec.yaml` and assets; SFPro stays bundled until the swap is verified, then is removed.
- **Iconsax mapping** — a few `Icons.*` may not have a 1:1 Iconsax equivalent; in those rare cases the closest equivalent is chosen and noted in the implementation plan.
- **Color token rename** — moving `app_colors.dart` from `lib/core/constants/` to `lib/ui/design_system/` is a one-shot import update; covered by the implementation plan.

## Out of scope

- MobX stores, repositories, models, edge functions, migrations
- Routing
- Backend integrations
- App icon / splash assets
- Localization strings
- New features
