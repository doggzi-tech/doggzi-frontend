import 'package:dio/dio.dart';
import 'package:doggzi/models/order_model.dart';
import 'package:doggzi/services/base_api_service.dart';
import 'package:doggzi/services/razorpay_service.dart';

class OrderService extends BaseApiService {
  Future<void> placeOrder(String promoCode, String addressId) async {
    try {
      Map<String, dynamic> data = {
        'address_id': addressId,
      };
      if (promoCode.isNotEmpty && promoCode != '') {
        data['promo_code'] = promoCode;
      }
      final response = await dio.post(
        '/orders/',
        data: data,
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to place order');
      }
      final razorpayService = RazorpayService();
      razorpayService.openCheckout(
        orderId: response.data['razorpay_order_id'],
        amount: response.data['amount'],
        name: response.data['name'],
        description: response.data['description'],
        prefillEmail: response.data['prefill_email'],
        prefillContact: response.data['prefill_contact'],
      );
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await dio.get('/orders/');

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch orders');
      }

      final data = response.data;

      if (data == null) return [];

      if (data is! List) {
        throw Exception('Expected a list of orders, got ${data.runtimeType}');
      }

      return data
          .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }
}
