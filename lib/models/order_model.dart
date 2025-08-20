import 'package:doggzi/models/address_model.dart';
import 'package:doggzi/models/menu_model.dart';

enum OrderStatus {
  pending_payment,
  pending_confirmation,
  confirmed,
  preparing,
  out_for_delivery,
  delivered,
  cancelled,
  failed,
}

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final OrderStatus status;
  final double totalAmount;
  final double deliveryCharge;
  final double discount;
  final double tax;
  final AddressModel? address;
  final DateTime deliveryDate;
  final int? rating;
  final String? ratingComment;

  OrderModel({
    required this.id,
    required this.items,
    required this.status,
    required this.totalAmount,
    required this.deliveryCharge,
    required this.discount,
    required this.tax,
    required this.address,
    required this.deliveryDate,
    this.rating,
    this.ratingComment,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending_payment,
      ),
      totalAmount: json['total_amount'] ?? 0.0,
      deliveryCharge: json['delivery_charge'] ?? 0.0,
      discount: json['discount'] ?? 0.0,
      tax: json['tax'] ?? 0.0,
      address: json['shipping_address'] != null
          ? AddressModel.fromJson(json['shipping_address'])
          : null,
      deliveryDate: DateTime.parse(json['delivery_date']),
      rating: json['rating'],
      ratingComment: json['rating_comment'],
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final MenuModel? menuItem;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.menuItem,
  });

  /// Creates an OrderItem from a JSON map.
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String,
      quantity: json['quantity'] ?? 1,
      price: json['price'] ?? 0.0,
      menuItem: json['menu_item'] != null
          ? MenuModel.fromJson(json['menu_item'])
          : null,
    );
  }
}
