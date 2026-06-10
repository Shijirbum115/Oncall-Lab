import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/patient/home_screen.dart';
import 'package:bugamed/ui/patient/requests_screen.dart';
import 'package:bugamed/ui/patient/profile_screen.dart';
import 'package:bugamed/ui/patient/ai_assistant/callcare_ai_bot_screen.dart';
import 'package:bugamed/ui/auth/login_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// CallCare patient shell: 4 docked tabs with stable indices.
///
/// Guests see the same 4 tabs; protected tabs (Bookings, Assistant, Profile)
/// render a sign-in prompt instead of renumbering the bar.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  AuthStore get authStore => GetIt.I<AuthStore>();

  void _onTabSwitch(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (context) {
        final isAuthenticated = authStore.isAuthenticated;

        final pages = <Widget>[
          PatientHomeScreen(
            onNavigateToProfile: () => _onTabSwitch(3),
            onNavigateToBookings: () => _onTabSwitch(1),
            onNavigateToAssistant: () => _onTabSwitch(2),
          ),
          isAuthenticated
              ? const PatientRequestsScreen()
              : _GuestSignInPanel(l10n: l10n),
          isAuthenticated
              ? const CallCareAiBotScreen(embedded: true)
              : _GuestSignInPanel(l10n: l10n),
          isAuthenticated
              ? const PatientProfileScreen()
              : _GuestSignInPanel(l10n: l10n),
        ];

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
              onDestinationSelected: _onTabSwitch,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Iconsax.home_1),
                  selectedIcon: const Icon(Iconsax.home_15),
                  label: l10n.home,
                ),
                NavigationDestination(
                  icon: const Icon(Iconsax.calendar_1),
                  selectedIcon: const Icon(Iconsax.calendar5),
                  label: l10n.bookingsTab,
                ),
                NavigationDestination(
                  icon: const Icon(Iconsax.message_question),
                  selectedIcon: const Icon(Iconsax.message5),
                  label: l10n.assistantTab,
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
      },
    );
  }
}

/// Shown inside protected tabs when the user is not signed in.
class _GuestSignInPanel extends StatelessWidget {
  const _GuestSignInPanel({required this.l10n});

  final AppLocalizations l10n;

  Future<void> _openLogin(BuildContext context) async {
    await Navigator.push<bool>(
      context,
      CupertinoPageRoute(builder: (_) => const LoginScreen()),
    );
    // Auth state is observed by MainPage; on success the tab re-renders.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradientSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.lock_1,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.signInToContinue,
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.signInPromptBody,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.signIn,
                onPressed: () => _openLogin(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
