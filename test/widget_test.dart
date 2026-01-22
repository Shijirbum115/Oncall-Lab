// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bugamed/main.dart';
import 'package:bugamed/stores/auth_store.dart';

void main() {
  testWidgets('Shows login screen when not authenticated', (tester) async {
    authStore
      ..isInitializing = false
      ..currentUser = null
      ..currentProfile = null;

    await tester.pumpWidget(const OnCallLabApp());

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
