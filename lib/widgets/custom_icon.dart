import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.radius = 12,
  });

  final IconData? icon;
  final VoidCallback? onTap;
  final int radius;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.textMedium.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(radius!.toDouble().r),
        ),
        child: Icon(
          icon,
          color: AppColors.textMedium,
          size: 24.sp,
        ),
      ),
    );
  }
}
