// Page 1: Personalized Nutrition Plans
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onboarding2_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90.h),
            Text(
              '📦 Subscription-Based Deliveries',
              style: TextStyles.h2.copyWith(
                color: AppColors.darkGrey500,
              ),
            ),
            SizedBox(height: 20.h),
            Text("Auto-schedule meals with flexible delivery options.",
                style: TextStyles.h4.copyWith(
                  color: AppColors.darkGrey300,
                )),
            SizedBox(height: 60.h),
            // Pet tags
          ],
        ),
      ),
    );
  }
}
