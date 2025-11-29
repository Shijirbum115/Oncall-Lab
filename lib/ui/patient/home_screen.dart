import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/ui/patient/widgets/visit_options_section.dart';
import 'package:oncall_lab/ui/patient/widgets/test_types_section.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:oncall_lab/ui/patient/widgets/available_doctors_section.dart';
import 'package:oncall_lab/ui/patient/all_lab_services_screen.dart';
import 'package:oncall_lab/ui/patient/direct_services_screen.dart';
import 'package:oncall_lab/ui/shared/widgets/profile_avatar.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/patient/widgets/ad_banner.dart';

class PatientHomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToProfile;

  const PatientHomeScreen({
    super.key,
    required this.onNavigateToProfile,
  });

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> testTypes = [];
  List<Map<String, dynamic>> availableDoctors = [];
  bool isLoading = true;
  String? errorMessage;

  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _waveAnimation =
        Tween<double>(begin: -0.12, end: 0.12).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waveController.repeat(reverse: true);
      Timer(const Duration(seconds: 4), () {
        if (mounted) {
          _waveController.forward(from: 0);
          _waveController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load all lab tests offered across laboratories
      final labServicesRaw = await supabase
          .from('laboratory_services')
          .select('''
            service_id,
            price_mnt,
            estimated_duration_hours,
            laboratories ( name ),
            services (
              id,
              name,
              description,
              service_categories ( type )
            )
          ''')
          .eq('is_available', true)
          .limit(200);

      final labServicesData =
          List<Map<String, dynamic>>.from(labServicesRaw);

      final combinedTests = <String, Map<String, dynamic>>{};

      for (final record in labServicesData) {
        final service = record['services'] as Map<String, dynamic>?;
        if (service == null) continue;

        final serviceId = service['id']?.toString();
        if (serviceId == null) continue;

        final labName =
            (record['laboratories'] as Map<String, dynamic>?)?['name']
                as String?;
        final offeredPrice = record['price_mnt'] as int?;

        final entry = combinedTests.putIfAbsent(serviceId, () {
          return {
            'id': serviceId,
            'name': service['name'] ?? '',
            'price_mnt': offeredPrice ?? 0,
            'labs': <String>[],
            'lab_count': 0,
            'service_categories': service['service_categories'],
          };
        });

        if (offeredPrice != null) {
          final currentPrice = entry['price_mnt'] as int? ?? offeredPrice;
          entry['price_mnt'] = math.min(currentPrice, offeredPrice);
        }

        if (labName != null) {
          final labs = entry['labs'] as List<String>;
          if (!labs.contains(labName)) {
            labs.add(labName);
            entry['lab_count'] = labs.length;
          }
        }
      }

      final aggregatedTests = combinedTests.values.toList()
        ..sort((a, b) {
          final bCount = b['lab_count'] as int? ?? 0;
          final aCount = a['lab_count'] as int? ?? 0;
          return bCount.compareTo(aCount);
        });

      // Load available doctors
      final doctorsData = await supabase.rpc('get_available_doctors');

      setState(() {
        testTypes = aggregatedTests.take(12).toList();
        availableDoctors = List<Map<String, dynamic>>.from(doctorsData);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
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
                l10n.errorLoadingData,
                style: const TextStyle(
                  fontSize: 20,
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
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _loadData();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildHeader(l10n),
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadData,
              displacement: 30,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VisitOptionsSection(
                      onClinicTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AllLabServicesScreen()),
                        );
                      },
                      onHomeTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DirectServicesScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const AdBanner(),
                    const SizedBox(height: 24),
                    TestTypesSection(
                      testTypes: testTypes,
                      onSeeAllTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllLabServicesScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.availableDoctors,
                            style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.black,
                              letterSpacing: -.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DirectServicesScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                    const SizedBox(height: 15),
                    AvailableDoctorsSection(doctors: availableDoctors),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final profile = authStore.currentProfile;
    final displayName =
        (profile?.firstName?.isNotEmpty ?? false) ? profile!.firstName : profile?.displayName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    displayName ?? l10n.welcome,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _waveAnimation.value,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    "assets/images/hand.png",
                    height: 35,
                    width: 35,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onNavigateToProfile,
            child: ProfileAvatar(
              avatarUrl: profile?.getAvatarUrl(),
              initials: profile?.initials ?? 'U',
              radius: 27,
            ),
          ),
        ],
      ),
    );
  }

}
