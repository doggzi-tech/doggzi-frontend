import 'package:doggzi/models/menu_model.dart';

class Cart {
  final double total;
  final List<CartItem> items;

  Cart({required this.total, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      total: json['total']?.toDouble() ?? 0.0,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}

class CartItem {
  final String id;
  final MenuModel menuItem;
  final int quantity;

  CartItem({required this.id, required this.menuItem, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      menuItem: MenuModel.fromJson(json["menu_item"]),
      quantity: json['quantity'],
    );
  }
}
