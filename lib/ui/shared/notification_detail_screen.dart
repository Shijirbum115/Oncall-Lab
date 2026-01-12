import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/data/models/notification_model.dart';
import 'package:oncall_lab/ui/shared/widgets/mascot_state_widget.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/patient/requests_screen.dart';
import 'package:animate_do/animate_do.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  MascotEmotion _getMascotForType(NotificationType type) {
    switch (type) {
      case NotificationType.requestCreated:
        return MascotEmotion.loading;
      case NotificationType.requestAccepted:
        return MascotEmotion.happy;
      case NotificationType.requestUpdated:
        return MascotEmotion.onTheWay;
      case NotificationType.statusChanged:
        return MascotEmotion.collected;
      case NotificationType.systemAlert:
        return MascotEmotion.error;
    }
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.requestCreated:
        return Iconsax.add_circle;
      case NotificationType.requestAccepted:
        return Iconsax.tick_circle;
      case NotificationType.requestUpdated:
        return Iconsax.refresh;
      case NotificationType.statusChanged:
        return Iconsax.repeat;
      case NotificationType.systemAlert:
        return Iconsax.info_circle;
    }
  }

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.requestCreated:
        return AppColors.info;
      case NotificationType.requestAccepted:
        return AppColors.success;
      case NotificationType.requestUpdated:
        return AppColors.warning;
      case NotificationType.statusChanged:
        return AppColors.primary;
      case NotificationType.systemAlert:
        return AppColors.error;
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.requestCreated:
        return 'Request Created';
      case NotificationType.requestAccepted:
        return 'Request Accepted';
      case NotificationType.requestUpdated:
        return 'Request Updated';
      case NotificationType.statusChanged:
        return 'Status Changed';
      case NotificationType.systemAlert:
        return 'System Alert';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _getColor(notification.type);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.notificationDetails,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Mascot with appropriate emotion
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Image.asset(
                  _getMascotAssetPath(),
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Badge
                    FadeInLeft(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getIcon(notification.type),
                              size: 16,
                              color: color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getTypeLabel(notification.type),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Message
                    FadeInLeft(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 600),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(notification.createdAt),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Metadata if available
                    if (notification.metadata != null &&
                        notification.metadata!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.additionalInfo,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...notification.metadata!.entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${entry.key}:',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          entry.value.toString(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Action button if there's a related request
                    if (notification.relatedRequestId != null)
                      FadeInUp(
                        delay: const Duration(milliseconds: 700),
                        duration: const Duration(milliseconds: 600),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to requests screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PatientRequestsScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Iconsax.document_text, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.viewRequest,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMascotAssetPath() {
    const basePath = 'assets/images/mascot/';
    switch (_getMascotForType(notification.type)) {
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy \'at\' h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
