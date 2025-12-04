import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';

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
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
      decoration: InputDecoration(
        hintText: hint,
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
