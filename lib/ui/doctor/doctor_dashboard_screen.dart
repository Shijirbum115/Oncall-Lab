import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/doctor_request_store.dart';
import 'package:oncall_lab/data/models/test_request_model.dart';
import 'package:oncall_lab/ui/doctor/doctor_request_detail_screen.dart';
import 'package:oncall_lab/ui/shared/widgets/notification_bell.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _subscribeToRequests();
  }

  void _subscribeToRequests() {
    final doctorId = authStore.currentUser?.id;
    if (doctorId != null) {
      // Subscribe to real-time available requests
      doctorRequestStore.subscribeToAvailableRequests();

      // Subscribe to real-time active requests
      doctorRequestStore.subscribeToMyActiveRequests(doctorId);

      // Load completed requests (one-time, doesn't need real-time)
      doctorRequestStore.loadMyCompletedRequests(doctorId);
    }
  }

  @override
  void dispose() {
    doctorRequestStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (doctorRequestStore.isLoading &&
            doctorRequestStore.availableRequests.isEmpty &&
            doctorRequestStore.myActiveRequests.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Dashboard",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const NotificationBell(),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final tabWidth =
                                  (constraints.maxWidth - 12) / 3;
                              return TabBar(
                                indicatorColor: AppColors.primary,
                                unselectedLabelColor:
                                    AppColors.black.withValues(alpha: 0.5),
                                labelStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelColor: Colors.white,
                                indicator: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tabs: [
                                  SizedBox(
                                    width: tabWidth,
                                    child: const Tab(text: 'Available'),
                                  ),
                                  SizedBox(
                                    width: tabWidth,
                                    child: const Tab(text: 'My Requests'),
                                  ),
                                  SizedBox(
                                    width: tabWidth,
                                    child: const Tab(text: 'Completed'),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildAvailableRequestsList(),
                            _buildMyRequestsList(),
                            _buildCompletedRequestsList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvailableRequestsList() {
    return Observer(
      builder: (_) {
        if (doctorRequestStore.availableRequests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.clipboard_tick,
                    size: 60,
                    color: AppColors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No available requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'New requests will appear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => doctorRequestStore.loadAvailableRequests(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: doctorRequestStore.availableRequests.length,
            itemBuilder: (context, index) {
              final request = doctorRequestStore.availableRequests[index];
              return _RequestCard(
                request: request,
                showAcceptButton: true,
                onTap: () => _navigateToDetail(request),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMyRequestsList() {
    return Observer(
      builder: (_) {
        if (doctorRequestStore.myActiveRequests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.task_square,
                    size: 60,
                    color: AppColors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No active requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Accept a request to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final doctorId = authStore.currentUser?.id;
        return RefreshIndicator(
          onRefresh: () => doctorRequestStore.loadMyActiveRequests(doctorId!),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: doctorRequestStore.myActiveRequests.length,
            itemBuilder: (context, index) {
              final request = doctorRequestStore.myActiveRequests[index];
              return _RequestCard(
                request: request,
                onTap: () => _navigateToDetail(request),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompletedRequestsList() {
    return Observer(
      builder: (_) {
        if (doctorRequestStore.myCompletedRequests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.tick_circle,
                    size: 60,
                    color: AppColors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No completed requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your completed requests will appear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final doctorId = authStore.currentUser?.id;
        return RefreshIndicator(
          onRefresh: () => doctorRequestStore.loadMyCompletedRequests(doctorId!),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: doctorRequestStore.myCompletedRequests.length,
            itemBuilder: (context, index) {
              final request = doctorRequestStore.myCompletedRequests[index];
              return _RequestCard(
                request: request,
                onTap: () => _navigateToDetail(request),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToDetail(TestRequestModel request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorRequestDetailScreen(request: request),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final TestRequestModel request;
  final VoidCallback onTap;
  final bool showAcceptButton;

  const _RequestCard({
    required this.request,
    required this.onTap,
    this.showAcceptButton = false,
  });

  String _getStatusString() {
    switch (request.status) {
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

  @override
  Widget build(BuildContext context) {
    final statusStr = _getStatusString();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.getStatusColor(statusStr),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.getStatusColor(statusStr)
                    .withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: request.requestType == RequestType.labService
                                ? Colors.blue.withValues(alpha: 0.1)
                                : Colors.purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            request.requestType == RequestType.labService
                                ? 'Lab Test Service'
                                : 'Direct Home Service',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: request.requestType == RequestType.labService
                                  ? Colors.blue[700]
                                  : Colors.purple[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.getStatusColor(statusStr)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppColors.getStatusText(statusStr),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getStatusColor(statusStr),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                  const SizedBox(width: 5),
                  Text(
                    'Scheduled: ${request.scheduledDate} ${request.scheduledTimeSlot ?? ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: AppColors.grey),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      request.patientAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price: ${request.priceMnt} MNT',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  if (showAcceptButton)
                    ElevatedButton(
                      onPressed: () async {
                        final doctorId = authStore.currentUser?.id;
                        if (doctorId != null) {
                          final result = await doctorRequestStore.acceptRequest(
                            requestId: request.id,
                            doctorId: doctorId,
                          );

                          if (result != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Request accepted successfully!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Accept'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
