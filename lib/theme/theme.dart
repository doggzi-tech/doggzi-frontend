import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class DoggziTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: AppColors.primaryOrange,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDark, size: 24.sp),
        titleTextStyle: DoggziTextStyles.heading2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.dividerGray, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryOrange, width: 2.w),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryOrange,
        secondary: AppColors.accentYellow,
        error: AppColors.errorRed,
        surface: AppColors.white,
        background: AppColors.lightBackground,
      ),
    );
  }
}
