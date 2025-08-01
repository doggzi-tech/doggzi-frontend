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
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        children: [
          CustomIcon(
            icon: Icons.location_on_outlined,
            iconColor: AppColors.orange400,
            onTap: () {
              // Navigate to settings page
            },
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Location",
                style: TextStyles.bodyS.copyWith(
                  color: AppColors.lightGrey400,
                ),
              ),
              Obx(() {
                return Text(
                  controller.currentPosition == null
                      ? "Fetching location..."
                      : "${controller.currentPosition?.latitude}, ${controller.currentPosition?.longitude}",
                  style: TextStyles.bodyXS,
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
