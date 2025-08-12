class PromoCode {
  final String id;
  final String code;
  final String discountType; // e.g., "fixed_amount" or "percentage"
  final String description;
  final double value;
  final double? maxDiscount; // nullable
  final double minOrderValue;

  PromoCode({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.value,
    this.maxDiscount,
    required this.minOrderValue,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['id'] as String,
      code: json['code'] as String,
      discountType: json['discount_type'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      maxDiscount: json['max_discount'] != null
          ? (json['max_discount'] as num).toDouble()
          : null,
      minOrderValue: (json['min_order_value'] as num).toDouble(),
    );
  }
}
