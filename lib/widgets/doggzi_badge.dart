import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/text_style.dart';

// 🏷 Tags / Badges (Responsive)
class DoggziBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const DoggziBadge({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.w,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.accentYellow,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: DoggziTextStyles.smallText.copyWith(
          color: textColor ?? AppColors.primaryOrange,
        ),
      ),
    );
  }
}
