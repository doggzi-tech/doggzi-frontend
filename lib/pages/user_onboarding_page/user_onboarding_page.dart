import 'package:doggzi/controllers/auth_controller.dart';
import 'package:doggzi/controllers/pet_onboarding_controller.dart';
import 'package:doggzi/models/pet_model.dart';
import 'package:doggzi/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../models/user_model.dart';
import '../../theme/colors.dart';
import '../../theme/text_style.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon.dart';

class UserOnboardingPage extends GetView<AuthController> {
  const UserOnboardingPage({super.key});

  // Constants for better maintainability
  static const double _horizontalPadding = 16.0;
  static const double _sectionSpacing = 24.0;

  @override
  Widget build(BuildContext context) {
    print("full name value is ${controller.userOnboarding.value.fullName}");

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(_horizontalPadding.w),
        child: _buildNextButton(),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar(
              title: "My Profile",
              trailingIcon: Icons.logout,
              isTrailingIconVisible: true,
              onTrailingIconTap: () {
                controller.logout();
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _horizontalPadding.w,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      _buildPetDetailsForm(),
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

  Widget _buildPetDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pet Name
        _buildNameField(),
        SizedBox(height: _sectionSpacing.h),
        // Pet Name
        _buildEmailField(),
        SizedBox(height: _sectionSpacing.h),
        _buildGenderSection(),
        SizedBox(height: _sectionSpacing.h),

        // Date of Birth
        _buildDateOfBirthField(),
        SizedBox(height: _sectionSpacing.h),

        // Physical Activity (only for dogs)
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Full Name *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          onChanged: (value) {
            controller.userOnboarding.value = controller.userOnboarding.value
                .copyWith(fullName: value.trim());
          },
          initialValue: controller.userOnboarding.value.fullName,
          decoration: InputDecoration(
            hintText: "Enter your name",
            hintStyle: TextStyles.bodyM.copyWith(
              color: AppColors.darkGrey300,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey300),
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

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email *",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          onChanged: (value) {
            controller.userOnboarding.value =
                controller.userOnboarding.value.copyWith(email: value.trim());
          },
          keyboardType: TextInputType.emailAddress,
          initialValue: controller.userOnboarding.value.email,
          decoration: InputDecoration(
            hintText: "Enter your email",
            hintStyle: TextStyles.bodyM.copyWith(
              color: AppColors.darkGrey300,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.lightGrey300),
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
          "Date of Birth",
          style: TextStyles.bodyM.copyWith(
            color: AppColors.darkGrey500,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => TextFormField(
              readOnly: true,
              initialValue: controller.userOnboarding.value.dateOfBirth == ""
                  ? ""
                  : controller.userOnboarding.value.dateOfBirth,
              onTap: () => _selectDateOfBirth(),
              decoration: InputDecoration(
                hintText: controller.userOnboarding.value.dateOfBirth.isEmpty
                    ? "Select date of birth"
                    : controller.userOnboarding.value.dateOfBirth,
                hintStyle: TextStyles.bodyM.copyWith(
                  color: controller.userOnboarding.value.dateOfBirth.isEmpty
                      ? AppColors.darkGrey300
                      : AppColors.darkGrey500,
                ),
                suffixIcon: const Icon(Icons.calendar_today,
                    color: AppColors.darkGrey400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.lightGrey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.lightGrey300),
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
            color: isSelected ? AppColors.orange400 : AppColors.lightGrey300,
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

  Widget _buildNextButton() {
    return Obx(() {
      final user = controller.userOnboarding.value;
      final isValid = _validateForm(user);

      return CustomButton(
        text: "Complete Profile",
        onPressed: isValid ? _onNextPressed : null,
      );
    });
  }

  bool _validateForm(UserUpdateRequest user) {
    return user.email.isNotEmpty && user.fullName.isNotEmpty;
  }

  void _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 80)),
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
                foregroundColor: AppColors.orange400, // button text color
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
      controller.userOnboarding.value =
          controller.userOnboarding.value.copyWith(
        dateOfBirth: formattedDate,
      );
    }
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
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
                    isSelected:
                        controller.userOnboarding.value.gender == "male",
                    onTap: () => _selectGender("male"),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildSelectionCard(
                    title: "Female",
                    isSelected:
                        controller.userOnboarding.value.gender == "female",
                    onTap: () => _selectGender("female"),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  void _selectGender(String gender) {
    controller.userOnboarding.value = controller.userOnboarding.value.copyWith(
      gender: gender,
    );
  }

  void _onNextPressed() {
    controller.updateProfile();
  }
}
