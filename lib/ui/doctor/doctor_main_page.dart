import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/doctor_request_store.dart';
import 'package:bugamed/ui/doctor/doctor_dashboard_screen.dart';
import 'package:bugamed/ui/doctor/doctor_earnings_screen.dart';
import 'package:bugamed/ui/doctor/doctor_profile_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// CallCare doctor shell: 3 docked tabs (Dashboard, Earnings, Profile).
///
/// Real-time request subscriptions live here so they survive tab switches
/// and are cleaned up once when the doctor shell unmounts.
class DoctorMainPage extends StatefulWidget {
  const DoctorMainPage({super.key});

  @override
  State<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DoctorDashboardScreen(),
    DoctorEarningsScreen(),
    DoctorProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final doctorId = authStore.currentUser?.id;
    if (doctorId != null) {
      doctorRequestStore.subscribeToAvailableRequests();
      doctorRequestStore.subscribeToMyActiveRequests(doctorId);
      doctorRequestStore.loadMyCompletedRequests(doctorId);
    }
  }

  @override
  void dispose() {
    doctorRequestStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outline)),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() => selectedIndex = value);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Iconsax.clipboard_text),
              selectedIcon: const Icon(Iconsax.clipboard_text5),
              label: l10n.dashboard,
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.wallet_2),
              selectedIcon: const Icon(Iconsax.wallet5),
              label: l10n.earnings,
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.user),
              selectedIcon: const Icon(Iconsax.user),
              label: l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}
