import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/bottom_nav_controller.dart';

// Bottom Navigation Item Model
class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// Custom Bottom Navigation Bar
class CustomBottomNavBar extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<BottomNavItem> items = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    BottomNavItem(
      icon: Icons.menu_outlined,
      activeIcon: Icons.menu,
      label: 'Menu',
    ),
    BottomNavItem(
      icon: Icons.subscriptions_outlined,
      activeIcon: Icons.subscriptions,
      label: 'Subscription',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBackground,
            blurRadius: 2.r,
            offset: Offset(0, -1.h),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => _buildNavItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeTabIndex(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16.w : 12.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryOrange.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? items[index].activeIcon : items[index].icon,
                  color: isSelected
                      ? AppColors.primaryOrange
                      : AppColors.textMedium,
                  size: isSelected ? 26.sp : 24.sp,
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryOrange
                      : AppColors.textMedium,
                  fontSize: isSelected ? 12.sp : 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(items[index].label),
              ),
              SizedBox(height: 2.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3.h,
                width: isSelected ? 20.w : 0,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
