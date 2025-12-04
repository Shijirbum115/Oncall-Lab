import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/di/service_locator.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/locale_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oncall_lab/ui/auth/login_screen.dart';
import 'package:oncall_lab/ui/patient/main_page.dart';
import 'package:oncall_lab/ui/doctor/doctor_main_page.dart';
import 'package:oncall_lab/ui/shared/splash_screen.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/design_system/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  // Initialize Supabase
  await SupabaseService.initialize();
  await authStore.initialize();
  await localeStore.initialize();

  runApp(const OnCallLabApp());
}

class OnCallLabApp extends StatelessWidget {
  const OnCallLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: 'OnCall Lab',
        debugShowCheckedModeBanner: false,
        // Localization support
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('mn'), // Mongolian
        ],
        locale: localeStore.currentLocale,
        theme: AppTheme.light(),
        home: const SplashWrapper(
          child: AuthGate(),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!authStore.isAuthenticated) {
          return const LoginScreen();
        }

        if (authStore.isPatient) {
          return const MainPage();
        }

        if (authStore.isDoctor) {
          return const DoctorMainPage();
        }

        if (authStore.isAdmin) {
          return const _RolePlaceholderScreen(roleName: 'Admin');
        }

        return const LoginScreen();
      },
    );
  }
}

class _RolePlaceholderScreen extends StatelessWidget {
  const _RolePlaceholderScreen({required this.roleName});

  final String roleName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.build_circle_outlined,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '$roleName experience coming soon!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'We are finalizing the dedicated dashboard for this role. '
                'Please check back later or sign out to switch accounts.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => authStore.signOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
