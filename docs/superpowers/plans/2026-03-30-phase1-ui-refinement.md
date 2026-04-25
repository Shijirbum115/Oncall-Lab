# Phase 1: UI Refinement - "Feels Complete" Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform Bugamed from "functional prototype" to "polished production app" by upgrading service discovery screens to 3-column grouped grids, adding micro-interactions (tap scale, haptics, transitions), standardizing visual consistency (padding, radius, icons), and adding skeleton loaders to all screens.

**Architecture:** Keep existing MobX stores, Supabase backend, and navigation structure. Changes are purely UI-layer: rewrite two service screens to grouped grid layout, add a reusable `TappableCard` wrapper with scale animation, switch all `MaterialPageRoute` to `CupertinoPageRoute`, normalize spacing/radius constants, and add shimmer skeleton loaders.

**Tech Stack:** Flutter 3.10+, MobX, Iconsax icons, Supabase (unchanged backend)

---

## File Structure

### New Files
| File | Responsibility |
|------|---------------|
| `lib/ui/shared/widgets/tappable_card.dart` | Reusable wrapper adding scale-down animation + haptic feedback on tap to any child widget |
| `lib/ui/shared/widgets/skeleton_loader.dart` | Reusable shimmer skeleton components (rectangle, circle, card) |
| `lib/ui/patient/widgets/service_category_grid.dart` | Grouped 3-column grid of square service buttons with icons, used by both AllLabServicesScreen and DirectServicesScreen |

### Modified Files
| File | Changes |
|------|---------|
| `lib/ui/patient/all_lab_services_screen.dart` | Replace flat list with grouped 3-column grid using `ServiceCategoryGrid` |
| `lib/ui/patient/direct_services_screen.dart` | Replace 2-column grid with grouped 3-column grid using `ServiceCategoryGrid` |
| `lib/ui/patient/home_screen.dart` | Add search bar below header, wrap cards in `TappableCard`, use CupertinoPageRoute |
| `lib/ui/patient/main_page.dart` | Add haptic feedback on tab tap |
| `lib/ui/patient/laboratories_screen.dart` | Wrap lab cards in `TappableCard`, use CupertinoPageRoute |
| `lib/ui/patient/requests_screen.dart` | Add skeleton loader for loading state, wrap request cards in `TappableCard` |
| `lib/ui/patient/widgets/visit_options_section.dart` | Wrap cards in `TappableCard` |
| `lib/ui/patient/widgets/test_types_section.dart` | Wrap test cards in `TappableCard` |
| `lib/ui/patient/widgets/available_doctors_section.dart` | Wrap doctor cards in `TappableCard` |
| `lib/ui/patient/widgets/doctor_card_tile.dart` | Wrap in `TappableCard` |
| `lib/ui/patient/widgets/ad_banner.dart` | Wrap banner cards in `TappableCard` |
| `lib/ui/design_system/app_theme.dart` | Add `AppRadius` constants class, `AppPadding` constants class |
| `lib/core/constants/app_colors.dart` | Add `serviceCategoryColors` list for grid icon backgrounds |
| `lib/l10n/app_mn.arb` | Add new strings: `searchHome`, `popularServices`, `allServices` |
| `lib/l10n/app_en.arb` | Add same new strings in English |
| `lib/l10n/app_localizations.dart` | Regenerated (auto) |
| `lib/l10n/app_localizations_mn.dart` | Regenerated (auto) |
| `lib/l10n/app_localizations_en.dart` | Regenerated (auto) |

---

## Task 1: Add Design Tokens — `AppRadius`, `AppPadding`, Service Category Colors

Standardize all magic numbers into named constants so every subsequent task uses consistent values.

**Files:**
- Modify: `lib/ui/design_system/app_theme.dart` (add after `AppSpacing` class, ~line 103)
- Modify: `lib/core/constants/app_colors.dart` (add service category color list)

- [ ] **Step 1: Add `AppRadius` and `AppPadding` to app_theme.dart**

Add these two classes after the existing `AppSpacing` class (after line 111):

```dart
class AppRadius {
  AppRadius._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 100;
}

class AppPadding {
  AppPadding._();
  static const double screen = 20;
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets screenAll = EdgeInsets.all(20);
}
```

- [ ] **Step 2: Add service category colors to app_colors.dart**

Add after the `doctorCardColors` list (after line 47):

```dart
/// Colors for service category grid icons
static const List<Color> serviceCategoryColors = [
  Color(0xFF338868), // primary teal
  Color(0xFF42A5F5), // blue
  Color(0xFF7E57C2), // purple
  Color(0xFFFF7043), // deep orange
  Color(0xFF26A69A), // teal
  Color(0xFFEC407A), // pink
  Color(0xFF5C6BC0), // indigo
  Color(0xFF66BB6A), // green
  Color(0xFFFFA726), // amber
  Color(0xFF29B6F6), // light blue
];

/// Get a category color by index, cycling through the palette
static Color getServiceCategoryColor(int index) {
  return serviceCategoryColors[index % serviceCategoryColors.length];
}
```

