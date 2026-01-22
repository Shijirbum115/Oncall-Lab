import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/laboratory_technician_model.dart';

class LaboratoryTechnicianRepository {
  /// Get all technicians for a specific laboratory
  Future<List<LaboratoryTechnicianModel>> getTechniciansForLaboratory(
      String laboratoryId) async {
    final data = await supabase
        .from('laboratory_technicians')
        .select('''
          *,
          doctor_profiles(
            id,
            profession,
            license_number,
            rating,
            total_completed_requests,
            doctor_type,
            is_available
          ),
          profiles(
            id,
            full_name,
            phone_number,
            email,
            avatar_url,
            gender
          )
        ''')
        .eq('laboratory_id', laboratoryId)
        .eq('is_active', true)
        .order('is_primary_technician', ascending: false)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => LaboratoryTechnicianModel.fromJson(json))
        .toList();
  }

  /// Get all laboratories where a technician works
  Future<List<LaboratoryTechnicianModel>> getLaboratoriesForTechnician(
      String technicianId) async {
    final data = await supabase
        .from('laboratory_technicians')
        .select('''
          *,
          laboratories(
            id,
            name,
            address,
            phone_number,
            email
          )
        ''')
        .eq('technician_id', technicianId)
        .eq('is_active', true)
        .order('is_primary_technician', ascending: false);

    return (data as List)
        .map((json) => LaboratoryTechnicianModel.fromJson(json))
        .toList();
  }

  /// Get technicians using database function (optimized query)
  Future<List<Map<String, dynamic>>> getTechniciansForLaboratoryOptimized(
      String laboratoryId) async {
    final data = await supabase.rpc('get_laboratory_technicians', params: {
      'p_laboratory_id': laboratoryId,
    });

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get primary technician for a laboratory
  Future<LaboratoryTechnicianModel?> getPrimaryTechnician(
      String laboratoryId) async {
    final data = await supabase
        .from('laboratory_technicians')
        .select('''
          *,
          doctor_profiles(
            id,
            profession,
            license_number,
            rating,
            doctor_type
          ),
          profiles(
            id,
            full_name,
            phone_number,
            avatar_url
          )
        ''')
        .eq('laboratory_id', laboratoryId)
        .eq('is_primary_technician', true)
        .eq('is_active', true)
        .maybeSingle();

    if (data == null) return null;
    return LaboratoryTechnicianModel.fromJson(data);
  }

  /// Assign a technician to a laboratory (Admin only)
  Future<LaboratoryTechnicianModel> assignTechnicianToLaboratory({
    required String laboratoryId,
    required String technicianId,
    bool isPrimaryTechnician = false,
    String? employmentStartDate,
    String? employmentEndDate,
    bool canCollectSamples = true,
    bool canPerformTests = true,
    String? notes,
  }) async {
    final data = await supabase
        .from('laboratory_technicians')
        .insert({
          'laboratory_id': laboratoryId,
          'technician_id': technicianId,
          'is_primary_technician': isPrimaryTechnician,
          'employment_start_date': employmentStartDate,
          'employment_end_date': employmentEndDate,
          'can_collect_samples': canCollectSamples,
          'can_perform_tests': canPerformTests,
          'notes': notes,
          'is_active': true,
        })
        .select()
        .single();

    return LaboratoryTechnicianModel.fromJson(data);
  }

  /// Update technician assignment (Admin only)
  Future<LaboratoryTechnicianModel> updateTechnicianAssignment({
    required String assignmentId,
    bool? isPrimaryTechnician,
    bool? isActive,
    String? employmentStartDate,
    String? employmentEndDate,
    bool? canCollectSamples,
    bool? canPerformTests,
    String? notes,
  }) async {
    final updateData = <String, dynamic>{};
    if (isPrimaryTechnician != null) {
      updateData['is_primary_technician'] = isPrimaryTechnician;
    }
    if (isActive != null) updateData['is_active'] = isActive;
    if (employmentStartDate != null) {
      updateData['employment_start_date'] = employmentStartDate;
    }
    if (employmentEndDate != null) {
      updateData['employment_end_date'] = employmentEndDate;
    }
    if (canCollectSamples != null) {
      updateData['can_collect_samples'] = canCollectSamples;
    }
    if (canPerformTests != null) {
      updateData['can_perform_tests'] = canPerformTests;
    }
    if (notes != null) updateData['notes'] = notes;

    final data = await supabase
        .from('laboratory_technicians')
        .update(updateData)
        .eq('id', assignmentId)
        .select()
        .single();

    return LaboratoryTechnicianModel.fromJson(data);
  }

  /// Remove technician from laboratory (Admin only)
  Future<void> removeTechnicianFromLaboratory(String assignmentId) async {
    await supabase
        .from('laboratory_technicians')
        .update({'is_active': false})
        .eq('id', assignmentId);
  }

  /// Permanently delete technician assignment (Admin only)
  Future<void> deleteTechnicianAssignment(String assignmentId) async {
    await supabase.from('laboratory_technicians').delete().eq('id', assignmentId);
  }

  /// Check if technician is assigned to laboratory
  Future<bool> isTechnicianAssignedToLaboratory({
    required String laboratoryId,
    required String technicianId,
  }) async {
    final data = await supabase
        .from('laboratory_technicians')
        .select('id')
        .eq('laboratory_id', laboratoryId)
        .eq('technician_id', technicianId)
        .eq('is_active', true)
        .maybeSingle();

    return data != null;
  }
}
