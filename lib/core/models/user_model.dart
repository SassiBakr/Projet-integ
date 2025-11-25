enum UserRole { client, technician, admin }

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatar;
  final DateTime? createdAt;
  final bool? isActive;
  final bool? isAvailable;
  final List<String>? specialties;
  final double? rating;
  final int? totalReviews;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    this.createdAt,
    this.isActive,
    this.isAvailable,
    this.specialties,
    this.rating,
    this.totalReviews,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.client,
      ),
      avatar: json['avatar'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      isActive: json['isActive'],
      isAvailable: json['isAvailable'],
      specialties: json['specialties'] != null ? List<String>.from(json['specialties']) : null,
      rating: json['rating']?.toDouble(),
      totalReviews: json['totalReviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'avatar': avatar,
      'createdAt': createdAt?.toIso8601String(),
      'isActive': isActive,
      'isAvailable': isAvailable,
      'specialties': specialties,
      'rating': rating,
      'totalReviews': totalReviews,
    };
  }
}
