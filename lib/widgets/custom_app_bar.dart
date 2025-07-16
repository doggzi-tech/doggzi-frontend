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
    this.showBackButton = false,
    this.onBackButtonTap,
    required this.title,
  });

  final String title;
  final IconData leadingIcon;
  final bool isLeadingIconVisible;
  final IconData trailingIcon;
  final Function()? onLeadingIconTap;
  final bool isTrailingIconVisible;
  final Function()? onTrailingIconTap;
  final bool showBackButton;
  final Function()? onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    // Check if we can go back in navigation
    final canGoBack = Navigator.canPop(context);
    final shouldShowBackButton = showBackButton && canGoBack;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Show back button if conditions are met, otherwise show leading icon
              Visibility(
                visible: shouldShowBackButton || isLeadingIconVisible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: CustomIcon(
                  icon:
                      shouldShowBackButton ? Icons.arrow_back_ios : leadingIcon,
                  onTap: () {
                    if (shouldShowBackButton) {
                      if (onBackButtonTap != null) {
                        onBackButtonTap!();
                      } else {
                        Navigator.pop(context);
                      }
                    } else {
                      onLeadingIconTap?.call();
                    }
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
                    onTrailingIconTap?.call();
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
