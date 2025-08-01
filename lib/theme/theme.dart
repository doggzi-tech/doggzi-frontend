import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class DoggziTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: AppColors.orange400,
      scaffoldBackgroundColor: AppColors.lightGrey100,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightGrey100,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkGrey500, size: 24.sp),
        titleTextStyle: TextStyles.bodyXL,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange400,
          foregroundColor: AppColors.darkGrey500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.darkGrey400, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.orange400, width: 2.w),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.orange400,
        secondary: AppColors.orange200,
        error: AppColors.orange500,
        surface: AppColors.darkGrey500,
        background: AppColors.lightGrey300,
      ),
    );
  }
}
