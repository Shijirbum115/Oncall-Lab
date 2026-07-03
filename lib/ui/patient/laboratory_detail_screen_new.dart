import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/data/models/laboratory_service_model.dart';
import 'package:bugamed/stores/service_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/ui/patient/booking/lab_service_booking_screen.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/l10n/app_localizations.dart';

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

      if (widget.preSelectedServiceId != null && mounted) {
        final match = data.firstWhere(
          (s) => s.serviceId == widget.preSelectedServiceId,
          orElse: () => data.first,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LabServiceBookingScreen(
                  laboratory: widget.laboratory,
                  laboratoryService: match,
                ),
              ),
            );
          }
        });
      }
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.laboratory['name']),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildLabInfo(l10n),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: AppPadding.screenAll,
            child: AppSearchField(
              hint: l10n.searchServices,
              prefixIcon: Iconsax.search_normal,
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              onClear: () => setState(() => searchQuery = ''),
            ),
          ),
          Expanded(
            child: _buildServicesList(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildLabInfo(AppLocalizations l10n) {
    return Container(
      padding: AppPadding.screenAll,
      color: AppColors.primarySoft,
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
                  style: AppTypography.body,
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
                style:
                    AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (widget.laboratory['email'] != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(widget.laboratory['email'], style: AppTypography.body),
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
        child: SingleChildScrollView(
          child: MascotStateWidget(
            emotion: MascotEmotion.error,
            title: l10n.errorLoadingServices,
            subtitle: errorMessage!,
            actionText: l10n.retry,
            onAction: _loadServices,
          ),
        ),
      );
    }

    final displayServices = filteredServices;

    if (displayServices.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: MascotStateWidget(
            emotion: MascotEmotion.empty,
            title: searchQuery.isEmpty
                ? l10n.noServicesAvailable
                : l10n.noServicesMatchSearch,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView.separated(
        padding: AppPadding.screenAll,
        itemCount: displayServices.length,
        separatorBuilder: (_, index) => const SizedBox(height: 12),
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

    return AppCard(
      onTap: onTap,
      backgroundColor:
          isPreSelected ? AppColors.primarySoft : AppColors.surface,
      borderColor: isPreSelected ? AppColors.primary : AppColors.border,
      borderWidth: isPreSelected ? 2 : 1,
      borderRadius: AppRadius.sm,
      elevation: AppCardElevation.resting,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
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
                      style: AppTypography.bodyLg.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (category != null)
                      Text(category.name, style: AppTypography.caption),
                  ],
                ),
              ),
            ],
          ),
          if (service.description != null) ...[
            const SizedBox(height: 12),
            Text(
              service.description!,
              style: AppTypography.bodySm,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  l10n.priceInMNT(labService.priceMnt),
                  style: AppTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (labService.estimatedDurationHours != null)
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: AppColors.inkSubtle),
                    const SizedBox(width: 4),
                    Text(
                      '~${l10n.durationHours(labService.estimatedDurationHours!)}',
                      style: AppTypography.bodySm,
                    ),
                  ],
                ),
              const Spacer(),
              const Icon(Iconsax.arrow_right_3,
                  size: 20, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}
