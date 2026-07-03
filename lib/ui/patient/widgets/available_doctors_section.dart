import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/stores/home_store.dart';
import 'package:bugamed/ui/patient/models/doctor_profile_ui.dart';
import 'package:bugamed/ui/patient/screens/doctor_detail_screen.dart';
import 'package:bugamed/ui/patient/widgets/doctor_card_tile.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class AvailableDoctorsSection extends StatelessWidget {
  const AvailableDoctorsSection({
    super.key,
    required this.doctors,
  });

  final List<Map<String, dynamic>> doctors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (doctors.isEmpty) {
      return Center(
        child: Padding(
          padding: AppPadding.screenAll,
          child: Text(
            l10n.noDoctorsAvailable,
            style: AppTypography.bodySm,
          ),
        ),
      );
    }

    final uiDoctors =
        doctors.map((e) => DoctorProfileUI.fromMap(e)).toList();

    final displayDoctors = uiDoctors.take(maxDoctorsOnHome).toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: AppPadding.screenH,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        mainAxisExtent: 110,
      ),
      itemCount: displayDoctors.length,
      itemBuilder: (context, index) {
        final doctor = displayDoctors[index];
        return DoctorCardTile(
          doctor: doctor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorDetailScreen(doctor: doctor),
              ),
            );
          },
        );
      },
    );
  }
}
