import 'package:flutter/cupertino.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/core/constants/app_colors.dart';
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
          padding: const EdgeInsets.all(20),
          child: Text(
            l10n.noDoctorsAvailable,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey,
            ),
          ),
        ),
      );
    }

    final uiDoctors =
        doctors.map((e) => DoctorProfileUI.fromMap(e)).toList();

    // Show maximum doctors on home screen (defined in HomeStore)
    final displayDoctors = uiDoctors.take(maxDoctorsOnHome).toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
              CupertinoPageRoute(
                builder: (_) => DoctorDetailScreen(doctor: doctor),
              ),
            );
          },
        );
      },
    );
  }
}
