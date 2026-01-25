import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/utils/avatar_helper.dart';
import 'package:bugamed/ui/patient/models/doctor_profile_ui.dart';
import 'package:bugamed/data/repositories/doctor_repository.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({
    super.key,
    required this.doctor,
  });

  final DoctorProfileUI doctor;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final _doctorRepository = DoctorRepository();
  Map<String, dynamic>? fullDoctorData;
  List<Map<String, dynamic>> doctorServices = [];
  bool isLoading = true;
  String? errorMessage;
  bool isReadMore = false;

  @override
  void initState() {
    super.initState();
    _loadDoctorDetails();
  }

  Future<void> _loadDoctorDetails() async {
    try {
      debugPrint('Loading details for doctor ID: ${widget.doctor.id}');
      debugPrint('Doctor name: ${widget.doctor.name}');

      final details = await _doctorRepository.getDoctorDetails(widget.doctor.id);
      final services = await _doctorRepository.getDoctorServices(widget.doctor.id);

      debugPrint('Successfully loaded doctor details');
      setState(() {
        fullDoctorData = details;
        doctorServices = services;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading doctor details for ID ${widget.doctor.id}: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        errorMessage = l10n.doctorProfileNotFound;
        isLoading = false;
      });
    }
  }

  String get displayBio {
    if (fullDoctorData?['bio'] != null && fullDoctorData!['bio'].toString().isNotEmpty) {
      return fullDoctorData!['bio'];
    }
    return '${widget.doctor.name.split(' ').first} is an experienced specialist dedicated to providing high-quality healthcare services. With years of experience in the field, they are committed to patient care and continuous professional development.';
  }

  String get displayLocation {
    final profile = fullDoctorData?['profiles'];
    if (profile?['permanent_address'] != null &&
        profile['permanent_address'].toString().isNotEmpty) {
      return profile['permanent_address'];
    }
    return 'Ulaanbaatar, Mongolia';
  }

  String? get photoUrl => fullDoctorData?['photo_url'];

  int get yearsOfExperience {
    return fullDoctorData?['years_of_experience'] as int? ??
           fullDoctorData?['work_experience_years'] as int? ?? 5;
  }

  int get consultationPrice {
    if (doctorServices.isNotEmpty) {
      return doctorServices.first['price_mnt'] ?? 55000;
    }
    return widget.doctor.price ?? 55000;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.info_circle, size: 64, color: AppColors.error),
                  const SizedBox(height: 20),
                  Text(
                    l10n.errorLoadingDoctorDetails,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      _loadDoctorDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Iconsax.refresh),
                    label: Text(l10n.retry),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.goBack),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Header
          _buildHeader(),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Space for fixed footer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Doctor Profile Header
                  _buildDoctorProfile(),

                  const SizedBox(height: 24),

                  // Stats Row
                  _buildStatsRow(),

                  const SizedBox(height: 24),

                  // About Section
                  _buildAboutSection(),

                  const SizedBox(height: 24),

                  // Working Hours Section
                  _buildWorkingHoursSection(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Footer with Book Appointment Button
      bottomNavigationBar: _buildFooter(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.grey),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              _buildIconButton(
                icon: Iconsax.arrow_left,
                onTap: () => Navigator.pop(context),
              ),

              // Action Buttons
              Row(
                children: [
                  _buildIconButton(
                    icon: Iconsax.share,
                    onTap: () {
                      // TODO: Implement share
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildIconButton(
                    icon: Iconsax.heart,
                    onTap: () {
                      // TODO: Implement favorite
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grey),
        ),
        child: Icon(icon, size: 20, color: AppColors.black),
      ),
    );
  }

  Widget _buildDoctorProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Avatar with Verified Badge
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(widget.doctor.color),
                backgroundImage: photoUrl != null
                    ? (AvatarHelper.isDefaultAvatar(photoUrl)
                        ? AssetImage(photoUrl!) as ImageProvider
                        : NetworkImage(photoUrl!))
                    : (widget.doctor.avatarUrl != null
                        ? (AvatarHelper.isDefaultAvatar(widget.doctor.avatarUrl)
                            ? AssetImage(widget.doctor.avatarUrl!) as ImageProvider
                            : NetworkImage(widget.doctor.avatarUrl!))
                        : null),
                child: photoUrl == null && widget.doctor.avatarUrl == null
                    ? Text(
                        widget.doctor.name.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              // Verified Badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.tick_circle5,
                      size: 12,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.doctor.specialization,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Iconsax.location5,
                      size: 14,
                      color: AppColors.black,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        displayLocation,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            icon: Iconsax.people,
            value: '${widget.doctor.totalReviews}+',
            label: l10n.patients,
          ),
          _buildStatItem(
            icon: Iconsax.briefcase,
            value: '$yearsOfExperience+',
            label: l10n.yearsExp,
          ),
          _buildStatItem(
            icon: Iconsax.star1,
            value: widget.doctor.rating.toStringAsFixed(1),
            label: l10n.rating,
          ),
          _buildStatItem(
            icon: Iconsax.message,
            value: '${widget.doctor.totalReviews}',
            label: l10n.reviews,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.black,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    final l10n = AppLocalizations.of(context)!;
    final bio = displayBio;
    final shouldShowReadMore = bio.length > 150;
    final displayText = !isReadMore && shouldShowReadMore
        ? '${bio.substring(0, 150)}...'
        : bio;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.about,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(text: displayText),
                if (shouldShowReadMore)
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isReadMore = !isReadMore;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          isReadMore ? l10n.showLess : l10n.readMore,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursSection() {
    final l10n = AppLocalizations.of(context)!;
    // Sample working hours - in production, this would come from the API
    final workingHours = [
      {'day': l10n.monday, 'time': '09:00 AM - 05:00 PM'},
      {'day': l10n.tuesday, 'time': '09:00 AM - 05:00 PM'},
      {'day': l10n.wednesday, 'time': '09:00 AM - 05:00 PM'},
      {'day': l10n.thursday, 'time': '09:00 AM - 05:00 PM'},
      {'day': l10n.friday, 'time': '09:00 AM - 05:00 PM'},
      {'day': l10n.saturday, 'time': '10:00 AM - 02:00 PM'},
      {'day': l10n.sunday, 'time': l10n.closed},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.workingHours,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...workingHours.map((hour) {
            final isClosed = hour['time'] == l10n.closed;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hour['day']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    hour['time']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isClosed ? AppColors.error : AppColors.black,
                      fontWeight: isClosed ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.grey),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // TODO: Navigate to booking screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Book Appointment feature coming soon!'),
                  backgroundColor: AppColors.black,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              l10n.bookAppointment,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
