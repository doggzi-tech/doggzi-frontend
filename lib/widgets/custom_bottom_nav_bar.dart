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
    return NavigationBar(
      backgroundColor: Colors.transparent,
      destinations: [
        for (int i = 0; i < items.length; i++) _buildNavItem(i),
      ],
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
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(isSelected ? 8.w : 0.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.orange400 : Colors.transparent,
                ),
                child: Icon(
                  isSelected ? items[index].activeIcon : items[index].icon,
                  color: isSelected
                      ? AppColors.lightGrey100
                      : AppColors.darkGrey300,
                  size: isSelected ? 26.sp : 24.sp,
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color:
                      isSelected ? AppColors.orange400 : AppColors.darkGrey300,
                  fontSize: isSelected ? 9.5.sp : 8.5.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(items[index].label),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      );
    });
  }
}
