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
                          Text(
                            "Meals for Pet",
                            style: DoggziTextStyles.bold16.copyWith(
                              color: OldAppColors.textDark,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: OldAppColors.textDark,
                            size: 15.sp,
                          ),
                        ],
                      ),

                      // Menu Items Horizontal List
                      Obx(() {
                        return SizedBox(
                          height: 255.h,
                          child: menuController.menuItems.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: menuController.menuItems.length > 2
                                      ? 2
                                      : menuController.menuItems.length,
                                  itemBuilder: (context, index) {
                                    return ZoomTapAnimation(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 12.w),
                                        child: MenuItem(
                                          item: menuController.menuItems[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        );
                      }),

                      SizedBox(height: 2.h),

                      // Subscription Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFE5E5),
                              Color(0xFFFFF0F0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: OldAppColors.primaryOrange
                                .withValues(alpha: 0.3),
                            width: 2.w,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Main content
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                left: 12.w,
                                right: 12.w,
                                bottom: 8.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header section
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Subscribe to the meal',
                                              style: DoggziTextStyles.bold14
                                                  .copyWith(
                                                color:
                                                    OldAppColors.primaryOrange,
                                              ),
                                            ),
                                            Text(
                                              'In 3 simple steps',
                                              style:
                                                  DoggziTextStyles.semiBold14,
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Navigate to subscription page
                                          Get.to(
                                              () => const SubscriptionPage());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: OldAppColors.primaryOrange
                                                .withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                              color: OldAppColors.primaryOrange,
                                              width: 1.5.w,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'Try now',
                                            style: DoggziTextStyles.semiBold12
                                                .copyWith(
                                              color: OldAppColors.primaryOrange,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),

                                  // Steps
                                  _buildStep(
                                    stepNumber: '1.',
                                    icon: '🐕',
                                    text:
                                        'Tell us all about your furry friend!',
                                  ),
                                  SizedBox(height: 4.h),
                                  _buildStep(
                                    stepNumber: '2.',
                                    icon: '🍽️',
                                    text:
                                        'Get a custom meal plan curated by nutritionists!',
                                  ),
                                  SizedBox(height: 4.h),

                                  _buildStep(
                                    stepNumber: '3.',
                                    icon: '🚚',
                                    text:
                                        'Pay & relax while we deliver to your doorstep!',
                                  ),
                                ],
                              ),
                            ),

                            // Discount badge
                            Positioned(
                              top: 0,
                              right: 10.w,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(60.r),
                                    bottomLeft: Radius.circular(60.r),
                                  ),
                                  gradient: OldAppColors.purpleGradient,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.award,
                                      color: OldAppColors.white,
                                      size: 10.sp,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      offerSliderItems[0],
                                      style:
                                          DoggziTextStyles.semiBold10.copyWith(
                                        color: OldAppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

Widget _buildStep({
  required String stepNumber,
  required String icon,
  required String text,
}) {
  return Row(
    children: [
      Text(
        stepNumber,
        style: DoggziTextStyles.semiBold14,
      ),
      SizedBox(width: 4.w),
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 12.w),
              Text(
                icon,
                style: TextStyle(fontSize: 10.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  text,
                  style: DoggziTextStyles.semiBold10,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
