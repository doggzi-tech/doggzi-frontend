// Main onboarding screen
import 'package:doggzi/pages/on_boarding_page/on_boarding_page_2.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/on_boarding_controller.dart';
import 'on_boarding_page/on_boarding_page_1.dart';
import 'on_boarding_page/on_boarding_page_3.dart';
import 'on_boarding_page/on_boarding_page_4.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        top: false,
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              children: const [
                OnboardingPage1(),
                OnboardingPage2(),
                OnboardingPage3(),
                OnboardingPage4(),
              ],
            ),
            // Page indicators and navigation
            Positioned(
              bottom: 50.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Page indicators
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.only(left: 30.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          4,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: controller.currentPage.value == index
                                ? 20.w
                                : 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color: controller.currentPage.value == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Navigation buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: controller.skipOnboarding,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.nextPage,
                          child: Obx(
                            () => SizedBox(
                              width: 80.w,
                              height: 80.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer progress indicator circle
                                  SizedBox(
                                    width: 80.w,
                                    height: 80.h,
                                    child: CircularProgressIndicator(
                                      value:
                                          (controller.currentPage.value + 1) / 4,
                                      strokeWidth: 2.w,
                                      backgroundColor:
                                          Colors.white.withValues(alpha: 0.3),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Inner button circle with transparent arrow
                                  Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black.withValues(alpha: 0.1),
                                      size: 24.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
