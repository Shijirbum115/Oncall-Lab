import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/ui/patient/laboratories_screen.dart';
import 'package:bugamed/ui/patient/widgets/service_category_grid.dart';
import 'package:bugamed/ui/patient/widgets/category_filter_bar.dart';
import 'package:bugamed/ui/shared/widgets/category_icon.dart';
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
import 'package:bugamed/ui/shared/widgets/skeleton_loader.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/core/utils/error_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllLabServicesScreen extends StatefulWidget {
  const AllLabServicesScreen({super.key, this.initialCategory});

  /// Pre-selected category (localized name), e.g. when the user taps a
  /// category on home — their selection must survive the navigation.
  final String? initialCategory;

  @override
  State<AllLabServicesScreen> createState() => _AllLabServicesScreenState();
}

class _AllLabServicesScreenState extends State<AllLabServicesScreen> {
  List<Map<String, dynamic>> allServices = [];
  List<Map<String, dynamic>> filteredServices = [];
  bool isLoading = true;
  String? errorMessage;
  String _searchQuery = '';
  String? _selectedCategory;
  final _searchController = TextEditingController();

  String _categoryNameOf(Map<String, dynamic> s, bool isMn) {
    final mn = s['category_name_mn'] as String?;
    final en = s['category_name'] as String?;
    return (isMn ? (mn ?? en) : en) ?? '';
  }

  List<String> _categoriesFor(bool isMn) {
    final cats = <String>{};
    for (final s in allServices) {
      final name = _categoryNameOf(s, isMn);
      if (name.isNotEmpty) cats.add(name);
    }
    return cats.toList();
  }

  /// One entry per category, preserving both names and the icon key.
  List<Map<String, String?>> _categoryTiles() {
    final seen = <String, Map<String, String?>>{};
    for (final s in allServices) {
      final en = s['category_name'] as String?;
      if (en == null || en.isEmpty || seen.containsKey(en)) continue;
      seen[en] = {
        'name': en,
        'name_mn': s['category_name_mn'] as String?,
        'icon': s['category_icon'] as String?,
      };
    }
    return seen.values.toList();
  }

  /// Browse mode: nothing selected, nothing searched — show categories
  /// instead of dumping every service in one list.
  bool get _browsing => _selectedCategory == null && _searchQuery.isEmpty;

  void _applyFilters(bool isMn) {
    var result = allServices;

    if (_selectedCategory != null) {
      // Match either language so navigation sources that only know one
      // name (e.g. the home row) can never land on an empty list.
      result = result.where((s) {
        return s['category_name'] == _selectedCategory ||
            s['category_name_mn'] == _selectedCategory;
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final lower = _searchQuery.toLowerCase();
      result = result.where((s) {
        final name = (s['service_name'] as String?)?.toLowerCase() ?? '';
        final nameMn = (s['service_name_mn'] as String?)?.toLowerCase() ?? '';
        final desc = (s['description'] as String?)?.toLowerCase() ?? '';
        return name.contains(lower) ||
            nameMn.contains(lower) ||
            desc.contains(lower);
      }).toList();
    }

    filteredServices = result;
  }

  void _selectCategory(String? category, bool isMn) {
    setState(() {
      _selectedCategory = category;
      _applyFilters(isMn);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
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
          .select('*, service_categories!inner(*)')
          .eq('service_categories.type', 'lab_test')
          .eq('is_active', true)
          .order('name');

      if (!mounted) return;

      final services = (response as List).map((item) {
        final category = item['service_categories'] as Map<String, dynamic>;
        return {
          'service_id': item['id'],
          'service_name': item['name'],
          'service_name_mn': item['name_mn'],
          'description': item['description'],
          'description_mn': item['description_mn'],
          'sample_type': item['sample_type'],
          'preparation_instructions': item['preparation_instructions'],
          'preparation_instructions_mn': item['preparation_instructions_mn'],
          'category_name': category['name'],
          'category_name_mn': category['name_mn'],
          'category_type': category['type'],
          'category_icon': category['icon_name'] ?? category['icon'],
        };
      }).toList();

      final isMn = Localizations.localeOf(context).languageCode == 'mn';
      setState(() {
        allServices = services;
        _applyFilters(isMn);
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

  void _filterServices(String query, bool isMn) {
    setState(() {
      _searchQuery = query;
      _applyFilters(isMn);
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
    final isMn = l10n.localeName == 'mn';

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
                  child: AppEmptyState(
                    emotion: AppEmptyEmotion.error,
                    title: l10n.errorLoadingServices,
                    subtitle: friendlyErrorMessage(l10n, errorMessage),
                    actionText: l10n.retry,
                    onAction: _loadServices,
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: AppSearchField(
                          controller: _searchController,
                          hint: l10n.searchServices,
                          onChanged: (q) => _filterServices(q, isMn),
                          onClear: () {
                            _searchController.clear();
                            _filterServices('', isMn);
                          },
                        ),
                      ),
                    ),
                    if (_browsing)
                      // Category browse grid: pick a category first, then
                      // drill into its services.
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        sliver: _CategoryBrowseGrid(
                          categories: _categoryTiles(),
                          isMn: isMn,
                          onCategoryTap: (label) =>
                              _selectCategory(label, isMn),
                        ),
                      )
                    else ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                          child: CategoryFilterBar(
                            categories: _categoriesFor(isMn),
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (c) =>
                                _selectCategory(c, isMn),
                            allLabel: l10n.all,
                          ),
                        ),
                      ),
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
                      if (filteredServices.isEmpty && !isLoading)
                        SliverFillRemaining(
                          child: Center(
                            child: AppEmptyState(
                              emotion: AppEmptyEmotion.searching,
                              title: l10n.noServicesMatchSearch,
                              subtitle: l10n.tryDifferentKeywords,
                            ),
                          ),
                        )
                      else
                        ServiceCategoryGrid(
                          services: filteredServices,
                          onServiceTap: _navigateToLaboratories,
                        ),
                    ],
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ],
                ),
    );
  }
}

/// 3-column grid of category tiles (gradient icon + label, borderless).
class _CategoryBrowseGrid extends StatelessWidget {
  const _CategoryBrowseGrid({
    required this.categories,
    required this.isMn,
    required this.onCategoryTap,
  });

  final List<Map<String, String?>> categories;
  final bool isMn;
  final void Function(String localizedName) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cat = categories[index];
          final label =
              (isMn ? (cat['name_mn'] ?? cat['name']) : cat['name']) ?? '';

          return GestureDetector(
            onTap: () => onCategoryTap(label),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                CategoryIcon(
                  categoryName: cat['name'],
                  iconName: cat['icon'],
                  size: 62,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
