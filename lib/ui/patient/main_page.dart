import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/ui/patient/home_screen.dart';
import 'package:oncall_lab/ui/patient/laboratories_screen.dart';
import 'package:oncall_lab/ui/patient/requests_screen.dart';
import 'package:oncall_lab/ui/patient/profile_screen.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  void _onTabSwitch(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> get pages => [
    PatientHomeScreen(onNavigateToProfile: () => _onTabSwitch(3)),
    const LaboratoriesScreen(),
    const PatientRequestsScreen(),
    const PatientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black26,
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.home5),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.building),
            label: l10n.laboratories,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.calendar),
            label: l10n.requests,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
    );
  }
}
