# BUGAMED UI Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Consolidate the design system into unified components, redesign service discovery as category-first browsing, clean up screen flows by eliminating bottom sheets, add micro-interactions, and integrate the deer mascot at 50% opacity.

**Architecture:** Progressive refactor — build the design system foundation first (tokens + components), then swap old widgets for new ones screen by screen. No screen rewrites; existing structure stays, components get replaced.

**Tech Stack:** Flutter, MobX, Iconsax, SFPro font, Supabase

---

## File Map

### New Files
| File | Purpose |
|------|---------|
| `lib/ui/design_system/app_shadows.dart` | Shadow token definitions (none, sm, md) |
| `lib/ui/design_system/widgets/app_card.dart` | Unified card with optional tap interaction (scale + haptic) |
| `lib/ui/design_system/widgets/app_empty_state.dart` | Empty/error/loading state with 50% opacity deer mascot |
| `lib/ui/design_system/widgets/app_badge.dart` | Status badge pill (moved from shared) |
| `lib/ui/patient/widgets/service_category_row.dart` | Horizontal scrollable category cards for home screen |
| `lib/ui/patient/widgets/category_filter_bar.dart` | Horizontal pill/chip filter bar for All Services screen |
| `lib/ui/patient/screens/edit_profile_screen.dart` | Full-screen edit profile (replaces bottom sheet) |

### Modified Files
| File | Changes |
|------|---------|
| `lib/ui/design_system/app_theme.dart` | Add `heading` and `caption` to AppTypography |
| `lib/ui/design_system/widgets/app_button.dart` | Rewrite with variant enum (primary/secondary/ghost/danger) |
| `lib/ui/patient/home_screen.dart` | Replace TestTypesSection with ServiceCategoryRow, reorder sections |
| `lib/ui/patient/all_lab_services_screen.dart` | Add CategoryFilterBar, swap MascotStateWidget → AppEmptyState |
| `lib/ui/patient/direct_services_screen.dart` | Add CategoryFilterBar, swap MascotStateWidget → AppEmptyState |
| `lib/ui/patient/profile_screen.dart` | Inline language toggle, grouped sections, remove bottom sheets, push EditProfileScreen |
| `lib/ui/patient/main_page.dart` | Add FadeTransition for tab switches |
| `lib/ui/patient/requests_screen.dart` | Swap MascotStateWidget → AppEmptyState, AppCard usage |
| `lib/ui/patient/widgets/service_category_grid.dart` | Use AppCard instead of TappableCard+Container, 48px icon |
| `lib/ui/shared/notifications_screen.dart` | Swap MascotStateWidget → AppEmptyState |
| `lib/ui/shared/widgets/language_switcher.dart` | Add LanguageSegmentedPill widget |

### Files to Delete (after migration complete)
| File | Replaced By |
|------|-------------|
| `lib/ui/shared/widgets/custom_button.dart` | `AppButton` |
| `lib/ui/shared/widgets/custom_text_field.dart` | `AppTextField` |
| `lib/ui/shared/widgets/tappable_card.dart` | `AppCard` |

---

## Task 1: Add Shadow Tokens

**Files:**
- Create: `lib/ui/design_system/app_shadows.dart`

- [ ] **Step 1: Create the shadow tokens file**

```dart
// lib/ui/design_system/app_shadows.dart
import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  static final List<BoxShadow> sm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 1),
    ),
  ];

  static final List<BoxShadow> md = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 2),
    ),
  ];
}
```

- [ ] **Step 2: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/design_system/app_shadows.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/app_shadows.dart
git commit -m "feat: add AppShadows token system (none, sm, md)"
```

---

## Task 2: Add Typography Tokens

**Files:**
- Modify: `lib/ui/design_system/app_theme.dart:66-101`

- [ ] **Step 1: Add heading and caption to AppTypography**

Add these two entries to the `AppTypography` class in `lib/ui/design_system/app_theme.dart`, after the existing `labelSmall` definition (line 100):

```dart
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
```

- [ ] **Step 2: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/design_system/app_theme.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/app_theme.dart
git commit -m "feat: add heading and caption typography tokens"
```

---

## Task 3: Rewrite AppButton with Variants

**Files:**
- Modify: `lib/ui/design_system/widgets/app_button.dart`

- [ ] **Step 1: Replace the entire file content**

Replace all of `lib/ui/design_system/widgets/app_button.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

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

    return SizedBox(
      height: 52,
      width: fullWidth ? double.infinity : null,
      child: switch (variant) {
        AppButtonVariant.primary => ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: _buildChild(Colors.white),
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: _buildChild(AppColors.primary),
          ),
        AppButtonVariant.ghost => TextButton(
            onPressed: isDisabled ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: _buildChild(AppColors.primary),
          ),
        AppButtonVariant.danger => ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
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

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      );
    }

    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
```

- [ ] **Step 2: Verify no existing code uses PrimaryButton or SecondaryButton**