- [ ] **Step 3: Run the app to verify no regressions**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No new analysis errors.

- [ ] **Step 4: Commit**

```bash
git add lib/ui/design_system/app_theme.dart lib/core/constants/app_colors.dart
git commit -m "feat: add AppRadius, AppPadding, and service category color tokens"
```

---

## Task 2: Create `TappableCard` Widget — Scale Animation + Haptic Feedback

Every tappable card in the app should feel alive. This widget wraps any child with a subtle scale-down on press (0.97) and haptic feedback.

**Files:**
- Create: `lib/ui/shared/widgets/tappable_card.dart`

- [ ] **Step 1: Create the TappableCard widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps any child widget with a scale-down animation on press
/// and optional haptic feedback on tap.
class TappableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enableHaptic;
  final double scaleDown;
  final Duration duration;

  const TappableCard({
    super.key,
    required this.child,
    this.onTap,
    this.enableHaptic = true,
    this.scaleDown = 0.97,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<TappableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/shared/widgets/tappable_card.dart
git commit -m "feat: add TappableCard widget with scale animation and haptic feedback"
```

---

## Task 3: Create `SkeletonLoader` Widgets — Shimmer Effect

Reusable skeleton components with a shimmer animation for loading states across all screens.

**Files:**
- Create: `lib/ui/shared/widgets/skeleton_loader.dart`

- [ ] **Step 1: Create the skeleton loader widgets**

```dart
import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';

/// A shimmer animation wrapper that sweeps a light gradient across its child.
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({super.key, required this.child});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A rectangular skeleton placeholder.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A circular skeleton placeholder.
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Skeleton for a request card (used in requests_screen.dart).
class SkeletonRequestCard extends StatelessWidget {
  const SkeletonRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonBox(width: 40, height: 40, borderRadius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(height: 16, width: 140),
                      SizedBox(height: 6),
                      SkeletonBox(height: 12, width: 100),
                    ],
                  ),
                ),
                const SkeletonBox(width: 70, height: 24, borderRadius: 30),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonBox(height: 14),
            const SizedBox(height: 8),
            const SkeletonBox(height: 14),
            const SizedBox(height: 8),
            const SkeletonBox(height: 14, width: 120),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the service category grid (3-column square tiles).
class SkeletonServiceGrid extends StatelessWidget {
  final int itemCount;

  const SkeletonServiceGrid({super.key, this.itemCount = 9});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SkeletonBox(width: 44, height: 44, borderRadius: 12),
                SizedBox(height: 8),
                SkeletonBox(width: 60, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/shared/widgets/skeleton_loader.dart
git commit -m "feat: add reusable shimmer skeleton loader widgets"
```

---

## Task 4: Create `ServiceCategoryGrid` Widget — 3-Column Grouped Square Buttons

This is the core UX improvement. A reusable widget showing services as a 3-column grid of square buttons, grouped under category headers. Each button has a colored icon and short Mongolian text.

**Files:**
- Create: `lib/ui/patient/widgets/service_category_grid.dart`

- [ ] **Step 1: Create the ServiceCategoryGrid widget**

```dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// Displays services in a 3-column grid of square buttons, grouped by category.
///
/// Each category gets a header label, and its services render as square tiles
/// with a colored icon and short text label underneath.
class ServiceCategoryGrid extends StatelessWidget {
  /// List of services, each a Map with keys:
  /// - service_id, service_name, service_name_mn
  /// - category_name, category_name_mn, category_type, category_icon
  /// - min_price_mnt, max_price_mnt (optional)
  final List<Map<String, dynamic>> services;

  /// Called when a service tile is tapped.
  final void Function(Map<String, dynamic> service) onServiceTap;

  /// Optional selected category filter. If null, shows all grouped.
  final String? selectedCategory;

  const ServiceCategoryGrid({
    super.key,
    required this.services,
    required this.onServiceTap,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMn = l10n.localeName == 'mn';

    // Group services by category
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final service in services) {
      final categoryName = service['category_name'] as String? ?? '';
      grouped.putIfAbsent(categoryName, () => []).add(service);
    }

    // Filter to selected category if provided
    final categories = selectedCategory != null
        ? [selectedCategory!]
        : grouped.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, sectionIndex) {
          final category = categories[sectionIndex];
          final categoryServices = grouped[category] ?? [];
          if (categoryServices.isEmpty) return const SizedBox.shrink();

          // Get localized category name
          final firstService = categoryServices.first;
          final categoryLabel = isMn
              ? (firstService['category_name_mn'] as String? ?? category)
              : category;

          // Determine category color
          final colorIndex = categories.indexOf(category);
          final categoryColor = AppColors.getServiceCategoryColor(colorIndex);

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                Padding(
                  padding: AppPadding.screenH,
                  child: Text(
                    categoryLabel,
                    style: AppTypography.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                // 3-column grid
                Padding(
                  padding: AppPadding.screenH,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: categoryServices.length,
                    itemBuilder: (context, index) {
                      final service = categoryServices[index];
                      return _ServiceSquareTile(
                        service: service,
                        color: categoryColor,
                        isMn: isMn,
                        onTap: () => onServiceTap(service),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }
}

/// A single square tile for a service.
class _ServiceSquareTile extends StatelessWidget {
  final Map<String, dynamic> service;
  final Color color;
  final bool isMn;
  final VoidCallback onTap;

  const _ServiceSquareTile({
    required this.service,
    required this.color,
    required this.isMn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = isMn
        ? (service['service_name_mn'] as String? ??
            service['service_name'] as String)
        : service['service_name'] as String;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with colored background
            Container(
              width: 44,
              height: 44,
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
            // Service name
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
      ),
    );
  }

  static IconData _getServiceIcon(String? iconName) {
    switch (iconName) {
      case 'heart':
        return Iconsax.heart;
      case 'activity':
        return Iconsax.activity;
      case 'health':
        return Iconsax.health;
      case 'hospital':
        return Iconsax.hospital;
      case 'blood':
        return Iconsax.drop;
      case 'microscope':
        return Iconsax.microscope;
      case 'shield':
        return Iconsax.shield_tick;
      case 'flask':
        return Iconsax.filter;
      default:
        return Iconsax.health;
    }
  }
}
```

- [ ] **Step 2: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/widgets/service_category_grid.dart
git commit -m "feat: add ServiceCategoryGrid widget with 3-column square grouped tiles"
```

---

## Task 5: Rewrite `AllLabServicesScreen` — Grouped 3-Column Grid

Replace the flat list of lab services with the grouped 3-column grid.

**Files:**
- Modify: `lib/ui/patient/all_lab_services_screen.dart` (full rewrite of body)

- [ ] **Step 1: Rewrite AllLabServicesScreen to use ServiceCategoryGrid**

Replace the entire content of `lib/ui/patient/all_lab_services_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/ui/patient/laboratories_screen.dart';
import 'package:bugamed/ui/patient/widgets/service_category_grid.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/ui/shared/widgets/skeleton_loader.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllLabServicesScreen extends StatefulWidget {
  const AllLabServicesScreen({super.key});

  @override
  State<AllLabServicesScreen> createState() => _AllLabServicesScreenState();
}

class _AllLabServicesScreenState extends State<AllLabServicesScreen> {
  List<Map<String, dynamic>> allServices = [];
  List<Map<String, dynamic>> filteredServices = [];
  bool isLoading = true;
  String? errorMessage;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await Supabase.instance.client
          .from('services')
          .select('''
            id,
            service_name,
            service_name_mn,
            description,
            description_mn,
            sample_type,
            preparation_instructions,
            preparation_instructions_mn,
            service_categories!inner(
              id,
              name,
              name_mn,
              type,
              icon
            )
          ''')
          .eq('service_categories.type', 'lab_test')
          .order('service_name');

      if (!mounted) return;

      final services = (response as List).map((item) {
        final category = item['service_categories'] as Map<String, dynamic>;
        return {
          'service_id': item['id'],
          'service_name': item['service_name'],
          'service_name_mn': item['service_name_mn'],
          'description': item['description'],
          'description_mn': item['description_mn'],
          'sample_type': item['sample_type'],
          'preparation_instructions': item['preparation_instructions'],
          'preparation_instructions_mn': item['preparation_instructions_mn'],
          'category_name': category['name'],
          'category_name_mn': category['name_mn'],
          'category_type': category['type'],
          'category_icon': category['icon'],
        };
      }).toList();

      setState(() {
        allServices = services;
        filteredServices = services;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _filterServices(String query) {
    if (query.isEmpty) {
      setState(() => filteredServices = allServices);
      return;
    }
    final lower = query.toLowerCase();
    setState(() {
      filteredServices = allServices.where((s) {
        final name = (s['service_name'] as String?)?.toLowerCase() ?? '';
        final nameMn = (s['service_name_mn'] as String?)?.toLowerCase() ?? '';
        final desc = (s['description'] as String?)?.toLowerCase() ?? '';
        return name.contains(lower) ||
            nameMn.contains(lower) ||
            desc.contains(lower);
      }).toList();
    });
  }

  void _navigateToLaboratories(Map<String, dynamic> service) {
    final l10n = AppLocalizations.of(context)!;
    final serviceName = l10n.localeName == 'mn'
        ? (service['service_name_mn'] ?? service['service_name'])
        : service['service_name'];

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => LaboratoriesScreen(
          preSelectedServiceId: service['service_id'],
          serviceName: serviceName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(l10n.labServices),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: isLoading
          ? const SkeletonServiceGrid(itemCount: 9)
          : errorMessage != null
              ? Center(
                  child: MascotStateWidget(
                    emotion: MascotEmotion.error,
                    title: l10n.errorLoadingServices,
                    subtitle: errorMessage ?? '',
                    actionText: l10n.retry,
                    onAction: _loadServices,
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // Search bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: AppSearchField(
                          controller: _searchController,
                          hintText: l10n.searchServices,
                          onChanged: _filterServices,
                        ),
                      ),
                    ),
                    // Results count
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Text(
                          '${filteredServices.length} ${l10n.services.toLowerCase()}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    // Empty search state
                    if (filteredServices.isEmpty && !isLoading)
                      SliverFillRemaining(
                        child: Center(
                          child: MascotStateWidget(
                            emotion: MascotEmotion.searching,
                            title: l10n.noServicesMatchSearch,
                            subtitle: l10n.tryDifferentKeywords,
                          ),
                        ),
                      )
                    else
                      // Grouped grid
                      ServiceCategoryGrid(
                        services: filteredServices,
                        onServiceTap: _navigateToLaboratories,
                      ),
                    // Bottom padding
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ],
                ),
    );
  }
}
```

- [ ] **Step 2: Test the screen builds and navigates correctly**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors. Manually verify on device that tapping "Эмнэлгийн үзлэг" shows the new grouped grid.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/all_lab_services_screen.dart
git commit -m "feat: rewrite AllLabServicesScreen with grouped 3-column service grid"
```

---

## Task 6: Rewrite `DirectServicesScreen` — 3-Column Grouped Grid

Replace the 2-column grid with the same 3-column grouped style for consistency.

**Files:**
- Modify: `lib/ui/patient/direct_services_screen.dart` (full rewrite)

- [ ] **Step 1: Rewrite DirectServicesScreen**

Replace the entire content of `lib/ui/patient/direct_services_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/service_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/ui/patient/booking/direct_service_booking_screen.dart';
import 'package:bugamed/ui/patient/widgets/service_category_grid.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/ui/shared/widgets/skeleton_loader.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DirectServicesScreen extends StatefulWidget {
  const DirectServicesScreen({super.key});

  @override
  State<DirectServicesScreen> createState() => _DirectServicesScreenState();
}

class _DirectServicesScreenState extends State<DirectServicesScreen> {
  String? selectedCategory;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    serviceStore.loadDirectServices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredServices(
      List<Map<String, dynamic>> services) {
    var result = services;

    // Filter by category
    if (selectedCategory != null) {
      result = result
          .where((s) => s['category_name'] == selectedCategory)
          .toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      final lower = _searchQuery.toLowerCase();
      result = result.where((s) {
        final name = (s['service_name'] as String?)?.toLowerCase() ?? '';
        final nameMn =
            (s['service_name_mn'] as String?)?.toLowerCase() ?? '';
        return name.contains(lower) || nameMn.contains(lower);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(l10n.directDoctorServices),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: Observer(
        builder: (_) {
          if (serviceStore.isLoading) {
            return const SkeletonServiceGrid(itemCount: 9);
          }

          if (serviceStore.errorMessage != null) {
            return Center(
              child: MascotStateWidget(
                emotion: MascotEmotion.error,
                title: l10n.errorLoadingServices,
                subtitle: serviceStore.errorMessage ?? '',
                actionText: l10n.retry,
                onAction: () => serviceStore.loadDirectServices(),
              ),
            );
          }

          final services = serviceStore.directServices;
          if (services.isEmpty) {
            return Center(
              child: MascotStateWidget(
                emotion: MascotEmotion.empty,
                title: l10n.noServicesAvailable,
              ),
            );
          }

          // Get unique categories for filter tabs
          final categories = <String>{};
          for (final s in services) {
            categories.add(s['category_name'] as String);
          }

          final filtered = _getFilteredServices(services.toList());

          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Category tabs
              SliverToBoxAdapter(
                child: _buildCategoryTabs(
                    categories.toList(), services.toList(), l10n),
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: AppSearchField(
                    controller: _searchController,
                    hintText: l10n.searchServices,
                    onChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                  ),
                ),
              ),
              // Results count
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Text(
                    '${filtered.length} ${l10n.services.toLowerCase()}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              // Grid or empty state
              if (filtered.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: MascotStateWidget(
                      emotion: MascotEmotion.searching,
                      title: l10n.noServicesMatchSearch,
                      subtitle: l10n.tryDifferentKeywords,
                    ),
                  ),
                )
              else
                ServiceCategoryGrid(
                  services: filtered,
                  onServiceTap: (service) =>
                      _navigateToBooking(service, l10n),
                  selectedCategory: selectedCategory,
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryTabs(
    List<String> categories,
    List<Map<String, dynamic>> allServices,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _CategoryChip(
            label: l10n.all,
            isSelected: selectedCategory == null,
            color: AppColors.primary,
            onTap: () => setState(() => selectedCategory = null),
          ),
          ...categories.map((category) {
            final categoryServices =
                allServices.where((s) => s['category_name'] == category);
            final first =
                categoryServices.isNotEmpty ? categoryServices.first : null;
            final localizedName = _getLocalizedCategoryName(
                category, first, l10n);
            final colorIndex = categories.indexOf(category);
            final color = AppColors.getServiceCategoryColor(colorIndex);

            return _CategoryChip(
              label: localizedName,
              isSelected: selectedCategory == category,
              color: color,
              onTap: () => setState(() => selectedCategory = category),
            );
          }),
        ],
      ),
    );
  }

  String _getLocalizedCategoryName(
    String categoryName,
    Map<String, dynamic>? service,
    AppLocalizations l10n,
  ) {
    if (service == null) return categoryName;
    final categoryNameMn = service['category_name_mn'] as String?;
    if (l10n.localeName == 'mn' && categoryNameMn != null) {
      return categoryNameMn;
    }
    return categoryName;
  }

  void _navigateToBooking(
      Map<String, dynamic> service, AppLocalizations l10n) {
    String serviceName = service['service_name'];
    if (l10n.localeName == 'mn' && service['service_name_mn'] != null) {
      serviceName = service['service_name_mn'];
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => DirectServiceBookingScreen(
          serviceId: service['service_id'],
          serviceName: serviceName,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: isSelected ? color : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isSelected
                    ? color
                    : AppColors.grey.withValues(alpha: 0.3),
                width: 1.5,
              ),
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
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/direct_services_screen.dart
git commit -m "feat: rewrite DirectServicesScreen with grouped 3-column grid and search"
```

---

## Task 7: Add Search Bar to Home Screen + CupertinoPageRoute

Add a search field below the greeting header and switch all navigation pushes to `CupertinoPageRoute` for smooth iOS-style transitions.

**Files:**
- Modify: `lib/ui/patient/home_screen.dart`

- [ ] **Step 1: Add search bar and update navigation transitions**

In `lib/ui/patient/home_screen.dart`:

**Add import at top** (after line 1):
```dart
import 'package:flutter/cupertino.dart';
```

**Add search controller** — in `_PatientHomeScreenState`, add a field after `_homeStore` (after line 34):
```dart
final _searchController = TextEditingController();
```

**Dispose search controller** — in `dispose()`, add before `super.dispose()`:
```dart
_searchController.dispose();
```

**Add search bar** — replace `const SizedBox(height: AppSpacing.lg),` right before `Expanded(` (the second one, line 121) with:
```dart
const SizedBox(height: AppSpacing.sm),
// Search bar
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15),
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const AllLabServicesScreen(),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.grey,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.searchServices,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  ),
),
const SizedBox(height: AppSpacing.md),
```

**Replace all `MaterialPageRoute` with `CupertinoPageRoute`** in the same file. There are 4 occurrences around lines 137, 147, 159, 179. Replace each:

```dart
// Before:
MaterialPageRoute(
// After:
CupertinoPageRoute(
```

- [ ] **Step 2: Verify it builds and looks correct**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors. The home screen should now show a tappable search bar that navigates to AllLabServicesScreen.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/home_screen.dart
git commit -m "feat: add search bar to home screen and switch to CupertinoPageRoute transitions"
```

---

## Task 8: Add TappableCard to Home Screen Cards

Wrap visit options, test type cards, doctor cards, and ad banner items with `TappableCard` for press feedback.

**Files:**
- Modify: `lib/ui/patient/widgets/visit_options_section.dart`
- Modify: `lib/ui/patient/widgets/test_types_section.dart`
- Modify: `lib/ui/patient/widgets/doctor_card_tile.dart`
- Modify: `lib/ui/patient/widgets/ad_banner.dart`

- [ ] **Step 1: Wrap VisitOptionCards with TappableCard**

In `lib/ui/patient/widgets/visit_options_section.dart`:

**Add import** at top:
```dart
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
```

**Wrap first Expanded child** (the clinic card, around line 26-40). Replace:
```dart
          Expanded(
            child: VisitOptionCard(
```
with:
```dart
          Expanded(
            child: TappableCard(
              onTap: onClinicTap,
              child: VisitOptionCard(
```

And close the `TappableCard` — add `)` after the closing of `VisitOptionCard(...)`:
```dart
              onTap: onClinicTap,
            ),
            ),
```

Wait — this approach is cleaner: since `VisitOptionCard` already has an `onTap`, we should modify the card itself to not duplicate tap handlers. Instead, let's wrap the entire card and remove the `onTap` from `VisitOptionCard` to avoid double-taps.

Actually, the simplest approach: wrap each `Expanded` child, pass `onTap` to `TappableCard`, and keep `VisitOptionCard.onTap` as-is (it uses `GestureDetector` or `InkWell` internally). The scale animation from `TappableCard` uses `GestureDetector` which will handle the visual feedback, while the inner tap handler fires the navigation. But this could cause conflicts.

**Better approach**: Just wrap the `VisitOptionCard` in `TappableCard` without an onTap (for visual feedback only), and let the existing `onTap` in `VisitOptionCard` handle navigation:

Replace the first `Expanded` child (lines 25-40) with:
```dart
          Expanded(
            child: TappableCard(
              onTap: onClinicTap,
              child: IgnorePointer(
                child: VisitOptionCard(
                  icon: Icons.add,
                  iconWeight: FontWeight.w700,
                  iconSize: 28,
                  title: l10n.clinicVisit,
                  subtitle: l10n.makeAnAppointment,
                  backgroundColor: AppColors.primary,
                  titleColor: Colors.white,
                  subtitleColor: Colors.white.withValues(alpha: 0.8),
                  iconBackgroundColor: Colors.white,
                  iconColor: AppColors.primary,
                  elevated: true,
                  showWavyPattern: true,
                  onTap: null,
                ),
              ),
            ),
          ),
```

Replace the second `Expanded` child (lines 42-67) with:
```dart
          Expanded(
            child: TappableCard(
              onTap: onHomeTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: IgnorePointer(
                  child: VisitOptionCard(
                    icon: Iconsax.home_2,
                    iconFilled: true,
                    title: l10n.homeVisit,
                    subtitle: l10n.callTheDoctorHome,
                    backgroundColor: Colors.transparent,
                    titleColor: AppColors.black,
                    subtitleColor: AppColors.black,
                    iconBackgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    iconColor: AppColors.primary,
                    elevated: false,
                    onTap: null,
                  ),
                ),
              ),
            ),
          ),
```

- [ ] **Step 2: Add TappableCard to test type cards**

In `lib/ui/patient/widgets/test_types_section.dart`:

**Add import** at top:
```dart
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
```

Find the test card builder inside the `ListView.builder` `itemBuilder` (around line 140-190). Wrap the card `Container` with `TappableCard`. The card is likely returned as a `Container(...)` or `GestureDetector(child: Container(...))`.

Look for the card widget being returned in the `itemBuilder` and wrap it:

Replace the `GestureDetector` (or outermost widget) wrapping each test card with:
```dart
TappableCard(
  onTap: () { /* existing navigation */ },
  child: Container(
    // ... existing card content, remove old GestureDetector/InkWell
  ),
),
```

The exact edit depends on the current card structure. The key point: wrap with `TappableCard`, remove any existing `GestureDetector`/`InkWell` that handled tap.

- [ ] **Step 3: Add TappableCard to doctor_card_tile.dart**

In `lib/ui/patient/widgets/doctor_card_tile.dart`:

**Add import** at top:
```dart
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
```

Wrap the outermost widget returned by `build()` with `TappableCard`:
```dart
return TappableCard(
  onTap: onTap,  // use existing onTap callback
  child: Container(
    // ... existing card content, remove old GestureDetector/InkWell
  ),
);
```

- [ ] **Step 4: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/ui/patient/widgets/visit_options_section.dart lib/ui/patient/widgets/test_types_section.dart lib/ui/patient/widgets/doctor_card_tile.dart
git commit -m "feat: add TappableCard press animation to visit options, test types, and doctor tiles"
```

---

## Task 9: Add Skeleton Loaders to Requests Screen + TappableCard on Request Cards

Replace the plain `CircularProgressIndicator` loading state with shimmer skeleton cards, and wrap request cards with `TappableCard`.

**Files:**
- Modify: `lib/ui/patient/requests_screen.dart`

- [ ] **Step 1: Add imports**

Add to the top of `lib/ui/patient/requests_screen.dart`:
```dart
import 'package:bugamed/ui/shared/widgets/skeleton_loader.dart';
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
```

- [ ] **Step 2: Replace CircularProgressIndicator with skeleton cards**

Replace the loading block (lines 51-57):
```dart
        if (testRequestStore.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }
```

With:
```dart
        if (testRequestStore.isLoading) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerEffect(
                    child: SkeletonBox(height: 28, width: 180),
                  ),
                  const SizedBox(height: 8),
                  const ShimmerEffect(
                    child: SkeletonBox(height: 16, width: 120),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 14),
                      itemBuilder: (_, __) =>
                          const SkeletonRequestCard(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
```

- [ ] **Step 3: Wrap _RequestCard with TappableCard**

In the `_buildRequestsList` method, find the `itemBuilder` (around line 249):
```dart
        itemBuilder: (context, index) =>
            _RequestCard(request: requests[index], l10n: l10n),
```

Replace with:
```dart
        itemBuilder: (context, index) => TappableCard(
          child: _RequestCard(request: requests[index], l10n: l10n),
        ),
```

- [ ] **Step 4: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/ui/patient/requests_screen.dart
git commit -m "feat: add skeleton loaders and TappableCard to requests screen"
```

---

## Task 10: Add TappableCard + CupertinoPageRoute to Laboratories Screen

Wrap lab cards with `TappableCard` and switch to `CupertinoPageRoute`.

**Files:**
- Modify: `lib/ui/patient/laboratories_screen.dart`

- [ ] **Step 1: Add imports**

Add to the top of `lib/ui/patient/laboratories_screen.dart`:
```dart
import 'package:flutter/cupertino.dart';
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
```

- [ ] **Step 2: Replace all MaterialPageRoute with CupertinoPageRoute**

Search and replace all instances of `MaterialPageRoute` with `CupertinoPageRoute` in this file.

- [ ] **Step 3: Wrap _ModernLabCard with TappableCard**

Find where `_ModernLabCard` is used in the `ListView.builder` `itemBuilder`. Wrap it:

```dart
TappableCard(
  onTap: () => _navigateToLabDetail(lab),
  child: _ModernLabCard(
    laboratory: lab,
    // ... remove the onTap from _ModernLabCard if it has one
  ),
),
```

If `_ModernLabCard` handles its own tap internally, wrap it with `TappableCard` without an `onTap` (visual feedback only) and keep the internal navigation.

- [ ] **Step 4: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/ui/patient/laboratories_screen.dart
git commit -m "feat: add TappableCard and CupertinoPageRoute to laboratories screen"
```

---

## Task 11: Standardize Padding and Border Radius Across Screens

Replace hard-coded magic numbers with `AppPadding`, `AppRadius`, and `AppSpacing` constants.

**Files:**
- Modify: `lib/ui/patient/home_screen.dart` — replace `15` padding with `AppPadding.screen` (20)
- Modify: `lib/ui/patient/requests_screen.dart` — replace `20` padding and `18` radius
- Modify: `lib/ui/patient/main_page.dart` — add haptic feedback on tab changes

- [ ] **Step 1: Standardize home_screen.dart padding**

In `lib/ui/patient/home_screen.dart`, replace all `EdgeInsets.symmetric(horizontal: 15)` with `AppPadding.screenH`:

Find and replace (there are ~3 occurrences):
```dart
// Before:
padding: const EdgeInsets.symmetric(horizontal: 15),
// After:
padding: AppPadding.screenH,
```

- [ ] **Step 2: Standardize requests_screen.dart**

In `lib/ui/patient/requests_screen.dart`:

Replace `EdgeInsets.fromLTRB(20, 24, 20, 8)` with:
```dart
const EdgeInsets.fromLTRB(AppPadding.screen, 24, AppPadding.screen, 8)
```

Replace `EdgeInsets.symmetric(horizontal: 16)` with `AppPadding.screenH` (needs to also update from 16 to 20 for consistency).

Replace `BorderRadius.circular(18)` with `BorderRadius.circular(AppRadius.md)`.

- [ ] **Step 3: Add haptic feedback to main_page.dart tab changes**

In `lib/ui/patient/main_page.dart`:

**Add import**:
```dart
import 'package:flutter/services.dart';
```

Find the `onTap` handler for the nav bar items (where `setState` changes `selectedIndex`). Add haptic feedback:
```dart
onTap: () {
  HapticFeedback.selectionClick();
  setState(() => selectedIndex = index);
},
```

- [ ] **Step 4: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/ui/patient/home_screen.dart lib/ui/patient/requests_screen.dart lib/ui/patient/main_page.dart
git commit -m "feat: standardize padding/radius constants and add haptic feedback to nav bar"
```

---

## Task 12: Standardize Icon Library — Migrate to Iconsax Everywhere

Replace scattered `Icons.*` (Material) usage with `Iconsax.*` for visual consistency. Only touch screens we've already modified.

**Files:**
- Modify: `lib/ui/patient/requests_screen.dart` — replace Material icons in `_RequestMetaRow`

- [ ] **Step 1: Replace Material icons in requests_screen.dart**

In `lib/ui/patient/requests_screen.dart`, ensure Iconsax is imported:
```dart
import 'package:iconsax/iconsax.dart';
```

Replace the icons in `_RequestCard.build()`:
```dart
// Before:
_RequestMetaRow(icon: Icons.calendar_month_outlined, ...)
_RequestMetaRow(icon: Icons.location_on_outlined, ...)
_RequestMetaRow(icon: Icons.payments_outlined, ...)
_RequestMetaRow(icon: Icons.note_alt_outlined, ...)

// After:
_RequestMetaRow(icon: Iconsax.calendar_1, ...)
_RequestMetaRow(icon: Iconsax.location, ...)
_RequestMetaRow(icon: Iconsax.wallet_2, ...)
_RequestMetaRow(icon: Iconsax.note_text, ...)
```

Also replace the icons in `_RequestTypeInfo.fromRequest()`:
```dart
// Before:
icon: Icons.biotech_outlined,
icon: Icons.home_work_outlined,

// After:
icon: Iconsax.microscope,
icon: Iconsax.home_2,
```

- [ ] **Step 2: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/ui/patient/requests_screen.dart
git commit -m "feat: standardize request screen icons to Iconsax"
```

---

## Task 13: Add Localization Strings

Add the new strings needed for the search bar and any new UI text.

**Files:**
- Modify: `lib/l10n/app_mn.arb`
- Modify: `lib/l10n/app_en.arb`

- [ ] **Step 1: Add new strings to app_mn.arb**

Add these entries (before the closing `}`):
```json
  "searchHome": "Үйлчилгээ, лаборатори хайх...",
  "popularServices": "Эрэлттэй үйлчилгээ",
  "allCategories": "Бүх ангилал"
```

- [ ] **Step 2: Add same strings to app_en.arb**

Add these entries (before the closing `}`):
```json
  "searchHome": "Search services, laboratories...",
  "popularServices": "Popular Services",
  "allCategories": "All Categories"
```

- [ ] **Step 3: Regenerate localizations**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter gen-l10n`

If that doesn't work, run:
```bash
cd /Users/shijirbum_b/Oncall-Lab && flutter pub get
```

The localization files at `lib/l10n/app_localizations*.dart` should regenerate.

- [ ] **Step 4: Commit**

```bash
git add lib/l10n/
git commit -m "feat: add localization strings for search and category UI"
```

---

## Task 14: Haptic Feedback on Key Actions

Add `HapticFeedback.mediumImpact()` to booking confirmation, payment success, and other critical user moments.

**Files:**
- Modify: `lib/ui/patient/booking_confirmation_screen.dart`
- Modify: `lib/ui/payment/payment_success_screen.dart`

- [ ] **Step 1: Add haptic feedback to booking confirmation**

In `lib/ui/patient/booking_confirmation_screen.dart`:

**Add import**:
```dart
import 'package:flutter/services.dart';
```

Find where the booking success state is set (the `setState` after successful request creation, around line 70-90). Add haptic feedback right before or after the setState:
```dart
HapticFeedback.mediumImpact();
```

- [ ] **Step 2: Add haptic feedback to payment success**

In `lib/ui/payment/payment_success_screen.dart`:

**Add import**:
```dart
import 'package:flutter/services.dart';
```

Add `HapticFeedback.mediumImpact()` in `initState` or the first build when the success screen appears:
```dart
@override
void initState() {
  super.initState();
  HapticFeedback.mediumImpact();
}
```

- [ ] **Step 3: Verify it builds**

Run: `cd /Users/shijirbum_b/Oncall-Lab && flutter analyze`

Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/ui/patient/booking_confirmation_screen.dart lib/ui/payment/payment_success_screen.dart
git commit -m "feat: add haptic feedback on booking confirmation and payment success"
```

---

## Task 15: Final Verification and Smoke Test

Run the full app, verify all screens, and ensure no regressions.

- [ ] **Step 1: Run full analysis**

```bash
cd /Users/shijirbum_b/Oncall-Lab && flutter analyze
```

Expected: No errors (warnings OK).

- [ ] **Step 2: Run on device**

```bash
cd /Users/shijirbum_b/Oncall-Lab && flutter run -d 00008110-001C702E0E40401E
```

**Verify these flows:**
1. Home screen shows search bar → tapping opens AllLabServicesScreen
2. "Эмнэлгийн үзлэг" → 3-column grouped grid with square icon buttons
3. "Дуудлагын шинжилгээ" → 3-column grouped grid with category tabs
4. All card taps have scale-down animation
5. Page transitions are smooth iOS-style slides
6. Requests screen shows skeleton loaders during load
7. Bottom nav bar has haptic click
8. All icons are Iconsax (consistent)
9. Padding is consistent (20px horizontal everywhere)

- [ ] **Step 3: Commit any final fixes**

```bash
git add -A
git commit -m "fix: final adjustments from smoke testing"
```
