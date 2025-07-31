import 'package:doggzi/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Container(
      decoration: const BoxDecoration(
        color: Color(0x82A1A1A1),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0, 
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/onboarding3_bg.png',
              width: screenWidth, 
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
                  style: DoggziTextStyles.heading1.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Text("Fresh food delivered on your schedule.",
                    style: DoggziTextStyles.heading2.copyWith(
                      color: Colors.white,
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
