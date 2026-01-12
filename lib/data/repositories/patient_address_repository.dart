import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/patient_address_model.dart';

class PatientAddressRepository {
  /// Get all addresses for the current user
  Future<List<PatientAddressModel>> getMyAddresses() async {
    final data = await supabase
        .from('patient_addresses')
        .select()
        .order('is_default', ascending: false)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => PatientAddressModel.fromJson(json))
        .toList();
  }

  /// Get a specific address by ID
  Future<PatientAddressModel> getAddressById(String addressId) async {
    final data = await supabase
        .from('patient_addresses')
        .select()
        .eq('id', addressId)
        .single();

    return PatientAddressModel.fromJson(data);
  }

  /// Get the default address for the current user
  Future<PatientAddressModel?> getDefaultAddress() async {
    final data = await supabase
        .from('patient_addresses')
        .select()
        .eq('is_default', true)
        .maybeSingle();

    if (data == null) return null;
    return PatientAddressModel.fromJson(data);
  }

  /// Create a new address
  Future<PatientAddressModel> createAddress({
    required String userId,
    required double latitude,
    required double longitude,
    required String addressLine,
    String? apartmentNumber,
    String? floor,
    String? doorNumber,
    String? entrance,
    String? buildingName,
    String? additionalInfo,
    String? label,
    bool isDefault = false,
  }) async {
    final data = await supabase
        .from('patient_addresses')
        .insert({
          'user_id': userId,
          'latitude': latitude,
          'longitude': longitude,
          'address_line': addressLine,
          'apartment_number': apartmentNumber,
          'floor': floor,
          'door_number': doorNumber,
          'entrance': entrance,
          'building_name': buildingName,
          'additional_info': additionalInfo,
          'label': label,
          'is_default': isDefault,
        })
        .select()
        .single();

    return PatientAddressModel.fromJson(data);
  }

  /// Update an existing address
  Future<PatientAddressModel> updateAddress({
    required String addressId,
    double? latitude,
    double? longitude,
    String? addressLine,
    String? apartmentNumber,
    String? floor,
    String? doorNumber,
    String? entrance,
    String? buildingName,
    String? additionalInfo,
    String? label,
    bool? isDefault,
  }) async {
    final updateData = <String, dynamic>{};
    if (latitude != null) updateData['latitude'] = latitude;
    if (longitude != null) updateData['longitude'] = longitude;
    if (addressLine != null) updateData['address_line'] = addressLine;
    if (apartmentNumber != null) updateData['apartment_number'] = apartmentNumber;
    if (floor != null) updateData['floor'] = floor;
    if (doorNumber != null) updateData['door_number'] = doorNumber;
    if (entrance != null) updateData['entrance'] = entrance;
    if (buildingName != null) updateData['building_name'] = buildingName;
    if (additionalInfo != null) updateData['additional_info'] = additionalInfo;
    if (label != null) updateData['label'] = label;
    if (isDefault != null) updateData['is_default'] = isDefault;

    final data = await supabase
        .from('patient_addresses')
        .update(updateData)
        .eq('id', addressId)
        .select()
        .single();

    return PatientAddressModel.fromJson(data);
  }

  /// Set an address as default (will unset other defaults automatically via trigger)
  Future<PatientAddressModel> setAsDefault(String addressId) async {
    final data = await supabase
        .from('patient_addresses')
        .update({'is_default': true})
        .eq('id', addressId)
        .select()
        .single();

    return PatientAddressModel.fromJson(data);
  }

  /// Delete an address
  Future<void> deleteAddress(String addressId) async {
    await supabase.from('patient_addresses').delete().eq('id', addressId);
  }

  /// Get addresses for a specific user (admin use)
  Future<List<PatientAddressModel>> getAddressesByUserId(String userId) async {
    final data = await supabase
        .from('patient_addresses')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => PatientAddressModel.fromJson(json))
        .toList();
  }
}
