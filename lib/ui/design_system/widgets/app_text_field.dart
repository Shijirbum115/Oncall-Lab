import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: enabled
            ? AppColors.grey.withValues(alpha: 0.08)
            : AppColors.grey.withValues(alpha: 0.16),
      ),
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    return TextField(
      controller: ctrl,
      onChanged: onChanged,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
        prefixIcon: Icon(prefixIcon ?? Icons.search,
            color: AppColors.textSecondary.withValues(alpha: 0.7)),
        suffixIcon: ctrl != null && ctrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.grey),
                onPressed: onClear,
              )
            : null,
      ),
    );
  }
}
