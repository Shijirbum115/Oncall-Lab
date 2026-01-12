import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/users_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/common/modern_data_table.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  bool _showOnlyUnverified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersProvider>().subscribeToUsers();
    });
  }

  @override
  void dispose() {
    context.read<UsersProvider>().unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Doctor Management'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Consumer<UsersProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: provider.isLoading ? null : () => provider.refresh(),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<UsersProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final doctors = _showOnlyUnverified
              ? provider.unverifiedDoctors
              : provider.doctors;

          return Column(
            children: [
              _buildFilterSection(provider),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: doctors.isEmpty
                      ? const Center(child: Text('No doctors found'))
                      : ModernDataTable(
                          columns: const [
                            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('License', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Profession', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Rating', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Completed', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Verified', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: doctors.map((doctor) => _buildDoctorRow(doctor, provider)).toList(),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(UsersProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ModernFilterChip(
            label: 'All Doctors (${provider.doctors.length})',
            selected: !_showOnlyUnverified,
            onSelected: () => setState(() => _showOnlyUnverified = false),
          ),
          ModernFilterChip(
            label: 'Unverified (${provider.unverifiedDoctors.length})',
            selected: _showOnlyUnverified,
            onSelected: () => setState(() => _showOnlyUnverified = true),
          ),
        ],
      ),
    );
  }

  DataRow _buildDoctorRow(UserModel doctor, UsersProvider provider) {
    return DataRow(
      cells: [
        DataCell(Text(doctor.displayName, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(doctor.phoneNumber)),
        DataCell(Text(doctor.licenseNumber ?? 'N/A')),
        DataCell(Text(doctor.profession ?? 'N/A')),
        DataCell(Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(doctor.rating?.toStringAsFixed(1) ?? '0.0'),
          ],
        )),
        DataCell(Text(doctor.totalCompletedRequests?.toString() ?? '0')),
        DataCell(StatusBadge(
          text: doctor.isVerified ? 'Verified' : 'Pending',
          color: doctor.isVerified ? Colors.green : Colors.orange,
        )),
        DataCell(_buildActions(doctor, provider)),
      ],
    );
  }

  Widget _buildActions(UserModel doctor, UsersProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            doctor.isVerified ? Icons.cancel : Icons.check_circle,
            color: doctor.isVerified ? Colors.orange : Colors.green,
            size: 20,
          ),
          tooltip: doctor.isVerified ? 'Revoke Verification' : 'Approve Doctor',
          onPressed: () async {
            final success = await provider.updateUserVerification(
              doctor.id,
              !doctor.isVerified,
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Doctor verification updated'
                      : 'Failed to update doctor verification'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },
        ),
        IconButton(
          icon: Icon(
            doctor.isActive ? Icons.block : Icons.check,
            color: doctor.isActive ? Colors.red : Colors.green,
            size: 20,
          ),
          tooltip: doctor.isActive ? 'Deactivate' : 'Activate',
          onPressed: () async {
            final success = await provider.updateUserActiveStatus(
              doctor.id,
              !doctor.isActive,
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Doctor status updated'
                      : 'Failed to update doctor status'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
