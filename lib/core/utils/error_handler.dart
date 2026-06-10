import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// Translates raw/technical errors into short, user-friendly, localized text.
///
/// Accepts either an error object or its string form. Matches on the common
/// failure signatures (network, timeout, auth, server) and falls back to a
/// generic "something went wrong" message — never the raw exception.
String friendlyErrorMessage(AppLocalizations l10n, Object? error) {
  final text = error?.toString().toLowerCase() ?? '';

  if (text.isEmpty) return l10n.somethingWentWrong;

  if (text.contains('socketexception') ||
      text.contains('failed host lookup') ||
      text.contains('no address associated') ||
      text.contains('clientexception') ||
      text.contains('connection closed') ||
      text.contains('connection refused') ||
      text.contains('network is unreachable') ||
      text.contains('handshakeexception')) {
    return l10n.networkError;
  }

  if (text.contains('timeout') || text.contains('timed out')) {
    return l10n.connectionTimedOut;
  }

  if (text.contains('authexception') ||
      text.contains('jwt') ||
      text.contains('unauthorized') ||
      text.contains('401') ||
      text.contains('invalid login') ||
      text.contains('session')) {
    return l10n.sessionExpired;
  }

  if (text.contains('postgrestexception') ||
      text.contains('internal server error') ||
      text.contains('statuscode: 5') ||
      text.contains(' 500') ||
      text.contains(' 502') ||
      text.contains(' 503')) {
    return l10n.serverError;
  }

  return l10n.somethingWentWrong;
}

/// Installs app-wide error handlers so users never see Flutter's raw red error
/// screen or an unhandled-exception crash. Technical details still go to the
/// console (and are where a crash reporter like Crashlytics/Sentry would hook
/// in). Call once, before `runApp`.
void installGlobalErrorHandlers() {
  // Framework (build/layout/paint) errors.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); // keeps full detail in the dev console
    // TODO(prod): forward `details.exception` / `details.stack` to Crashlytics
    // or Sentry here so errors from real devices are collected.
  };

  // Uncaught async errors that reach the platform dispatcher.
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('Uncaught async error: $error');
    }
    // TODO(prod): forward to a crash reporter here.
    return true; // handled — don't crash the app
  };

  // Replace the red "error widget" with a calm, branded fallback.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const _FriendlyErrorView();
  };
}

class _FriendlyErrorView extends StatelessWidget {
  const _FriendlyErrorView();

  @override
  Widget build(BuildContext context) {
    // Localizations may be unavailable this low in the tree, so fall back to a
    // neutral bilingual message.
    final l10n = AppLocalizations.of(context);
    final message = l10n?.somethingWentWrong ??
        'Something went wrong. Please restart the app.\n'
            'Алдаа гарлаа. Аппликейшнээ дахин эхлүүлнэ үү.';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: AppColors.scaffoldBackground,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 56, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
