import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoggziShadows {
  static BoxShadow get cardShadow => BoxShadow(
        color: const Color(0x0A000000),
        blurRadius: 6.r,
        offset: Offset(0, 2.h),
      );

  static BoxShadow get onboardingShadow => BoxShadow(
        color: const Color(0x14000000),
        blurRadius: 16.r,
        offset: Offset(0, 8.h),
      );

  static BoxShadow get componentShadow => BoxShadow(
        color: const Color(0x0A000000),
        blurRadius: 8.r,
        offset: Offset(0, 4.h),
      );
}
