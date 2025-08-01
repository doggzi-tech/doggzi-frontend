import 'package:doggzi/models/menu_model.dart';
import 'package:doggzi/pages/menu_page/widget/menu_item.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:doggzi/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../controllers/food_menu_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_search_component.dart';

class MenuPage extends GetView<FoodMenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar(
              title: "Menu",
              trailingIcon: Icons.notification_add,
              isTrailingIconVisible: true,
              onLeadingIconTap: () {
                // Navigate to settings page
              },
            ),
            const CustomSearchWidget(),
            Expanded(
              // Changed from Container to Expanded
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    // Filter chips row
                    Row(
                      children: [
                        // Food Type Filters
                        Row(
                          children: [
                            _buildFoodTypeChip(DietType.all),
                            SizedBox(width: 6.w),
                            _buildFoodTypeChip(DietType.vegetarian),
                            SizedBox(width: 6.w),
                            _buildFoodTypeChip(DietType.non_vegetarian),
                          ],
                        ),

                        SizedBox(width: 37.w),

                        // Pet Type Filters
                        Row(
                          children: [
                            _buildPetTypeChip(
                                Species.cat, FontAwesomeIcons.cat),
                            _buildToggleButton(),
                            _buildPetTypeChip(
                                Species.dog, FontAwesomeIcons.dog),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h), // Add some spacing
                    // GridView section
                    Expanded(
                      // Make GridView take remaining space
                      child: Obx(() {
                        return MasonryGridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                          // Add vertical spacing
                          itemCount: controller.allMenuItems.length,
                          itemBuilder: (context, index) {
                            return ZoomTapAnimation(
                              child: MenuItem(
                                item: controller.allMenuItems[index],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTypeChip(DietType type) {
    return Obx(() => GestureDetector(
          onTap: () => controller.selectFoodType(type),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: controller.selectedFoodType.value == type
                  ? AppColors.orange400.withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: controller.selectedFoodType.value == type
                    ? AppColors.orange400
                    : Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              type == DietType.vegetarian
                  ? 'Veg'
                  : type == DietType.non_vegetarian
                      ? 'Non-Veg'
                      : 'All',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: controller.selectedFoodType.value == type
                    ? AppColors.orange400
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ));
  }

  Widget _buildPetTypeChip(Species type, IconData icon) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectPetType(type),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: controller.selectedPetType.value == type
                    ? AppColors.orange400
                    : Colors.grey.shade600,
              ),
              SizedBox(height: 2.h),
              Text(
                type.name.capitalizeFirst!,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: controller.selectedPetType.value == type
                      ? AppColors.orange400
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Obx(() => GestureDetector(
          onTap: () {
            // Toggle between Cat and Dog
            String newType = controller.selectedPetType.value == Species.cat
                ? Species.dog.name
                : Species.cat.name;
            controller.selectPetType(
              Species.values.firstWhere((e) => e.name == newType),
            );
          },
          child: Container(
            width: 40.w,
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: controller.selectedPetType.value == 'Cat' ? 2.w : 20.w,
                  top: 3.h,
                  child: Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.orange400,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
