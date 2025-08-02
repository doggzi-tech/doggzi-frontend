import 'package:doggzi/controllers/location_controller.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/colors.dart';
import 'custom_icon.dart';

class LocationAppBar extends GetView<LocationController> {
  const LocationAppBar({super.key});

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
          Icon(
            Icons.location_on,
            color: AppColors.darkGrey100,
            size: 28.sp,
          ),
          SizedBox(width: 10.w),
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
          Spacer(),
          CustomIcon(
            icon: Icons.notification_add,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
