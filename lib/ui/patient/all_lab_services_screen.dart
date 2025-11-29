import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/ui/patient/laboratories_screen.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/shared/widgets/app_card.dart';
import 'package:oncall_lab/ui/design_system/widgets/app_text_field.dart';

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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadServices();
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load all lab test services
      final servicesData = await supabase
          .from('services')
          .select('''
            *,
            service_categories(*)
          ''')
          .eq('service_categories.type', 'lab_test')
          .eq('is_active', true)
          .order('name');

      setState(() {
        allServices = List<Map<String, dynamic>>.from(servicesData);
        filteredServices = List<Map<String, dynamic>>.from(servicesData);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading services: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredServices = List<Map<String, dynamic>>.from(allServices);
      } else {
        filteredServices = allServices.where((service) {
          final name = (service['name'] as String).toLowerCase();
          final description =
              (service['description'] as String?)?.toLowerCase() ?? '';
          return name.contains(query) || description.contains(query);
        }).toList();
      }
    });
  }

  void _navigateToLaboratories(Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LaboratoriesScreen(
          preSelectedServiceId: service['id'],
          serviceName: service['name'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.laboratoryTestsTitle),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchField(
              controller: _searchController,
              hint: l10n.searchTests,
              prefixIcon: Iconsax.search_normal,
              onChanged: (_) => _filterServices(),
              onClear: () {
                _searchController.clear();
                _filterServices();
              },
            ),
          ),

          // Results Count
          if (!isLoading && filteredServices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  filteredServices.length == 1
                      ? l10n.singleTestAvailable
                      : l10n.testsAvailable(filteredServices.length),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Services List
          Expanded(
            child: _buildContent(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.error,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.errorLoadingServices,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadServices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredServices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.search_normal,
                size: 60,
                color: AppColors.grey.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 20),
              Text(
                _searchController.text.isEmpty
                    ? l10n.noServicesAvailable
                    : l10n.noResultsFound,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _searchController.text.isEmpty
                    ? l10n.pleaseTryAgainLater
                    : l10n.tryDifferentKeywords,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          final service = filteredServices[index];
          return _ServiceCard(
            service: service,
            l10n: l10n,
            onTap: () => _navigateToLaboratories(service),
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _ServiceCard({
    required this.service,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final sampleType = service['sample_type'] as String?;
    final preparationInstructions = service['preparation_instructions'] as String?;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 18,
      borderColor: AppColors.grey.withValues(alpha: 0.16),
      showShadow: false,
      onTap: onTap,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.health,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        if (sampleType != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Iconsax.drop,
                                size: 14,
                                color: AppColors.grey.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                sampleType.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.grey,
                  ),
                ],
              ),
              if (service['description'] != null) ...[
                const SizedBox(height: 12),
                Text(
                  service['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (preparationInstructions != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.warning.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.preparationRequired,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
    );
  }
}
