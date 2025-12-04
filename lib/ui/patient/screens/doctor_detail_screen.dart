import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/utils/avatar_helper.dart';
import 'package:oncall_lab/ui/patient/models/doctor_profile_ui.dart';
import 'package:oncall_lab/data/repositories/doctor_repository.dart';

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

  @override
  void initState() {
    super.initState();
    _loadDoctorDetails();
  }

  Future<void> _loadDoctorDetails() async {
    try {
      final details = await _doctorRepository.getDoctorDetails(widget.doctor.id);
      final services = await _doctorRepository.getDoctorServices(widget.doctor.id);

      setState(() {
        fullDoctorData = details;
        doctorServices = services;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading doctor details: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String get displayBio {
    if (fullDoctorData?['bio'] != null && fullDoctorData!['bio'].toString().isNotEmpty) {
      return fullDoctorData!['bio'];
    }
    return '${widget.doctor.name.split(' ').first} is an experienced specialist who is constantly working on improving their skills.';
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

  int get consultationPrice {
    if (doctorServices.isNotEmpty) {
      // Return the price of the first service as consultation price
      return doctorServices.first['price_mnt'] ?? 55000;
    }
    return widget.doctor.price ?? 55000;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'Error loading doctor details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                      errorMessage = null;
                    });
                    _loadDoctorDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ),
            CircleAvatar(
              radius: 45,
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
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              widget.doctor.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            Text(
              widget.doctor.specialization,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionCircle(
                  icon: CupertinoIcons.phone_fill,
                  onTap: () {},
                ),
                const SizedBox(width: 24),
                _ActionCircle(
                  icon: CupertinoIcons.chat_bubble_text_fill,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  children: [
                    const Text(
                      'About Doctor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayBio,
                      style: const TextStyle(
                        color: AppColors.black,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Reviews',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              widget.doctor.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${widget.doctor.totalReviews})',
                              style: const TextStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (widget.doctor.totalReviews > 0)
                      const SizedBox(height: 12),
                    if (widget.doctor.totalReviews > 0)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Reviews feature coming soon',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Service Area',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                displayLocation,
                                style: const TextStyle(color: AppColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service Price',
                  style: TextStyle(color: AppColors.grey),
                ),
                Text(
                  '$consultationPrice MNT',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white.withValues(alpha: 0.25),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
