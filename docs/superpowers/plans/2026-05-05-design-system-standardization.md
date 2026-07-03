# Design System Standardization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Standardize the Flutter UI in `lib/ui/` to a single design system — consistent tokens (color/typography/spacing/radius/shadow), single canonical components, and updated documentation — without redesigning the app.

**Architecture:** Token-first migration. Add new tokens alongside old aliases so the build stays green at every step. Refactor canonical components, add three new ones (`AppScreenHeader`, `AppSectionHeader`, `AppStatusChip`), then sweep every screen file by file. Delete legacy widgets and old aliases only after all callers have been migrated. Verify with `flutter analyze` after each task and `grep` checks against the spec's success criteria at the end.

**Tech Stack:** Flutter 3.10+, Material 3, MobX, AutoRoute, `google_fonts` (already a dep, used to load Inter), `iconsax` (already a dep, becomes the only icon set). Spec: `docs/superpowers/specs/2026-05-05-design-system-standardization-design.md`.

**Verification loop after every task:** Run `flutter analyze` from project root. Expected: `No issues found!` (or, if pre-existing analyzer warnings exist, no new ones introduced by this task).

---

## Phase 1: Token foundation

### Task 1: Wire Inter via google_fonts

**Files:**
- Modify: `pubspec.yaml` (no changes — `google_fonts: ^6.2.1` already there; SFPro asset block stays commented out)
- Modify: `lib/ui/design_system/app_theme.dart`

- [ ] **Step 1: Confirm `google_fonts` is already a dependency**

Run: `grep -n "google_fonts" /Users/shijirbum_b/Oncall-Lab/pubspec.yaml`
Expected: shows `google_fonts: ^6.2.1` in the dependencies section.

- [ ] **Step 2: Update `lib/ui/design_system/app_theme.dart` to use Inter via google_fonts**

Replace the whole file with:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_radius.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.border.withValues(alpha: 0.4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.inkSubtle),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
```

(This will not compile yet — `app_colors.dart` and `app_radius.dart` paths/exports change in Tasks 2 & 4. That's fine; Step 3 leaves the existing theme in place and we fix imports in later tasks. Skip writing this file until Task 7. **For now, only verify the dependency exists.**)

- [ ] **Step 3: Commit (no file changes)**

No commit needed; Task 1 is verification only. Proceed to Task 2.

---

### Task 2: Move and expand `app_colors.dart`

**Files:**
- Create: `lib/ui/design_system/app_colors.dart`
- Modify (delete after migration): `lib/core/constants/app_colors.dart` — replaced by re-export so existing imports keep working
- Update imports project-wide as a single `find` pass

- [ ] **Step 1: Create new `lib/ui/design_system/app_colors.dart`**

Replace any existing file at this path. New content:

```dart
import 'package:flutter/material.dart';

/// Single source of truth for color tokens.
/// No screen, widget, or store outside `lib/ui/design_system/` may define
/// its own hex value. Use these tokens.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF338A68);
  static const Color primaryDark = Color(0xFF2C7A5F);
  static Color get primarySoft => primary.withValues(alpha: 0.12);

  // Neutrals
  static const Color ink = Color(0xFF1A1D1F);
  static const Color inkMuted = Color(0xFF6F7378);
  static const Color inkSubtle = Color(0xFFA2A8B4);
  static const Color border = Color(0xFFECEEF1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FA);

  // Status (gently muted to harmonize with teal)
  static const Color pending = Color(0xFFE89B3C);
  static const Color accepted = Color(0xFF3F88C5);
  static const Color onTheWay = Color(0xFF3F88C5);
  static const Color sampleCollected = Color(0xFF5BA86A);
  static const Color deliveredToLab = Color(0xFF5BA86A);
  static const Color completed = primary;
  static const Color cancelled = Color(0xFFD8543C);

  // Semantic aliases of the toned palette
  static const Color success = sampleCollected;
  static const Color error = cancelled;
  static const Color warning = pending;
  static const Color info = accepted;

  // Doctor pastels (slightly desaturated for harmony)
  static const List<Color> doctorCardColors = [
    Color(0xFFF6BFC1), // Pink
    Color(0xFFEFCBA9), // Peach
    Color(0xFFC3C9F0), // Lavender
    Color(0xFFD6E2EF), // Light Blue
    Color(0xFFBFD9C0), // Light Green
  ];

  // Service category icons (toned ~10% softer)
  static const List<Color> serviceCategoryColors = [
    Color(0xFF338868), // primary teal
    Color(0xFF3F88C5), // blue
    Color(0xFF7259B5), // purple
    Color(0xFFE56A3D), // deep orange
    Color(0xFF26A69A), // teal
    Color(0xFFD83C73), // pink
    Color(0xFF5462B0), // indigo
    Color(0xFF5BA86A), // green
    Color(0xFFE89B3C), // amber
    Color(0xFF3FA0DD), // light blue
  ];

  // ---- Backward-compat aliases (removed in Task 25) ----
  // These let existing screens keep building during the per-screen sweep.
  static const Color grey = inkSubtle;
  static const Color black = ink;
  static const Color white = surface;
  static const Color textPrimary = ink;
  static const Color textSecondary = inkMuted;
  static const Color secondary = primaryDark;
  static const Color cardBackground = surface;
  static const Color scaffoldBackground = background;
  // accent yellow dropped — no alias; remaining call sites must migrate to primary or status colors

  // ---- Helpers ----
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return pending;
      case 'accepted':
        return accepted;
      case 'on_the_way':
      case 'ontheway':
        return onTheWay;
      case 'sample_collected':
      case 'samplecollected':
        return sampleCollected;
      case 'delivered_to_lab':
      case 'deliveredtolab':
        return deliveredToLab;
      case 'completed':
        return completed;
      case 'cancelled':
        return cancelled;
      default:
        return inkSubtle;
    }
  }

  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'on_the_way':
      case 'ontheway':
        return 'On the Way';
      case 'sample_collected':
      case 'samplecollected':
        return 'Sample Collected';
      case 'delivered_to_lab':
      case 'deliveredtolab':
        return 'Delivered to Lab';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  static Color getDoctorCardColor(int index) =>
      doctorCardColors[index % doctorCardColors.length];

  static Color getServiceCategoryColor(int index) =>
      serviceCategoryColors[index % serviceCategoryColors.length];
}
```

- [ ] **Step 2: Replace `lib/core/constants/app_colors.dart` with a re-export**

```dart
// Deprecated location. Re-exports the canonical tokens from the design system.
// New code should import 'package:bugamed/ui/design_system/app_colors.dart'.
export 'package:bugamed/ui/design_system/app_colors.dart';
```

This keeps the 49 existing import paths working while the migration runs.

- [ ] **Step 3: Update imports across the codebase to the new path**

Run from project root:

```bash
grep -rl "package:bugamed/core/constants/app_colors.dart" lib/ \
  | xargs sed -i '' 's|package:bugamed/core/constants/app_colors.dart|package:bugamed/ui/design_system/app_colors.dart|g'
```

- [ ] **Step 4: Delete the now-unused re-export shim**

```bash
rm lib/core/constants/app_colors.dart
```

- [ ] **Step 5: Verify no callers still reference the old path**

```bash
grep -rn "core/constants/app_colors" lib/
```

Expected: no output.

- [ ] **Step 6: Verify analyze**

Run: `flutter analyze`
Expected: no new issues introduced.

- [ ] **Step 7: Commit**

```bash
git add -A lib/
git commit -m "refactor(design-system): consolidate color tokens under design_system/"
```

---

### Task 3: Add `app_typography.dart`

**Files:**
- Create: `lib/ui/design_system/app_typography.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';

