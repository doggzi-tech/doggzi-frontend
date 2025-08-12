import 'package:doggzi/models/cart.dart';
import 'package:doggzi/services/cart_service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartService = CartService();
  Rx<Cart> cart = Cart(total: 0.0, items: []).obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
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
      await cartService.placeOrder(promoCode, addressId);
      fetchCart();
    } catch (e) {
      print("failed to place order: $e");
    }
  }
}
