import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
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
            name,
            name_mn,
            description,
            description_mn,
            sample_type,
            preparation_instructions,
            service_categories!inner(
              id,
              name,
              name_mn,
              type,
              icon_name
            )
          ''')
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
          'category_name': category['name'],
          'category_name_mn': category['name_mn'],
          'category_type': category['type'],
          'category_icon': category['icon_name'],
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
        titleSpacing: 0,
        title: AppScreenHeader(
          title: l10n.labServices,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: AppSearchField(
                          controller: _searchController,
                          hint: l10n.searchServices,
                          onChanged: _filterServices,
                          onClear: () {
                            _searchController.clear();
                            _filterServices('');
                          },
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
                          child: MascotStateWidget(
                            emotion: MascotEmotion.searching,
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
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ],
                ),
    );
  }
}
