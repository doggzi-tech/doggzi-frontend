import 'package:doggzi/controllers/pet_onboarding_controller.dart';
import 'package:doggzi/models/pet_model.dart';
import 'package:doggzi/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../theme/colors.dart';
import '../../theme/text_style.dart';
import '../../widgets/custom_icon.dart';

class PetOnboarding3Page extends GetView<PetOnboardingController> {
  const PetOnboarding3Page({super.key});

  // Constants for better maintainability
  static const double _horizontalPadding = 16.0;
  static const double _progressValue = 0.75;
  static const double _sectionSpacing = 24.0;
  static const double _itemSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header
            _buildHeader(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildPetDetailsForm(),
                    SizedBox(height: 20.h),
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
          "Step 3",
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
      semanticsLabel: 'Progress: Step 3 of 4',
    );
  }

  Widget _buildPetDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGenderSection(),
        SizedBox(height: _sectionSpacing.h),
        // Pet Name
        _buildNameField(),
        SizedBox(height: _sectionSpacing.h),

        // Date of Birth
        _buildDateOfBirthField(),
        SizedBox(height: _sectionSpacing.h),

        // Weight
        _buildWeightField(),
        SizedBox(height: _sectionSpacing.h),

        // Body Condition
        _buildBodyConditionSection(),
        SizedBox(height: _sectionSpacing.h),

        // Neutered/Spayed
        _buildNeuteredSpayedSection(),
        SizedBox(height: _sectionSpacing.h),

        // Physical Activity (only for dogs)
        Obx(() {
          if (controller.petOnboarding.value.species == "dog") {
            return Column(
              children: [
                _buildPhysicalActivitySection(),
                SizedBox(height: _sectionSpacing.h),

                // Allergies
                _buildAllergiesSection(),
                SizedBox(height: _sectionSpacing.h),

                // Dietary Restrictions
                _buildDietaryRestrictionsField(),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pet Name *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          onChanged: (value) {
            controller.petOnboarding.value =
                controller.petOnboarding.value.copyWith(
              name: value,
            );
          },
          decoration: InputDecoration(
            hintText: "Enter your pet's name",
            hintStyle: TextStyles.bodyM.copyWith(
              color: AppColors.darkGrey300,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.orange400),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date of Birth *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => TextFormField(
              readOnly: true,
              onTap: () => _selectDateOfBirth(),
              decoration: InputDecoration(
                hintText: controller.petOnboarding.value.dateOfBirth.isEmpty
                    ? "Select date of birth"
                    : controller.petOnboarding.value.dateOfBirth,
                hintStyle: TextStyles.bodyM.copyWith(
                  color: controller.petOnboarding.value.dateOfBirth.isEmpty
                      ? AppColors.darkGrey300
                      : AppColors.darkGrey500,
                ),
                suffixIcon: const Icon(Icons.calendar_today,
                    color: AppColors.darkGrey400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.lightGrey100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.lightGrey100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.orange400),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            )),
      ],
    );
  }

  Widget _buildWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weight (kg) *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          onChanged: (value) {
            final weight = double.tryParse(value) ?? 0.0;
            controller.petOnboarding.value =
                controller.petOnboarding.value.copyWith(
              weightKg: weight,
            );
          },
          decoration: InputDecoration(
            hintText: "Enter weight in kg",
            hintStyle: TextStyles.bodyM.copyWith(
              color: AppColors.darkGrey300,
            ),
            suffixText: "kg",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.orange400),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyConditionSection() {
    const bodyConditions = ["underweight", "normal", "overweight"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Body Condition *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Row(
              children: bodyConditions.map((condition) {
                final isSelected =
                    controller.petOnboarding.value.bodyCondition == condition;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: condition != bodyConditions.last ? 8.w : 0),
                    child: _buildSelectionCard(
                      title: condition.capitalize!,
                      isSelected: isSelected,
                      onTap: () => _selectBodyCondition(condition),
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildNeuteredSpayedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Neutered/Spayed",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Row(
              children: [
                Expanded(
                  child: _buildSelectionCard(
                    title: "Yes",
                    isSelected:
                        controller.petOnboarding.value.isNeuteredOrSpayed!,
                    onTap: () => _toggleNeuteredSpayed(true),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildSelectionCard(
                    title: "No",
                    isSelected:
                        !controller.petOnboarding.value.isNeuteredOrSpayed!,
                    onTap: () => _toggleNeuteredSpayed(false),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildPhysicalActivitySection() {
    const activities = [
      "less than 45 min",
      "between 45 mins to 90 mins",
      "more than 90 mins"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daily Physical Activity *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Column(
              children: activities.map((activity) {
                final isSelected =
                    controller.petOnboarding.value.physicalActivity == activity;
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _buildFullWidthSelectionCard(
                    title: activity,
                    isSelected: isSelected,
                    onTap: () => _selectPhysicalActivity(activity),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildAllergiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Does your pet have allergies?",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Row(
              children: [
                Expanded(
                  child: _buildSelectionCard(
                    title: "Yes",
                    isSelected:
                        controller.petOnboarding.value.isAllergic == true,
                    onTap: () => _toggleAllergies(true),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildSelectionCard(
                    title: "No",
                    isSelected:
                        controller.petOnboarding.value.isAllergic == false,
                    onTap: () => _toggleAllergies(false),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildDietaryRestrictionsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dietary Restrictions (Optional)",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          maxLines: 3,
          onChanged: (value) {
            controller.petOnboarding.value =
                controller.petOnboarding.value.copyWith(
              dietaryRestrictions: value,
            );
          },
          decoration: InputDecoration(
            hintText: "Enter any dietary restrictions or special requirements",
            hintStyle: TextStyles.bodyM.copyWith(
              color: AppColors.darkGrey300,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.orange400),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.orange400 : AppColors.lightGrey100,
            width: 2.w,
          ),
          color: isSelected
              ? AppColors.orange400.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyles.bodyM.copyWith(
            color: isSelected ? AppColors.orange400 : AppColors.darkGrey500,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthSelectionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.orange400 : AppColors.lightGrey100,
            width: 2.w,
          ),
          color: isSelected
              ? AppColors.orange400.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.bodyM.copyWith(
                color: isSelected ? AppColors.orange400 : AppColors.darkGrey500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.orange400,
                size: 20.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Obx(() {
      final pet = controller.petOnboarding.value;
      final isValid = _validateForm(pet);

      return CustomButton(
        text: "Complete Profile",
        onPressed: isValid ? _onNextPressed : null,
      );
    });
  }

  bool _validateForm(PetCreate pet) {
    return pet.name.isNotEmpty &&
        pet.dateOfBirth.isNotEmpty &&
        pet.weightKg > 0 &&
        pet.bodyCondition.isNotEmpty &&
        (pet.species != "dog" || pet.isAllergic != null) &&
        pet.gender.isNotEmpty;
  }

  void _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orange400,
              // header background & selected date
              onPrimary: Colors.white,
              // text color on header
              onSurface: Colors.black, // default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      controller.petOnboarding.value = controller.petOnboarding.value.copyWith(
        dateOfBirth: formattedDate,
      );
    }
  }

  void _selectBodyCondition(String condition) {
    controller.petOnboarding.value = controller.petOnboarding.value.copyWith(
      bodyCondition: condition,
    );
  }

  void _toggleNeuteredSpayed(bool value) {
    controller.petOnboarding.value = controller.petOnboarding.value.copyWith(
      isNeuteredOrSpayed: value,
    );
  }

  void _selectPhysicalActivity(String activity) {
    controller.petOnboarding.value = controller.petOnboarding.value.copyWith(
      physicalActivity: activity,
    );
  }

  void _toggleAllergies(bool value) {
    controller.petOnboarding.value = controller.petOnboarding.value.copyWith(
      isAllergic: value,
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Row(
              children: [
                Expanded(
                  child: _buildSelectionCard(
                    title: "Male",
                    isSelected: controller.petOnboarding.value.gender == "male",
                    onTap: () => _selectGender("male"),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildSelectionCard(
                    title: "Female",
                    isSelected:
                        controller.petOnboarding.value.gender == "female",
                    onTap: () => _selectGender("female"),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  void _selectGender(String gender) {
    controller.petOnboarding.value = controller.petOnboarding.value.copyWith(
      gender: gender,
    );
  }

  void _onNextPressed() {
    controller.completePetOnboarding();
  }
}
