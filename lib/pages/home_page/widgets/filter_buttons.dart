import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';
Widget buildFilterButton(
  String text, {
  required VoidCallback onPressed,
  Icon? icon,
}) {
  return Padding(
    padding: EdgeInsets.only(right: 8.w),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightGrey100.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
          side: BorderSide(
            color: AppColors.orange300,
            width: 1.w,
          ),
        ),
        elevation: 0,
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
  );
}
