import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  // Headings
  static const String _fontFamily = "Manrope";
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800, // Extra Bold
    fontSize: 30,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 28,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 24,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 16,
  );

  // Body
  static const TextStyle bodyXL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 18,
  );

  static const TextStyle bodyL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 16,
  );

  static const TextStyle bodyM = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500, // Medium
    fontSize: 14,
  );

  static const TextStyle bodyS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 12,
  );

  static const TextStyle bodyXS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 10,
  );

  // Action
  static const TextStyle actionL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // Semi-Bold
    fontSize: 18,
  );

  static const TextStyle actionM = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  static const TextStyle actionS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 10,
  );

  // Caption
  static const TextStyle captionL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  static const TextStyle captionM = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static const TextStyle captionS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 8,
  );
}

class DoggziTextStyles {
  static const String _fontFamily = "Manrope";

  static TextStyle get heading1 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 30.sp,
        fontWeight: FontWeight.w900,
        color: OldAppColors.textDark,
      );

  static TextStyle get heading2 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: OldAppColors.textDark,
      );

  static TextStyle get pageHeading => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        color: OldAppColors.textDark,
      );

  static TextStyle get bodyText => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: OldAppColors.textDark,
      );

  static TextStyle get label => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: OldAppColors.textDark,
      );

  static TextStyle get bold14 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w900,
        color: OldAppColors.textDark,
      );

  static TextStyle get bold16 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w900,
        color: OldAppColors.black,
      );

  static TextStyle get semiBold10 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: OldAppColors.textDark,
      );

  static TextStyle get semiBold12 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: OldAppColors.textDark,
      );

  static TextStyle get semiBold14 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: OldAppColors.textMedium,
      );

  static TextStyle get semiBold16 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: OldAppColors.textDark,
      );
}
