import 'package:doggzi/pages/profile_page/widget/my_pet_view.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/pet_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon.dart';
import 'widget/profile_intro_item.dart';
import 'widget/profile_item.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final authController = Get.find<AuthController>();
  final petController = Get.find<PetController>();

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
                  ProfileIntroItem(),
                  SizedBox(height: 30.h),
                  ProfileItem(
                    title: "My Pets",
                    onTap: () {
                      Get.to(
                        () => MyPetView(pets: petController.pets),
                        transition: Transition.rightToLeft,
                      );
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
                      authController.logout();
                    },
                    textColor: OldAppColors.errorRed,
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
