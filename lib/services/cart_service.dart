import 'package:dio/dio.dart';
import '../models/cart.dart';
import 'base_api_service.dart';

class CartService extends BaseApiService {
  Future<Cart> addToCart(String menuItemId, int quantity) async {
    try {
      final response = await dio.post(
        '/cart/add',
        data: {'menu_item_id': menuItemId, 'quantity': quantity},
      );
      return Cart.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  Future<Cart> getCart() async {
    try {
      final response = await dio.get('/cart');
      return Cart.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  Future<void> placeOrder(String promoCode, String addressId) async {
    try {
      Map<String, dynamic> data = {
        'address_id': addressId,
      };
      if (promoCode.isNotEmpty && promoCode != '') {
        data['promo_code'] = promoCode;
      }
      await dio.post(
        '/orders/',
        data: data,
      );
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  Future<Cart> removeFromCart(String cartItemId) async {
    try {
      final response = await dio.delete('/cart/remove/$cartItemId');
      return Cart.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }
}
