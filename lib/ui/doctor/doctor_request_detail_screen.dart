import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/data/models/patient_address_model.dart';
import 'package:bugamed/data/models/profile_model.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/data/repositories/auth_repository.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/doctor_request_store.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/status_timeline.dart';
import 'package:bugamed/ui/doctor/widgets/location_viewer_widget.dart';
import 'package:bugamed/ui/patient/widgets/request_journey.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';

/// Doctor-facing job detail: who, where, what, and the next status action.
class DoctorRequestDetailScreen extends StatefulWidget {
  final TestRequestModel request;

  const DoctorRequestDetailScreen({
    super.key,
    required this.request,
  });

  @override
  State<DoctorRequestDetailScreen> createState() =>
      _DoctorRequestDetailScreenState();
}

class _DoctorRequestDetailScreenState extends State<DoctorRequestDetailScreen> {
  late TestRequestModel currentRequest;
  bool isUpdating = false;
  ProfileModel? patientProfile;

  bool get _isMine =>
      currentRequest.doctorId != null &&
      currentRequest.doctorId == authStore.currentUser?.id;

  bool get _isFinished =>
      currentRequest.status == RequestStatus.completed ||
      currentRequest.status == RequestStatus.cancelled;

  @override
  void initState() {
    super.initState();
    currentRequest = widget.request;
    _loadPatientProfile();
  }

  Future<void> _loadPatientProfile() async {
    // RLS only exposes the patient profile to the assigned doctor.
    if (!_isMine) return;
    final profile = await GetIt.I<AuthRepository>()
        .getProfileById(currentRequest.patientId);
    if (mounted && profile != null) {
      setState(() => patientProfile = profile);
    }
  }

