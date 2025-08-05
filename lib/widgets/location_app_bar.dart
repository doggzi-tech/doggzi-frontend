import 'package:doggzi/controllers/location_controller.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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
        left: 25.w,
        right: 25.w,
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
            ZoomTapAnimation(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.darkGrey100,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 10.w),
          ],
          Icon(
            Icons.location_on,
            color: AppColors.darkGrey100,
            size: 26.sp,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Location",
                style: TextStyles.bodyM.copyWith(
                  color: AppColors.darkGrey100,
                ),
              ),
              Obx(() {
                return Text(
                  controller.currentPosition == null
                      ? "Fetching location..."
                      : "${controller.currentPosition?.latitude}, ${controller.currentPosition?.longitude}",
                  style: TextStyles.bodyL.copyWith(
                    color: AppColors.darkGrey100,
                  ),
                );
              }),
            ],
          ),
          const Spacer(),
          ZoomTapAnimation(
            onTap: () {
              Get.to(() => const LoggerScreen());
            },
            child: Container(
              width: 60.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppColors.orange300,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  "Monitor",
                  style: TextStyles.bodyS.copyWith(
                    color: AppColors.lightGrey100,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          CustomIcon(
            icon: Icons.notification_add,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
