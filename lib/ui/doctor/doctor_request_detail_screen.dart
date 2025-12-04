import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/data/models/test_request_model.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/doctor_request_store.dart';

class DoctorRequestDetailScreen extends StatefulWidget {
  final TestRequestModel request;

  const DoctorRequestDetailScreen({
    super.key,
    required this.request,
  });

  @override
  State<DoctorRequestDetailScreen> createState() => _DoctorRequestDetailScreenState();
}

class _DoctorRequestDetailScreenState extends State<DoctorRequestDetailScreen> {
  late TestRequestModel currentRequest;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    currentRequest = widget.request;
  }

  Future<void> _updateStatus(RequestStatus newStatus) async {
    setState(() => isUpdating = true);

    final result = await doctorRequestStore.updateRequestStatus(
      requestId: currentRequest.id,
      status: newStatus,
    );

    if (result != null) {
      setState(() {
        currentRequest = result;
        isUpdating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${_getStatusDisplayName(newStatus)}'),
            backgroundColor: AppColors.success,
          ),
        );

        // If completed, go back to dashboard
        if (newStatus == RequestStatus.completed) {
          Navigator.of(context).pop();
        }
      }
    } else {
      setState(() => isUpdating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update status'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _cancelRequest() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _CancelRequestDialog(),
    );

    if (reason != null) {
      setState(() => isUpdating = true);

      final result = await doctorRequestStore.cancelRequest(
        requestId: currentRequest.id,
        cancelledBy: authStore.currentUser!.id,
        cancellationReason: reason,
      );

      setState(() => isUpdating = false);

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request cancelled'),
            backgroundColor: AppColors.warning,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  String _getStatusDisplayName(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.onTheWay:
        return 'On the Way';
      case RequestStatus.sampleCollected:
        return 'Sample Collected';
      case RequestStatus.deliveredToLab:
        return 'Delivered to Lab';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  List<Widget> _buildActionButtons() {
    final buttons = <Widget>[];

    switch (currentRequest.status) {
      case RequestStatus.accepted:
        buttons.add(
          _ActionButton(
            label: 'On the Way',
            icon: Iconsax.car,
            color: Colors.blue,
            onPressed: () => _updateStatus(RequestStatus.onTheWay),
          ),
        );
        break;

      case RequestStatus.onTheWay:
        buttons.add(
          _ActionButton(
            label: 'Collect Sample',
            icon: Iconsax.health,
            color: Colors.orange,
            onPressed: () => _updateStatus(RequestStatus.sampleCollected),
          ),
        );
        break;

      case RequestStatus.sampleCollected:
        if (currentRequest.requestType == RequestType.labService) {
          buttons.add(
            _ActionButton(
              label: 'Deliver to Lab',
              icon: Iconsax.building,
              color: Colors.purple,
              onPressed: () => _updateStatus(RequestStatus.deliveredToLab),
            ),
          );
        } else {
          // For direct service, skip to completed
          buttons.add(
            _ActionButton(
              label: 'Complete Request',
              icon: Iconsax.tick_circle,
              color: AppColors.success,
              onPressed: () => _updateStatus(RequestStatus.completed),
            ),
          );
        }
        break;

      case RequestStatus.deliveredToLab:
        buttons.add(
          _ActionButton(
            label: 'Complete Request',
            icon: Iconsax.tick_circle,
            color: AppColors.success,
            onPressed: () => _updateStatus(RequestStatus.completed),
          ),
        );
        break;

      default:
        break;
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final statusStr = _getStatusString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (currentRequest.status != RequestStatus.completed &&
              currentRequest.status != RequestStatus.cancelled)
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
              onPressed: _cancelRequest,
              tooltip: 'Cancel Request',
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Status Badge
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.getStatusColor(statusStr)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    AppColors.getStatusText(statusStr),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getStatusColor(statusStr),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Request Type
              _InfoCard(
                title: 'Request Type',
                icon: Iconsax.clipboard_text,
                children: [
                  _InfoRow(
                    label: 'Type',
                    value: currentRequest.requestType == RequestType.labService
                        ? 'Lab Test Service'
                        : 'Direct Home Service',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Schedule Info
              _InfoCard(
                title: 'Schedule',
                icon: Iconsax.calendar,
                children: [
                  _InfoRow(
                    label: 'Date',
                    value: currentRequest.scheduledDate,
                  ),
                  if (currentRequest.scheduledTimeSlot != null)
                    _InfoRow(
                      label: 'Time Slot',
                      value: currentRequest.scheduledTimeSlot!,
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Location Info
              _InfoCard(
                title: 'Location',
                icon: Iconsax.location,
                children: [
                  _InfoRow(
                    label: 'Address',
                    value: currentRequest.patientAddress,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Payment Info
              _InfoCard(
                title: 'Payment',
                icon: Iconsax.wallet,
                children: [
                  _InfoRow(
                    label: 'Total Amount',
                    value: '${currentRequest.priceMnt} MNT',
                    valueStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Patient Notes
              if (currentRequest.patientNotes != null &&
                  currentRequest.patientNotes!.isNotEmpty)
                _InfoCard(
                  title: 'Patient Notes',
                  icon: Iconsax.note,
                  children: [
                    Text(
                      currentRequest.patientNotes!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 100), // Space for bottom buttons
            ],
          ),

          // Action Buttons (Fixed at bottom)
          if (currentRequest.status != RequestStatus.completed &&
              currentRequest.status != RequestStatus.cancelled)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._buildActionButtons(),
                  ],
                ),
              ),
            ),

          // Loading Overlay
          if (isUpdating)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  String _getStatusString() {
    switch (currentRequest.status) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.onTheWay:
        return 'on_the_way';
      case RequestStatus.sampleCollected:
        return 'sample_collected';
      case RequestStatus.deliveredToLab:
        return 'delivered_to_lab';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.cancelled:
        return 'cancelled';
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  const TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _CancelRequestDialog extends StatefulWidget {
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
    return AlertDialog(
      title: const Text('Cancel Request'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please provide a reason for cancellation:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter reason...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
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
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
