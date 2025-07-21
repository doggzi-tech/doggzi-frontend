import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/pet_model.dart';
import '../../../theme/colors.dart';
import '../../../widgets/custom_app_bar.dart';

class MyPetView extends StatelessWidget {
  final List<PetModel> pets;

  const MyPetView({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil in your app's entry point (usually in MaterialApp builder)
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "My Pets",
              trailingIcon: Icons.notification_add,
              isTrailingIconVisible: true,
              onLeadingIconTap: () {
                // Navigate to settings page
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(16.w),
              itemCount: pets.length,
              itemBuilder: (context, index) => _PetCard(pet: pets[index]),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final PetModel pet;

  const _PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: AppColors.orangeGradient,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    "",
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80.w,
                      height: 80.h,
                      color: AppColors.dividerGray,
                      child: Icon(
                        Icons.pets,
                        color: AppColors.black,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${pet.species} • ${pet.breed}',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.9),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.cake,
                            label:
                                '${(pet.ageMonths / 12).floor()}y ${(pet.ageMonths % 12)}m',
                          ),
                          SizedBox(width: 8.w),
                          _InfoChip(
                            icon: Icons.fitness_center,
                            label: '${pet.weightKg.toStringAsFixed(1)} kg',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppColors.black.withOpacity(0.7), size: 16.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: AppColors.black),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
