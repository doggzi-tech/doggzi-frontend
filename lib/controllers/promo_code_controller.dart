import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/models/promo_code_model.dart';
import 'package:doggzi/services/promo_code_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoCodeController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final PromoCodeService _promoCodeService = PromoCodeService();
  final TextEditingController promoCodeTextController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isApplyingCode = false.obs;
  RxList<PromoCode> offers = <PromoCode>[].obs;
  RxString appliedPromoCode = ''.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble finalPayableAmount = 0.0.obs;
  RxString promoCodeMessage = ''.obs;
  Rx<PromoCode?> appliedPromoCodeDetails = Rx<PromoCode?>(null);

  double get subtotal => _cartController.cart.value.total;
  double deliveryCharge =
      0.0; // You can make this dynamic based on location/distance
  double tax = 0.0; // You can calculate tax as percentage of subtotal

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
    } catch (e) {
      print("Error fetching promo codes: $e");
      // You might want to show a snackbar or error message here
    } finally {
      isLoading.value = false;
    }
  }

  Future<PromoCode?> validatePromoCode(String code) async {
    try {
      // First check in cached offers
      for (var promoCode in offers) {
        if (promoCode.code.toLowerCase() == code.toLowerCase()) {
          return promoCode;
        }
      }

      // If not found in cache, try to fetch from API
      // This is useful if the promo code is new and not in the initial list
      await getPromoCodes();

      for (var promoCode in offers) {
        if (promoCode.code.toLowerCase() == code.toLowerCase()) {
          return promoCode;
        }
      }

      return null;
    } catch (e) {
      print("Error validating promo code: $e");
      return null;
    }
  }

  void calculateTotalAmount() {
    // Calculate tax (you can make this configurable)
    tax = subtotal * 0.0; // 0% tax for now, adjust as needed

    double currentTotal =
        subtotal + deliveryCharge + tax - discountAmount.value;
    finalPayableAmount.value = currentTotal > 0 ? currentTotal : 0.0;
  }

  Future<void> applyPromoCode() async {
    String code = promoCodeTextController.text.trim();

    // Clear previous messages
    promoCodeMessage.value = '';

    if (code.isEmpty) {
      _showMessage('Please enter a promo code.', isError: true);
      return;
    }

    // Check if same code is already applied
    if (appliedPromoCode.value.isNotEmpty &&
        appliedPromoCode.value.toLowerCase() == code.toLowerCase()) {
      _showMessage('This promo code is already applied.', isError: true);
      return;
    }

    try {
      isApplyingCode.value = true;

      PromoCode? promoCode = await validatePromoCode(code);

      if (promoCode == null) {
        _showMessage('Invalid or expired promo code.', isError: true);
        return;
      }

      // Note: Date validation removed as model doesn't include date fields
      // If you need date validation, add startDate and expiryDate to your PromoCode model

      // Check minimum order value
      if (subtotal < promoCode.minOrderValue) {
        _showMessage(
          'Order total must be at least ₹${promoCode.minOrderValue.toStringAsFixed(2)} to use this code.',
          isError: true,
        );
        return;
      }

      // Check maximum order value (if applicable)
      // if (promoCode.maxOrderValue != null &&
      //     subtotal > promoCode.maxOrderValue!) {
      //   _showMessage(
      //     'This promo code is only valid for orders up to ₹${promoCode.maxOrderValue!.toStringAsFixed(2)}.',
      //     isError: true,
      //   );
      //   return;
      // }

      // Calculate discount
      double calculatedDiscount = _calculateDiscount(promoCode, subtotal);

      // Apply the promo code
      appliedPromoCode.value = code.toUpperCase();
      appliedPromoCodeDetails.value = promoCode;
      discountAmount.value = calculatedDiscount;

      String discountText = calculatedDiscount.toStringAsFixed(2);
      _showMessage('Promo code applied successfully! You saved ₹$discountText');

      calculateTotalAmount();
    } catch (e) {
      print("Error applying promo code: $e");
      _showMessage('Failed to apply promo code. Please try again.',
          isError: true);
    } finally {
      isApplyingCode.value = false;
    }
  }

  double _calculateDiscount(PromoCode promoCode, double orderTotal) {
    double calculatedDiscount = 0.0;

    if (promoCode.discountType == 'percentage') {
      calculatedDiscount = (promoCode.value / 100) * orderTotal;

      // Apply maximum discount limit if specified
      if (promoCode.maxDiscount != null &&
          calculatedDiscount > promoCode.maxDiscount!) {
        calculatedDiscount = promoCode.maxDiscount!;
      }
    } else if (promoCode.discountType == 'fixed_amount') {
      calculatedDiscount = promoCode.value;

      // Ensure discount doesn't exceed order total
      if (calculatedDiscount > orderTotal) {
        calculatedDiscount = orderTotal;
      }
    }

    return calculatedDiscount;
  }

  void clearPromoCode() {
    promoCodeTextController.clear();
    appliedPromoCode.value = '';
    appliedPromoCodeDetails.value = null;
    discountAmount.value = 0.0;
    promoCodeMessage.value = '';
    calculateTotalAmount();
  }

  void _showMessage(String message, {bool isError = false}) {
    promoCodeMessage.value = message;

    // Auto-clear success messages after 3 seconds
    if (!isError) {
      Future.delayed(const Duration(seconds: 3), () {
        if (promoCodeMessage.value == message) {
          promoCodeMessage.value = '';
        }
      });
    }
  }

  // Helper method to check if a promo code can be applied
  bool canApplyPromoCode(PromoCode promoCode) {
    // Note: Date validation removed as model doesn't include date fields

    // Check minimum order value
    if (subtotal < promoCode.minOrderValue) {
      return false;
    }

    return true;
  }

  // Helper method to get discount text for display
  String getDiscountText(PromoCode promoCode) {
    if (promoCode.discountType == 'percentage') {
      String text = '${promoCode.value.toInt()}% OFF';
      if (promoCode.maxDiscount != null) {
        text += ' (Max ₹${promoCode.maxDiscount!.toStringAsFixed(0)})';
      }
      return text;
    } else if (promoCode.discountType == 'fixed_amount') {
      return '₹${promoCode.value.toStringAsFixed(0)} OFF';
    }
    return 'DISCOUNT';
  }
}
