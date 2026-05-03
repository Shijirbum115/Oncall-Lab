import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/laboratory_model.dart';

class LaboratoryRepository {
  /// Get all active laboratories
  Future<List<LaboratoryModel>> getAllLaboratories() async {
    final data =
        await supabase.from('laboratories').select().order('name');

    return (data as List)
        .map((json) => LaboratoryModel.fromJson(json))
        .toList();
  }

  /// Get a specific laboratory by ID
  Future<LaboratoryModel> getLaboratoryById(String laboratoryId) async {
    final data =
        await supabase.from('laboratories').select().eq('id', laboratoryId).single();

    return LaboratoryModel.fromJson(data);
  }
}