/// Typography scale. All app text uses these tokens — no inline TextStyle
/// font sizes / weights / families / colors elsewhere.
class AppTypography {
  AppTypography._();

  static TextStyle get display => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        height: 1.15,
      );

  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        height: 1.2,
      );

  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        height: 1.25,
        letterSpacing: -0.3,
      );

  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
        height: 1.3,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
        height: 1.4,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
        height: 1.4,
      );

  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.inkMuted,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.inkMuted,
        height: 1.4,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.inkMuted,
        letterSpacing: 0.4,
      );
}
```

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze lib/ui/design_system/app_typography.dart`
Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/app_typography.dart
git commit -m "feat(design-system): add Inter typography scale"
```

---

### Task 4: Split tokens — `app_radius.dart`, `app_spacing.dart`, `app_padding.dart`

**Files:**
- Create: `lib/ui/design_system/app_radius.dart`
- Create: `lib/ui/design_system/app_spacing.dart`
- Create: `lib/ui/design_system/app_padding.dart`
- Modify: `lib/ui/design_system/app_theme.dart` — drop the `AppRadius`, `AppSpacing`, `AppPadding`, `AppTypography` classes that currently live there (left in place from Task 1; they'll be removed in Task 7)

- [ ] **Step 1: Create `app_radius.dart`**

```dart
class AppRadius {
  AppRadius._();
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double pill = 999;
}
```

- [ ] **Step 2: Create `app_spacing.dart`**

```dart
class AppSpacing {
  AppSpacing._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  // xxxl 60 dropped — only used once
}
```

- [ ] **Step 3: Create `app_padding.dart`**

```dart
import 'package:flutter/widgets.dart';

class AppPadding {
  AppPadding._();
  static const double screen = 20;
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets screenAll = EdgeInsets.all(20);
}
```

- [ ] **Step 4: Verify analyze**

Run: `flutter analyze lib/ui/design_system/`
Expected: no issues for the three new files.

- [ ] **Step 5: Commit**

```bash
git add lib/ui/design_system/app_radius.dart lib/ui/design_system/app_spacing.dart lib/ui/design_system/app_padding.dart
git commit -m "feat(design-system): split radius / spacing / padding tokens"
```

---

### Task 5: Refactor `app_shadows.dart` to 3 named levels

**Files:**
- Modify: `lib/ui/design_system/app_shadows.dart`

- [ ] **Step 1: Replace the file**

```dart
import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  /// Cards in lists, default surfaces. Quiet.
  static final List<BoxShadow> resting = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  /// Hero cards, tappable feature surfaces, ad banner.
  static final List<BoxShadow> raised = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  /// Navbar, bottom sheets, modals — the layer that hovers above content.
  static final List<BoxShadow> floating = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> none = [];

  // ---- Backward-compat aliases (removed in Task 6) ----
  static List<BoxShadow> get sm => resting;
  static List<BoxShadow> get md => raised;
}
```

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze lib/ui/design_system/app_shadows.dart`
Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/app_shadows.dart
git commit -m "refactor(design-system): shadow scale → resting / raised / floating"
```

---

### Task 6: Migrate existing callers from old `AppShadows.sm/md` and `AppSpacing.xxxl`

**Files:**
- Modify (project-wide): every caller of `AppShadows.sm`, `AppShadows.md`, `AppSpacing.xxxl`

- [ ] **Step 1: Find old shadow callers**

```bash
grep -rn "AppShadows\.\(sm\|md\)\|AppSpacing\.xxxl" lib/
```

- [ ] **Step 2: Replace `AppShadows.sm` → `AppShadows.resting` and `AppShadows.md` → `AppShadows.raised`**

```bash
grep -rl "AppShadows\.sm\b" lib/ | xargs sed -i '' 's/AppShadows\.sm\b/AppShadows.resting/g'
grep -rl "AppShadows\.md\b" lib/ | xargs sed -i '' 's/AppShadows\.md\b/AppShadows.raised/g'
```

- [ ] **Step 3: Replace `AppSpacing.xxxl` (60) with literal `60` at the lone caller**

```bash
grep -rn "AppSpacing\.xxxl" lib/
```

For each match shown, manually change `AppSpacing.xxxl` → `60` (or, more often, the caller can drop the spacer entirely if it was decorative). Document the change in the commit body.

- [ ] **Step 4: Verify analyze**

Run: `flutter analyze`
Expected: no new issues.

- [ ] **Step 5: Commit**

```bash
git add -A lib/
git commit -m "refactor(design-system): migrate callers to new shadow / spacing tokens"
```

---

### Task 7: Wire `app_theme.dart` to new tokens (remove duplicate token classes)

**Files:**
- Modify: `lib/ui/design_system/app_theme.dart`

The existing file (from before this work) defines `AppTypography`, `AppSpacing`, `AppRadius`, `AppPadding` inline. Tasks 3 and 4 added them as standalone files. We now collapse `app_theme.dart` to **only** the `ThemeData` factory and re-export the others.

- [ ] **Step 1: Replace the file**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_radius.dart';

// Convenience re-exports so a single import gets the whole DS.
export 'package:bugamed/ui/design_system/app_colors.dart';
export 'package:bugamed/ui/design_system/app_radius.dart';
export 'package:bugamed/ui/design_system/app_spacing.dart';
export 'package:bugamed/ui/design_system/app_padding.dart';
export 'package:bugamed/ui/design_system/app_typography.dart';
export 'package:bugamed/ui/design_system/app_shadows.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.border.withValues(alpha: 0.4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.inkSubtle),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze`
Expected: no new issues. (Some screens may now have unused-import warnings on `app_theme.dart`; those resolve in Phase 3.)

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/app_theme.dart
git commit -m "refactor(design-system): wire theme to Inter and tokens; collapse duplicates"
```

---

## Phase 2: Canonical components

### Task 8: Move `AppCard` to design_system, refactor to tokens

**Files:**
- Create: `lib/ui/design_system/widgets/app_card.dart`
- Delete: `lib/ui/shared/widgets/app_card.dart`
- Update imports project-wide

- [ ] **Step 1: Create new `lib/ui/design_system/widgets/app_card.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_radius.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';

enum AppCardElevation { none, resting, raised, floating }

