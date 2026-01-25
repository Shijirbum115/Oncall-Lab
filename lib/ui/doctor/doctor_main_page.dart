import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/doctor/doctor_dashboard_screen.dart';
import 'package:bugamed/ui/doctor/doctor_profile_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DoctorMainPage extends StatefulWidget {
  const DoctorMainPage({super.key});

  @override
  State<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DoctorDashboardScreen(),
    DoctorProfileScreen(),
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
            icon: const Icon(Iconsax.clipboard_text),
            label: l10n.dashboard,
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
