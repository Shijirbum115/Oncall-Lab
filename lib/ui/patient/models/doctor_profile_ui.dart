class DoctorProfileUI {
  const DoctorProfileUI({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.totalReviews,
    required this.color,
    this.avatarUrl,
    this.gender,
    this.about,
    this.location,
    this.price,
  });

  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int totalReviews;
  final int color;
  final String? avatarUrl;
  final String? gender;
  final String? about;
  final String? location;
  final int? price;

  factory DoctorProfileUI.fromMap(Map<String, dynamic> json) {
    final name = (json['full_name'] as String?) ?? 'Doctor';

    // ID is required - must be a valid UUID from database
    final rawId = json['id'];
    if (rawId == null) {
      throw ArgumentError('Doctor ID is required but was null in data: $json');
    }
    final id = rawId.toString();

    final gender = json['gender'] as String?;

    // Get avatar URL - use provided avatar_url, or generate default
    String? avatarUrl = json['avatar_url'] as String?;

    return DoctorProfileUI(
      id: id,
      name: name,
      specialization: (json['profession'] as String?) ??
                      (json['specialization'] as String?) ??
                      'Lab Technician',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      totalReviews: json['total_reviews'] as int? ?? 0,
      color: _colorPalette[(json.hashCode.abs()) % _colorPalette.length],
      avatarUrl: avatarUrl,
      gender: gender,
      about: json['bio'] as String?,
      location: json['location'] as String?,
      price: json['price'] as int?,
    );
  }
}

const List<int> _colorPalette = [
  0xFFffcdcf,
  0xFFf9d8b9,
  0xFFccd1fa,
  0xFFe1edf8,
  0xFFc8e6c9,
];
