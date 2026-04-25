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

    if (selectedCategory != null) {
      result = result
          .where((s) => s['category_name'] == selectedCategory)
          .toList();
    }

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
              SliverToBoxAdapter(
                child: _buildCategoryTabs(
                    categories.toList(), services.toList(), l10n),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: AppSearchField(
                    controller: _searchController,
                    hint: l10n.searchServices,
                    onChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                  ),
                ),
              ),
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