Run: `cd /Users/shijirbum_b/Oncall-Lab && grep -rn 'PrimaryButton\|SecondaryButton' lib/ --include='*.dart' | grep -v 'app_button.dart'`
Expected: No matches (these classes are defined but never imported elsewhere)

- [ ] **Step 3: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/design_system/widgets/app_button.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/ui/design_system/widgets/app_button.dart
git commit -m "feat: rewrite AppButton with variant enum (primary/secondary/ghost/danger)"
```

---

## Task 4: Build Unified AppCard

**Files:**
- Create: `lib/ui/design_system/widgets/app_card.dart`
- Modify: imports in files that use `lib/ui/shared/widgets/app_card.dart` (6 files)
- Modify: imports in files that use `lib/ui/shared/widgets/tappable_card.dart` (1 file)

- [ ] **Step 1: Create the new AppCard in design_system**

Create `lib/ui/design_system/widgets/app_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor = Colors.white,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.shadow,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? borderRadius;
  final List<BoxShadow>? shadow;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool get _isTappable => widget.onTap != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppRadius.md;
    final resolvedShadow = widget.shadow ?? AppShadows.sm;

    Widget content = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
            : null,
        boxShadow: resolvedShadow,
      ),
      child: widget.child,
    );

    if (_isTappable) {
      content = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) =>
              Transform.scale(scale: _scaleAnimation.value, child: child),
          child: content,
        ),
      );
    }

    if (widget.margin != null) {
      content = Padding(padding: widget.margin!, child: content);
    }

    return content;
  }
}
```

- [ ] **Step 2: Update imports in files using the old AppCard**

These 6 files import `package:bugamed/ui/shared/widgets/app_card.dart`:
- `lib/ui/patient/booking/widgets/saved_address_selector.dart`
- `lib/ui/patient/booking/direct_service_booking_screen.dart`
- `lib/ui/patient/booking/lab_service_booking_screen.dart`
- `lib/ui/patient/requests_screen.dart`

In each file, change:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/app_card.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
```

The new AppCard has the same constructor API (`child`, `onTap`, `padding`, `margin`, `backgroundColor`, `borderColor`, `borderWidth`, `borderRadius`) so no call-site changes needed. The only difference: `borderRadius` is now `double?` instead of `double` (defaults to `AppRadius.md`/16 which matches the old default), and `showShadow` is replaced by `shadow` (defaults to `AppShadows.sm` which is visually similar).

Check if any call site uses `showShadow`:

Run: `cd /Users/shijirbum_b/Oncall-Lab && grep -rn 'showShadow' lib/ --include='*.dart'`

If any matches are found, update them: `showShadow: false` → `shadow: AppShadows.none`, `showShadow: true` → remove it (default).

- [ ] **Step 3: Update ServiceCategoryGrid to use AppCard instead of TappableCard**

In `lib/ui/patient/widgets/service_category_grid.dart`:

Change the import:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
```

In `_ServiceSquareTile.build()`, replace the `TappableCard` + `Container` combo:
```dart
// OLD (lines 120-165)
    return TappableCard(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          ...
        ),
      ),
    );

