import 'package:doggzi/controllers/pet_controller.dart';
import 'package:doggzi/controllers/pet_onboarding_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../theme/colors.dart';
import '../../theme/text_style.dart';
import '../../widgets/custom_icon.dart';

class PetOnboarding1Page extends GetView<PetOnboardingController> {
  const PetOnboarding1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // Add horizontal padding
          child: Column(
            children: [
              SizedBox(height: 16.h),
              // Custom AppBar container
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: CustomIcon(
                      iconColor: AppColors.darkGrey400,
                      icon: Icons.chevron_left,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  Text(
                    "ADD PET PROFILE",
                    style: TextStyles.h4.copyWith(
                      color: AppColors.darkGrey400,
                    ),
                  ),
                  Text(
                    "Step 1",
                    style: TextStyles.bodyL.copyWith(
                      color: AppColors.darkGrey500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              LinearProgressIndicator(
                value: 0.25,
                // 25%
                minHeight: 6.h,
                backgroundColor: AppColors.lightGrey300,
                borderRadius: BorderRadius.circular(8.r),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.orange400),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Who’s joining us? 🐾",
                        style: TextStyles.h5.copyWith(
                          color: AppColors.darkGrey500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ZoomTapAnimation(
                      onTap: () {
                        controller.petOnboarding.value = controller
                            .petOnboarding.value
                            .copyWith(species: "dog");
                      },
                      child: SizedBox(
                        height: 310.h,
                        width: 310.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background image (centered and fully visible)
                            Positioned(
                              bottom: 50.h,
                              child: Container(
                                width: 250.w,
                                height: 180.h,
                                decoration: BoxDecoration(
                                  color: AppColors.orange100
                                      .withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(38.r),
                                    topRight: Radius.circular(38.r),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              if (controller.petOnboarding.value.species ==
                                  "dog") {
                                return Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 290.w,
                                    height: 310.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.green200,
                                        width: 1.w,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(38.r),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            }),
                            Positioned(
                              top: 0,
                              child: Image.asset(
                                "assets/images/dog_onboarding.png",
                                fit: BoxFit.contain,
                                width: 310.w,
                                height: 260.h,
                              ),
                            ),
                            Positioned(
                              bottom: 10.h,
                              child: Text(
                                "The Bark Side - Dog",
                                style: TextStyles.h5,
                              ),
                            ),
                            // Other stacked widgets can go here if needed
                          ],
                        ),
                      ),
                    ),
                    ZoomTapAnimation(
                      beginCurve: Curves.elasticOut, // <- More bounce
                      endCurve: Curves.easeOut,
                      onTap: () {
                        controller.petOnboarding.value = controller
                            .petOnboarding.value
                            .copyWith(species: "cat");
                      },
                      child: SizedBox(
                        height: 310.h,
                        width: 310.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background image (centered and fully visible)
                            Positioned(
                              bottom: 50.h,
                              child: Container(
                                width: 250.w,
                                height: 180.h,
                                decoration: BoxDecoration(
                                  color: AppColors.orange100
                                      .withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(38.r),
                                    topRight: Radius.circular(38.r),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              if (controller.petOnboarding.value.species ==
                                  "cat") {
                                return Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 290.w,
                                    height: 310.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.green200,
                                        width: 1.w,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(38.r),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            }),
                            Positioned(
                              top: 0,
                              child: Image.asset(
                                "assets/images/cat_onboarding.png",
                                fit: BoxFit.contain,
                                width: 310.w,
                                height: 260.h,
                              ),
                            ),
                            Positioned(
                              bottom: 10.h,
                              child: Text(
                                "The Meow Side - Cat",
                                style: TextStyles.h5,
                              ),
                            ),
                            // Other stacked widgets can go here if needed
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      text: "Next",
                      onPressed: () {
                        if (controller.petOnboarding.value.species.isEmpty) {
                          customSnackBar.show(
                            message: "Please select a species",
                          );
                          return;
                        }
                        controller.petOnboarding.value.breed = "";
                        Get.toNamed(AppRoutes.petOnboarding2Page);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
