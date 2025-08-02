import 'package:carousel_slider/carousel_slider.dart';
import 'package:doggzi/controllers/bottom_nav_controller.dart';
import 'package:doggzi/controllers/carousel_controller.dart';
import 'package:doggzi/pages/home_page/widgets/explore_buttons.dart';
import 'package:doggzi/pages/home_page/widgets/filter_buttons.dart';
import 'package:doggzi/widgets/meal_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../controllers/food_menu_controller.dart';
import '../../theme/colors.dart';
import '../../theme/text_style.dart';
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
  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationAppBar(),
            SizedBox(height: 5.h),

            // Filter Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  buildFilterContainer("Filters",
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.sliders,
                        size: 16.sp,
                        color: AppColors.darkGrey500,
                      )),
                  buildFilterContainer("Pure Veg", onPressed: () {}),
                  buildFilterContainer("Under ₹500", onPressed: () {}),
                  buildFilterContainer("Previously Ordered", onPressed: () {}),
                  buildFilterContainer("Rating 4.0+", onPressed: () {}),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Special Offers",
                style: TextStyles.bodyL.copyWith(
                  color: AppColors.darkGrey500,
                ),
              ),
            ),

            SizedBox(height: 8.h),

            // Carousel
            CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOut,
                height: 140.h,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  currentIndex.value = index;
                },
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

            SizedBox(height: 6.h),

            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    sliderItems.length,
                    (index) => Container(
                      width: currentIndex.value == index ? 16.w : 8.w,
                      height: 8.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: currentIndex.value == index
                            ? AppColors.orange300
                            : AppColors.lightGrey200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                )),

            SizedBox(height: 4.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Explore More",
                style: TextStyles.bodyL.copyWith(
                  color: AppColors.darkGrey500,
                ),
              ),
            ),

            SizedBox(height: 6.h),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  buildExploreContainer("Dog's Fav",
                      imagePath: "assets/images/dog_fav.png", onPressed: () {}),
                  buildExploreContainer("Cat's Fav",
                      imagePath: "assets/images/cat_fav.png", onPressed: () {}),
                  buildExploreContainer("Offers",
                      imagePath: "assets/images/offers.png", onPressed: () {}),
                  buildExploreContainer("Treats",
                      imagePath: "assets/images/treats.png", onPressed: () {}),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Meals for Pet",
                    style:
                        TextStyles.bodyL.copyWith(color: AppColors.darkGrey500),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.darkGrey500,
                      size: 15.sp,
                    ),
                    onPressed: () {
                      controller.selectedIndex.value = 1;
                    },
                  ),
                ],
              ),
            ),

            Obx(() {
              return SizedBox(
                height: 255.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menuController.homeMenuItems.length > 2
                      ? 2
                      : menuController.homeMenuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuController.homeMenuItems[index];
                    return ZoomTapAnimation(
                      onTap: () {
                      showMenuItemDetails(item.id);
                    },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 12.w),
                        child: MenuItem(
                          item: item,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
