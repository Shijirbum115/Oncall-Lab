import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/data/models/notification_model.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/patient/requests_screen.dart';
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.notificationDetails,
          style: AppTypography.h3.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Mascot with appropriate emotion
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Image.asset(
                  _getMascotAssetPath(),
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Badge
                    FadeInLeft(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
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
                              style: AppTypography.bodySm.copyWith(
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Title
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        notification.title,
                        style: AppTypography.h2.copyWith(
                          fontSize: 24,
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Message
                    FadeInLeft(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        notification.message,
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.inkMuted,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Time
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 600),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.clock,
                            size: 18,
                            color: AppColors.inkSubtle,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            _formatDate(notification.createdAt),
                            style: AppTypography.body.copyWith(
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Metadata if available
                    if (notification.metadata != null &&
                        notification.metadata!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.additionalInfo,
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ...notification.metadata!.entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.xs,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${entry.key}:',
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.inkMuted,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Expanded(
                                        child: Text(
                                          entry.value.toString(),
                                          style: AppTypography.bodySm.copyWith(
                                            color: AppColors.ink,
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

                    const SizedBox(height: AppSpacing.xl),

                    // Action button if there's a related request
                    if (notification.relatedRequestId != null)
                      FadeInUp(
                        delay: const Duration(milliseconds: 700),
                        duration: const Duration(milliseconds: 600),
                        child: AppButton(
                          label: l10n.viewRequest,
                          icon: Iconsax.document_text,
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
                        ),
                      ),

                    const SizedBox(height: AppSpacing.xl),
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
