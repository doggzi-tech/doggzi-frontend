import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'custom_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leadingIcon = Icons.settings,
    this.isLeadingIconVisible = false,
    this.trailingIcon,
    this.onLeadingIconTap,
    this.isTrailingIconVisible = false,
    this.onTrailingIconTap,
    this.showBackButton = false,
    this.onBackButtonTap,
    required this.title,
  });

  final String title;
  final IconData leadingIcon;
  final bool isLeadingIconVisible;
  final IconData? trailingIcon;
  final VoidCallback? onLeadingIconTap;
  final bool isTrailingIconVisible;
  final VoidCallback? onTrailingIconTap;
  final bool showBackButton;
  final VoidCallback? onBackButtonTap;

  @override
  Size get preferredSize => Size.fromHeight(50.h + 44.h);

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);
    final shouldShowBackButton = showBackButton && canGoBack;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      decoration: BoxDecoration(
        color: AppColors.orange400,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(17.r),
          bottomRight: Radius.circular(17.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 50.h), // status bar / top padding
          Row(
            children: [
              // Left slot (fixed size)
              SizedBox(
                width: 44.w,
                height: 44.h,
                child: Visibility(
                  visible: shouldShowBackButton || isLeadingIconVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: CustomIcon(
                    icon:
                        shouldShowBackButton ? Icons.chevron_left : leadingIcon,
                    onTap: () {
                      if (shouldShowBackButton) {
                        if (onBackButtonTap != null) {
                          onBackButtonTap!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      } else {
                        onLeadingIconTap?.call();
                      }
                    },
                  ),
                ),
              ),

              // Center slot (expands, centers title)
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyles.h3.copyWith(
                      color: AppColors.lightGrey100,
                    ),
                  ),
                ),
              ),

              // Right slot (fixed size)
              SizedBox(
                width: 44.w,
                height: 44.h,
                child: Visibility(
                  visible: isTrailingIconVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: CustomIcon(
                    icon: trailingIcon,
                    onTap: onTrailingIconTap,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
