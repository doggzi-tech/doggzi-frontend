import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon.dart';
import 'widget/profile_intro_item.dart';
import 'widget/profile_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(
              title: "Profile",
              trailingIcon: Icons.notification_add,
              isTrailingIconVisible: true,
              onLeadingIconTap: () {
                // Navigate to settings page
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  const ProfileIntroItem(),
                  SizedBox(height: 30.h),
                  ProfileItem(
                    title: "My Pets",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                  ),
                  ProfileItem(
                    title: "Address",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                  ),
                  ProfileItem(
                    title: "Pet Management",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                  ),
                  ProfileItem(
                    title: "Subscriptions",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                  ),
                  ProfileItem(
                    title: "Notifications",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                  ),
                  ProfileItem(
                    title: "Terms & Conditions",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                  ),
                  ProfileItem(
                    title: "Privacy Policy",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                  ),
                  ProfileItem(
                    title: "Logout",
                    onTap: () {
                      // Navigate to My Pets page
                    },
                    textColor: AppColors.errorRed,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
