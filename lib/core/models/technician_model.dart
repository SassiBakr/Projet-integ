class TechnicianModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? photoUrl;
  final String storeId;
  final String storeName;
  final List<String> specialties;
  final Map<String, String> workingHours;
  final bool isAvailable;
  final double averageRating;
  final int totalRepairs;
  final double averageTime;
  final DateTime createdAt;

  TechnicianModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.storeId,
    required this.storeName,
    this.specialties = const [],
    this.workingHours = const {},
    this.isAvailable = true,
    this.averageRating = 0.0,
    this.totalRepairs = 0,
    this.averageTime = 0.0,
    required this.createdAt,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photoUrl: json['photoUrl'],
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      specialties: List<String>.from(json['specialties'] ?? []),
      workingHours: Map<String, String>.from(json['workingHours'] ?? {}),
      isAvailable: json['isAvailable'] ?? true,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalRepairs: json['totalRepairs'] ?? 0,
      averageTime: (json['averageTime'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'storeId': storeId,
      'storeName': storeName,
      'specialties': specialties,
      'workingHours': workingHours,
      'isAvailable': isAvailable,
      'averageRating': averageRating,
      'totalRepairs': totalRepairs,
      'averageTime': averageTime,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
