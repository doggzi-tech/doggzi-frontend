// Page 1: Personalized Nutrition Plans
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onboarding4_bg.png'),
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
              '🧠 Vet-Approved Diet Guidance',
              style: TextStyles.h2.copyWith(
                color: AppColors.lightGrey100,
              ),
            ),
            SizedBox(height: 20.h),
            Text("Nutrition designed by experts for pet condition.",
                style: TextStyles.bodyL.copyWith(
                  color: AppColors.lightGrey100,
                )),
            SizedBox(height: 60.h),
            // Pet tags
          ],
        ),
      ),
    );
  }
}
