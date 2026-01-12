import 'supabase_service.dart';
import '../models/user_model.dart';
import '../models/request_model.dart';
import '../models/dashboard_stats.dart';

class AdminService {
  /// Get dashboard statistics
  Future<DashboardStats> getDashboardStats() async {
    try {
      final response = await supabase
          .from('admin_dashboard_stats')
          .select()
          .single();

      return DashboardStats.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load dashboard stats: $e');
    }
  }

  /// Get daily request statistics for chart
  Future<List<DailyRequestStat>> getDailyRequestStats({int daysBack = 30}) async {
    try {
      final response = await supabase.rpc(
        'get_daily_request_stats',
        params: {'days_back': daysBack},
      );

      return (response as List)
          .map((json) => DailyRequestStat.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load daily stats: $e');
    }
  }

  /// Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await supabase.rpc('get_all_users_admin');

      return (response as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  /// Get all requests
  Future<List<RequestModel>> getAllRequests() async {
    try {
      final response = await supabase.rpc('get_all_requests_admin');

      return (response as List)
          .map((json) => RequestModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }

  /// Update user verification status (for doctors)
  Future<void> updateUserVerification(String userId, bool isVerified) async {
    try {
      await supabase
          .from('profiles')
          .update({'is_verified': isVerified, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update verification: $e');
    }
  }

  /// Update user active status
  Future<void> updateUserActiveStatus(String userId, bool isActive) async {
    try {
      await supabase
          .from('profiles')
          .update({'is_active': isActive, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update active status: $e');
    }
  }

  /// Update doctor availability
  Future<void> updateDoctorAvailability(String doctorId, bool isAvailable) async {
    try {
      await supabase
          .from('doctor_profiles')
          .update({'is_available': isAvailable, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', doctorId);
    } catch (e) {
      throw Exception('Failed to update doctor availability: $e');
    }
  }

  /// Create new user
  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await supabase.from('profiles').insert(userData);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Update user information
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      userData['updated_at'] = DateTime.now().toIso8601String();
      await supabase.from('profiles').update(userData).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      // First check if user has any active requests
      final activeRequests = await supabase
          .from('test_requests')
          .select('id')
          .or('patient_id.eq.$userId,doctor_id.eq.$userId')
          .inFilter('status', ['pending', 'accepted', 'on_the_way', 'sample_collected', 'delivered_to_lab']);

      if ((activeRequests as List).isNotEmpty) {
        throw Exception('Cannot delete user with active requests');
      }

      // Delete from doctor_profiles if exists
      await supabase.from('doctor_profiles').delete().eq('id', userId);

      // Delete from profiles
      await supabase.from('profiles').delete().eq('id', userId);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// Update request status
  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    try {
      final updateData = {
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Set timestamp based on status
      switch (newStatus) {
        case 'accepted':
          updateData['accepted_at'] = DateTime.now().toIso8601String();
          break;
        case 'on_the_way':
          updateData['on_the_way_at'] = DateTime.now().toIso8601String();
          break;
        case 'sample_collected':
          updateData['sample_collected_at'] = DateTime.now().toIso8601String();
          break;
        case 'delivered_to_lab':
          updateData['delivered_to_lab_at'] = DateTime.now().toIso8601String();
          break;
        case 'completed':
          updateData['completed_at'] = DateTime.now().toIso8601String();
          break;
        case 'cancelled':
          updateData['cancelled_at'] = DateTime.now().toIso8601String();
          break;
      }

      await supabase.from('test_requests').update(updateData).eq('id', requestId);
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }
}
