// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_address_model.freezed.dart';
part 'patient_address_model.g.dart';

@freezed
class PatientAddressModel with _$PatientAddressModel {
  const PatientAddressModel._(); // Private constructor for custom methods

  const factory PatientAddressModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,

    // Location coordinates
    required double latitude,
    required double longitude,

    // Address details
    @JsonKey(name: 'address_line') required String addressLine,
    @JsonKey(name: 'apartment_number') String? apartmentNumber,
    String? floor,
    @JsonKey(name: 'door_number') String? doorNumber,
    String? entrance,
    @JsonKey(name: 'building_name') String? buildingName,
    @JsonKey(name: 'additional_info') String? additionalInfo,

    // Metadata
    String? label, // e.g., "Home", "Work", "Parent's House"
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PatientAddressModel;

  factory PatientAddressModel.fromJson(Map<String, dynamic> json) =>
      _$PatientAddressModelFromJson(json);

  // Custom getters and methods
  String get fullAddress {
    final parts = <String>[addressLine];

    if (buildingName != null) parts.add(buildingName!);
    if (entrance != null) parts.add('Орц: $entrance');
    if (floor != null) parts.add('Давхар: $floor');
    if (apartmentNumber != null) parts.add('Орон сууц: $apartmentNumber');
    if (doorNumber != null) parts.add('Хаалга: $doorNumber');

    return parts.join(', ');
  }

  String get shortAddress {
    final parts = <String>[addressLine];
    if (apartmentNumber != null) parts.add('#$apartmentNumber');
    return parts.join(' ');
  }

  String get displayLabel => label ?? 'Хаяг';
}
