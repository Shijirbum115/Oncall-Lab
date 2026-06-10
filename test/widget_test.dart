import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:bugamed/data/repositories/auth_repository.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/locale_store.dart';
import 'package:bugamed/ui/auth/login_screen.dart';

void main() {
  setUpAll(() {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<AuthStore>()) {
      getIt.registerSingleton<AuthStore>(AuthStore(AuthRepository()));
    }
    if (!getIt.isRegistered<LocaleStore>()) {
      getIt.registerSingleton<LocaleStore>(LocaleStore());
    }
  });

  testWidgets('Login screen renders the phone + password form', (tester) async {
    authStore
      ..isInitializing = false
      ..currentUser = null
      ..currentProfile = null;

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('CallCare'), findsOneWidget);
  });
}
