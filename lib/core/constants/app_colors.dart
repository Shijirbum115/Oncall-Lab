import 'package:flutter/material.dart';

/// App-wide color constants
/// Design matching Doctor Appointment UI template
class AppColors {
  // Primary colors from Doctor Appointment UI
  static const Color primary = Color.fromARGB(255, 32, 179, 147); // greenish color
  static const Color grey = Color(0xFFA2A8B4);
  static const Color black = Color(0xFF2F2F32);
  static const Color white = Color(0xFFFFFFFF);

  // Secondary shades
  static const Color secondary = grey;
  static const Color textPrimary = black;
  static const Color textSecondary = Color(0xFF8A8A8A);

  // Status colors (matching database enum)
  static const Color pending = Color(0xFFFFA726);
  static const Color accepted = Color(0xFF42A5F5);
  static const Color onTheWay = Color(0xFF29B6F6);
  static const Color sampleCollected = Color(0xFF66BB6A);
  static const Color deliveredToLab = Color(0xFF9CCC65);
  static const Color completed = Color(0xFF26A69A);
  static const Color cancelled = Color(0xFFEF5350);

  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF5F6FA);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);

  // Doctor profile card colors (pastel colors from template)
  static const List<Color> doctorCardColors = [
    Color(0xFFffcdcf), // Pink
    Color(0xFFf9d8b9), // Peach
    Color(0xFFccd1fa), // Lavender
    Color(0xFFe1edf8), // Light Blue
    Color(0xFFc8e6c9), // Light Green
  ];

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

  /// Get doctor card color by index
  static Color getDoctorCardColor(int index) {
    return doctorCardColors[index % doctorCardColors.length];
  }
}
