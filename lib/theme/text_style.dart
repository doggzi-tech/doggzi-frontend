
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
