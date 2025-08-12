import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/models/promo_code_model.dart';
import 'package:doggzi/services/promo_code_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoCodeController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final PromoCodeService _promoCodeService = PromoCodeService();
  final TextEditingController promoCodeTextController = TextEditingController();
  RxBool isLoading = true.obs;
  RxList<PromoCode> offers = <PromoCode>[].obs;
  RxString appliedPromoCode = ''.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble finalPayableAmount = 0.0.obs;
  RxString promoCodeMessage = ''.obs;

  double get subtotal => _cartController.cart.value.total;
  double deliveryCharge = 0.0; // Hardcoded for now as per backend logic
  double tax = 0.0; // Hardcoded for now as per backend logic

  @override
  void onInit() {
    super.onInit();
    // Listen to cart changes to recalculate total
    ever(_cartController.cart, (_) {
      calculateTotalAmount();
    });
    getPromoCodes();
    calculateTotalAmount(); // Initial calculation
  }

  @override
  void onClose() {
    promoCodeTextController.dispose();
    super.onClose();
  }

  Future<void> getPromoCodes() async {
    try {
      isLoading.value = true;
      List<PromoCode> promoCodes = await _promoCodeService.getAllPromoCodes();
      offers.value = promoCodes;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error fetching promo codes: $e");
    }
  }

  Future<PromoCode> validatePromoCode(String code) async {
    for (var promoCode in offers) {
      if (promoCode.code == code) {
        return promoCode; // Return the matching promo code
      }
    }
    throw Exception('Promo code not found');
  }

  void calculateTotalAmount() {
    double currentTotal =
        subtotal + deliveryCharge + tax - discountAmount.value;
    finalPayableAmount.value = currentTotal > 0 ? currentTotal : 0.0;
  }

  Future<void> applyPromoCode() async {
    String code = promoCodeTextController.text.trim();
    if (code.isEmpty) {
      promoCodeMessage.value = 'Please enter a promo code.';
      return;
    }

    try {
      PromoCode promoCode = await validatePromoCode(code);

      if (subtotal < promoCode.minOrderValue) {
        promoCodeMessage.value =
            'Order total must be at least ₹${promoCode.minOrderValue} to use this code.';
        appliedPromoCode.value = '';
        discountAmount.value = 0.0;
        calculateTotalAmount();
        return;
      }

      // Calculate discount
      double calculatedDiscount = 0.0;
      if (promoCode.discountType == 'percentage') {
        calculatedDiscount = (promoCode.value / 100) * subtotal;
        if (promoCode.maxDiscount != null) {
          calculatedDiscount = calculatedDiscount > promoCode.maxDiscount!
              ? promoCode.maxDiscount!
              : calculatedDiscount;
        }
      } else {
        // Fixed amount
        calculatedDiscount = promoCode.value;
      }

      appliedPromoCode.value = code;
      discountAmount.value = calculatedDiscount;
      promoCodeMessage.value = 'Promo code applied successfully!';
      calculateTotalAmount();
    } catch (e) {
      promoCodeMessage.value = 'Invalid or expired promo code.';
      appliedPromoCode.value = '';
      discountAmount.value = 0.0;
      calculateTotalAmount();
      print("Error applying promo code: $e");
    }
  }

  void clearPromoCode() {
    promoCodeTextController.clear();
    appliedPromoCode.value = '';
    discountAmount.value = 0.0;
    promoCodeMessage.value = '';
    calculateTotalAmount();
  }
}
