// Page 1: Personalized Nutrition Plans
import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.orangeGradient),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90.h),
            Text(
              '🐶 Personalized\nNutrition Plans',
              style: DoggziTextStyles.heading1.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            Text('Meals tailored to your pet\'s unique needs.',
                style: DoggziTextStyles.heading2.copyWith(
                  color: Colors.white,
                )),
            SizedBox(height: 60.h),
            // Pet tags
          ],
        ),
      ),
    );
  }
}
