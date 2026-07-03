import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  static final List<BoxShadow> resting = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> raised = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> floating = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  // Backward-compat aliases while callers migrate.
  static List<BoxShadow> get sm => resting;
  static List<BoxShadow> get md => raised;
}
