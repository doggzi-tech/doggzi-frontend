import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoggziTextStyles {
  static const String _fontFamily = 'Manrope';

  static TextStyle get heading1 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 30.sp,
        fontWeight: FontWeight.w900,
        color: AppColors.textDark,
      );

  static TextStyle get heading2 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
      );

  static TextStyle get pageHeading => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      );

  static TextStyle get bodyText => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      );

  static TextStyle get label => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      );

  static TextStyle get bold14 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w900,
        color: AppColors.textDark,
      );

  static TextStyle get bold16 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w900,
        color: AppColors.black,
      );

  static TextStyle get semiBold10 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get semiBold12 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get semiBold14 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textMedium,
      );

  static TextStyle get semiBold16 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );
}
