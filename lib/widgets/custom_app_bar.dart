import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/text_style.dart';
import 'custom_icon.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.leadingIcon = Icons.settings,
    this.isLeadingIconVisible = false,
    this.trailingIcon = Icons.notification_add,
    this.onLeadingIconTap,
    this.isTrailingIconVisible = true,
    this.onTrailingIconTap,
    required this.title,
  });

  final String title;
  final IconData leadingIcon;
  final bool isLeadingIconVisible;
  final IconData trailingIcon;
  final Function()? onLeadingIconTap;
  final bool isTrailingIconVisible;
  final Function()? onTrailingIconTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: isLeadingIconVisible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: CustomIcon(
                  icon: leadingIcon,
                  onTap: () {
                    // Navigate to settings page
                  },
                ),
              ),
              Text(
                title,
                style: DoggziTextStyles.pageHeading,
              ),
              Visibility(
                visible: isTrailingIconVisible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: CustomIcon(
                  icon: trailingIcon,
                  onTap: () {
                    onLeadingIconTap?.call();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