// NEW
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      shadow: AppShadows.none,
      borderColor: AppColors.grey.withValues(alpha: 0.12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              _getServiceIcon(service['category_icon'] as String?),
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
```

Note: icon container increased from 44px to 48px as per spec.

- [ ] **Step 4: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/design_system/widgets/app_card.dart lib/ui/patient/widgets/service_category_grid.dart`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/ui/design_system/widgets/app_card.dart lib/ui/design_system/app_shadows.dart lib/ui/patient/widgets/service_category_grid.dart lib/ui/patient/booking/widgets/saved_address_selector.dart lib/ui/patient/booking/direct_service_booking_screen.dart lib/ui/patient/booking/lab_service_booking_screen.dart lib/ui/patient/requests_screen.dart
git commit -m "feat: add unified AppCard with scale-down + haptic, migrate all usages"
```

---

## Task 5: Build AppEmptyState

**Files:**
- Create: `lib/ui/design_system/widgets/app_empty_state.dart`

- [ ] **Step 1: Create the AppEmptyState widget**

```dart
// lib/ui/design_system/widgets/app_empty_state.dart
import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';

enum AppEmptyEmotion {
  loading,
  searching,
  happy,
  empty,
  sleeping,
  error,
  onTheWay,
  welcome,
  collected,
  verified,
  noWifi,
  canceled,
  greenSample,
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.emotion,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  final AppEmptyEmotion emotion;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  String _getAssetPath() {
    const basePath = 'assets/images/mascot/';
    return switch (emotion) {
      AppEmptyEmotion.loading => '${basePath}deer_loading.jpeg',
      AppEmptyEmotion.searching => '${basePath}deer_searching.jpeg',
      AppEmptyEmotion.happy => '${basePath}deer_happy.jpeg',
      AppEmptyEmotion.empty => '${basePath}deer_empty_appts.jpeg',
      AppEmptyEmotion.sleeping => '${basePath}deer_sleeping.jpeg',
      AppEmptyEmotion.error => '${basePath}deer_error.jpeg',
      AppEmptyEmotion.onTheWay => '${basePath}deer_on_the_way.jpeg',
      AppEmptyEmotion.welcome => '${basePath}deer_welcome.jpeg',
      AppEmptyEmotion.collected => '${basePath}deer_collected.jpeg',
      AppEmptyEmotion.verified => '${basePath}deer_verified_doctor.jpeg',
      AppEmptyEmotion.noWifi => '${basePath}deer_no_wifi.jpeg',
      AppEmptyEmotion.canceled => '${basePath}deer_canceled.jpeg',
      AppEmptyEmotion.greenSample => '${basePath}deer_green_sample.jpeg',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              _getAssetPath(),
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleMedium,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
          ],
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 24),
            AppButton(
              label: actionText!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/design_system/widgets/app_empty_state.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/ui/design_system/widgets/app_empty_state.dart
git commit -m "feat: add AppEmptyState with 50% opacity deer mascot"
```

---

## Task 6: Move StatusBadge → AppBadge

**Files:**
- Create: `lib/ui/design_system/widgets/app_badge.dart`
- Modify: `lib/ui/shared/widgets/status_badge.dart` (keep as re-export for backwards compat)

- [ ] **Step 1: Create AppBadge in design system**

```dart
// lib/ui/design_system/widgets/app_badge.dart
import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getStatusColor(status);
    final text = AppColors.getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Update the old StatusBadge to re-export AppBadge**

Replace `lib/ui/shared/widgets/status_badge.dart` with:

```dart
// Re-export for backwards compatibility. New code should import from design_system.
export 'package:bugamed/ui/design_system/widgets/app_badge.dart';
```

This way existing imports of `StatusBadge` won't break — callers just need to update the class name to `AppBadge` when they're touched. The existing widget name `StatusBadge` is no longer defined; callers will get a compile error pointing them to update. Since `StatusBadge` is not imported in any mobile app dart file (only used in `admin_panel_web/`), this is safe.

Actually, checking again: `StatusBadge` is not imported in any `lib/` file — it's only used in `admin_panel_web/`. So we can safely create AppBadge without touching the old file at all for now.

- [ ] **Step 3: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/design_system/widgets/app_badge.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/ui/design_system/widgets/app_badge.dart
git commit -m "feat: add AppBadge to design system"
```

---

## Task 7: Migrate Screens to AppEmptyState (Phase 5 — Mascot Integration)

**Files:**
- Modify: `lib/ui/patient/home_screen.dart`
- Modify: `lib/ui/patient/all_lab_services_screen.dart`
- Modify: `lib/ui/patient/direct_services_screen.dart`
- Modify: `lib/ui/patient/requests_screen.dart`
- Modify: `lib/ui/shared/notifications_screen.dart`

- [ ] **Step 1: Update home_screen.dart**

In `lib/ui/patient/home_screen.dart`:

Change import:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
```

Replace loading state (around line 90):
```dart
// OLD
            child: MascotStateWidget(
              emotion: MascotEmotion.loading,
              title: 'Мэдээлэл уншиж байна...',
            ),

// NEW
            child: AppEmptyState(
              emotion: AppEmptyEmotion.loading,
              title: 'Мэдээлэл уншиж байна...',
            ),
```

Replace error state (around line 100):
```dart
// OLD
              child: MascotStateWidget(
                emotion: MascotEmotion.error,
                title: l10n.errorLoadingData,
                subtitle: _homeStore.errorMessage ?? '',
                actionText: l10n.retry,
                onAction: _homeStore.loadHomeData,
              ),

// NEW
              child: AppEmptyState(
                emotion: AppEmptyEmotion.error,
                title: l10n.errorLoadingData,
                subtitle: _homeStore.errorMessage ?? '',
                actionText: l10n.retry,
                onAction: _homeStore.loadHomeData,
              ),
```

- [ ] **Step 2: Update all_lab_services_screen.dart**

In `lib/ui/patient/all_lab_services_screen.dart`:

Change import:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
```

Replace error state (around line 154):
```dart
// OLD
                  child: MascotStateWidget(
                    emotion: MascotEmotion.error,
                    title: l10n.errorLoadingServices,
                    subtitle: errorMessage ?? '',
                    actionText: l10n.retry,
                    onAction: _loadServices,
                  ),
// NEW
                  child: AppEmptyState(
                    emotion: AppEmptyEmotion.error,
                    title: l10n.errorLoadingServices,
                    subtitle: errorMessage ?? '',
                    actionText: l10n.retry,
                    onAction: _loadServices,
                  ),
```

Replace empty search state (around line 195):
```dart
// OLD
                          child: MascotStateWidget(
                            emotion: MascotEmotion.searching,
                            title: l10n.noServicesMatchSearch,
                            subtitle: l10n.tryDifferentKeywords,
                          ),
// NEW
                          child: AppEmptyState(
                            emotion: AppEmptyEmotion.searching,
                            title: l10n.noServicesMatchSearch,
                            subtitle: l10n.tryDifferentKeywords,
                          ),
```

- [ ] **Step 3: Update direct_services_screen.dart**

In `lib/ui/patient/direct_services_screen.dart`:

Change import:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
```

Replace all `MascotStateWidget` → `AppEmptyState` and `MascotEmotion` → `AppEmptyEmotion` (3 instances at lines 80, 93, 142).

- [ ] **Step 4: Update requests_screen.dart**

In `lib/ui/patient/requests_screen.dart`:

Change import:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
```

Replace the `MascotStateWidget` at line 233:
```dart
// OLD
          child: MascotStateWidget(
// NEW
          child: AppEmptyState(
```
And `MascotEmotion` → `AppEmptyEmotion`.

- [ ] **Step 5: Update notifications_screen.dart**

In `lib/ui/shared/notifications_screen.dart`:

Change import:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
```

Replace the `MascotStateWidget` at line 82:
```dart
// OLD
              child: MascotStateWidget(
// NEW
              child: AppEmptyState(
```
And `MascotEmotion` → `AppEmptyEmotion`.

- [ ] **Step 6: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/patient/home_screen.dart lib/ui/patient/all_lab_services_screen.dart lib/ui/patient/direct_services_screen.dart lib/ui/patient/requests_screen.dart lib/ui/shared/notifications_screen.dart`
Expected: No issues found

- [ ] **Step 7: Commit**

```bash
git add lib/ui/patient/home_screen.dart lib/ui/patient/all_lab_services_screen.dart lib/ui/patient/direct_services_screen.dart lib/ui/patient/requests_screen.dart lib/ui/shared/notifications_screen.dart
git commit -m "feat: migrate all screens from MascotStateWidget to AppEmptyState (50% opacity deer)"
```

---

## Task 8: Add LanguageSegmentedPill

**Files:**
- Modify: `lib/ui/shared/widgets/language_switcher.dart`

- [ ] **Step 1: Add LanguageSegmentedPill widget to language_switcher.dart**

Add this new widget at the bottom of `lib/ui/shared/widgets/language_switcher.dart`:

```dart
/// Compact inline segmented pill for language selection.
/// Designed to be embedded in profile headers or settings sections.
class LanguageSegmentedPill extends StatelessWidget {
  const LanguageSegmentedPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPill('MN', '🇲🇳', localeStore.isMongolian, () {
              localeStore.changeLocale(const Locale('mn'));
            }),
            _buildPill('EN', '🇬🇧', localeStore.isEnglish, () {
              localeStore.changeLocale(const Locale('en'));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(
    String code,
    String flag,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              code,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

You'll need to add the `AppRadius` import at the top of the file:
```dart
import 'package:bugamed/ui/design_system/app_theme.dart';
```

- [ ] **Step 2: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/shared/widgets/language_switcher.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/ui/shared/widgets/language_switcher.dart
git commit -m "feat: add LanguageSegmentedPill inline widget for profile header"
```

---

## Task 9: Redesign Profile Screen (Inline Controls + Grouped Sections)

**Files:**
- Create: `lib/ui/patient/screens/edit_profile_screen.dart`
- Modify: `lib/ui/patient/profile_screen.dart`

- [ ] **Step 1: Create EditProfileScreen as full-screen page**

Create `lib/ui/patient/screens/edit_profile_screen.dart`. This is the `EditProfileSheet` content extracted into a full `Scaffold`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/utils/notification_helper.dart';
import 'package:bugamed/data/models/profile_model.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final ProfileModel profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _registrationController;
  late final TextEditingController _allergiesController;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _firstNameController = TextEditingController(text: profile.firstName ?? '');
    _lastNameController = TextEditingController(text: profile.lastName ?? '');
    _emailController = TextEditingController(text: profile.email ?? '');
    _addressController = TextEditingController(text: profile.permanentAddress ?? '');
    _registrationController = TextEditingController(text: profile.registrationNumber ?? '');
    _allergiesController = TextEditingController(text: profile.allergies ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _registrationController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context)!;

    final success = await authStore.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      permanentAddress: _addressController.text.trim(),
      registrationNumber: _registrationController.text.trim(),
      allergies: _allergiesController.text.trim(),
    );

    if (success && context.mounted) {
      navigator.pop();
      NotificationHelper.showSuccess(context, l10n.profileUpdatedSuccessfully);
    } else if (authStore.errorMessage != null && context.mounted) {
      NotificationHelper.showError(context, authStore.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(l10n.editProfile),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppPadding.screenAll,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: l10n.firstName),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? l10n.required : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: l10n.lastName),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? l10n.required : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.email),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: l10n.address),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _registrationController,
                decoration: InputDecoration(labelText: l10n.registrationNumber),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _allergiesController,
                decoration: InputDecoration(labelText: l10n.allergies),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.lg),
              Observer(
                builder: (_) => AppButton(
                  label: l10n.saveChanges,
                  loading: authStore.isUpdatingProfile,
                  onPressed: authStore.isUpdatingProfile ? null : _handleSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Rewrite the profile screen**

Replace the `PatientProfileScreen` class and `_buildProfileOption` method in `lib/ui/patient/profile_screen.dart`. Keep the `EditProfileSheet` and `SavedAddressSheet` classes at the bottom for now (they can be removed later).

Replace the imports section at the top of the file:
```dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/services/storage_service.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/profile_model.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';
import 'package:bugamed/ui/shared/widgets/language_switcher.dart';
import 'package:bugamed/ui/patient/screens/edit_profile_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/core/utils/notification_helper.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
```

Replace the `PatientProfileScreen` build method body (inside the `Observer` builder, the Column children) with:

```dart
Column(
  children: [
    const SizedBox(height: 20),
    // Avatar with camera button (keep existing GestureDetector)
    GestureDetector(
      onTap: () async {
        // ... keep existing photo upload logic unchanged ...
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ProfileAvatar(
            avatarUrl: profile?.getAvatarUrl(),
            initials: profile?.initials ?? 'U',
            radius: 50,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 16),
    Text(
      profile?.displayName ?? l10n.user,
      style: AppTypography.heading.copyWith(fontSize: 24),
    ),
    const SizedBox(height: 4),
    Text(
      profile?.phoneNumber ?? profile?.email ?? l10n.noPhoneNumber,
      style: AppTypography.bodyMedium,
    ),
    const SizedBox(height: 8),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        l10n.patient,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const SizedBox(height: 16),
    // Inline language toggle
    const LanguageSegmentedPill(),
    const SizedBox(height: 32),

    // ── Account section ──
    _buildSectionHeader(l10n.account),
    const SizedBox(height: 8),
    _buildProfileOption(
      icon: Iconsax.user_edit,
      title: l10n.editProfile,
      onTap: () {
        final userProfile = authStore.currentProfile;
        if (userProfile != null) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => EditProfileScreen(profile: userProfile),
            ),
          );
        }
      },
    ),
    const SizedBox(height: 24),

    // ── History section ──
    _buildSectionHeader(l10n.requestHistory),
    const SizedBox(height: 8),
    _buildProfileOption(
      icon: Iconsax.clock,
      title: l10n.requestHistory,
      onTap: () {
        NotificationHelper.show(context, l10n.viewAll);
      },
    ),
    const SizedBox(height: 24),

    // ── Preferences section ──
    _buildSectionHeader(l10n.notifications),
    const SizedBox(height: 8),
    _buildProfileOption(
      icon: Iconsax.notification,
      title: l10n.notifications,
      onTap: () {
        NotificationHelper.show(
          context,
          '${l10n.notifications} ${l10n.adminComingSoon}',
        );
      },
    ),
    const SizedBox(height: 32),

    // Sign out button
    Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog<bool>(
            context: context,
            builder: (ctx) {
              final dialogL10n = AppLocalizations.of(ctx)!;
              return AlertDialog(
                title: Text(dialogL10n.signOut),
                content: Text('${dialogL10n.yes}? ${dialogL10n.signOut}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(dialogL10n.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    child: Text(dialogL10n.signOut),
                  ),
                ],
              );
            },
          ).then((shouldSignOut) async {
            if (shouldSignOut == true && context.mounted) {
              await authStore.signOut();
              if (context.mounted) {
                NotificationHelper.showSuccess(context, l10n.success);
              }
            }
          });
        },
        icon: const Icon(Icons.logout),
        label: Text(l10n.signOut),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
    ),
    const Text(
      'OnCall Lab v1.0.0',
      style: TextStyle(color: AppColors.grey, fontSize: 12),
    ),
  ],
);
```

Replace the `_buildProfileOption` method:
```dart
Widget _buildSectionHeader(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title.toUpperCase(),
      style: AppTypography.labelSmall.copyWith(
        letterSpacing: 1.2,
        color: AppColors.textSecondary,
      ),
    ),
  );
}

Widget _buildProfileOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return AppCard(
    onTap: onTap,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
      ],
    ),
  );
}
```

- [ ] **Step 3: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/patient/profile_screen.dart lib/ui/patient/screens/edit_profile_screen.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/ui/patient/profile_screen.dart lib/ui/patient/screens/edit_profile_screen.dart
git commit -m "feat: redesign profile with inline language pill, grouped sections, full-screen edit"
```

