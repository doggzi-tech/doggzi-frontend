import 'package:doggzi/controllers/address_controller.dart';
import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/pages/cart_page/widgets/cart_items.dart';
import 'package:doggzi/pages/cart_page/widgets/delivery_address_card.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:doggzi/widgets/location_app_bar.dart';
import 'package:doggzi/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/promo_code_controller.dart';
import '../../core/app_routes.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final cartController = Get.find<CartController>();
  final promoCodeController = Get.put(PromoCodeController());
  final addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cartController.cart.value.items.isEmpty) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const LocationAppBar(showBackButton: true),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Your cart is empty",
                        style: TextStyles.captionL.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Add some delicious items to get started!",
                        style: TextStyles.captionM
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              const LocationAppBar(showBackButton: true),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Review Your Order",
                          style: TextStyles.captionL,
                        ),
                        SizedBox(height: 16.h),

                        // Order Item Card
                        CartItemCard(),

                        SizedBox(height: 20.h),

                        // Improved Promo Code Section
                        _buildPromoCodeSection(),

                        SizedBox(height: 20.h),

                        // Bill Details Section
                        _buildBillDetailsSection(),

                        SizedBox(height: 20.h),

                        // Delivery Info
                        const DeliveryAddressCard(),
                        SizedBox(height: 16.h),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Image.asset(
                              'assets/images/subscription_information.png',
                              height: 60.h),
                        ),

                        SizedBox(height: 20.h),
                        // Extra space for bottom padding
                      ],
                    ),
                  ),
                ),
              ),

              // Pay Button (Sticky at bottom)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(0, -1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement payment logic
                      if (addressController.defaultAddress.value.id.isEmpty) {
                        customSnackBar.show(
                          message: 'Please select a delivery address',
                          type: SnackBarType.error,
                        );
                        return;
                      }
                      if (promoCodeController.finalPayableAmount.value <= 0) {
                        customSnackBar.show(
                          message: 'Total amount must be greater than zero',
                          type: SnackBarType.error,
                        );
                        return;
                      }
                      cartController.placeOrder(
                        promoCodeController.appliedPromoCode.value,
                        addressController.defaultAddress.value.id,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, color: Colors.white, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            "Pay ₹${promoCodeController.finalPayableAmount.value.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: AppColors.orange500,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "Apply Coupon Code",
                style: TextStyles.captionM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Obx(() {
            bool hasAppliedCode =
                promoCodeController.appliedPromoCode.value.isNotEmpty;

            if (hasAppliedCode) {
              return _buildAppliedCodeCard();
            } else {
              return _buildPromoCodeInput();
            }
          }),

          SizedBox(height: 12.h),

          // Message Display
          Obx(() {
            if (promoCodeController.promoCodeMessage.value.isNotEmpty) {
              bool isSuccess = promoCodeController.promoCodeMessage.value
                  .contains('successfully');
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color:
                        isSuccess ? Colors.green.shade300 : Colors.red.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSuccess
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      color: isSuccess ? Colors.green : Colors.red,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        promoCodeController.promoCodeMessage.value,
                        style: TextStyles.captionS.copyWith(
                          color: isSuccess
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          SizedBox(height: 8.h),

          // Explore offers button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.offers);
              },
              icon: Icon(
                Icons.local_offer,
                size: 16.sp,
                color: AppColors.orange500,
              ),
              label: Text(
                "Explore more offers",
                style: TextStyles.captionS.copyWith(
                  color: AppColors.orange500,
                  decoration: TextDecoration.underline,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeInput() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: promoCodeController.promoCodeTextController,
            hintText: "Enter coupon code",
            prefixIcon: Icons.confirmation_number_outlined,
          ),
        ),
        SizedBox(width: 12.w),
        Obx(() {
          bool isLoading = promoCodeController.isLoading.value;
          return ZoomTapAnimation(
            onTap: isLoading
                ? null
                : () {
                    promoCodeController.applyPromoCode();
                  },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.orange500,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20.sp,
                    ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAppliedCodeCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promoCodeController.appliedPromoCode.value.toUpperCase(),
                  style: TextStyles.captionM.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                Text(
                  "Coupon applied successfully",
                  style: TextStyles.captionS.copyWith(
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
          ZoomTapAnimation(
            onTap: () {
              promoCodeController.clearPromoCode();
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetailsSection() {
    return Obx(() => Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.darkGrey300),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      color: AppColors.green300, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text("Bill Details",
                      style: TextStyles.captionL
                          .copyWith(color: AppColors.darkGrey500)),
                  const Spacer(),
                  Text(
                      "₹${promoCodeController.finalPayableAmount.value.toStringAsFixed(2)}",
                      style: TextStyles.captionL.copyWith(
                          color: AppColors.green300,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 16.h),
              _row("Item Total",
                  "₹${promoCodeController.subtotal.toStringAsFixed(2)}"),
              _row("Delivery Charge",
                  "₹${promoCodeController.deliveryCharge.toStringAsFixed(2)}"),
              _row("Tax", "₹${promoCodeController.tax.toStringAsFixed(2)}"),
              if (promoCodeController.discountAmount.value > 0)
                _row("Coupon Discount",
                    "-₹${promoCodeController.discountAmount.value.toStringAsFixed(2)}",
                    isDiscount: true),
              Divider(height: 24.h, thickness: 1),
              _row("Total Amount",
                  "₹${promoCodeController.finalPayableAmount.value.toStringAsFixed(2)}",
                  isBold: true),
            ],
          ),
        ));
  }

  Widget _row(String label, String value,
      {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyles.captionM.copyWith(
                fontWeight:
                    isBold ? FontWeight.bold : TextStyles.captionM.fontWeight,
                color: isBold ? AppColors.darkGrey500 : AppColors.darkGrey300,
              )),
          Text(value,
              style: TextStyles.captionM.copyWith(
                fontWeight:
                    isBold ? FontWeight.bold : TextStyles.captionM.fontWeight,
                color: isDiscount
                    ? Colors.green.shade600
                    : isBold
                        ? AppColors.darkGrey500
                        : AppColors.darkGrey300,
              )),
        ],
      ),
    );
  }
}
