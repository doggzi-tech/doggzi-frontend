import 'package:doggzi/controllers/location_controller.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../core/app_routes.dart';
import '../logger/log_screen.dart';
import '../theme/colors.dart';
import 'custom_icon.dart';

class LocationAppBar extends GetView<LocationController> {
  final bool showBackButton;

  const LocationAppBar({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
        top: 50.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.orange400,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(17.r),
          bottomRight: Radius.circular(17.r),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            CustomIcon(
              onTap: () => Get.back(),
              icon: Icons.chevron_left,
            ),
            SizedBox(width: 5.w),
          ],
          ZoomTapAnimation(
            onTap: () {
              Get.toNamed(AppRoutes.addressListPage);
            },
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.darkGrey100,
                  size: 26.sp,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Location",
                      style: TextStyles.bodyS.copyWith(
                        color: AppColors.darkGrey100,
                      ),
                    ),
                    Obx(() {
                      return Text(
                        controller.currentPosition == null
                            ? "Fetching location..."
                            : controller.address.value,
                        style: TextStyles.bodyM.copyWith(
                          color: AppColors.darkGrey100,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          ZoomTapAnimation(
            onTap: () {
              Get.to(() => const LoggerScreen());
            },
            child: Container(
              width: 50.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColors.orange300,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  "Monitor",
                  style: TextStyles.bodyXS.copyWith(
                    color: AppColors.lightGrey100,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
