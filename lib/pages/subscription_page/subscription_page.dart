import 'package:carousel_slider/carousel_slider.dart';
import 'package:doggzi/widgets/custom_app_bar.dart';
import 'package:doggzi/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/carousel_controller.dart';
import '../../controllers/pet_controller.dart';
import '../../core/app_routes.dart';
import '../../theme/colors.dart';
import '../../theme/text_style.dart';
import '../../widgets/cache_image.dart';

List<LinearGradient> gradientList = [
  AppColors.purpleGradient,
  AppColors.blueGradient,
  AppColors.orangeGradient,
  AppColors.greenGradient
];

class SubscriptionPage extends GetView<PetController> {
  SubscriptionPage({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(
              title: "Subscription",
            ),
            SizedBox(height: 30.h),
            Obx(
              () => CarouselSlider(
                options: CarouselOptions(
                  height: 50.h,
                  autoPlay: true,
                  // 🔁 Enables auto-rotation
                  autoPlayInterval: Duration(seconds: 3),
                  // ⏱ Interval between slides
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  // 🎞 Animation speed
                  autoPlayCurve: Curves.easeInOut, // 🌀 Smooth transition
                ),
                items:
                    authController.generalSettings.value.offerTaglines.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 310.w,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: gradientList[(authController
                                      .generalSettings.value.offerTaglines
                                      .indexOf(i) +
                                  1) %
                              gradientList.length],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.award,
                              color: AppColors.lightGrey100,
                              size: 20.sp,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              i.tagline,
                              style: TextStyles.bodyS.copyWith(
                                color: AppColors.lightGrey100,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Obx(() {
                    final images = authController
                        .generalSettings.value.subscriptionCarouselImages;
                    return CarouselSlider(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.easeInOut,
                        height: 220.h,
                        viewportFraction: 0.9,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          currentIndex.value = index;
                        },
                      ),
                      items: images.map((i) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          child: CachedImage(
                            cacheKey: i.imageUrl,
                            imageUrl: i.s3Url,
                            fit: BoxFit.cover,
                            width: 350.w,
                            height: 220.h,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  SizedBox(height: 20.h),
                  Text(
                    "Your Pet’s Personalized Nutrition Plan",
                    style: TextStyles.bodyL.copyWith(
                      color: AppColors.darkGrey400,
                    ),
                  ),
                  Text(
                    "Crafted by experts. Delivered with care",
                    style: TextStyles.bodyS.copyWith(
                      color: AppColors.lightGrey400,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CustomButton(
                    text: "Add New Pet",
                    onPressed: () {
                      Get.toNamed(AppRoutes.petOnboarding1Page);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
