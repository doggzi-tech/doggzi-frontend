import 'package:carousel_slider/carousel_slider.dart';
import 'package:doggzi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/colors.dart';
import '../../theme/text_style.dart';

List<String> sliderItems = [
  "30 % off on 3 months subscription",
  "40 % off on 3 months subscription",
  "50 % off on 3 months subscription",
];
List<LinearGradient> gradientList = [
  AppColors.purpleGradient,
  AppColors.blueGradient,
  AppColors.orangeGradient,
  AppColors.greenGradient
];

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: "Subscription",
          ),
          SizedBox(height: 30.h),
          CarouselSlider(
            options: CarouselOptions(
              height: 50.h,
            ),
            items: sliderItems.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: 310.w,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: gradientList[
                          (sliderItems.indexOf(i) + 1) % gradientList.length],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.award,
                          color: AppColors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          i,
                          style: DoggziTextStyles.semiBold14.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Image.asset(
                  "assets/images/subscription_information.png",
                  fit: BoxFit.cover,
                  width: 360.w,
                  height: 230.h,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Your Pet’s Personalized Nutrition Plan",
                  style: DoggziTextStyles.bold16.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  "Crafted by experts. Delivered with care",
                  style: DoggziTextStyles.semiBold14.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
