import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';

enum MascotEmotion {
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

class MascotStateWidget extends StatelessWidget {
  final MascotEmotion emotion;
  final String title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionText;

  const MascotStateWidget({
    super.key,
    required this.emotion,
    required this.title,
    this.subtitle,
    this.onAction,
    this.actionText,
  });

  String _getAssetPath() {
    const basePath = 'assets/images/mascot/';
    switch (emotion) {
      case MascotEmotion.loading:
        return '${basePath}deer_loading.jpeg';
      case MascotEmotion.searching:
        return '${basePath}deer_searching.jpeg';
      case MascotEmotion.happy:
        return '${basePath}deer_happy.jpeg';
      case MascotEmotion.empty:
        return '${basePath}deer_empty_appts.jpeg';
      case MascotEmotion.sleeping:
        return '${basePath}deer_sleeping.jpeg';
      case MascotEmotion.error:
        return '${basePath}deer_error.jpeg';
      case MascotEmotion.onTheWay:
        return '${basePath}deer_on_the_way.jpeg';
      case MascotEmotion.welcome:
        return '${basePath}deer_welcome.jpeg';
      case MascotEmotion.collected:
        return '${basePath}deer_collected.jpeg';
      case MascotEmotion.verified:
        return '${basePath}deer_verified_doctor.jpeg';
      case MascotEmotion.noWifi:
        return '${basePath}deer_no_wifi.jpeg';
      case MascotEmotion.canceled:
        return '${basePath}deer_canceled.jpeg';
      case MascotEmotion.greenSample:
        return '${basePath}deer_green_sample.jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            _getAssetPath(),
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          ],
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
