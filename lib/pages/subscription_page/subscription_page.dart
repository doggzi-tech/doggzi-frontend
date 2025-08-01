import 'package:carousel_slider/carousel_slider.dart';
import 'package:doggzi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/pet_controller.dart';
import '../../theme/colors.dart';
import '../../theme/text_style.dart';

List<String> offerSliderItems = [
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

class SubscriptionPage extends GetView<PetController> {
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
              autoPlay: true,
              // 🔁 Enables auto-rotation
              autoPlayInterval: Duration(seconds: 3),
              // ⏱ Interval between slides
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              // 🎞 Animation speed
              autoPlayCurve: Curves.easeInOut, // 🌀 Smooth transition
            ),
            items: offerSliderItems.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: 310.w,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: gradientList[(offerSliderItems.indexOf(i) + 1) %
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
                          i,
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
              ],
            ),
          )
        ],
      )),
    );
  }
}
