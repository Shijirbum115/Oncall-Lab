class UserModel {
  final String id;
  final String role;
  final String phoneNumber;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final int? age;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;

  // Doctor-specific fields
  final String? profession;
  final String? licenseNumber;
  final String? doctorType;
  final double? rating;
  final int? totalCompletedRequests;

  UserModel({
    required this.id,
    required this.role,
    required this.phoneNumber,
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    this.profession,
    this.licenseNumber,
    this.doctorType,
    this.rating,
    this.totalCompletedRequests,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      role: json['role'] as String,
      phoneNumber: json['phone_number'] as String,
      fullName: json['full_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      profession: json['profession'] as String?,
      licenseNumber: json['license_number'] as String?,
      doctorType: json['doctor_type'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalCompletedRequests: json['total_completed_requests'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'age': age,
      'is_active': isActive,
      'is_verified': isVerified,
    };
  }

  String get displayName => fullName ?? (firstName != null && lastName != null ? '$firstName $lastName' : phoneNumber);
}
