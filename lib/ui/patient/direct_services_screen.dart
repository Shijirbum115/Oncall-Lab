import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/stores/service_store.dart';
import 'package:oncall_lab/ui/patient/booking/direct_service_booking_screen.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/shared/widgets/app_card.dart';

class DirectServicesScreen extends StatefulWidget {
  const DirectServicesScreen({super.key});

  @override
  State<DirectServicesScreen> createState() => _DirectServicesScreenState();
}

class _DirectServicesScreenState extends State<DirectServicesScreen> {
  @override
  void initState() {
    super.initState();
    serviceStore.loadDirectServices();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.directDoctorServices),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Observer(
        builder: (_) {
          if (serviceStore.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (serviceStore.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      l10n.errorLoadingServices,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      serviceStore.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => serviceStore.loadDirectServices(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          final services = serviceStore.directServices;

          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.health, size: 60, color: AppColors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noServicesAvailable,
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

          // Group services by category
          final groupedServices = <String, List<Map<String, dynamic>>>{};
          for (final service in services) {
            final categoryName = service['category_name'] as String;
            if (!groupedServices.containsKey(categoryName)) {
              groupedServices[categoryName] = [];
            }
            groupedServices[categoryName]!.add(service);
          }

          return RefreshIndicator(
            onRefresh: () => serviceStore.loadDirectServices(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedServices.length,
              itemBuilder: (context, index) {
                final categoryName = groupedServices.keys.elementAt(index);
                final categoryServices = groupedServices[categoryName]!;
                final categoryType = categoryServices.first['category_type'];
                final categoryIcon = categoryServices.first['category_icon'];

                return _CategorySection(
                  categoryName: categoryName,
                  categoryType: categoryType,
                  categoryIcon: categoryIcon,
                  services: categoryServices,
                  l10n: l10n,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String categoryName;
  final String categoryType;
  final String? categoryIcon;
  final List<Map<String, dynamic>> services;
  final AppLocalizations l10n;

  const _CategorySection({
    required this.categoryName,
    required this.categoryType,
    required this.categoryIcon,
    required this.services,
    required this.l10n,
  });

  IconData _getCategoryIcon() {
    switch (categoryIcon) {
      case 'heart':
        return Iconsax.heart;
      case 'activity':
        return Iconsax.activity;
      case 'health':
        return Iconsax.health;
      default:
        return Iconsax.hospital;
    }
  }

  Color _getCategoryColor() {
    switch (categoryType) {
      case 'diagnostic_procedure':
        return AppColors.info;
      case 'nursing_care':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(_getCategoryIcon(), color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${services.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Services List
        ...services.map((service) => _ServiceCard(
              service: service,
              categoryColor: color,
              l10n: l10n,
            )),

        const SizedBox(height: 24),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final Color categoryColor;
  final AppLocalizations l10n;

  const _ServiceCard({
    required this.service,
    required this.categoryColor,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final minPrice = service['min_price_mnt'] as int?;
    final maxPrice = service['max_price_mnt'] as int?;
    final doctorsCount = service['available_doctors_count'] as int? ?? 0;
    final priceLabel = minPrice == null
        ? null
        : (maxPrice != null && minPrice != maxPrice
            ? '${l10n.priceInMNT(minPrice)} - ${l10n.priceInMNT(maxPrice)}'
            : l10n.priceInMNT(minPrice));

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 18,
      borderColor: categoryColor.withValues(alpha: 0.15),
      showShadow: false,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DirectServiceBookingScreen(
              serviceId: service['service_id'],
              serviceName: service['service_name'],
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  service['service_name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              const Icon(
                Iconsax.arrow_right_3,
                size: 20,
                color: AppColors.grey,
              ),
            ],
          ),
          if (service['service_description'] != null) ...[
            const SizedBox(height: 8),
            Text(
              service['service_description'],
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
              if (priceLabel != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    priceLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: categoryColor),
                  const SizedBox(width: 4),
                  Text(
                    '$doctorsCount ${doctorsCount == 1 ? l10n.doctor : l10n.doctors}',
                    style: TextStyle(
                      fontSize: 13,
                      color: categoryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (service['estimated_duration_minutes'] != null) ...[
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '~${l10n.durationMinutes(service['estimated_duration_minutes'] as int)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
