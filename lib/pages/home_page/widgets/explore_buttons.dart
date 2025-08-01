import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';

Widget buildExploreButton(
  String text, {
  required VoidCallback onPressed,
  required String imagePath,
}) {
  return Padding(
    padding: EdgeInsets.only(right: 12.w),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(80.w, 80.w), 
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
          side: BorderSide(
            color: AppColors.darkGrey500,
            width: 1.2.w,
          ),
        ),
        elevation: 0,
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
  );
}
