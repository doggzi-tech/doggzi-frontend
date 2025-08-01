import 'package:carousel_slider/carousel_slider.dart';
import 'package:doggzi/pages/subscription_page/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../controllers/food_menu_controller.dart';
import '../../theme/colors.dart';
import '../../theme/text_style.dart';
import '../../widgets/custom_search_component.dart';
import '../../widgets/location_app_bar.dart';
import '../menu_page/widget/menu_item.dart';

List<String> sliderItems = [
  "assets/images/subscription_information.png",
  "assets/images/subscription_information.png",
  "assets/images/subscription_information.png",
];

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final menuController = Get.find<FoodMenuController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            const LocationAppBar(),
            const CustomSearchWidget(),
            SizedBox(height: 5.h),

            // Carousel Section
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOut,
                height: 140.h,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              items: sliderItems.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Image.asset(
                          i,
                          fit: BoxFit.cover,
                          width: 350.w,
                          height: 140.h,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 10.h),

            // Main Content Section - Make it scrollable and expandable
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      // Meals for Pet Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Meals for Pet",
                            style: TextStyles.bodyL,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.lightGrey400,
                            size: 15.sp,
                          ),
                        ],
                      ),

                      // Menu Items Horizontal List
                      Obx(() {
                        return SizedBox(
                          height: 255.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: menuController.homeMenuItems.length > 2
                                ? 2
                                : menuController.homeMenuItems.length,
                            itemBuilder: (context, index) {
                              return ZoomTapAnimation(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: MenuItem(
                                    item: menuController.homeMenuItems[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),

                      SizedBox(height: 2.h),

                      // Subscription Card
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
