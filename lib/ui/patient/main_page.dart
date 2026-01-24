import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/ui/patient/home_screen.dart';
import 'package:oncall_lab/ui/patient/laboratories_screen.dart';
import 'package:oncall_lab/ui/patient/requests_screen.dart';
import 'package:oncall_lab/ui/patient/profile_screen.dart';
import 'package:oncall_lab/ui/auth/login_screen.dart';
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
  
  AuthStore get authStore => GetIt.I<AuthStore>();

  List<Widget> _getPagesForAuthenticated() => [
    PatientHomeScreen(onNavigateToProfile: () => _onTabSwitch(3)),
    const LaboratoriesScreen(),
    const PatientRequestsScreen(),
    const PatientProfileScreen(),
  ];

  List<Widget> _getPagesForGuest() => [
    PatientHomeScreen(onNavigateToProfile: () => _onTabSwitch(2)),
    const LaboratoriesScreen(),
    LoginScreen(
      onLoginSuccess: () {
        setState(() {
          selectedIndex = 0; // Reset to home after login
        });
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (context) {
        final isAuthenticated = authStore.isAuthenticated;
        final pages = isAuthenticated ? _getPagesForAuthenticated() : _getPagesForGuest();
        
        // Ensure selectedIndex is within bounds
        if (selectedIndex >= pages.length) {
          selectedIndex = 0;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Main content
              IndexedStack(
                index: selectedIndex,
                children: pages,
              ),

              // Floating Navigation Bar
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BottomNavigationBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      unselectedItemColor: AppColors.grey,
                      selectedItemColor: AppColors.primary,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: selectedIndex,
                      selectedFontSize: 12,
                      unselectedFontSize: 12,
                      showUnselectedLabels: true,
                      onTap: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      items: isAuthenticated
                          ? [
                              _buildNavItem(Iconsax.home5, Iconsax.home_15, l10n.home, 0),
                              _buildNavItem(Iconsax.building, Iconsax.building5, l10n.laboratories, 1),
                              _buildNavItem(Iconsax.calendar, Iconsax.calendar5, l10n.requests, 2),
                              _buildNavItem(Icons.person_outline, Icons.person, l10n.profile, 3),
                            ]
                          : [
                              _buildNavItem(Iconsax.home5, Iconsax.home_15, l10n.home, 0),
                              _buildNavItem(Iconsax.building, Iconsax.building5, l10n.laboratories, 1),
                              _buildNavItem(Icons.login_outlined, Icons.login, l10n.login, 2),
                            ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, IconData activeIcon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(icon),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(activeIcon),
      ),
      label: label,
    );
  }
}
