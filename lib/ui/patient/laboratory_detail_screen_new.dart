import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/data/models/laboratory_service_model.dart';
import 'package:oncall_lab/stores/service_store.dart';
import 'package:oncall_lab/ui/patient/booking/lab_service_booking_screen.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/design_system/widgets/app_text_field.dart';

class LaboratoryDetailScreenNew extends StatefulWidget {
  final Map<String, dynamic> laboratory;
  final String? preSelectedServiceId;

  const LaboratoryDetailScreenNew({
    super.key,
    required this.laboratory,
    this.preSelectedServiceId,
  });

  @override
  State<LaboratoryDetailScreenNew> createState() =>
      _LaboratoryDetailScreenNewState();
}

class _LaboratoryDetailScreenNewState
    extends State<LaboratoryDetailScreenNew> {
  List<LaboratoryServiceModel> services = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data =
          await serviceStore.getLaboratoryServices(widget.laboratory['id']);
      setState(() {
        services = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<LaboratoryServiceModel> get filteredServices {
    if (searchQuery.isEmpty) return services;

    return services.where((service) {
      final name = service.service?.name.toLowerCase() ?? '';
      final description = service.service?.description?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();

      return name.contains(query) || description.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.laboratory['name']),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Laboratory Info Header
          _buildLabInfo(l10n),
          const Divider(height: 1),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchField(
              hint: l10n.searchServices,
              prefixIcon: Iconsax.search_normal,
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              onClear: () => setState(() => searchQuery = ''),
            ),
          ),

          // Services List
          Expanded(
            child: _buildServicesList(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildLabInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.laboratory['address'] ?? l10n.addressNotAvailable,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                widget.laboratory['phone_number'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (widget.laboratory['email'] != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  widget.laboratory['email'],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServicesList(AppLocalizations l10n) {
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
              const Icon(Icons.error_outline, size: 60, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingServices,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadServices,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final displayServices = filteredServices;

    if (displayServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isEmpty ? Iconsax.box : Iconsax.search_normal,
              size: 60,
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty
                  ? l10n.noServicesAvailable
                  : l10n.noServicesMatchSearch,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: displayServices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final labService = displayServices[index];

          return _ServiceCard(
            labService: labService,
            isPreSelected: widget.preSelectedServiceId == labService.serviceId,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LabServiceBookingScreen(
                    laboratory: widget.laboratory,
                    laboratoryService: labService,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final LaboratoryServiceModel labService;
  final VoidCallback onTap;
  final bool isPreSelected;

  const _ServiceCard({
    required this.labService,
    required this.onTap,
    this.isPreSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final service = labService.service!;
    final category = service.category;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isPreSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPreSelected
                ? AppColors.primary
                : AppColors.grey.withValues(alpha: 0.2),
            width: isPreSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isPreSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    service.sampleType == 'blood'
                        ? Icons.bloodtype
                        : service.sampleType == 'urine'
                            ? Iconsax.health
                            : Iconsax.activity,
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
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      if (category != null)
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (service.description != null) ...[
              const SizedBox(height: 12),
              Text(
                service.description!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.priceInMNT(labService.priceMnt),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (labService.estimatedDurationHours != null)
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '~${l10n.durationHours(labService.estimatedDurationHours!)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                const Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