---

## Task 10: Add ServiceCategoryRow for Home Screen

**Files:**
- Create: `lib/ui/patient/widgets/service_category_row.dart`

- [ ] **Step 1: Create the horizontal category row widget**

```dart
// lib/ui/patient/widgets/service_category_row.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';

class ServiceCategoryRow extends StatelessWidget {
  const ServiceCategoryRow({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  final List<Map<String, dynamic>> categories;
  final void Function(Map<String, dynamic> category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: AppPadding.screenH,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = AppColors.getServiceCategoryColor(index);
          final name = category['name'] as String? ?? '';
          final icon = _getCategoryIcon(category['icon'] as String?);

          return AppCard(
            onTap: () => onCategoryTap(category),
            padding: EdgeInsets.zero,
            shadow: AppShadows.none,
            borderColor: AppColors.grey.withValues(alpha: 0.12),
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      name,
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static IconData _getCategoryIcon(String? iconName) {
    return switch (iconName) {
      'heart' => Iconsax.heart,
      'activity' => Iconsax.activity,
      'health' => Iconsax.health,
      'hospital' => Iconsax.hospital,
      'blood' => Iconsax.drop,
      'microscope' => Iconsax.microscope,
      'shield' => Iconsax.shield_tick,
      'flask' => Iconsax.filter,
      _ => Iconsax.health,
    };
  }
}
```

