import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/data/repositories/doctor_review_repository.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_bottom_sheet.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';

/// Star-rating sheet shown after a request completes.
/// Returns `true` when a review was submitted.
Future<bool?> showRateDoctorSheet(
  BuildContext context, {
  required TestRequestModel request,
  required String patientId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _RateDoctorSheet(request: request, patientId: patientId),
    ),
  );
}

class _RateDoctorSheet extends StatefulWidget {
  const _RateDoctorSheet({required this.request, required this.patientId});

  final TestRequestModel request;
  final String patientId;

  @override
  State<_RateDoctorSheet> createState() => _RateDoctorSheetState();
}

class _RateDoctorSheetState extends State<_RateDoctorSheet> {
  int _rating = 0;
  bool _submitting = false;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final doctorId = widget.request.doctorId;
    if (doctorId == null || _rating == 0) return;

    setState(() => _submitting = true);
    try {
      await GetIt.I<DoctorReviewRepository>().createReview(
        doctorId: doctorId,
        patientId: widget.patientId,
        testRequestId: widget.request.id,
        rating: _rating.toDouble(),
        reviewText: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.ratingSubmitted),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.somethingWentWrong),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBottomSheet(
      title: l10n.rateDoctor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.howWasYourExperience, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                final filled = i < _rating;
                return IconButton(
                  onPressed: () => setState(() => _rating = i + 1),
                  icon: Icon(
                    filled ? Iconsax.star1 : Iconsax.star,
                    size: 38,
                    color: filled
                        ? const Color(0xFFF59E0B)
                        : AppColors.grey.withValues(alpha: 0.5),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _commentController,
            hint: l10n.addCommentOptional,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: l10n.submitRating,
            loading: _submitting,
            onPressed: _rating == 0 ? null : _submit,
          ),
        ],
      ),
    );
  }
}
