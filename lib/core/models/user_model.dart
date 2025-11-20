enum UserRole { client, technician, admin }

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? photoUrl;
  final DateTime createdAt;
  final bool isActive;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.photoUrl,
    required this.createdAt,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.client,
      ),
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
