import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem(
      {super.key,
      required this.title,
      required this.onTap,
      this.textColor = AppColors.black});

  final String title;
  final Function() onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.h),
      child: ZoomTapAnimation(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 17.h),
          decoration: BoxDecoration(
            color: AppColors.dividerGray.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: DoggziTextStyles.semiBold16.copyWith(
                  color: textColor,
                ),
              ),
              Icon(
                CupertinoIcons.forward,
                size: 20,
                color: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
