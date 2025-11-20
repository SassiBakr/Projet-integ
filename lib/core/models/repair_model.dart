enum RepairStatus {
  waiting,
  assigned,
  diagnostic,
  repairing,
  repaired,
  ready,
  completed
}

class RepairModel {
  final String id;
  final String clientId;
  final String clientName;
  final String? technicianId;
  final String? technicianName;
  final String productType;
  final String brand;
  final String model;
  final String problemDescription;
  final List<String> photoUrls;
  final RepairStatus status;
  final DateTime createdAt;
  final DateTime? assignedAt;
  final DateTime? diagnosticAt;
  final DateTime? repairingAt;
  final DateTime? repairedAt;
  final DateTime? readyAt;
  final DateTime? completedAt;
  final String? estimatedTime;
  final double? estimatedCost;
  final double? rating;
  final String? feedback;

  RepairModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.technicianId,
    this.technicianName,
    required this.productType,
    required this.brand,
    required this.model,
    required this.problemDescription,
    this.photoUrls = const [],
    required this.status,
    required this.createdAt,
    this.assignedAt,
    this.diagnosticAt,
    this.repairingAt,
    this.repairedAt,
    this.readyAt,
    this.completedAt,
    this.estimatedTime,
    this.estimatedCost,
    this.rating,
    this.feedback,
  });

  factory RepairModel.fromJson(Map<String, dynamic> json) {
    return RepairModel(
      id: json['id'] ?? '',
      clientId: json['clientId'] ?? '',
      clientName: json['clientName'] ?? '',
      technicianId: json['technicianId'],
      technicianName: json['technicianName'],
      productType: json['productType'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      problemDescription: json['problemDescription'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      status: RepairStatus.values.firstWhere(
        (e) => e.toString() == 'RepairStatus.${json['status']}',
        orElse: () => RepairStatus.waiting,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      assignedAt: json['assignedAt'] != null ? DateTime.parse(json['assignedAt']) : null,
      diagnosticAt: json['diagnosticAt'] != null ? DateTime.parse(json['diagnosticAt']) : null,
      repairingAt: json['repairingAt'] != null ? DateTime.parse(json['repairingAt']) : null,
      repairedAt: json['repairedAt'] != null ? DateTime.parse(json['repairedAt']) : null,
      readyAt: json['readyAt'] != null ? DateTime.parse(json['readyAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      estimatedTime: json['estimatedTime'],
      estimatedCost: json['estimatedCost']?.toDouble(),
      rating: json['rating']?.toDouble(),
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'productType': productType,
      'brand': brand,
      'model': model,
      'problemDescription': problemDescription,
      'photoUrls': photoUrls,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'assignedAt': assignedAt?.toIso8601String(),
      'diagnosticAt': diagnosticAt?.toIso8601String(),
      'repairingAt': repairingAt?.toIso8601String(),
      'repairedAt': repairedAt?.toIso8601String(),
      'readyAt': readyAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'estimatedTime': estimatedTime,
      'estimatedCost': estimatedCost,
      'rating': rating,
      'feedback': feedback,
    };
  }
}
