import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  // Headings
  static const String _fontFamily = "Manrope";
  static TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800, // Extra Bold
    fontSize: 30.sp,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 28.sp,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 24.sp,
  );

  static TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 20.sp,
  );

  static TextStyle h5 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 16.sp,
  );

  // Body
  static TextStyle bodyXL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 18.sp,
  );

  static TextStyle bodyL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 16.sp,
  );

  static TextStyle bodyM = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500, // Medium
    fontSize: 14.sp,
  );

  static TextStyle bodyS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 12.sp,
  );

  static TextStyle bodyXS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 10.sp,
  );

  // Action
  static TextStyle actionL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // Semi-Bold
    fontSize: 18.sp,
  );

  static TextStyle actionM = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
  );

  static TextStyle actionS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 10.sp,
  );

  // Caption
  static TextStyle captionL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
  );

  static TextStyle captionM = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
  );

  static TextStyle captionS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 8.sp,
  );
}
