import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';

Widget buildExploreContainer(
  String text, {
  required VoidCallback onPressed,
  required String imagePath,
}) {
  return Padding(
    padding: EdgeInsets.only(right: 12.w),
    child: ZoomTapAnimation(
      onTap: onPressed,
      child: Container(
        width: 80.w,
        height: 65.w,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: AppColors.darkGrey200,
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 32.w,
              height: 32.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 6.h),
            Text(
              text,
              style: TextStyles.bodyS.copyWith(
                color: AppColors.darkGrey500,
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
