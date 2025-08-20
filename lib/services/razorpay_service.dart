import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../pages/order_status/cancelled.dart';
import '../pages/order_status/confirmed.dart';
import '../widgets/custom_loader.dart';
import 'base_api_service.dart';

class RazorpayService extends BaseApiService {
  late Razorpay _razorpay;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required String orderId,
    required double amount,
    required String name,
    required String description,
    required String prefillEmail,
    required String prefillContact,
  }) async {
    var options = {
      'key': dotenv.env["RAZORPAY_KEY_ID"],
      'amount': (amount * 100).toInt(),
      'name': name,
      'description': description,
      'order_id': orderId,
      'prefill': {
        'email': prefillEmail,
        'contact': prefillContact,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
     final verifyResponse= await dio.post(
        '/orders/${response.orderId}/verify-payment',
        data: {
          'razorpay_order_id': response.orderId,
          'razorpay_payment_id': response.paymentId,
          'razorpay_signature': response.signature,
        },
      );
      final status = verifyResponse.data['status'];

      if (status == 'success') {
        Get.offAll(() => OrderConfirmedPage());
        return;
      }

      if (status == 'pending') {
        int elapsed = 0;
        const interval = Duration(seconds: 10);
        const timeout = 60;

        Timer.periodic(interval, (timer) async {
          elapsed += 10;

          final res = await dio.get('/orders/${response.orderId}/status');
          final s = res.data["status"];
          if (s == 'success') {
            timer.cancel();
            Get.offAll(() => OrderConfirmedPage());
          } else if (s == 'failed' || elapsed > timeout) {
            timer.cancel();
            Get.offAll(() => OrderCancelledPage());
          } else {
            Get.offAll(CustomLoader());
          }
        });
      }
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('ERROR: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('EXTERNAL_WALLET: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear();
  }
}