enum OfferType { welcome, loyalty, seasonal, special }

class OfferModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final OfferType type;
  final String discountType; // percentage, fixed, free_service
  final double discountValue;
  final String? conditions;
  final DateTime startDate;
  final DateTime endDate;
  final int? usageLimit;
  final int currentUsage;
  final String? promoCode;
  final bool isActive;
  final List<String> eligibleProducts;
  final double? minimumAmount;
  final DateTime createdAt;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.type,
    required this.discountType,
    required this.discountValue,
    this.conditions,
    required this.startDate,
    required this.endDate,
    this.usageLimit,
    this.currentUsage = 0,
    this.promoCode,
    this.isActive = true,
    this.eligibleProducts = const [],
    this.minimumAmount,
    required this.createdAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      type: OfferType.values.firstWhere(
        (e) => e.toString() == 'OfferType.${json['type']}',
        orElse: () => OfferType.special,
      ),
      discountType: json['discountType'] ?? '',
      discountValue: (json['discountValue'] ?? 0.0).toDouble(),
      conditions: json['conditions'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      usageLimit: json['usageLimit'],
      currentUsage: json['currentUsage'] ?? 0,
      promoCode: json['promoCode'],
      isActive: json['isActive'] ?? true,
      eligibleProducts: List<String>.from(json['eligibleProducts'] ?? []),
      minimumAmount: json['minimumAmount']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type.toString().split('.').last,
      'discountType': discountType,
      'discountValue': discountValue,
      'conditions': conditions,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'usageLimit': usageLimit,
      'currentUsage': currentUsage,
      'promoCode': promoCode,
      'isActive': isActive,
      'eligibleProducts': eligibleProducts,
      'minimumAmount': minimumAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isValid => isActive && !isExpired && (usageLimit == null || currentUsage < usageLimit!);
}
