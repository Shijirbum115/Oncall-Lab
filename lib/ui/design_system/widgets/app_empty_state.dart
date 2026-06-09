import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';

enum AppEmptyEmotion {
  loading,
  searching,
  happy,
  empty,
  sleeping,
  error,
  onTheWay,
  welcome,
  collected,
  verified,
  noWifi,
  canceled,
  greenSample,
}

/// Full-screen empty / error / loading state with the deer mascot shown at
/// 50% opacity. Replaces the heavier `MascotStateWidget`.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.emotion,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  final AppEmptyEmotion emotion;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  String _getAssetPath() {
    const basePath = 'assets/images/mascot/';
    return switch (emotion) {
      AppEmptyEmotion.loading => '${basePath}deer_loading.jpeg',
      AppEmptyEmotion.searching => '${basePath}deer_searching.jpeg',
      AppEmptyEmotion.happy => '${basePath}deer_happy.jpeg',
      AppEmptyEmotion.empty => '${basePath}deer_empty_appts.jpeg',
      AppEmptyEmotion.sleeping => '${basePath}deer_sleeping.jpeg',
      AppEmptyEmotion.error => '${basePath}deer_error.jpeg',
      AppEmptyEmotion.onTheWay => '${basePath}deer_on_the_way.jpeg',
      AppEmptyEmotion.welcome => '${basePath}deer_welcome.jpeg',
      AppEmptyEmotion.collected => '${basePath}deer_collected.jpeg',
      AppEmptyEmotion.verified => '${basePath}deer_verified_doctor.jpeg',
      AppEmptyEmotion.noWifi => '${basePath}deer_no_wifi.jpeg',
      AppEmptyEmotion.canceled => '${basePath}deer_canceled.jpeg',
      AppEmptyEmotion.greenSample => '${basePath}deer_green_sample.jpeg',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              _getAssetPath(),
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleMedium,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
          ],
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 24),
            AppButton(
              label: actionText!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
