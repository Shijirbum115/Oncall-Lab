import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/patient/home_screen.dart';
import 'package:bugamed/ui/patient/laboratories_screen.dart';
import 'package:bugamed/ui/patient/requests_screen.dart';
import 'package:bugamed/ui/patient/profile_screen.dart';
import 'package:bugamed/ui/auth/login_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';

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
              selectedIndex = 0;
            });
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Observer(
      builder: (context) {
        final isAuthenticated = authStore.isAuthenticated;
        final pages =
            isAuthenticated ? _getPagesForAuthenticated() : _getPagesForGuest();

        if (selectedIndex >= pages.length) {
          selectedIndex = 0;
        }

        final navItems = isAuthenticated
            ? [
                _NavItem(Iconsax.home_1, Iconsax.home_15, l10n.home),
                _NavItem(Iconsax.microscope, Iconsax.microscope, l10n.laboratories),
                _NavItem(Iconsax.calendar_1, Iconsax.calendar5, l10n.requests),
                _NavItem(Iconsax.user, Iconsax.user, l10n.profile),
              ]
            : [
                _NavItem(Iconsax.home_1, Iconsax.home_15, l10n.home),
                _NavItem(Iconsax.microscope, Iconsax.microscope, l10n.laboratories),
                _NavItem(Iconsax.login, Iconsax.login, l10n.login),
              ];

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Stack(
            children: [
              // Main content with bottom padding for navbar
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 70 + bottomPadding),
                  child: IndexedStack(
                    index: selectedIndex,
                    children: pages,
                  ),
                ),
              ),

              // Custom Floating Navigation Bar
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: 12 + bottomPadding,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: [
                      ...AppShadows.raised,
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(navItems.length, (index) {
                      final item = navItems[index];
                      final isSelected = selectedIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: _NavBarItem(
                            icon: item.icon,
                            activeIcon: item.activeIcon,
                            label: item.label,
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: 48,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primarySoft
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            isSelected ? activeIcon : icon,
            size: 22,
            color: isSelected ? AppColors.primary : AppColors.inkSubtle,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.label.copyWith(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.inkSubtle,
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
