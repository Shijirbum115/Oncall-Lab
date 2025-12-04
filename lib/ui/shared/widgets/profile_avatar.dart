import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/utils/avatar_helper.dart';

/// A widget that displays a user's profile avatar
/// Handles both network images (custom avatars) and asset images (default avatars)
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.initials,
    this.radius = 27,
    this.backgroundColor,
  });

  final String? avatarUrl;
  final String initials;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? AppColors.primary.withValues(alpha: 0.2);

    // If no avatar URL, show initials
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: radius * 0.8,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );
    }

    // Check if it's a default avatar (from assets)
    final isDefaultAvatar = AvatarHelper.isDefaultAvatar(avatarUrl);

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      backgroundImage: isDefaultAvatar
          ? AssetImage(avatarUrl!) as ImageProvider
          : NetworkImage(avatarUrl!),
      onBackgroundImageError: (exception, stackTrace) {
        // If image fails to load, we'll show initials instead
        debugPrint('Error loading avatar: $exception');
      },
      child: null, // Don't show initials if we have an image
    );
  }
}