- [ ] **Step 2: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/patient/widgets/service_category_row.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/widgets/service_category_row.dart
git commit -m "feat: add ServiceCategoryRow horizontal category browser for home screen"
```

---

## Task 11: Redesign Home Screen Layout

**Files:**
- Modify: `lib/ui/patient/home_screen.dart`
- Modify: `lib/stores/home_store.dart` (if categories not already loaded)

- [ ] **Step 1: Check if HomeStore loads categories**

Run: `cd /Users/shijirbum_b/Oncall-Lab && grep -n 'categor\|service_categories' lib/stores/home_store.dart`

If categories are not loaded, add a `loadCategories()` method to `HomeStore` that fetches from `service_categories` table. If they are already loaded, note the property name.

- [ ] **Step 2: Update home_screen.dart layout**

In `lib/ui/patient/home_screen.dart`:

Add import:
```dart
import 'package:bugamed/ui/patient/widgets/service_category_row.dart';
```

Remove import:
```dart
// Remove this line:
import 'package:bugamed/ui/patient/widgets/test_types_section.dart';
```

In the `SingleChildScrollView` Column children (around lines 132-205), replace the layout:

```dart
// OLD order:
// VisitOptionsSection
// SizedBox(height: xl)
// AdBanner
// SizedBox(height: lg)
// TestTypesSection
// SizedBox(height: xxl)
// "Available Doctors" header
// AvailableDoctorsSection

