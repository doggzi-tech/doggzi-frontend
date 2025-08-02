import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.radius = 12,
    this.iconColor = AppColors.lightGrey100,
  });

  final IconData? icon;
  final VoidCallback? onTap;
  final int radius;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: icon == Icons.notification_add
          ? () => Get.toNamed('/notifications')
          : onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(radius.toDouble().r),
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
