import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/pages/cart_page/widgets/cart_items.dart';
import 'package:doggzi/pages/cart_page/widgets/delivery_address_card.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:doggzi/widgets/location_app_bar.dart';
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
                  child: Text(
                    "Your cart is empty",
                    style: TextStyles.captionL.copyWith(color: Colors.grey),
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

                        // Order Item Card, need to retrieve actual cart items
                        CartItemCard(),

                        SizedBox(height: 16.h),
                        // Promo Code Section
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.discount,
                                      color: AppColors.orange500, size: 20.sp),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: TextField(
                                      controller: promoCodeController
                                          .promoCodeTextController,
                                      decoration: const InputDecoration(
                                        hintText: "Apply Coupon",
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: TextStyles.captionM,
                                    ),
                                  ),
                                  Obx(
                                    () => promoCodeController
                                            .appliedPromoCode.value.isNotEmpty
                                        ? ZoomTapAnimation(
                                            onTap: () {
                                              promoCodeController
                                                  .clearPromoCode();
                                            },
                                            child: Icon(Icons.close,
                                                size: 16.sp,
                                                color: Colors.grey),
                                          )
                                        : ZoomTapAnimation(
                                            onTap: () {
                                              promoCodeController
                                                  .applyPromoCode();
                                            },
                                            child: Icon(Icons.arrow_forward_ios,
                                                size: 16.sp,
                                                color: Colors.grey),
                                          ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => promoCodeController
                                        .promoCodeMessage.value.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                          promoCodeController
                                              .promoCodeMessage.value,
                                          style: TextStyles.captionM.copyWith(
                                            color: promoCodeController
                                                    .promoCodeMessage.value
                                                    .contains('successfully')
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(AppRoutes
                                        .offers); // Assuming notificationPage can be used for offers
                                  },
                                  child: Text(
                                    "Explore other offers",
                                    style: TextStyles.captionM.copyWith(
                                        color: AppColors.orange500,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Obx(
                          () => Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.darkGrey300),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.receipt_long,
                                        color: AppColors.green300, size: 20.sp),
                                    SizedBox(width: 8.w),
                                    Text("Total Bill ",
                                        style: TextStyles.captionL.copyWith(
                                            color: AppColors.darkGrey500)),
                                    Text(
                                        "₹${promoCodeController.finalPayableAmount.value.toStringAsFixed(2)}",
                                        style: TextStyles.captionL.copyWith(
                                            color: AppColors.green300)),
                                  ],
                                ),
                                Divider(height: 24.h),
                                _row("Item Total",
                                    "₹${promoCodeController.subtotal.toStringAsFixed(2)}"),
                                _row("Delivery Charge",
                                    "₹${promoCodeController.deliveryCharge.toStringAsFixed(2)}"),
                                _row("Tax",
                                    "₹${promoCodeController.tax.toStringAsFixed(2)}"),
                                _row("Coupon Discount",
                                    "-₹${promoCodeController.discountAmount.value.toStringAsFixed(2)}"),
                                Divider(),
                                _row("To Pay",
                                    "₹${promoCodeController.finalPayableAmount.value.toStringAsFixed(2)}",
                                    isBold: true),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

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
                      ],
                    ),
                  ),
                ),
              ),

              // Pay Button (Sticky at bottom)
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Obx(
                      () => Text(
                          "Pay ₹${promoCodeController.finalPayableAmount.value.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold)),
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

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
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
                color: isBold ? AppColors.darkGrey500 : AppColors.darkGrey300,
              )),
        ],
      ),
    );
  }
}
