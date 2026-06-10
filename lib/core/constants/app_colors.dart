import 'package:flutter/material.dart';

/// CallCare color system — "CallCare Coral".
///
/// Brand: red→pink gradient (#E2334F → #F97C92) on white/warm-neutral
/// surfaces. Error is a deep brick red, visually distinct from brand coral,
/// and must always be paired with an icon + label (never color alone).
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------
  static const Color primary = Color(0xFFE2334F); // CallCare Coral
  static const Color primaryDark = Color(0xFFC2253E); // pressed / emphasis
  static const Color secondary = Color(0xFFF97C92); // CallCare Pink
  static const Color accent = Color(0xFFFFB84D); // warm highlight (sparingly)

  /// Hero gradient: coral → pink. Used on primary CTAs and hero surfaces.
  static const Gradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  /// Soft variant for large background surfaces (subtle, not loud).
  static const Gradient brandGradientSoft = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDE2E7), Color(0xFFFEF1F3)],
  );

  // Coral tonal ramp
  static const Color red50 = Color(0xFFFEF1F3);
  static const Color red100 = Color(0xFFFDE2E7);
  static const Color red200 = Color(0xFFFBC0CB);
  static const Color red500 = primary;
  static const Color red700 = Color(0xFFA81F38);
  static const Color red900 = Color(0xFF7A1226);

  // ---------------------------------------------------------------------
  // Neutrals & text (WCAG AA on white)
  // ---------------------------------------------------------------------
  static const Color black = Color(0xFF1C1F26); // near-black, warm
  static const Color white = Color(0xFFFFFFFF);

  static const Color textPrimary = black; // 15.4:1
  static const Color textSecondary = Color(0xFF5C6470); // 6.3:1
  static const Color textTertiary = Color(0xFF6B7280); // 4.8:1 — min for text

  /// Decorative grey: icons, borders, dividers. NOT for text.
  static const Color grey = Color(0xFF8B92A0);

  static const Color outline = Color(0xFFE6E8EC);
  static const Color background = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color scaffoldBackground = Colors.white;

  // ---------------------------------------------------------------------
  // Semantic (distinct from brand)
  // ---------------------------------------------------------------------
  static const Color success = Color(0xFF15803D);
  static const Color error = Color(0xFFB3261E); // deep brick ≠ brand coral
  static const Color warning = Color(0xFFB45309);
  static const Color info = Color(0xFF1D4ED8);

  // ---------------------------------------------------------------------
  // Request status
  //
  // Philosophy: the StatusTimeline tells the story by *position*; pills use
  // brand coral for any in-progress step, green when done, neutral when
  // cancelled. Pending is amber ("waiting for a doctor").
  // ---------------------------------------------------------------------
  static const Color pending = warning;
  static const Color accepted = primary;
  static const Color onTheWay = primary;
  static const Color sampleCollected = primary;
  static const Color deliveredToLab = primary;
  static const Color completed = success;
  static const Color cancelled = Color(0xFF6B7280);

  /// Get status color by status string
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
        return grey;
    }
  }

  /// Get readable status text
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

  // ---------------------------------------------------------------------
  // Decorative palettes (cards, category icons) — harmonized with brand
  // ---------------------------------------------------------------------
  static const List<Color> doctorCardColors = [
    Color(0xFFFDE2E7), // pink
    Color(0xFFFEEBDD), // peach
    Color(0xFFE9EAFD), // lavender
    Color(0xFFE3F0FB), // light blue
    Color(0xFFDFF3E4), // light green
  ];

  /// Get doctor card color by index
  static Color getDoctorCardColor(int index) {
    return doctorCardColors[index % doctorCardColors.length];
  }

  /// Colors for service category grid icons
  static const List<Color> serviceCategoryColors = [
    Color(0xFFE2334F), // brand coral
    Color(0xFF3B82F6), // blue
    Color(0xFF8B5CF6), // violet
    Color(0xFFF97316), // orange
    Color(0xFF14B8A6), // teal
    Color(0xFFEC4899), // pink
    Color(0xFF6366F1), // indigo
    Color(0xFF22C55E), // green
    Color(0xFFF59E0B), // amber
    Color(0xFF0EA5E9), // sky
  ];

  /// Get a category color by index, cycling through the palette
  static Color getServiceCategoryColor(int index) {
    return serviceCategoryColors[index % serviceCategoryColors.length];
  }
}
