import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/core/services/push_notification_service.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/di/service_locator.dart';
import 'package:bugamed/core/utils/error_handler.dart';
import 'package:bugamed/core/utils/navigation_helper.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/locale_store.dart';
import 'package:bugamed/stores/notification_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/ui/patient/main_page.dart';
import 'package:bugamed/ui/doctor/doctor_main_page.dart';
import 'package:bugamed/ui/shared/splash_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch framework + uncaught async errors and show a friendly fallback
  // instead of Flutter's raw red error screen.
  installGlobalErrorHandlers();

  // Load environment variables (skip on web if file doesn't exist)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      print('⚠️  .env file not found or could not be loaded: $e');
      print('ℹ️  App will use default configuration');
    }
  }

  // Initialize Firebase (optional - required for push notifications)
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    if (kDebugMode) print('✅ Firebase initialized successfully');
  } catch (e) {
    if (kDebugMode) {
      print('⚠️  Firebase initialization failed: $e');
      print('📱 App will run without push notifications');
      print('ℹ️  To enable push notifications, run: flutterfire configure');
    }
  }

  await setupServiceLocator();

  // Initialize Supabase
  await SupabaseService.initialize();
  await authStore.initialize();
  await localeStore.initialize();

  // Initialize push notifications only if Firebase is available
  if (firebaseInitialized) {
    try {
      final pushService = locator<PushNotificationService>();
      await pushService.initialize();

      // Initialize notification store if user is authenticated
      if (authStore.isAuthenticated && authStore.currentProfile != null) {
        final notificationStore = locator<NotificationStore>();
        await notificationStore.initialize(authStore.currentProfile!.id);
        await notificationStore.updateFcmToken(authStore.currentProfile!.id);
      }
    } catch (e) {
      if (kDebugMode) print('⚠️  Push notification setup failed: $e');
    }
  }

  runApp(const CallCareApp());
}

class CallCareApp extends StatelessWidget {
  const CallCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: 'CallCare',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey, // Global navigator key for push notifications
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
        // Allow unauthenticated users to browse the app
        // Authentication is only required for payments and booking services
        
        if (authStore.isAuthenticated) {
          // Authenticated users get role-specific experiences
          if (authStore.isPatient) {
            return const MainPage();
          }

          if (authStore.isDoctor) {
            return const DoctorMainPage();
          }

          if (authStore.isAdmin) {
            return const _RolePlaceholderScreen(roleName: 'Admin');
          }
        }

        // Unauthenticated users can browse as patients (with limited features)
        // They'll be prompted to login when trying to book or make payments
        return const MainPage();
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
