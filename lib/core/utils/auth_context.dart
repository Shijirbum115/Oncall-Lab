import 'package:flutter/material.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/auth/login_screen.dart';

/// Authentication context helper for optional authentication flow
/// 
/// Use this helper to check if user is authenticated before performing
/// actions that require authentication (e.g., payments, booking services)
class AuthContext {
  /// Check if user is authenticated and navigate to login if not
  /// 
  /// Returns true if user is authenticated, false if navigation to login occurred
  /// 
  /// Example usage:
  /// ```dart
  /// if (await AuthContext.requireAuth(context, reason: 'book an appointment')) {
  ///   // User is authenticated, proceed with booking
  ///   await bookAppointment();
  /// }
  /// ```
  static Future<bool> requireAuth(
    BuildContext context, {
    String? reason,
    VoidCallback? onAuthSuccess,
  }) async {
    if (authStore.isAuthenticated) {
      return true;
    }

    // Navigate to login screen with reason message
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          message: reason != null 
            ? 'Please sign in to $reason'
            : 'Please sign in to continue',
          onLoginSuccess: onAuthSuccess,
        ),
      ),
    );

    // Return true if login was successful
    return result == true && authStore.isAuthenticated;
  }

  /// Check if user has a specific role
  static bool hasRole(String role) {
    if (!authStore.isAuthenticated) return false;
    
    switch (role.toLowerCase()) {
      case 'patient':
        return authStore.isPatient;
      case 'doctor':
        return authStore.isDoctor;
      case 'admin':
        return authStore.isAdmin;
      default:
        return false;
    }
  }

  /// Show a dialog prompting user to sign in
  static Future<bool> showAuthRequiredDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );

    if (result == true) {
      return await requireAuth(context);
    }

    return false;
  }

  /// Check if user can perform action, returns error message if not
  static String? canPerformAction(String action) {
    switch (action) {
      case 'book_appointment':
      case 'make_payment':
      case 'view_results':
      case 'chat_with_doctor':
        if (!authStore.isAuthenticated) {
          return 'Please sign in to $action';
        }
        break;
      case 'view_home':
      case 'browse_services':
      case 'view_info':
        // These actions don't require authentication
        return null;
      default:
        return 'Unknown action';
    }
    return null;
  }
}
