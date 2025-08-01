import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFA1A1A1), // Background color
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/onboarding3_bg.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 90.h),
                Text(
                  '🕒 Timely Doorstep Delivery',
                  style: TextStyles.h2.copyWith(
                    color: AppColors.darkGrey500,
                  ),
                ),
                SizedBox(height: 20.h),
                Text("Fresh food delivered on your schedule.",
                    style: TextStyles.h4.copyWith(
                      color: AppColors.darkGrey300,
                    )),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
