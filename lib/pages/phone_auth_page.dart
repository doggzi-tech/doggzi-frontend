import 'package:doggzi/theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class PhoneAuthPage extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  Future<void> _handleSendOTP() async {
    if (_formKey.currentState!.validate()) {
      final success = await controller.sendOTP(_phoneController.text.trim());

      if (success) {
        Get.toNamed('/otp-verification');
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove any non-digit characters for validation
    String phone = value.replaceAll(RegExp(r'\D'), '');

    if (phone.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (phone.length > 15) {
      return 'Phone number cannot exceed 15 digits';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/content.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  width: 400.w,
                  height: 460.h,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Text(
                        'Enter your number',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: _phoneController,
                        hintText: '1234567890',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9+\-$$$$\s]'),
                          ),
                        ],
                        validator: _validatePhoneNumber,
                      ),
                      SizedBox(height: 210.h),
                      Obx(
                        () => CustomButton(
                          text: 'Continue',
                          onPressed:
                              controller.isLoading ? null : _handleSendOTP,
                          isLoading: controller.isLoading,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            const TextSpan(text: "By clicking, I accept the "),
                            TextSpan(
                              text: "Terms of Services",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              // recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              // recognizer:
                              //     TapGestureRecognizer()..onTap = onPrivacyTap,
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
