enum AppointmentStatus { pending, confirmed, completed, cancelled }

class AppointmentModel {
  final String id;
  final String clientId;
  final String clientName;
  final String technicianId;
  final String technicianName;
  final String storeId;
  final String storeName;
  final String storeAddress;
  final DateTime dateTime;
  final String reason;
  final List<String> photoUrls;
  final AppointmentStatus status;
  final DateTime createdAt;
  final String? cancellationReason;

  AppointmentModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.technicianId,
    required this.technicianName,
    required this.storeId,
    required this.storeName,
    required this.storeAddress,
    required this.dateTime,
    required this.reason,
    this.photoUrls = const [],
    required this.status,
    required this.createdAt,
    this.cancellationReason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      clientId: json['clientId'] ?? '',
      clientName: json['clientName'] ?? '',
      technicianId: json['technicianId'] ?? '',
      technicianName: json['technicianName'] ?? '',
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
      dateTime: DateTime.parse(json['dateTime']),
      reason: json['reason'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${json['status']}',
        orElse: () => AppointmentStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      cancellationReason: json['cancellationReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'storeId': storeId,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'dateTime': dateTime.toIso8601String(),
      'reason': reason,
      'photoUrls': photoUrls,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }
}
