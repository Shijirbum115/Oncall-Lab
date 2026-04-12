# BUGAMED UI Redesign — Design Spec

**Date**: 2026-04-12
**Approach**: Unified Foundation First — progressive refactor
**Direction**: Clean medical (Ada Health / One Medical style) — calm, trustworthy, minimal

---

## Phase 1: Design System Foundation

### Token Additions

**Shadows** (add to `AppTheme` or new `AppShadows` class):

| Token | Offset | Blur | Spread | Color |
|-------|--------|------|--------|-------|
| `none` | 0, 0 | 0 | 0 | — |
| `sm` | 0, 1 | 8 | 0 | black 5% |
| `md` | 0, 2 | 24 | 0 | black 8% |

**Typography** (add to `AppTypography`):

| Token | Size | Weight | Use |
|-------|------|--------|-----|
| `heading` | 28px | w700 | Screen titles (home greeting) |
| `caption` | 13px | w500 | Prices, metadata, secondary labels |

Existing tokens (`AppColors`, `AppSpacing`, `AppRadius`, `AppPadding`) are kept as-is.

### Component Consolidation

#### `AppButton` — replaces `CustomButton`, `PrimaryButton`, `SecondaryButton`

- **Variants** (via enum): `primary`, `secondary`, `ghost`, `danger`
- **Shared specs**: height 52, radius 16, full-width by default
- **Features**: loading state (spinner), optional leading icon, disabled state
- **Primary**: filled `AppColors.primary`, white text
- **Secondary**: outlined with `AppColors.primary` border, primary text
- **Ghost**: transparent background, primary text, no border
- **Danger**: filled `AppColors.error`, white text
- **Location**: `lib/ui/design_system/widgets/app_button.dart`
- **Delete**: `lib/ui/shared/widgets/custom_button.dart`

#### `AppTextField` + `AppSearchField` — replaces `CustomTextField`

- Keep both in `lib/ui/design_system/widgets/app_text_field.dart` (already there)
- `AppTextField`: form input with label, hint, validation, prefix/suffix icons
- `AppSearchField`: search bar with search icon, clear button, onChanged
- **Delete**: `lib/ui/shared/widgets/custom_text_field.dart`

#### `AppCard` — replaces `AppCard` + `TappableCard` + raw `Container`

- **When `onTap` is null**: static card with shadow, radius, white background
- **When `onTap` is provided**: scale-down to 0.97 (100ms) + `HapticFeedback.lightImpact()`
- **Shadow**: uses `AppShadows.sm` by default, configurable
- **Radius**: `AppRadius.md` (16) by default, configurable
- **Location**: `lib/ui/design_system/widgets/app_card.dart` (move from shared)
- **Delete**: `lib/ui/shared/widgets/tappable_card.dart`

#### `AppEmptyState` — replaces `MascotStateWidget`

- **Layout**: vertical `Column`, centered
  1. Deer image at 200px height, 50% opacity
  2. 16px gap
  3. Title text (bold, `AppTypography.titleMedium`)
  4. 8px gap
  5. Subtitle text (grey, `AppTypography.bodyMedium`)
  6. 24px gap
  7. Optional action button (`AppButton.primary`)
- **Deer emotion**: mapped via existing `MascotEmotion` enum
- **Location**: `lib/ui/design_system/widgets/app_empty_state.dart`
- **Old widget**: keep `MascotStateWidget` temporarily as alias, migrate screens progressively

#### `AppBadge` — rename of `StatusBadge`

- Same widget, renamed for consistency with design system naming
- Enforce usage everywhere status pills appear (remove inline implementations)
- **Location**: `lib/ui/design_system/widgets/app_badge.dart`

### Loading State Standardization

| Scenario | Widget |
|----------|--------|
| Content loading (lists, grids, cards) | `AppSkeleton` shimmer placeholders |
| Full-screen loading/empty/error | `AppEmptyState` with appropriate deer emotion |
| Button loading | `AppButton(loading: true)` — built-in spinner |

Remove all standalone `CircularProgressIndicator` usage in screens.

---

## Phase 2: Service Discovery Redesign

### Home Screen — Category Row

Replace the auto-scrolling `TestTypesSection` carousel with a horizontal scrollable category row:

- Each category: ~80px wide card with icon in tinted circle (48px) + category name below (caption text)
- Wrapped in `AppCard(onTap: ...)` for tap feedback
- Max 6-8 visible, horizontally scrollable
- Tapping a category navigates to `AllLabServicesScreen` pre-filtered to that category

### Home Screen Layout (Revised Order)

```
Greeting + avatar + notification bell
VisitOptionsSection (Clinic | Home)         ← keep as-is
Service Categories (horizontal scroll)      ← NEW
AdBanner                                    ← moved below categories
Popular Tests (3-4 horizontal cards)        ← first 4 from database order, or manually curated via a `is_popular` flag if available
Available Doctors (horizontal cards)        ← keep as-is
```

