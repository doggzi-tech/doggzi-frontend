import 'package:doggzi/controllers/food_menu_controller.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FoodMenuController()).quantityController;

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

          // Cart Item Section - change below as per backend
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  'assets/images/content.png',
                  width: 66.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),

              // Name and Weight
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chicken & Rice", style: TextStyles.bodyM),
                  SizedBox(height: 4.h),
                  Text("250 Gm", style: TextStyle(fontSize: 12.sp)),
                ],
              ),

              const Spacer(),

              // Quantity + Price
              Column(
                children: [
                  // Quantity Row
                  // quantity controller is not specific to item yet it is generalized. 
                  // need to assoicate quanitity controller with item id
                  Row(
                    children: [
                      ZoomTapAnimation(
                        onTap: () =>
                            Get.find<FoodMenuController>().quantityController.decrement(),
                        child: Icon(Icons.remove_circle,
                            size: 22.sp, color: AppColors.orange400),
                      ),
                      SizedBox(width: 8.w),
                      Obx(() {
                        final qty =
                            Get.find<FoodMenuController>().quantityController.quantity.value;
                        return Text(
                          qty.toString(),
                          style: TextStyles.bodyM.copyWith(
                            color: AppColors.darkGrey300,
                          ),
                        );
                      }),
                      SizedBox(width: 8.w),
                      ZoomTapAnimation(
                        onTap: () =>
                            Get.find<FoodMenuController>().quantityController.increment(),
                        child: Icon(Icons.add_circle,
                            size: 22.sp, color: AppColors.orange400),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Price
                  Text(
                    "₹199",
                    style: TextStyles.bodyM.copyWith(
                      color: AppColors.darkGrey300,
                    ),
                  ),
                ],
              )
            ],
          ),

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