// NEW order:
VisitOptionsSection(
  onClinicTap: () {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => const AllLabServicesScreen(),
      ),
    );
  },
  onHomeTap: () {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => const DirectServicesScreen(),
      ),
    );
  },
),
const SizedBox(height: AppSpacing.lg),

// Service Categories
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l10n.services, style: AppTypography.sectionHeader),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => const AllLabServicesScreen(),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          l10n.viewAll,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    ],
  ),
),
const SizedBox(height: AppSpacing.sm),
ServiceCategoryRow(
  categories: _homeStore.serviceCategories.toList(),
  onCategoryTap: (category) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => const AllLabServicesScreen(),
        // TODO: pass category filter when AllLabServicesScreen supports it
      ),
    );
  },
),
const SizedBox(height: AppSpacing.lg),

const AdBanner(),
const SizedBox(height: AppSpacing.lg),

// Available Doctors
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l10n.availableDoctors, style: AppTypography.sectionHeader),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => const DirectServicesScreen(),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          l10n.viewAll,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    ],
  ),
),
const SizedBox(height: AppSpacing.md),
AvailableDoctorsSection(doctors: doctors),
const SizedBox(height: 110),
```

Also add `import 'package:flutter/cupertino.dart';` at the top if not already present, for `CupertinoPageRoute`.

- [ ] **Step 3: Update header to use AppTypography.heading**

In `_buildHeader`, replace the hardcoded TextStyle:
```dart
// OLD
style: const TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: AppColors.black,
),
// NEW
style: AppTypography.heading,
```

- [ ] **Step 4: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/patient/home_screen.dart`
Expected: No issues found (or minor warnings about unused imports to clean up)

- [ ] **Step 5: Commit**

```bash
git add lib/ui/patient/home_screen.dart
git commit -m "feat: redesign home screen with category row, remove auto-scroll carousel"
```

---

## Task 12: Add CategoryFilterBar for All Services Screen

**Files:**
- Create: `lib/ui/patient/widgets/category_filter_bar.dart`

- [ ] **Step 1: Create the category filter bar widget**

```dart
// lib/ui/patient/widgets/category_filter_bar.dart
import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.allLabel = 'All',
  });

  final List<String> categories;
  final String? selectedCategory;
  final void Function(String? category) onCategorySelected;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: AppPadding.screenH,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : categories[index - 1];
          final label = isAll ? allLabel : category!;
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/patient/widgets/category_filter_bar.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/widgets/category_filter_bar.dart
git commit -m "feat: add CategoryFilterBar horizontal pill selector"
```

