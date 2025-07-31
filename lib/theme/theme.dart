import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class DoggziTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: OldAppColors.primaryOrange,
      scaffoldBackgroundColor: OldAppColors.white,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        backgroundColor: OldAppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: OldAppColors.textDark, size: 24.sp),
        titleTextStyle: DoggziTextStyles.heading2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OldAppColors.primaryOrange,
          foregroundColor: OldAppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: OldAppColors.dividerGray, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: OldAppColors.primaryOrange, width: 2.w),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: OldAppColors.primaryOrange,
        secondary: OldAppColors.accentYellow,
        error: OldAppColors.errorRed,
        surface: OldAppColors.white,
        background: OldAppColors.lightBackground,
      ),
    );
  }
}