The auto-scroll carousel is removed entirely — it's a UX anti-pattern that hides content from users.

### All Services Screen — Category Filter

1. **Top**: `AppSearchField` for searching across all categories
2. **Below search**: Horizontal scrollable pill/chip bar of categories ("All", "Blood Tests", "Hormones", etc.) — tapping filters the grid below
3. **Grid**: Existing `ServiceCategoryGrid` 3-column layout but showing only the selected category (or all if "All" is selected)

### Service Tile Refinements

- Icon container: 48px (up from 44px)
- Add price as `AppTypography.caption` below the service name
- Wrap in `AppCard(onTap: ...)` instead of raw `TappableCard` + `Container`

---

## Phase 3: Screen Flow Cleanup

### Profile Screen Overhaul

**Header zone:**
```
[Avatar 50px]
[Display Name]     (heading text)
[Phone number]     (body text, grey)
[Role badge]       (AppBadge)
[MN | EN] segmented control pill
```

Language toggle is an inline `SegmentedButton` or custom pill widget — not a menu row, not a bottom sheet.

**Grouped settings sections:**

```
── Account ──
  Edit Profile          → Navigator.push full screen
  Change Password       → Navigator.push full screen

── History ──
  Request History       → Navigator.push full screen

── Preferences ──
  Notifications         → inline toggle + detail screen

── Support ──
  Help & FAQ
  About BUGAMED

[Sign Out]              → AlertDialog confirmation
```

Each row: leading icon + title + trailing chevron, wrapped in `AppCard(onTap: ...)`.

### Bottom Sheet Elimination

| Current | Replacement |
|---------|-------------|
| `LanguageSettingsSheet` | Inline segmented pill in profile header |
| `EditProfileSheet` | Full-screen page via `Navigator.push` |
| Change password sheet | Full-screen page via `Navigator.push` |
| Sign-out confirmation sheet | `AlertDialog` |

### Padding Standardization

Replace all hardcoded `EdgeInsets.all(15)`, `EdgeInsets.symmetric(horizontal: 15)`, etc. with `AppPadding.screenH` (20px horizontal) or `AppPadding.screenAll` (20px all).

---

## Phase 4: Micro-Interactions & Polish

### Tap Feedback

Handled automatically by `AppCard(onTap: ...)`:
- Scale-down to 0.97 over 100ms
- `HapticFeedback.lightImpact()` on tap
- Applies to: service tiles, doctor cards, category cards, visit option cards, profile menu rows

### Page Transitions

- **Push navigation**: `CupertinoPageRoute` instead of `MaterialPageRoute` — smoother, consistent on both platforms
- **Tab switches**: `FadeTransition` (200ms) in bottom nav for lateral movement
- No custom hero transitions or parallax effects

### Scroll Behavior

- `BouncingScrollPhysics` on all scrollable screens (currently only on home)
- `RefreshIndicator(color: AppColors.primary)` on all list screens (requests, laboratories, services)

### What We Do NOT Add

- No Lottie/Rive animations (bundle size)
- No complex hero transitions
- No skeleton-to-content crossfade animations
- No parallax, blur, or glassmorphism effects
- No dark mode (future consideration, not in scope)

---

## Phase 5: Mascot Integration

### Placement Rules

**Shows in** (50% opacity, 200px height, vertical layout with text below):
- Empty notifications
- Empty requests list
- Search with no results
- Network error states
- Generic error states
- Payment success
- Order cancelled
- Full-screen loading

**Does NOT show in**:
- Home screen (has real content)
- Service browsing screens (content-heavy)
- Booking forms (task-focused)
- Profile screen (user identity)
- Any screen with data loaded

### Implementation

Replace `MascotStateWidget` usage with `AppEmptyState` across all screens. The widget uses the same `MascotEmotion` enum and asset paths — only the opacity and sizing change.

---

## Files to Delete

| File | Replaced By |
|------|-------------|
| `lib/ui/shared/widgets/custom_button.dart` | `AppButton` |
| `lib/ui/shared/widgets/custom_text_field.dart` | `AppTextField` |
| `lib/ui/shared/widgets/tappable_card.dart` | `AppCard` (with onTap) |

## Files to Move to Design System

| From | To |
|------|-----|
| `lib/ui/shared/widgets/app_card.dart` | `lib/ui/design_system/widgets/app_card.dart` |
| `lib/ui/shared/widgets/status_badge.dart` | `lib/ui/design_system/widgets/app_badge.dart` |
| `lib/ui/shared/widgets/mascot_state_widget.dart` | `lib/ui/design_system/widgets/app_empty_state.dart` |

## Priority Order

1. Design System Foundation (Phase 1)
2. Service Discovery Redesign (Phase 2)
3. Screen Flow Cleanup (Phase 3)
4. Micro-Interactions & Polish (Phase 4)
5. Mascot Integration (Phase 5)