/// Canonical card surface. All card-shaped containers in the app go through this.
/// Replaces ad-hoc `Container(decoration: BoxDecoration(...))` patterns.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor = AppColors.surface,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = AppRadius.md,
    this.elevation = AppCardElevation.resting,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final AppCardElevation elevation;

  List<BoxShadow> get _shadow {
    switch (elevation) {
      case AppCardElevation.none:
        return AppShadows.none;
      case AppCardElevation.resting:
        return AppShadows.resting;
      case AppCardElevation.raised:
        return AppShadows.raised;
      case AppCardElevation.floating:
        return AppShadows.floating;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: _shadow,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
```

- [ ] **Step 2: Replace old path with re-export shim**

Replace `lib/ui/shared/widgets/app_card.dart` with:

```dart
export 'package:bugamed/ui/design_system/widgets/app_card.dart';
```

- [ ] **Step 3: Update imports project-wide**

```bash
grep -rl "package:bugamed/ui/shared/widgets/app_card.dart" lib/ \
  | xargs sed -i '' 's|package:bugamed/ui/shared/widgets/app_card.dart|package:bugamed/ui/design_system/widgets/app_card.dart|g'
```

- [ ] **Step 4: Delete the shim**

```bash
rm lib/ui/shared/widgets/app_card.dart
```

- [ ] **Step 5: Verify**

```bash
grep -rn "shared/widgets/app_card" lib/
flutter analyze
```

Both should be clean.

- [ ] **Step 6: Migrate `showShadow` API at callers**

Old API: `AppCard(showShadow: true)` / `AppCard(showShadow: false)`. New API: `elevation: AppCardElevation.resting / .none`. Find and update:

```bash
grep -rn "showShadow:" lib/
```

For each match, replace `showShadow: true` → `elevation: AppCardElevation.resting`, `showShadow: false` → `elevation: AppCardElevation.none`. Add `import 'package:bugamed/ui/design_system/widgets/app_card.dart';` if missing.

- [ ] **Step 7: Verify**

```bash
grep -rn "showShadow" lib/
flutter analyze
```

Both clean.

- [ ] **Step 8: Commit**

```bash
git add -A lib/
git commit -m "refactor(design-system): move AppCard to design_system, add elevation enum"
```

---

### Task 9: Refactor `AppButton` to tokens

**Files:**
- Modify: `lib/ui/design_system/widgets/app_button.dart`

- [ ] **Step 1: Replace the file**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_radius.dart';
import 'package:bugamed/ui/design_system/app_typography.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    final padding = const EdgeInsets.symmetric(horizontal: 24);

    return SizedBox(
      height: 52,
      width: fullWidth ? double.infinity : null,
      child: switch (variant) {
        AppButtonVariant.primary => ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              elevation: 0,
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(Colors.white),
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(AppColors.primary),
          ),
        AppButtonVariant.ghost => TextButton(
            onPressed: isDisabled ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(AppColors.primary),
          ),
        AppButtonVariant.danger => ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.error.withValues(alpha: 0.5),
              elevation: 0,
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(Colors.white),
          ),
      },
    );
  }

  Widget _buildChild(Color color) {
    if (loading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    final text = Text(label, style: AppTypography.bodyLg.copyWith(color: color, fontWeight: FontWeight.w600));

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          text,
        ],
      );
    }
    return text;
  }
}
```

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze lib/ui/design_system/widgets/app_button.dart`
Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/widgets/app_button.dart
git commit -m "refactor(design-system): AppButton uses typography token"
```

---

### Task 10: Refactor `AppTextField` to tokens

**Files:**
- Modify: `lib/ui/design_system/widgets/app_text_field.dart`

- [ ] **Step 1: Replace the file**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_typography.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.body.copyWith(color: AppColors.inkMuted),
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(color: AppColors.inkSubtle),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: enabled
            ? AppColors.border.withValues(alpha: 0.4)
            : AppColors.border.withValues(alpha: 0.7),
      ),
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    return TextField(
      controller: ctrl,
      onChanged: onChanged,
      style: AppTypography.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(color: AppColors.inkSubtle),
        prefixIcon: Icon(prefixIcon ?? Icons.search, color: AppColors.inkMuted),
        suffixIcon: ctrl != null && ctrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.inkSubtle),
                onPressed: onClear,
              )
            : null,
      ),
    );
  }
}
```

(Note: the search field's prefix `Icons.search` and suffix `Icons.close` are intentionally kept Material-native because Iconsax's `search_normal` and `close_circle` will be swapped in Task 24 once we've done the global icon mapping. For now we leave them.)

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze lib/ui/design_system/widgets/app_text_field.dart`
Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/widgets/app_text_field.dart
git commit -m "refactor(design-system): AppTextField uses typography tokens"
```

---

### Task 11: Refactor `AppBottomSheet` to tokens

**Files:**
- Modify: `lib/ui/design_system/widgets/app_bottom_sheet.dart`

- [ ] **Step 1: Read current file**

Run: `cat lib/ui/design_system/widgets/app_bottom_sheet.dart`

- [ ] **Step 2: Update inline radii to `AppRadius.lg`, hardcoded shadows to `AppShadows.floating`, and any inline `TextStyle` to `AppTypography.*`**

Apply the standard mapping. Add the imports if missing:

```dart
import 'package:bugamed/ui/design_system/app_radius.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_typography.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
```

Replace any `BorderRadius.circular(28)` (or other literal) with `BorderRadius.circular(AppRadius.lg)`. Replace any inline `BoxShadow` with `AppShadows.floating`. Replace any `TextStyle(fontSize: …)` with `AppTypography.*`.

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/ui/design_system/widgets/app_bottom_sheet.dart
```

Expected: no issues.

- [ ] **Step 4: Commit**

```bash
git add lib/ui/design_system/widgets/app_bottom_sheet.dart
git commit -m "refactor(design-system): AppBottomSheet uses tokens"
```

---

### Task 12: Create `AppScreenHeader`

**Files:**
- Create: `lib/ui/design_system/widgets/app_screen_header.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_padding.dart';
import 'package:bugamed/ui/design_system/app_spacing.dart';
import 'package:bugamed/ui/design_system/app_typography.dart';

/// Canonical screen header. Use at the top of every screen.
/// Replaces the per-screen bespoke headers in home / requests / dashboard / etc.
class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = AppPadding.screenH,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.h1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySm,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/ui/design_system/widgets/app_screen_header.dart
```

Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/widgets/app_screen_header.dart
git commit -m "feat(design-system): add AppScreenHeader"
```

---

### Task 13: Create `AppSectionHeader`

**Files:**
- Create: `lib/ui/design_system/widgets/app_section_header.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_padding.dart';
import 'package:bugamed/ui/design_system/app_typography.dart';

