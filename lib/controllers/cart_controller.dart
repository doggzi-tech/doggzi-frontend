import 'package:doggzi/models/cart.dart';
import 'package:doggzi/models/order_model.dart';
import 'package:doggzi/pages/order_status/order_page/widgets/order_details.dart';
import 'package:doggzi/services/cart_service.dart';
import 'package:doggzi/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartService = CartService();
  final orderService = OrderService();
  RxList<OrderModel> orders = <OrderModel>[].obs;
  Rx<Cart> cart = Cart(total: 0.0, items: []).obs;
  Rx<int> itemQuantity = 1.obs;
  final RxBool isDetailsSheetOpen = false.obs;

  Future<CartController> init() async {
    await fetchCart();
    fetchOrders();
    return this;
  }

  Future<void> fetchCart() async {
    try {
      cart.value = await cartService.getCart();
    } catch (e) {
      print("failed to fetch cart items: $e");
    }
  }

  Future<void> addToCart(String menuItemId, int quantity) async {
    try {
      cart.value = await cartService.addToCart(menuItemId, quantity);
    } catch (e) {
      print("failed to update cart items: $e");
    }
  }

  Future<void> placeOrder(String promoCode, String addressId) async {
    try {
      await orderService.placeOrder(promoCode, addressId);
      fetchCart();
      Get.back();
    } catch (e) {
      print("failed to place order: $e");
    }
  }

  Future<void> fetchOrders() async {
    try {
      orders.value = await orderService.getOrders();
    } catch (e) {
      print("failed to fetch orders: $e");
    }
  }

  void showOrderDetails(OrderModel item) {
    Get.bottomSheet(
      OrderDetailsPage(order: item),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((_) {
      itemQuantity.value = 1;
     isDetailsSheetOpen.value=false;
    });
  }

}
