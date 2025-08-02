import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';

Widget buildFilterContainer(
  String text, {
  required VoidCallback onPressed,
  Icon? icon,
}) {
  return Padding(
    padding: EdgeInsets.only(right: 8.w),
    child: ZoomTapAnimation(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.lightGrey100.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: AppColors.orange300,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              SizedBox(width: 6.w),
            ],
            Text(
              text,
              style: TextStyles.bodyS.copyWith(
                color: AppColors.darkGrey500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
