import 'package:doggzi/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../controllers/pet_controller.dart';
import '../../../models/pet_model.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';
import '../../../widgets/custom_app_bar.dart';

class MyPetView extends GetView<PetController> {
  const MyPetView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil in your app's entry point (usually in MaterialApp builder)
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange400,
        child: Icon(Icons.add, size: 24.sp),
        onPressed: () {
          Get.toNamed(AppRoutes.petOnboarding1Page);
        },
      ),
      body: Column(
        children: [
          CustomAppBar(
            title: "My Pets",
            onLeadingIconTap: () {
              // Navigate to settings page
            },
          ),
          Obx(() {
            if (controller.pets.isEmpty) {
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      "You have no pets yet. Add your first pet!",
                      style: TextStyles.actionM,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
              ),
              shrinkWrap: true,
              padding: EdgeInsets.all(16.w),
              itemCount: controller.pets.length,
              itemBuilder: (context, index) =>
                  _PetCard(pet: controller.pets[index]),
            );
          })
        ],
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final PetModel pet;

  const _PetCard({required this.pet});

  String _getPetImageAsset(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return 'assets/images/dog_left.svg';
      case 'cat':
        return 'assets/images/cat_left.svg';
      default:
        return 'assets/images/dog_left.svg'; // Default to dog if species is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.lightGrey100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 60.w,
                height: 60.h,
                color: AppColors.lightGrey100,
                child: SvgPicture.asset(
                  _getPetImageAsset(pet.species),
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) => Container(
                    width: 80.w,
                    height: 80.h,
                    color: AppColors.darkGrey300,
                    child: Icon(
                      Icons.pets,
                      color: AppColors.darkGrey500,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${pet.name} , ${(pet.ageMonths / 12).floor()}y ${(pet.ageMonths % 12)}m",
                    style: TextStyles.actionM,
                  ),
                  const Spacer(),
                  Text(
                    pet.breed,
                    style: TextStyles.actionM.copyWith(
                      color: AppColors.darkGrey300,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 100.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: AppColors.orange400,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Edit Pet Details",
                        style: TextStyles.actionS.copyWith(
                          color: AppColors.orange400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
