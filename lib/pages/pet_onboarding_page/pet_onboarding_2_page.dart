import 'package:doggzi/controllers/auth_controller.dart';
import 'package:doggzi/controllers/pet_controller.dart';
import 'package:doggzi/controllers/pet_onboarding_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/widgets/cache_image.dart';
import 'package:doggzi/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../models/general_model.dart';
import '../../theme/colors.dart';
import '../../theme/text_style.dart';
import '../../widgets/custom_icon.dart';

class PetOnboarding2Page extends GetView<PetOnboardingController> {
  const PetOnboarding2Page({super.key});

  // Constants for better maintainability
  static const double _horizontalPadding = 16.0;
  static const double _gridSpacing = 12.0;
  static const double _progressValue = 0.5;
  static const int _gridCrossAxisCount = 2;
  static const double _gridAspectRatio = 1.0;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header
            _buildHeader(),

            // Scrollable content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildSectionTitle(),
                    SizedBox(height: 16.h),
                    Expanded(child: _buildBreedGrid(authController)),
                    _buildNextButton(),
                    SizedBox(height: 20.h), // Bottom spacing
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(_horizontalPadding.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          _buildAppBar(),
          SizedBox(height: 8.h),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 40.w,
          height: 40.h,
          child: CustomIcon(
            iconColor: AppColors.darkGrey400,
            icon: Icons.chevron_left,
            onTap: Get.back,
          ),
        ),
        Expanded(
          child: Text(
            "ADD PET PROFILE",
            textAlign: TextAlign.center,
            style: TextStyles.h4.copyWith(
              color: AppColors.darkGrey400,
            ),
          ),
        ),
        Text(
          "Step 2",
          style: TextStyles.bodyL.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: _progressValue,
      minHeight: 6.h,
      backgroundColor: AppColors.lightGrey300,
      borderRadius: BorderRadius.circular(8.r),
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.orange400),
      semanticsLabel: 'Progress: Step 2 of 4',
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      "Select Breed",
      style: TextStyles.h5.copyWith(
        color: AppColors.darkGrey500,
      ),
    );
  }

  Widget _buildBreedGrid(AuthController authController) {
    return Obx(() {
      final breedList = _getBreedList(authController);

      if (breedList.isEmpty) {
        return _buildEmptyState();
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridCrossAxisCount,
          childAspectRatio: _gridAspectRatio,
          crossAxisSpacing: _gridSpacing.w,
          mainAxisSpacing: _gridSpacing.h,
        ),
        itemBuilder: (context, index) => _buildBreedCard(breedList[index]),
        itemCount: breedList.length,
        shrinkWrap: true,
      );
    });
  }

  List<Breed> _getBreedList(AuthController authController) {
    final species = controller.petOnboarding.value.species;
    switch (species) {
      case "dog":
        return authController.generalSettings.value.dogBreeds;
      case "cat":
        return authController.generalSettings.value.catBreeds;
      default:
        return [];
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(
            Icons.pets,
            size: 48.w,
            color: AppColors.darkGrey300,
          ),
          SizedBox(height: 16.h),
          Text(
            "No breeds available",
            style: TextStyles.bodyL.copyWith(
              color: AppColors.darkGrey400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedCard(Breed breed) {
    return Obx(() {
      final isSelected = controller.petOnboarding.value.breed == breed.name;

      return ZoomTapAnimation(
        onTap: () => _selectBreed(breed),
        child: Semantics(
          label: 'Select ${breed.name} breed',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? AppColors.green100 : AppColors.lightGrey100,
                width: 2.w,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 25.h,
                    child: Container(
                      width: 150.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: AppColors.orange100.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                  // Background
                  if (breed.imageUrl.isNotEmpty == true)
                    Positioned(
                      child: CachedImage(
                        height: 130.h,
                        width: 100.w,
                        cacheKey: breed.imageUrl,
                        imageUrl: breed.s3Url,
                        fit: BoxFit.fill,
                      ),
                    ),

                  // Breed name
                  Positioned(
                    bottom: 5.h,
                    left: 12.w,
                    right: 12.w,
                    child: Text(
                      breed.name,
                      style: TextStyles.bodyM.copyWith(
                        color: AppColors.darkGrey500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Selection indicator
                  if (isSelected)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: const BoxDecoration(
                          color: AppColors.green100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.w,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _selectBreed(Breed breed) {
    // Update the pet onboarding with the selected breed
    controller.petOnboarding.value = controller.petOnboarding.value.copyWith(
      breed: breed.name,
    );

    // Optional: Provide haptic feedback
    // HapticFeedback.lightImpact();
  }

  Widget _buildNextButton() {
    return Obx(() {
      final hasSelectedBreed = controller.petOnboarding.value.breed != "";

      return CustomButton(
        text: "Next",
        onPressed: hasSelectedBreed ? _onNextPressed : null,
      );
    });
  }

  void _onNextPressed() {
    // Navigate to the next step
    // Add validation if needed
    if (controller.petOnboarding.value.breed.isEmpty) {
      customSnackBar.show(
        message: "Please select a breed",
      );
      return;
    }
    Get.toNamed(AppRoutes.petOnboarding3Page); // Replace with actual route
  }
}
