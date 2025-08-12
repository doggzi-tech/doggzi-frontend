import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/controllers/food_menu_controller.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:doggzi/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CartItemCard extends StatelessWidget {
  CartItemCard({super.key});

  final menuController = Get.find<FoodMenuController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.lightGrey100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Delivery Info
          Row(
            children: [
              const Icon(Icons.delivery_dining, color: Colors.blue),
              SizedBox(width: 6.w),
              Text("Delivery In 30 Mins", style: TextStyles.captionL),
            ],
          ),
          Divider(height: 18.h),

          Obx(() {
            return Column(
              children: [
                for (var item in cartController.cart.value.items)
                  // Cart Item Section - change below as per backend
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      CachedImage(
                        imageUrl: item.menuItem.s3Url,
                        cacheKey: item.menuItem.imageUrl,
                        width: 66.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10.w),

                      // Name and Weight
                      SizedBox(
                        width: 150.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.menuItem.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              // Adds "..." at the end
                              style: TextStyles.bodyM,
                            ),
                            SizedBox(height: 4.h),
                            Text(item.menuItem.quantity.toString(),
                                style: TextStyle(fontSize: 12.sp)),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Quantity + Price
                      Column(
                        children: [
                          Row(
                            children: [
                              ZoomTapAnimation(
                                onTap: () => cartController.addToCart(
                                    item.menuItem.id, -1),
                                // Decrease quantity
                                child: Icon(Icons.remove_circle,
                                    size: 22.sp, color: AppColors.orange400),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                item.quantity.toString(),
                                style: TextStyles.bodyM.copyWith(
                                  color: AppColors.darkGrey300,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              ZoomTapAnimation(
                                onTap: () => cartController.addToCart(
                                    item.menuItem.id, 1),
                                // Increase quantity
                                child: Icon(Icons.add_circle,
                                    size: 22.sp, color: AppColors.orange400),
                              ),
                            ],
                          ),

                          SizedBox(height: 8.h),

                          // Price
                          Text(
                            "₹${item.menuItem.price.toStringAsFixed(2)}",
                            style: TextStyles.bodyM.copyWith(
                              color: AppColors.darkGrey300,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
              ],
            );
          }),

          SizedBox(height: 12.h),

          ZoomTapAnimation(
            onTap: () {
              Get.toNamed('/menu');
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Icon(Icons.add, size: 18.sp),
                  SizedBox(width: 6.w),
                  Text("Add more items", style: TextStyles.actionM),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
