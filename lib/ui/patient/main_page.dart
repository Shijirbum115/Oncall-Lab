import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/utils/notification_helper.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/patient/home_screen.dart';
import 'package:bugamed/ui/patient/laboratories_screen.dart';
import 'package:bugamed/ui/patient/requests_screen.dart';
import 'package:bugamed/ui/patient/profile_screen.dart';
import 'package:bugamed/ui/patient/ai_assistant/callcare_ai_bot_screen.dart';
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

  /// Opens the AI assistant — but only for signed-in users. Guests are nudged
  /// to the login tab so the chat interface only works after logging in.
  void _openAiAssistant(BuildContext context, AppLocalizations l10n,
      bool isAuthenticated, int loginTabIndex) {
    if (isAuthenticated) {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (_) => const CallCareAiBotScreen()),
      );
    } else {
      NotificationHelper.show(context, l10n.loginToUseAiAssistant);
      setState(() => selectedIndex = loginTabIndex);
    }
  }

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

        // The AI item is an *action* (pushes a screen / gates on login), not a
        // page in the IndexedStack — so page indices stay 0..n unchanged.
        void openAi() => _openAiAssistant(
            context, l10n, isAuthenticated, pages.length - 1);

        final navItems = isAuthenticated
            ? [
                _NavItem(Iconsax.home_1, Iconsax.home_15, l10n.home,
                    pageIndex: 0),
                _NavItem(Icons.smart_toy_outlined, Icons.smart_toy,
                    l10n.aiAssistant,
                    onTap: openAi),
                _NavItem(Iconsax.microscope, Iconsax.microscope,
                    l10n.laboratories,
                    pageIndex: 1),
                _NavItem(Iconsax.calendar_1, Iconsax.calendar5, l10n.requests,
                    pageIndex: 2),
                _NavItem(Iconsax.user, Iconsax.user, l10n.profile,
                    pageIndex: 3),
              ]
            : [
                _NavItem(Iconsax.home_1, Iconsax.home_15, l10n.home,
                    pageIndex: 0),
                _NavItem(Icons.smart_toy_outlined, Icons.smart_toy,
                    l10n.aiAssistant,
                    onTap: openAi),
                _NavItem(Iconsax.microscope, Iconsax.microscope,
                    l10n.laboratories,
                    pageIndex: 1),
                _NavItem(Iconsax.login, Iconsax.login, l10n.login,
                    pageIndex: 2),
              ];

        return Scaffold(
          backgroundColor: Colors.white,
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
                left: 16,
                right: 16,
                bottom: 12 + bottomPadding,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
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
                      final isSelected =
                          item.pageIndex != null && selectedIndex == item.pageIndex;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (item.onTap != null) {
                              item.onTap!();
                            } else {
                              setState(() => selectedIndex = item.pageIndex!);
                            }
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

  /// Index into the IndexedStack pages. Null for action items (e.g. AI).
  final int? pageIndex;

  /// Action to run instead of switching pages (e.g. push the AI screen).
  final VoidCallback? onTap;

  const _NavItem(
    this.icon,
    this.activeIcon,
    this.label, {
    this.pageIndex,
    this.onTap,
  });
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
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isSelected ? activeIcon : icon,
            size: 22,
            color: isSelected ? AppColors.primary : AppColors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.grey,
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