---

## Task 13: Integrate CategoryFilterBar into AllLabServicesScreen

**Files:**
- Modify: `lib/ui/patient/all_lab_services_screen.dart`

- [ ] **Step 1: Add state for category filter and extract categories**

Add import:
```dart
import 'package:bugamed/ui/patient/widgets/category_filter_bar.dart';
```

Add state variable in `_AllLabServicesScreenState`:
```dart
String? _selectedCategory;
```

Add a getter to extract unique category names:
```dart
List<String> get _categories {
  final cats = <String>{};
  for (final s in allServices) {
    final name = s['category_name'] as String? ?? '';
    if (name.isNotEmpty) cats.add(name);
  }
  return cats.toList();
}
```

Update `_filterServices` to also filter by category:
```dart
void _filterServices(String query) {
  setState(() {
    _searchQuery = query;
    _applyFilters();
  });
}

void _selectCategory(String? category) {
  setState(() {
    _selectedCategory = category;
    _applyFilters();
  });
}

String _searchQuery = '';

void _applyFilters() {
  var result = allServices;

  if (_selectedCategory != null) {
    result = result.where((s) => s['category_name'] == _selectedCategory).toList();
  }

  if (_searchQuery.isNotEmpty) {
    final lower = _searchQuery.toLowerCase();
    result = result.where((s) {
      final name = (s['service_name'] as String?)?.toLowerCase() ?? '';
      final nameMn = (s['service_name_mn'] as String?)?.toLowerCase() ?? '';
      final desc = (s['description'] as String?)?.toLowerCase() ?? '';
      return name.contains(lower) || nameMn.contains(lower) || desc.contains(lower);
    }).toList();
  }

  filteredServices = result;
}
```

- [ ] **Step 2: Add CategoryFilterBar to the UI**

In the `CustomScrollView` slivers, add the filter bar between the search field and the count text:

```dart
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 4),
    child: CategoryFilterBar(
      categories: _categories,
      selectedCategory: _selectedCategory,
      onCategorySelected: _selectCategory,
      allLabel: l10n.all,
    ),
  ),
),
```

- [ ] **Step 3: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/patient/all_lab_services_screen.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/ui/patient/all_lab_services_screen.dart
git commit -m "feat: add category filter bar to All Lab Services screen"
```

---

## Task 14: Add Tab Fade Transition to MainPage

**Files:**
- Modify: `lib/ui/patient/main_page.dart`

- [ ] **Step 1: Replace IndexedStack with AnimatedSwitcher**

In `lib/ui/patient/main_page.dart`, replace the `IndexedStack` (around line 87):

```dart
// OLD
child: Padding(
  padding: EdgeInsets.only(bottom: 70 + bottomPadding),
  child: IndexedStack(
    index: selectedIndex,
    children: pages,
  ),
),

