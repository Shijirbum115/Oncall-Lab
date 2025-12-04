import 'dart:math' as math;

import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/service_category_model.dart';
import 'package:oncall_lab/data/models/service_model.dart';
import 'package:oncall_lab/data/models/laboratory_service_model.dart';
import 'package:oncall_lab/data/models/doctor_service_model.dart';

class ServiceRepository {
  /// Get all service categories
  Future<List<ServiceCategoryModel>> getServiceCategories() async {
    final data = await supabase
        .from('service_categories')
        .select()
        .order('type, name');

    return (data as List)
        .map((json) => ServiceCategoryModel.fromJson(json))
        .toList();
  }

  /// Get services by category
  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    final data = await supabase
        .from('services')
        .select('*, service_categories(*)')
        .eq('category_id', categoryId)
        .eq('is_active', true)
        .order('name');

    return (data as List).map((json) => ServiceModel.fromJson(json)).toList();
  }

  /// Get all direct services (ultrasounds, ECG, nursing)
  Future<List<Map<String, dynamic>>> getDirectServices() async {
    final data = await supabase.rpc('get_direct_services');
    return List<Map<String, dynamic>>.from(data);
  }

  /// Aggregates all lab services and returns consolidated test types
  Future<List<Map<String, dynamic>>> getAggregatedTestTypes({
    int limit = 200,
  }) async {
    final data = await supabase
        .from('laboratory_services')
        .select('''
            service_id,
            price_mnt,
            estimated_duration_hours,
            laboratories ( name ),
            services (
              id,
              name,
              description,
              service_categories ( type )
            )
          ''')
        .eq('is_available', true)
        .limit(limit);

    final labServicesData = List<Map<String, dynamic>>.from(data);

    final combinedTests = <String, Map<String, dynamic>>{};

    for (final record in labServicesData) {
      final service = record['services'] as Map<String, dynamic>?;
      if (service == null) continue;

      final serviceId = service['id']?.toString();
      if (serviceId == null) continue;

      final labName =
          (record['laboratories'] as Map<String, dynamic>?)?['name'] as String?;
      final offeredPrice = record['price_mnt'] as int?;

      final entry = combinedTests.putIfAbsent(serviceId, () {
        return {
          'id': serviceId,
          'name': service['name'] ?? '',
          'price_mnt': offeredPrice ?? 0,
          'labs': <String>[],
          'lab_count': 0,
          'service_categories': service['service_categories'],
        };
      });

      if (offeredPrice != null) {
        final currentPrice = entry['price_mnt'] as int? ?? offeredPrice;
        entry['price_mnt'] = math.min(currentPrice, offeredPrice);
      }

      if (labName != null) {
        final labs = entry['labs'] as List<String>;
        if (!labs.contains(labName)) {
          labs.add(labName);
          entry['lab_count'] = labs.length;
        }
      }
    }

    final aggregatedTests = combinedTests.values.toList()
      ..sort((a, b) {
        final bCount = b['lab_count'] as int? ?? 0;
        final aCount = a['lab_count'] as int? ?? 0;
        return bCount.compareTo(aCount);
      });

    return aggregatedTests;
  }

  /// Get services offered by a laboratory
  Future<List<LaboratoryServiceModel>> getLaboratoryServices(
      String laboratoryId) async {
    final data = await supabase
        .from('laboratory_services')
        .select('*, services(*, service_categories(*))')
        .eq('laboratory_id', laboratoryId)
        .eq('is_available', true)
        .order('services(name)');

    return (data as List)
        .map((json) => LaboratoryServiceModel.fromJson(json))
        .toList();
  }

  /// Get doctors who offer a specific service
  Future<List<Map<String, dynamic>>> getDoctorsForService(
      String serviceId) async {
    final data = await supabase.rpc('get_doctors_for_service', params: {
      'p_service_id': serviceId,
    });

    return List<Map<String, dynamic>>.from(data);
  }

  /// Search services
  Future<List<Map<String, dynamic>>> searchServices(String searchTerm) async {
    final data = await supabase.rpc('search_services', params: {
      'p_search_term': searchTerm,
    });

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get a specific service by ID
  Future<ServiceModel> getServiceById(String serviceId) async {
    final data = await supabase
        .from('services')
        .select('*, service_categories(*)')
        .eq('id', serviceId)
        .single();

    return ServiceModel.fromJson(data);
  }

  /// Get a specific laboratory service
  Future<LaboratoryServiceModel> getLaboratoryService(
      String laboratoryServiceId) async {
    final data = await supabase
        .from('laboratory_services')
        .select('*, services(*, service_categories(*))')
        .eq('id', laboratoryServiceId)
        .single();

    return LaboratoryServiceModel.fromJson(data);
  }

  /// Get a specific doctor service
  Future<DoctorServiceModel> getDoctorService(String doctorServiceId) async {
    final data = await supabase
        .from('doctor_services')
        .select('*, services(*, service_categories(*))')
        .eq('id', doctorServiceId)
        .single();

    return DoctorServiceModel.fromJson(data);
  }

  /// Get a doctor service entry for a doctor and service combination
  Future<DoctorServiceModel> getDoctorServiceByDoctor({
    required String doctorId,
    required String serviceId,
  }) async {
    final data = await supabase
        .from('doctor_services')
        .select('*, services(*, service_categories(*))')
        .eq('doctor_id', doctorId)
        .eq('service_id', serviceId)
        .single();

    return DoctorServiceModel.fromJson(data);
  }
}