  Future<void> _updateStatus(RequestStatus newStatus) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => isUpdating = true);

    final result = await doctorRequestStore.updateRequestStatus(
      requestId: currentRequest.id,
      status: newStatus,
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        currentRequest = result;
        isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.statusUpdatedTo(RequestJourney.label(
              newStatus, l10n,
              type: currentRequest.requestType))),
          backgroundColor: AppColors.success,
        ),
      );

      if (newStatus == RequestStatus.completed) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() => isUpdating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToUpdateStatus),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _cancelRequest() async {
    final l10n = AppLocalizations.of(context)!;
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _CancelRequestDialog(l10n: l10n),
    );

    if (reason == null || !mounted) return;

    setState(() => isUpdating = true);

    final result = await doctorRequestStore.cancelRequest(
      requestId: currentRequest.id,
      cancelledBy: authStore.currentUser!.id,
      cancellationReason: reason,
    );

    if (!mounted) return;
    setState(() => isUpdating = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.requestCancelled),
          backgroundColor: AppColors.warning,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _acceptRequest() async {
    final l10n = AppLocalizations.of(context)!;
    final doctorId = authStore.currentUser?.id;
    if (doctorId == null) return;

    setState(() => isUpdating = true);
    final result = await doctorRequestStore.acceptRequest(
      requestId: currentRequest.id,
      doctorId: doctorId,
    );

    if (!mounted) return;
    setState(() {
      isUpdating = false;
      if (result != null) currentRequest = result;
    });

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.requestAcceptedSuccess),
          backgroundColor: AppColors.success,
        ),
      );
      _loadPatientProfile();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              doctorRequestStore.errorMessage ?? l10n.somethingWentWrong),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _callPatient(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(uri);
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotCall),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Next step in the workflow for the current status, or null when there is
  /// no doctor action (pending / finished).
  (String, IconData, RequestStatus)? _nextAction(AppLocalizations l10n) {
    final isDirect = currentRequest.requestType == RequestType.directService;
    switch (currentRequest.status) {
      case RequestStatus.accepted:
        return (l10n.startOnTheWay, Iconsax.routing, RequestStatus.onTheWay);
      case RequestStatus.onTheWay:
        return isDirect
            ? (
                l10n.markTreatmentDone,
                Iconsax.health,
                RequestStatus.sampleCollected,
              )
            : (
                l10n.collectSample,
                Iconsax.drop,
                RequestStatus.sampleCollected,
              );
      case RequestStatus.sampleCollected:
        return isDirect
            ? (
                l10n.completeRequest,
                Iconsax.tick_circle,
                RequestStatus.completed,
              )
            : (
                l10n.deliverToLab,
                Iconsax.building,
                RequestStatus.deliveredToLab,
              );
      case RequestStatus.deliveredToLab:
        return (
          l10n.completeRequest,
          Iconsax.tick_circle,
          RequestStatus.completed,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canAccept = !_isMine &&
        currentRequest.status == RequestStatus.pending &&
        currentRequest.doctorId == null;
    final action = _isMine && !_isFinished ? _nextAction(l10n) : null;
    final showBottomBar = action != null || canAccept;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(l10n.requestDetails),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        actions: [
          if (_isMine && !_isFinished)
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
              onPressed: isUpdating ? null : _cancelRequest,
              tooltip: l10n.cancelRequest,
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20, 4, 20, showBottomBar ? 120 : 24),
            children: [
              _buildJourneyCard(l10n),
              const SizedBox(height: AppSpacing.sm),
              if (_isMine) ...[
                _buildPatientCard(l10n),
                const SizedBox(height: AppSpacing.sm),
              ],
              _buildLocationSection(l10n),
              const SizedBox(height: AppSpacing.sm),
              _buildJobCard(l10n),
              if (currentRequest.patientNotes != null &&
                  currentRequest.patientNotes!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildNotesCard(l10n),
              ],
            ],
          ),

          // Next-step action pinned at the bottom
          if (showBottomBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      const Border(top: BorderSide(color: AppColors.outline)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: canAccept
                    ? AppButton(
                        label: l10n.accept,
                        icon: Iconsax.tick_circle,
                        loading: isUpdating,
                        onPressed: _acceptRequest,
                      )
                    : AppButton(
                        label: action!.$1,
                        icon: action.$2,
                        loading: isUpdating,
                        onPressed: () => _updateStatus(action.$3),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(AppLocalizations l10n) {
    final statusColor = AppColors.getStatusColor(currentRequest.status.dbValue);

    return AppCard(
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  RequestJourney.label(currentRequest.status, l10n,
                      type: currentRequest.requestType),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
              Text(
                currentRequest.requestType == RequestType.labService
                    ? l10n.labTestServiceLabel
                    : l10n.directHomeServiceLabel,
                style: AppTypography.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          StatusTimeline(
            steps: RequestJourney.steps(l10n,
                type: currentRequest.requestType),
            currentIndex: RequestJourney.indexOf(currentRequest.status,
                type: currentRequest.requestType),
            cancelled: RequestJourney.isCancelled(currentRequest.status),
            cancelledLabel:
                '${l10n.cancelled}${currentRequest.cancellationReason != null ? ' · ${currentRequest.cancellationReason}' : ''}',
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(AppLocalizations l10n) {
    final profile = patientProfile;

    return AppCard(
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Iconsax.user, title: l10n.patientInformation),
          const SizedBox(height: 12),
          if (profile == null)
            Text(l10n.loading, style: AppTypography.bodySmall)
          else ...[
            Row(
              children: [
                ProfileAvatar(
                  avatarUrl: profile.getAvatarUrl(),
                  initials: profile.initials,
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (profile.age != null)
                            l10n.ageYears(profile.age!),
                          if (profile.gender != null) profile.gender!,
                        ].join(' · '),
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Call button — the doctor's lifeline in the field
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _callPatient(profile.phoneNumber),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child:
                            Icon(Iconsax.call, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MetaRow(icon: Iconsax.mobile, label: profile.phoneNumber),
            if (profile.allergies != null &&
                profile.allergies!.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Iconsax.danger,
                        size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n.allergiesShort}: ${profile.allergies}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildLocationSection(AppLocalizations l10n) {
    final lat = currentRequest.patientLatitude;
    final lng = currentRequest.patientLongitude;

    if (lat == null || lng == null) {
      return AppCard(
        borderRadius: AppRadius.lg,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(icon: Iconsax.location, title: l10n.location),
            const SizedBox(height: 12),
            _MetaRow(
                icon: Iconsax.location, label: currentRequest.patientAddress),
          ],
        ),
      );
    }

    final now = DateTime.now();
    return LocationViewerWidget(
      address: PatientAddressModel(
        id: currentRequest.id,
        userId: currentRequest.patientId,
        latitude: lat,
        longitude: lng,
        addressLine: currentRequest.patientAddress,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Widget _buildJobCard(AppLocalizations l10n) {
    return AppCard(
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Iconsax.clipboard_text, title: l10n.schedule),
          const SizedBox(height: 12),
          _MetaRow(
            icon: Iconsax.calendar_1,
            label: '${currentRequest.scheduledDate}'
                '${currentRequest.scheduledTimeSlot != null ? ' · ${currentRequest.scheduledTimeSlot}' : ''}',
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(l10n.totalAmount, style: AppTypography.bodySmall),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (currentRequest.isPaid
                              ? AppColors.success
                              : AppColors.warning)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      currentRequest.isPaid ? l10n.paid : l10n.awaitingPayment,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: currentRequest.isPaid
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                l10n.priceInMNT(currentRequest.doctorEarningsMnt),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(AppLocalizations l10n) {
    return AppCard(
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Iconsax.note_1, title: l10n.patientNotes),
          const SizedBox(height: 12),
          Text(
            currentRequest.patientNotes!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: AppTypography.bodySmall),
        ),
      ],
    );
  }
}

class _CancelRequestDialog extends StatefulWidget {
  final AppLocalizations l10n;

  const _CancelRequestDialog({required this.l10n});

  @override
  State<_CancelRequestDialog> createState() => _CancelRequestDialogState();
}

class _CancelRequestDialogState extends State<_CancelRequestDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;

    return AlertDialog(
      title: Text(l10n.cancelRequest),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.provideCancellationReason,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.enterReason,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_reasonController.text.trim().isNotEmpty) {
              Navigator.of(context).pop(_reasonController.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