/// Canonical "section title with optional View all" row.
/// Replaces all hand-rolled `Row(spaceBetween, [Text(title), TextButton('View all')])`
/// across the app.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.padding = AppPadding.screenH,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.h2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionLabel != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.primary,
              ),
              child: Text(
                actionLabel!,
                style: AppTypography.body
                    .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/ui/design_system/widgets/app_section_header.dart
```

Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/widgets/app_section_header.dart
git commit -m "feat(design-system): add AppSectionHeader"
```

---

### Task 14: Create `AppStatusChip`

**Files:**
- Create: `lib/ui/design_system/widgets/app_status_chip.dart`

This widget needs to handle two callsites:
1. Patient request screens, which have a `RequestStatus` enum (in `lib/data/models/test_request_model.dart`).
2. Anywhere a raw status string from the backend is passed (`StatusBadge` today).

We expose two factories: `AppStatusChip(status: RequestStatus)` and `AppStatusChip.fromString(...)`.

- [ ] **Step 1: Read the enum to confirm cases**

Run: `grep -n "enum RequestStatus" /Users/shijirbum_b/Oncall-Lab/lib/data/models/test_request_model.dart`
Then read the lines that follow to confirm the enum cases.

- [ ] **Step 2: Create the file**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_radius.dart';
import 'package:bugamed/ui/design_system/app_typography.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// Canonical status pill. Replaces the inline status pill in
/// `requests_screen.dart` and the legacy `StatusBadge` widget.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({super.key, required this.label, required this.color});

  /// Build from a typed `RequestStatus` (preferred).
  factory AppStatusChip.fromStatus(
    RequestStatus status,
    AppLocalizations l10n,
  ) {
    final color = _colorForStatus(status);
    final label = _labelForStatus(status, l10n);
    return AppStatusChip(label: label, color: color);
  }

  /// Build from a raw backend status string (fallback).
  factory AppStatusChip.fromString(
    String status,
    AppLocalizations l10n,
  ) {
    final parsed = _parseStatus(status);
    if (parsed != null) {
      return AppStatusChip.fromStatus(parsed, l10n);
    }
    return AppStatusChip(
      label: AppColors.getStatusText(status),
      color: AppColors.getStatusColor(status),
    );
  }

  final String label;
  final Color color;

  static Color _colorForStatus(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return AppColors.pending;
      case RequestStatus.accepted:
        return AppColors.accepted;
      case RequestStatus.onTheWay:
        return AppColors.onTheWay;
      case RequestStatus.sampleCollected:
        return AppColors.sampleCollected;
      case RequestStatus.deliveredToLab:
        return AppColors.deliveredToLab;
      case RequestStatus.completed:
        return AppColors.completed;
      case RequestStatus.cancelled:
        return AppColors.cancelled;
    }
  }

  static String _labelForStatus(RequestStatus status, AppLocalizations l10n) {
    switch (status) {
      case RequestStatus.pending:
        return l10n.pending;
      case RequestStatus.accepted:
        return l10n.accepted;
      case RequestStatus.onTheWay:
        return l10n.onTheWay;
      case RequestStatus.sampleCollected:
        return l10n.sampleCollected;
      case RequestStatus.deliveredToLab:
        return l10n.deliveredToLab;
      case RequestStatus.completed:
        return l10n.completed;
      case RequestStatus.cancelled:
        return l10n.cancelled;
    }
  }

  static RequestStatus? _parseStatus(String s) {
    switch (s.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'on_the_way':
      case 'ontheway':
        return RequestStatus.onTheWay;
      case 'sample_collected':
      case 'samplecollected':
        return RequestStatus.sampleCollected;
      case 'delivered_to_lab':
      case 'deliveredtolab':
        return RequestStatus.deliveredToLab;
      case 'completed':
        return RequestStatus.completed;
      case 'cancelled':
        return RequestStatus.cancelled;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/ui/design_system/widgets/app_status_chip.dart
```

Expected: no issues.

- [ ] **Step 4: Commit**

```bash
git add lib/ui/design_system/widgets/app_status_chip.dart
git commit -m "feat(design-system): add AppStatusChip"
```

---

## Phase 3: Per-screen sweep

**Standard mapping (apply to every screen file):**

| Old | New |
|-----|-----|
| `Color(0xFF...)` literal | `AppColors.<token>` |
| `BorderRadius.circular(12 / 14 / 18 / 20 / 24 / 28)` | `BorderRadius.circular(AppRadius.<sm/md/lg/pill>)` |
| Inline `BoxShadow(...)` | `AppShadows.<resting/raised/floating>` |
| `TextStyle(fontSize: 14, fontWeight: …)` | `AppTypography.<body/h1/h2/etc>` (use `.copyWith(...)` for color/weight tweaks) |
| `EdgeInsets.symmetric(horizontal: 15)` / `16` / `20` | `AppPadding.screenH` |
| `EdgeInsets.all(15 / 16 / 20)` | `AppPadding.screenAll` |
| `Container(decoration: BoxDecoration(color: white, borderRadius, boxShadow))` | `AppCard(child: ..., elevation: ..., padding: ...)` |
| Hand-rolled header `Row` with title + bell/avatar | `AppScreenHeader(title:, trailing:)` |
| Hand-rolled "Title + View all" row | `AppSectionHeader(title:, actionLabel: l10n.viewAll, onActionTap:)` |
| Inline status pill / `StatusBadge` | `AppStatusChip.fromStatus(status, l10n)` |
| `CustomButton(...)` | `AppButton(label:, onPressed:, variant:)` |
| `CustomTextField(...)` | `AppTextField(...)` |
| Bare `Icon + Text` empty state | `MascotStateWidget(emotion:, title:, subtitle:)` |
| `Icons.<name>` | left for now — Task 24 does the global Iconsax pass |

**Required imports for sweep tasks** (add the ones used at the top of each file you edit):

```dart
import 'package:bugamed/ui/design_system/app_theme.dart'; // re-exports all tokens
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_section_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_status_chip.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
```

(Then remove any of the above imports that are unused at file end.)

**After every sweep task: run `flutter analyze` and fix any issues introduced before committing.**

---

### Task 15: Refactor `VisitOptionCard` and `VisitOptionsSection`

This is the one specific visual fix in scope: both halves of the visit options become structurally consistent.

**Files:**
- Modify: `lib/ui/patient/widgets/visit_option_card.dart`
- Modify: `lib/ui/patient/widgets/visit_options_section.dart`

- [ ] **Step 1: Replace `lib/ui/patient/widgets/visit_option_card.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';

class VisitOptionCard extends StatelessWidget {
  const VisitOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
    this.borderColor,
    this.elevated = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color? borderColor;
  final bool elevated;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.lg);

    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
            boxShadow: elevated ? AppShadows.raised : AppShadows.none,
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(color: titleColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(color: subtitleColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

(The `_WavyPatternPainter` class is removed entirely.)

- [ ] **Step 2: Replace `lib/ui/patient/widgets/visit_options_section.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/patient/widgets/visit_option_card.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class VisitOptionsSection extends StatelessWidget {
  const VisitOptionsSection({
    super.key,
    required this.onClinicTap,
    required this.onHomeTap,
  });

  final VoidCallback onClinicTap;
  final VoidCallback onHomeTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: AppPadding.screenH,
      child: Row(
        children: [
          Expanded(
            child: VisitOptionCard(
              icon: Iconsax.hospital,
              title: l10n.clinicVisit,
              subtitle: l10n.makeAnAppointment,
              backgroundColor: AppColors.primary,
              titleColor: Colors.white,
              subtitleColor: Colors.white.withValues(alpha: 0.8),
              iconBackgroundColor: Colors.white.withValues(alpha: 0.18),
              iconColor: Colors.white,
              elevated: true,
              onTap: onClinicTap,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: VisitOptionCard(
              icon: Iconsax.home_2,
              title: l10n.homeVisit,
              subtitle: l10n.callTheDoctorHome,
              backgroundColor: AppColors.surface,
              titleColor: AppColors.ink,
              subtitleColor: AppColors.inkMuted,
              iconBackgroundColor: AppColors.primarySoft,
              iconColor: AppColors.primary,
              borderColor: AppColors.border,
              elevated: true,
              onTap: onHomeTap,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/ui/patient/widgets/visit_option_card.dart lib/ui/patient/widgets/visit_options_section.dart
```

Expected: no issues.

- [ ] **Step 4: Commit**

```bash
git add lib/ui/patient/widgets/visit_option_card.dart lib/ui/patient/widgets/visit_options_section.dart
git commit -m "refactor(patient): unify visit options into one consistent treatment"
```

---

### Task 16: Sweep patient home widgets

**Files (apply standard mapping):**
- `lib/ui/patient/widgets/test_types_section.dart`
- `lib/ui/patient/widgets/doctor_card_tile.dart`
- `lib/ui/patient/widgets/ad_banner.dart`
- `lib/ui/patient/widgets/service_category_grid.dart`
- `lib/ui/patient/widgets/available_doctors_section.dart`
- `lib/ui/patient/widgets/review_item.dart`
- `lib/ui/patient/widgets/schedule_item.dart`

- [ ] **Step 1: For each file, apply the standard mapping table above**

Special notes per file:
- **`test_types_section.dart`** — replace the inline `Container(decoration: BoxDecoration(color: white, borderRadius: 12, border: …, boxShadow: …))` with `AppCard(elevation: AppCardElevation.resting, padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: …)`. Replace the inline title `TextStyle(fontSize: 22, fontWeight: bold, letterSpacing: -0.5)` with `AppTypography.h2`. Replace the test name `TextStyle(fontSize: 13, fontWeight: w600)` with `AppTypography.body.copyWith(fontWeight: FontWeight.w600)`. Replace price `TextStyle(fontSize: 12, color: grey)` with `AppTypography.caption`.
- **`doctor_card_tile.dart`** — `BorderRadius.circular(12)` → `AppRadius.md`. Inline `BoxShadow` → `AppShadows.resting`. Rating pill `BorderRadius.circular(12)` → `AppRadius.sm`. Use typography tokens for name/specialization/price.
- **`ad_banner.dart`** — `BorderRadius.circular(20)` → `AppRadius.lg`. Title `TextStyle` → `AppTypography.h3.copyWith(color: white)`. Subtitle → `AppTypography.bodySm.copyWith(color: white)`. Indicator dot color: `AppColors.primary` for active, `AppColors.inkSubtle.withValues(alpha: 0.3)` for inactive.
- **`service_category_grid.dart`** — already uses `AppRadius.md` / `AppRadius.sm`; replace remaining inline `TextStyle` with `AppTypography.label` for the small tile name. Replace `AppTypography.titleMedium` (from old theme) with `AppTypography.h3`.
- **`available_doctors_section.dart`** — token sweep; ensure title uses `AppTypography.h2`.
- **`review_item.dart`, `schedule_item.dart`** — token sweep; cards become `AppCard`.

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/ui/patient/widgets/
```

Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/widgets/
git commit -m "refactor(patient): sweep home widgets to design tokens"
```

---

### Task 17: Sweep patient main screens

**Files:**
- `lib/ui/patient/home_screen.dart`
- `lib/ui/patient/requests_screen.dart`
- `lib/ui/patient/profile_screen.dart`
- `lib/ui/patient/all_lab_services_screen.dart`
- `lib/ui/patient/direct_services_screen.dart`
- `lib/ui/patient/laboratories_screen.dart`
- `lib/ui/patient/laboratory_detail_screen.dart`

- [ ] **Step 1: Apply the standard mapping**

Specific transformations:

- **`home_screen.dart`** — replace `_buildHeader()` body's `Row(...)` with `AppScreenHeader(title: displayName ?? l10n.welcome, trailing: Row(children: [const NotificationBell(), const SizedBox(width: 8), GestureDetector(onTap: widget.onNavigateToProfile, child: ProfileAvatar(...))]))`. Keep the waving-hand animation by wrapping the title in a custom `trailing` slot if needed; otherwise keep the simple `AppScreenHeader` and lose the animated hand (tradeoff: slight feature loss; acceptable for consistency, document in commit). Replace the "Available doctors / View all" `Row` with `AppSectionHeader(title: l10n.availableDoctors, actionLabel: l10n.viewAll, onActionTap: …)`.
  > **Decision required:** keep or drop the waving hand. Default: **drop** for consistency. If the user wants it preserved, leave the bespoke header for `home_screen.dart` only and add a `// EXEMPTION: animated hand` comment.

- **`requests_screen.dart`** — replace the title+subtitle `Padding(...)` block (lines 92–115 in the current file) with `AppScreenHeader(title: l10n.myRequests, subtitle: l10n.requestHistory)`. Replace the inline status pill in `_RequestCard` (lines 313–328) with `AppStatusChip.fromStatus(request.status, l10n)`. Replace the `AppCard(borderRadius: 18, …)` argument with default (`AppRadius.md`).

- **`profile_screen.dart`** — token sweep, ensure header uses `AppScreenHeader` if any.

- **`all_lab_services_screen.dart`, `direct_services_screen.dart`, `laboratories_screen.dart`, `laboratory_detail_screen.dart`** — token sweep, replace headers with `AppScreenHeader`.

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/ui/patient/
```

Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/
git commit -m "refactor(patient): sweep main screens to design tokens and canonical headers"
```

---

### Task 18: Sweep patient booking flow

**Files:**
- `lib/ui/patient/booking_confirmation_screen.dart`
- `lib/ui/patient/booking/lab_service_booking_screen.dart`
- `lib/ui/patient/booking/direct_service_booking_screen.dart`
- `lib/ui/patient/booking/widgets/saved_address_selector.dart`

- [ ] **Step 1: Apply the standard mapping to each file**

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/ui/patient/booking/ lib/ui/patient/booking_confirmation_screen.dart
```

Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/booking/ lib/ui/patient/booking_confirmation_screen.dart
git commit -m "refactor(patient): sweep booking flow to design tokens"
```

---

### Task 19: Sweep patient supplemental screens

**Files:**
- `lib/ui/patient/location/location_picker_screen.dart`
- `lib/ui/patient/screens/doctor_detail_screen.dart`
- `lib/ui/patient/screens/schedule_screen.dart`

- [ ] **Step 1: Apply the standard mapping**

- [ ] **Step 2: Verify and commit**

```bash
flutter analyze lib/ui/patient/location/ lib/ui/patient/screens/
git add lib/ui/patient/location/ lib/ui/patient/screens/
git commit -m "refactor(patient): sweep supplemental screens to design tokens"
```

---

### Task 20: Sweep doctor flow

**Files:**
- `lib/ui/doctor/doctor_dashboard_screen.dart`
- `lib/ui/doctor/doctor_main_page.dart`
- `lib/ui/doctor/doctor_profile_screen.dart`
- `lib/ui/doctor/doctor_request_detail_screen.dart`
- `lib/ui/doctor/widgets/location_viewer_widget.dart`

- [ ] **Step 1: Apply the standard mapping**

Specific:
- **`doctor_dashboard_screen.dart`** — replace the title+bell `Row` (lines 64–80) with `AppScreenHeader(title: l10n.myDashboard, trailing: const NotificationBell())`. Replace the `BorderRadius.circular(5)` on the tab container with `AppRadius.sm`. Replace inline status pills in request cards with `AppStatusChip.fromStatus(...)`.

- [ ] **Step 2: Verify and commit**

```bash
flutter analyze lib/ui/doctor/
git add lib/ui/doctor/
git commit -m "refactor(doctor): sweep doctor flow to design tokens"
```

---

### Task 21: Sweep auth flow

**Files:**
- `lib/ui/auth/login_screen.dart`
- `lib/ui/auth/patient_registration_screen.dart`
- `lib/ui/auth/doctor_registration_screen.dart`
- `lib/ui/auth/widgets/step_progress_bar.dart`

- [ ] **Step 1: Apply the standard mapping**

Specific:
- **`login_screen.dart`** — the welcome / signin texts (lines 110–125 of current file) become `AppTypography.h1` / `AppTypography.body`. The hospital-icon container's hardcoded `BorderRadius` and `Color` use tokens. Bottom buttons use `AppButton`.

- [ ] **Step 2: Verify and commit**

```bash
flutter analyze lib/ui/auth/
git add lib/ui/auth/
git commit -m "refactor(auth): sweep auth flow to design tokens"
```

---

### Task 22: Sweep payment flow

**Files:**
- `lib/ui/payment/payment_screen.dart`
- `lib/ui/payment/payment_method_screen.dart`
- `lib/ui/payment/payment_success_screen.dart`
- `lib/ui/payment/qpay_invoice_screen.dart`

- [ ] **Step 1: Apply the standard mapping**

- [ ] **Step 2: Verify and commit**

```bash
flutter analyze lib/ui/payment/
git add lib/ui/payment/
git commit -m "refactor(payment): sweep payment flow to design tokens"
```

---

### Task 23: Sweep shared screens, widgets, and `main_page.dart`

**Files:**
- `lib/ui/patient/main_page.dart`
- `lib/ui/shared/splash_screen.dart`
- `lib/ui/shared/notifications_screen.dart`
- `lib/ui/shared/notification_detail_screen.dart`
- `lib/ui/shared/widgets/notification_bell.dart`
- `lib/ui/shared/widgets/profile_avatar.dart`
- `lib/ui/shared/widgets/language_switcher.dart`
- `lib/ui/shared/widgets/skeleton_loader.dart`
- `lib/ui/shared/widgets/top_notification.dart`
- `lib/ui/shared/widgets/tappable_card.dart`
- `lib/ui/shared/widgets/mascot_state_widget.dart`

- [ ] **Step 1: Apply the standard mapping**

Specific:
- **`main_page.dart`** — replace `BorderRadius.circular(24)` on the navbar with `AppRadius.lg`. Replace the inline `BoxShadow`s with `AppShadows.floating`. Replace the inline `_NavBarItem` `TextStyle(fontSize: 10, fontWeight: …)` with `AppTypography.label.copyWith(color: ...)`.
- **`mascot_state_widget.dart`** — token sweep; ensure title/subtitle use `AppTypography.h2` / `AppTypography.bodySm`.

- [ ] **Step 2: Verify and commit**

```bash
flutter analyze lib/ui/shared/ lib/ui/patient/main_page.dart
git add lib/ui/shared/ lib/ui/patient/main_page.dart
git commit -m "refactor(shared): sweep shared screens and navbar to design tokens"
```

---

### Task 24: Global Iconsax pass

**Files:**
- All files in `lib/ui/` that currently reference `Icons.<name>`

- [ ] **Step 1: Find every reference**

```bash
grep -rn "Icons\." lib/ui/ | wc -l
grep -rn "Icons\." lib/ui/ > /tmp/icon_replacements.txt
```

- [ ] **Step 2: Apply the canonical Material → Iconsax mapping**

For every match, replace using this mapping (extend if you encounter an icon not listed — pick the closest Iconsax outline equivalent):

| `Icons.*` | `Iconsax.*` |
|-----------|-------------|
| `Icons.add` | `Iconsax.add` |
| `Icons.bloodtype` | `Iconsax.drop` |
| `Icons.calendar_month_outlined` | `Iconsax.calendar_1` |
| `Icons.location_on_outlined` | `Iconsax.location` |
| `Icons.payments_outlined` | `Iconsax.wallet_money` |
| `Icons.note_alt_outlined` | `Iconsax.note_text` |
| `Icons.biotech_outlined` | `Iconsax.flask` |
| `Icons.home_work_outlined` | `Iconsax.home_2` |
| `Icons.error_outline` | `Iconsax.warning_2` |
| `Icons.info_outline` | `Iconsax.info_circle` |
| `Icons.search` | `Iconsax.search_normal` |
| `Icons.close` | `Iconsax.close_circle` |
| `Icons.local_hospital` | `Iconsax.hospital` |
| `Icons.star` | `Iconsax.star1` |
| `Icons.arrow_back` | `Iconsax.arrow_left` |
| `Icons.arrow_forward` | `Iconsax.arrow_right_3` |
| `Icons.check` | `Iconsax.tick_circle` |
| `Icons.notifications_outlined` | `Iconsax.notification` |

In each file:
1. Add `import 'package:iconsax/iconsax.dart';` if not already present.
2. Replace each `Icons.<x>` with the mapped `Iconsax.<x>`.
3. If you see an icon not in the mapping, find the nearest Iconsax equivalent at <https://iconsax.io> and add a row to this table in your commit body.

- [ ] **Step 3: Verify there are no residual `Icons.` references in `lib/ui/`**

```bash
grep -rn "Icons\." lib/ui/
```

Expected: no output. If there are remnants in `app_text_field.dart`'s `AppSearchField` (placeholder from Task 10), update them now to `Iconsax.search_normal` and `Iconsax.close_circle`.

- [ ] **Step 4: Verify analyze**

```bash
flutter analyze
```

Expected: no issues.

- [ ] **Step 5: Commit**

```bash
git add -A lib/
git commit -m "refactor(icons): replace Material Icons with Iconsax everywhere"
```

---

## Phase 4: Cleanup

### Task 25: Delete legacy widgets and unused screens

**Files:**
- Delete: `lib/ui/shared/widgets/custom_button.dart`
- Delete: `lib/ui/shared/widgets/custom_text_field.dart`
- Delete: `lib/ui/shared/widgets/status_badge.dart`
- Delete: `lib/ui/shared/widgets/doctor_card.dart`
- Delete: `lib/ui/patient/laboratory_detail_screen_new.dart`

- [ ] **Step 1: Verify nothing imports these files**

```bash
for f in custom_button custom_text_field status_badge doctor_card laboratory_detail_screen_new; do
  echo "=== $f ==="
  grep -rln "$f" lib/ || echo "(no callers)"
done
```

Expected: each shows `(no callers)`. If any caller remains, that means a sweep task missed a swap — go back and fix the swap, then return here.

- [ ] **Step 2: Delete the files**

```bash
rm lib/ui/shared/widgets/custom_button.dart \
   lib/ui/shared/widgets/custom_text_field.dart \
   lib/ui/shared/widgets/status_badge.dart \
   lib/ui/shared/widgets/doctor_card.dart \
   lib/ui/patient/laboratory_detail_screen_new.dart
```

- [ ] **Step 3: Verify analyze**

```bash
flutter analyze
```

Expected: no new issues.

- [ ] **Step 4: Commit**

```bash
git add -A lib/
git commit -m "chore(design-system): delete legacy widgets and unused screen"
```

---

### Task 26: Remove old color aliases and verify single source

**Files:**
- Modify: `lib/ui/design_system/app_colors.dart` — remove the backward-compat aliases block (Task 2 added it)

- [ ] **Step 1: Remove the aliases block**

In `lib/ui/design_system/app_colors.dart`, delete these lines:

```dart
// ---- Backward-compat aliases (removed in Task 25) ----
static const Color grey = inkSubtle;
static const Color black = ink;
static const Color white = surface;
static const Color textPrimary = ink;
static const Color textSecondary = inkMuted;
static const Color secondary = primaryDark;
static const Color cardBackground = surface;
static const Color scaffoldBackground = background;
```

- [ ] **Step 2: Run analyze and migrate any remaining callers**

```bash
flutter analyze
```

Expected: errors at any caller still using `AppColors.grey`, `.black`, `.white`, `.textPrimary`, `.textSecondary`, `.secondary`, `.cardBackground`, `.scaffoldBackground`.

For each error, change the caller to the canonical token using this mapping:

| Old | New |
|-----|-----|
| `AppColors.grey` | `AppColors.inkSubtle` |
| `AppColors.black` | `AppColors.ink` |
| `AppColors.white` | `Colors.white` (or `AppColors.surface` for surfaces) |
| `AppColors.textPrimary` | `AppColors.ink` |
| `AppColors.textSecondary` | `AppColors.inkMuted` |
| `AppColors.secondary` | `AppColors.primaryDark` |
| `AppColors.cardBackground` | `AppColors.surface` |
| `AppColors.scaffoldBackground` | `AppColors.background` |

You can do most of this with sed:

```bash
grep -rl "AppColors\.grey\b" lib/ | xargs sed -i '' 's/AppColors\.grey\b/AppColors.inkSubtle/g'
grep -rl "AppColors\.black\b" lib/ | xargs sed -i '' 's/AppColors\.black\b/AppColors.ink/g'
grep -rl "AppColors\.textPrimary\b" lib/ | xargs sed -i '' 's/AppColors\.textPrimary\b/AppColors.ink/g'
grep -rl "AppColors\.textSecondary\b" lib/ | xargs sed -i '' 's/AppColors\.textSecondary\b/AppColors.inkMuted/g'
grep -rl "AppColors\.secondary\b" lib/ | xargs sed -i '' 's/AppColors\.secondary\b/AppColors.primaryDark/g'
grep -rl "AppColors\.cardBackground\b" lib/ | xargs sed -i '' 's/AppColors\.cardBackground\b/AppColors.surface/g'
grep -rl "AppColors\.scaffoldBackground\b" lib/ | xargs sed -i '' 's/AppColors\.scaffoldBackground\b/AppColors.background/g'
```

For `AppColors.white`, decide per call site (inline color = `Colors.white`, surface = `AppColors.surface`); do these by hand.

- [ ] **Step 3: Verify analyze passes**

```bash
flutter analyze
```

Expected: no issues.

- [ ] **Step 4: Commit**

```bash
git add -A lib/
git commit -m "refactor(design-system): remove old color aliases; migrate callers"
```

---

### Task 27: Verify all success criteria from the spec

- [ ] **Step 1: No inline `BoxShadow` outside the design system**

```bash
grep -rn "BoxShadow(" lib/ui/ | grep -v "lib/ui/design_system/app_shadows.dart"
```

Expected: no output.

- [ ] **Step 2: No inline radii outside the design system**

```bash
grep -rEn "borderRadius:\s*BorderRadius\.circular\([0-9]" lib/ui/ | grep -v "lib/ui/design_system/"
```

Expected: no output.

- [ ] **Step 3: No inline hex colors outside `app_colors.dart`**

```bash
grep -rn "Color(0xFF" lib/ui/ | grep -v "lib/ui/design_system/app_colors.dart"
```

Expected: no output.

- [ ] **Step 4: No inline `fontFamily` declarations**

```bash
grep -rn "fontFamily:" lib/ui/
```

Expected: matches only inside `lib/ui/design_system/`.

- [ ] **Step 5: No `Icons.*` calls outside the design system**

```bash
grep -rn "Icons\." lib/ui/
```

Expected: no output.

- [ ] **Step 6: Legacy widget files are gone**

```bash
ls lib/ui/shared/widgets/custom_button.dart lib/ui/shared/widgets/custom_text_field.dart lib/ui/shared/widgets/status_badge.dart lib/ui/shared/widgets/doctor_card.dart lib/ui/patient/laboratory_detail_screen_new.dart 2>/dev/null
```

Expected: every line shows `No such file or directory`.

- [ ] **Step 7: `flutter analyze` is clean**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 8: Visual smoke test on iPhone**

```bash
flutter run -d 00008110-001C702E0E40401E
```

Manually check:
- Patient home renders (header, visit options, ad banner, test types, available doctors)
- Patient requests list shows status chips
- Doctor dashboard renders with tabs
- Login screen shows
- One booking flow opens

If any of these fail or look broken, file a follow-up ticket; do not block on cosmetic regressions, but do block on layout breakage.

- [ ] **Step 9: If any criterion fails, return to the relevant Task and fix**

Otherwise, proceed.

- [ ] **Step 10: Commit (no changes expected — verification only)**

If any fixes were needed in this task, commit them with:

```bash
git add -A lib/
git commit -m "fix(design-system): close gaps from final verification sweep"
```

---

## Phase 5: Documentation

### Task 28: Write `lib/ui/design_system/README.md`

**Files:**
- Create: `lib/ui/design_system/README.md`

- [ ] **Step 1: Create the file**

```markdown
# Design System

Single source of truth for the OnCall Lab Flutter UI.

> **Rule:** No screen, widget, or store outside this folder may define its own
> hex value, radius, shadow, font family, or hardcoded text style. Use these
> tokens. If you need a value the system doesn't have, propose adding it here
> first.

## Tokens

### Colors — `app_colors.dart`

| Token | Hex | Use |
|-------|-----|-----|
| `primary` | `#338A68` | Brand color |
| `primaryDark` | `#2C7A5F` | Pressed states |
| `primarySoft` | primary @ 12% | Tinted backgrounds, icon containers |
| `ink` | `#1A1D1F` | Primary text |
| `inkMuted` | `#6F7378` | Secondary text |
| `inkSubtle` | `#A2A8B4` | Placeholder, disabled |
| `border` | `#ECEEF1` | Card borders, dividers |
| `surface` | `#FFFFFF` | Card / surface |
| `background` | `#F7F8FA` | Scaffold |

Status colors: `pending`, `accepted`, `onTheWay`, `sampleCollected`, `deliveredToLab`, `completed`, `cancelled`. Each composed at 12% alpha for chip backgrounds.

```dart
Container(color: AppColors.primarySoft);
Text('Hi', style: TextStyle(color: AppColors.ink));
```

### Typography — `app_typography.dart`

`display`, `h1`, `h2`, `h3`, `bodyLg`, `body`, `bodySm`, `caption`, `label`. All Inter.

```dart
Text('Welcome', style: AppTypography.h1);
Text('Subtitle', style: AppTypography.bodySm);
```

### Spacing — `app_spacing.dart`

`xs 8`, `sm 12`, `md 16`, `lg 24`, `xl 32`, `xxl 40`.

### Radius — `app_radius.dart`

`sm 12`, `md 16`, `lg 20`, `pill 999`.

### Shadow — `app_shadows.dart`

`resting`, `raised`, `floating`.

### Padding — `app_padding.dart`

`screen 20`, `screenH`, `screenAll`.

### Icons

Use **Iconsax** only:

```dart
import 'package:iconsax/iconsax.dart';
Icon(Iconsax.heart, color: AppColors.primary);
```

## Canonical components — `widgets/`

### `AppCard`
```dart
AppCard(
  elevation: AppCardElevation.resting,
  onTap: () {},
  child: Text('Hello'),
);
```

### `AppButton`
```dart
AppButton(
  label: 'Continue',
  variant: AppButtonVariant.primary,
  onPressed: () {},
);
```

### `AppTextField`
```dart
AppTextField(label: 'Phone', controller: ctrl);
```

### `AppScreenHeader`
```dart
AppScreenHeader(
  title: l10n.myRequests,
  subtitle: l10n.requestHistory,
  trailing: const NotificationBell(),
);
```

### `AppSectionHeader`
```dart
AppSectionHeader(
  title: l10n.availableDoctors,
  actionLabel: l10n.viewAll,
  onActionTap: () => Navigator.push(...),
);
```

### `AppStatusChip`
```dart
AppStatusChip.fromStatus(request.status, l10n);
```

## Single import for everything

```dart
import 'package:bugamed/ui/design_system/app_theme.dart';
```

This re-exports every token. Then import the specific widgets you use:

```dart
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
```

## Rules for new screens

1. Always wrap content in `SafeArea`.
2. Top of every screen: `AppScreenHeader`.
3. Section titles: `AppSectionHeader`.
4. Card surfaces: `AppCard`.
5. Buttons: `AppButton` (never raw `ElevatedButton`).
6. Inputs: `AppTextField`.
7. Status display: `AppStatusChip`.
8. Empty / error / loading states: `MascotStateWidget`.
9. Icons: `Iconsax` only.
10. Spacing/padding: tokens only — never literal `EdgeInsets.all(15)`.
```

- [ ] **Step 2: Commit**

```bash
git add lib/ui/design_system/README.md
git commit -m "docs(design-system): add developer reference README"
```

---

### Task 29: Rewrite `CLAUDE.md`

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Open the current `CLAUDE.md`**

Read the file end-to-end so you don't accidentally remove unrelated sections (push notification system docs, test request workflow, etc.).

- [ ] **Step 2: Replace the "Design System" subsection (currently under Architecture) with the following block**

```markdown
### Design System

Single source of truth: `lib/ui/design_system/`. See `lib/ui/design_system/README.md`
for the full token table and component reference.

**Brand color:** primary teal `#338A68` (`AppColors.primary`).

**Tokens:**
- Colors — `lib/ui/design_system/app_colors.dart`
- Typography (Inter via `google_fonts`) — `lib/ui/design_system/app_typography.dart`
- Spacing — `lib/ui/design_system/app_spacing.dart`
- Radius — `lib/ui/design_system/app_radius.dart` (`sm 12`, `md 16`, `lg 20`, `pill 999`)
- Shadow — `lib/ui/design_system/app_shadows.dart` (`resting`, `raised`, `floating`)
- Padding — `lib/ui/design_system/app_padding.dart`

**Canonical components:** `AppButton`, `AppTextField`, `AppCard`, `AppScreenHeader`,
`AppSectionHeader`, `AppStatusChip`, `AppBottomSheet`, `MascotStateWidget`.

**Icons:** Iconsax only (`package:iconsax/iconsax.dart`). No `Icons.*` references
in `lib/ui/`.

### Adding new screens — design system rules

1. Always use tokens — never hardcode hex, radius, shadow, font, or padding values.
2. Always wrap content in `SafeArea`.
3. Use `AppScreenHeader` at the top of every screen.
4. Use `AppSectionHeader` for any "title + action" row.
5. Use `AppCard` for any card surface (no ad-hoc `Container(decoration: BoxDecoration(...))`).
6. Use `AppButton` only — never `ElevatedButton`, `OutlinedButton`, or `TextButton` directly.
7. Use `AppTextField` for all inputs.
8. Use `AppStatusChip.fromStatus(...)` for any test-request status display.
9. Use `MascotStateWidget` for empty / error / loading states.
10. Icons are Iconsax only. Add the `iconsax` import; do not import `Icons` from material.
```

- [ ] **Step 3: Find and remove every reference to "Doctor Appointment UI", "purple", and the old `#665ACF` hex**

```bash
grep -n "Doctor Appointment\|665ACF\|purple" CLAUDE.md
```

Expected after edits: no output.

- [ ] **Step 4: Update the directory structure block in `CLAUDE.md`**

Replace the old `lib/` tree with:

```
lib/
├── core/                       # Core functionality and shared utilities
│   ├── constants/              # Non-UI constants (test types, supabase config, app strings)
│   ├── services/               # Services (supabase, storage, etc.)
│   └── utils/
├── data/
│   ├── models/                 # Freezed + json_serializable models
│   └── repositories/           # Data access (Supabase)
├── stores/                     # MobX stores
├── ui/
│   ├── design_system/          # Single source of truth — tokens + canonical components
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   ├── app_shadows.dart
│   │   ├── app_padding.dart
│   │   ├── app_theme.dart
│   │   ├── README.md
│   │   └── widgets/            # AppButton, AppCard, AppTextField, AppScreenHeader, etc.
│   ├── auth/
│   ├── doctor/
│   ├── patient/
│   ├── payment/
│   └── shared/
│       └── widgets/            # Feature-specific widgets only (NotificationBell, ProfileAvatar, etc.)
└── main.dart
```

- [ ] **Step 5: Verify**

```bash
grep -n "Doctor Appointment\|665ACF\|purple" CLAUDE.md
```

Expected: no output.

- [ ] **Step 6: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: rewrite CLAUDE.md design system section to match reality"
```

---

### Task 30: Update `README.md`, `CONTRIBUTING.md`, and clean stale notes

**Files:**
- Modify: `README.md`
- Modify: `CONTRIBUTING.md`
- Modify or delete: `docs/notes/design_suggestions.md`

- [ ] **Step 1: Update `README.md`**

Read the current `README.md`. In the tech-stack / project description section, ensure it mentions:

- Inter font (loaded via `google_fonts`)
- Iconsax for icons
- Single design system at `lib/ui/design_system/` (link to `lib/ui/design_system/README.md`)

Add a short "Design system" section near the top:

```markdown
## Design system

The UI uses a single source of truth at `lib/ui/design_system/` — color, typography,
spacing, radius, shadow, and padding tokens, plus canonical components like `AppButton`,
`AppCard`, `AppScreenHeader`, and `AppStatusChip`. See [the design system README](./lib/ui/design_system/README.md)
for the full reference. Never hardcode values; always import from the design system.
```

- [ ] **Step 2: Update `CONTRIBUTING.md`**

Add a "UI changes" section near the top of the contribution guide:

```markdown
## UI changes

When changing UI in `lib/ui/`:

- Read [the design system README](./lib/ui/design_system/README.md) first.
- Use design tokens (colors, typography, radius, shadow, spacing, padding) — never
  hardcode hex, font sizes, or geometric literals.
- Use canonical components (`AppButton`, `AppCard`, `AppScreenHeader`,
  `AppSectionHeader`, `AppTextField`, `AppStatusChip`) — never raw
  `ElevatedButton` / `Container(decoration: ...)` / inline status pills.
- Use Iconsax for icons. No `Icons.*` references.
- New tokens or components belong in `lib/ui/design_system/`, not in feature folders.
```

- [ ] **Step 3: Clean up `docs/notes/design_suggestions.md`**

Read the file. If it's stale (likely — it predates this work), replace its body with:

```markdown
# Design notes

The design system has been consolidated under `lib/ui/design_system/`.
See [the design system README](../../lib/ui/design_system/README.md) for the
canonical reference. This file is kept as a placeholder for future
larger design proposals.
```

- [ ] **Step 4: Commit**

```bash
git add README.md CONTRIBUTING.md docs/notes/design_suggestions.md
git commit -m "docs: point README and CONTRIBUTING at the new design system"
```

---

## Self-review checklist

Before declaring done, walk through this list once:

- [ ] Spec coverage: every section of the spec maps to a task in this plan (Phase 1 = tokens, Phase 2 = components, Phase 3 = sweep, Phase 4 = cleanup, Phase 5 = docs).
- [ ] No placeholders remain (no "TBD", "implement later", or "see Task N for code").
- [ ] Type / API consistency: `AppCardElevation` enum used consistently in Tasks 8 → 16+. `AppStatusChip.fromStatus` signature matches in Tasks 14 → 17, 20.
- [ ] Migration safety: backward-compat color aliases added in Task 2, removed only after all sweeps in Task 26.
- [ ] All success criteria from the spec map to grep / build commands in Task 27.
- [ ] Every documentation file mentioned in the spec (CLAUDE.md, README.md, design_system/README.md, CONTRIBUTING.md, design_suggestions.md) has its own task (28, 29, 30).