// NEW
child: Padding(
  padding: EdgeInsets.only(bottom: 70 + bottomPadding),
  child: AnimatedSwitcher(
    duration: const Duration(milliseconds: 200),
    child: KeyedSubtree(
      key: ValueKey<int>(selectedIndex),
      child: pages[selectedIndex],
    ),
  ),
),
```

Note: This changes from `IndexedStack` (which keeps all tabs alive) to `AnimatedSwitcher` (which rebuilds on switch). If keeping tabs alive is important, use a different approach — keep `IndexedStack` but wrap it in `AnimatedOpacity`:

```dart
// ALTERNATIVE (keeps state alive):
child: Padding(
  padding: EdgeInsets.only(bottom: 70 + bottomPadding),
  child: IndexedStack(
    index: selectedIndex,
    children: pages,
  ),
),
```

The `IndexedStack` approach is actually better for this app since it preserves scroll position and loaded data across tab switches. Keep `IndexedStack` — the floating nav bar animation already provides visual feedback for tab switches.

Actually, let's keep IndexedStack and skip this change. The existing tab switch behavior with the animated nav bar indicator is sufficient.

- [ ] **Step 2: Replace MaterialPageRoute with CupertinoPageRoute**

This is a global find-and-replace across all navigation in `lib/`. In each file that uses `MaterialPageRoute`:

Add import: `import 'package:flutter/cupertino.dart';`
Replace: `MaterialPageRoute` → `CupertinoPageRoute`

Files to update (only those not already using CupertinoPageRoute):
- `lib/ui/patient/home_screen.dart` (4 instances — may already be done in Task 11)
- `lib/ui/patient/laboratories_screen.dart` (1 instance)
- `lib/ui/patient/laboratory_detail_screen_new.dart` (2 instances)
- `lib/ui/shared/notifications_screen.dart` (1 instance)
- `lib/ui/shared/notification_detail_screen.dart` (1 instance)
- `lib/ui/shared/widgets/notification_bell.dart` (1 instance)
- `lib/ui/doctor/doctor_dashboard_screen.dart` (1 instance)
- `lib/ui/payment/payment_screen.dart` (1 instance)
- `lib/ui/payment/payment_method_screen.dart` (1 instance)
- `lib/ui/payment/payment_success_screen.dart` (1 instance)
- `lib/ui/patient/booking/direct_service_booking_screen.dart` (2 instances)
- `lib/ui/patient/booking/lab_service_booking_screen.dart` (2 instances)
- `lib/ui/auth/login_screen.dart` (2 instances)
- `lib/core/utils/navigation_helper.dart` (2 instances)
- `lib/core/utils/auth_context.dart` (1 instance)
- `lib/ui/doctor/widgets/location_viewer_widget.dart` (1 instance)
- `lib/ui/patient/widgets/available_doctors_section.dart` (1 instance)

In each file: `import 'package:flutter/cupertino.dart';` and change `MaterialPageRoute` → `CupertinoPageRoute`. The constructor is identical — just swap the class name.

- [ ] **Step 3: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/`
Expected: No issues found (or only pre-existing warnings)

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: switch all navigation to CupertinoPageRoute for smoother transitions"
```

---

## Task 15: Standardize Padding and ScrollPhysics

**Files:**
- Modify: Multiple files across `lib/ui/`

- [ ] **Step 1: Replace hardcoded padding values**

Search for `EdgeInsets.all(15)` and `EdgeInsets.symmetric(horizontal: 15)` in `lib/`:

Run: `cd /Users/shijirbum_b/Oncall-Lab && grep -rn 'EdgeInsets.all(15)\|EdgeInsets.symmetric(horizontal: 15)' lib/ --include='*.dart'`

For each match, replace with `AppPadding.screenAll` or `AppPadding.screenH` respectively. Add `import 'package:bugamed/ui/design_system/app_theme.dart';` if not already imported.

Also replace `const EdgeInsets.symmetric(horizontal: 15)` in section headers (e.g., home_screen.dart) with `AppPadding.screenH`.

- [ ] **Step 2: Add BouncingScrollPhysics to all scrollable screens**

Search for screens that use `SingleChildScrollView` or `ListView` without `BouncingScrollPhysics`:

Run: `cd /Users/shijirbum_b/Oncall-Lab && grep -rn 'SingleChildScrollView\|ListView.builder' lib/ui/ --include='*.dart' -l`

For each scrollable screen, ensure physics is set:
```dart
physics: const BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
),
```

Skip screens that already have this (home_screen.dart, all_lab_services_screen.dart).

- [ ] **Step 3: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "fix: standardize padding to AppPadding tokens and BouncingScrollPhysics everywhere"
```

---

## Task 16: Delete Deprecated Widget Files

**Files:**
- Delete: `lib/ui/shared/widgets/custom_button.dart`
- Delete: `lib/ui/shared/widgets/custom_text_field.dart`

- [ ] **Step 1: Verify no imports remain**

Run: `cd /Users/shijirbum_b/Oncall-Lab && grep -rn 'custom_button\|custom_text_field' lib/ --include='*.dart'`

For `custom_text_field.dart`: it's imported in `lib/ui/patient/location/location_picker_screen.dart`. Update that file:
```dart
// OLD
import 'package:bugamed/ui/shared/widgets/custom_text_field.dart';
// NEW
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
```

Then find where `CustomTextField` is used in that file and replace with `AppTextField`:
```dart
// CustomTextField has a required `label` positional parameter
// AppTextField uses `label` as optional named parameter
// Update the call site accordingly
```

For `custom_button.dart`: verify it's not imported anywhere (previous check showed 0 imports outside its own file).

- [ ] **Step 2: Delete the files**

```bash
rm lib/ui/shared/widgets/custom_button.dart lib/ui/shared/widgets/custom_text_field.dart
```

- [ ] **Step 3: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "chore: delete deprecated CustomButton and CustomTextField widgets"
```

---

## Task 17: Add RefreshIndicator to Remaining List Screens

**Files:**
- Modify: `lib/ui/patient/requests_screen.dart`
- Modify: `lib/ui/shared/notifications_screen.dart`

- [ ] **Step 1: Check which screens already have RefreshIndicator**

Run: `cd /Users/shijirbum_b/Oncall-Lab && grep -rn 'RefreshIndicator' lib/ui/ --include='*.dart'`

- [ ] **Step 2: Add RefreshIndicator to requests_screen.dart**

Wrap the main scrollable content in `RefreshIndicator`:
```dart
RefreshIndicator(
  color: AppColors.primary,
  onRefresh: () async {
    // call the store's reload method
  },
  child: // existing scrollable content
),
```

- [ ] **Step 3: Add RefreshIndicator to notifications_screen.dart**

Same pattern.

- [ ] **Step 4: Verify it compiles**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze lib/ui/patient/requests_screen.dart lib/ui/shared/notifications_screen.dart`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/ui/patient/requests_screen.dart lib/ui/shared/notifications_screen.dart
git commit -m "feat: add pull-to-refresh on requests and notifications screens"
```
