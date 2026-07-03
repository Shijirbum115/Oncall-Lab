import 'package:flutter/material.dart';

/// Single source of truth for color tokens.
/// No screen, widget, or store outside `lib/ui/design_system/` may define
/// its own hex value. Use these tokens.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF338A68);
  static const Color primaryDark = Color(0xFF2C7A5F);
  static Color get primarySoft => primary.withValues(alpha: 0.12);

  // Neutrals
  static const Color ink = Color(0xFF1A1D1F);
  static const Color inkMuted = Color(0xFF6F7378);
  static const Color inkSubtle = Color(0xFFA2A8B4);
  static const Color border = Color(0xFFECEEF1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FA);

  // Status (gently muted to harmonize with teal)
  static const Color pending = Color(0xFFE89B3C);
  static const Color accepted = Color(0xFF3F88C5);
  static const Color onTheWay = Color(0xFF3F88C5);
  static const Color sampleCollected = Color(0xFF5BA86A);
  static const Color deliveredToLab = Color(0xFF5BA86A);
  static const Color completed = primary;
  static const Color cancelled = Color(0xFFD8543C);

  // Semantic aliases of the toned palette
  static const Color success = sampleCollected;
  static const Color error = cancelled;
  static const Color warning = pending;
  static const Color info = accepted;

  // Doctor pastels (slightly desaturated for harmony)
  static const List<Color> doctorCardColors = [
    Color(0xFFF6BFC1), // Pink
    Color(0xFFEFCBA9), // Peach
    Color(0xFFC3C9F0), // Lavender
    Color(0xFFD6E2EF), // Light Blue
    Color(0xFFBFD9C0), // Light Green
  ];

  // Service category icons (toned ~10% softer)
  static const List<Color> serviceCategoryColors = [
    Color(0xFF338868), // primary teal
    Color(0xFF3F88C5), // blue
    Color(0xFF7259B5), // purple
    Color(0xFFE56A3D), // deep orange
    Color(0xFF26A69A), // teal
    Color(0xFFD83C73), // pink
    Color(0xFF5462B0), // indigo
    Color(0xFF5BA86A), // green
    Color(0xFFE89B3C), // amber
    Color(0xFF3FA0DD), // light blue
  ];

  // ---- Backward-compat aliases (removed in cleanup task) ----
  // These let existing screens keep building during the per-screen sweep.
  static const Color grey = inkSubtle;
  static const Color black = ink;
  static const Color white = surface;
  static const Color textPrimary = ink;
  static const Color textSecondary = inkMuted;
  static const Color secondary = primaryDark;
  static const Color cardBackground = surface;
  static const Color scaffoldBackground = background;
  static const Color accent = pending;

  // ---- Helpers ----
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return pending;
      case 'accepted':
        return accepted;
      case 'on_the_way':
      case 'ontheway':
        return onTheWay;
      case 'sample_collected':
      case 'samplecollected':
        return sampleCollected;
      case 'delivered_to_lab':
      case 'deliveredtolab':
        return deliveredToLab;
      case 'completed':
        return completed;
      case 'cancelled':
        return cancelled;
      default:
        return inkSubtle;
    }
  }

  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'on_the_way':
      case 'ontheway':
        return 'On the Way';
      case 'sample_collected':
      case 'samplecollected':
        return 'Sample Collected';
      case 'delivered_to_lab':
      case 'deliveredtolab':
        return 'Delivered to Lab';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  static Color getDoctorCardColor(int index) =>
      doctorCardColors[index % doctorCardColors.length];

  static Color getServiceCategoryColor(int index) =>
      serviceCategoryColors[index % serviceCategoryColors.length];
}
