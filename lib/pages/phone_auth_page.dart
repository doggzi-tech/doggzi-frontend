import 'package:doggzi/pages/policies/privacy_policy.dart';
import 'package:doggzi/pages/policies/terms_of_services.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/phone_auth_controller.dart';
import '../core/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class PhoneAuthPage extends StatelessWidget {
  PhoneAuthPage({super.key});

  final PhoneAuthController controller = Get.put(PhoneAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown.withOpacity(0.61),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/verification.png',
                fit: BoxFit.scaleDown,
              ),
            ),
            Positioned(
              top: 0,
              left: 20.w,
              right: 20.w,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            // Use Positioned instead of Align for better control
            Positioned(
              left: 0,
              right: 0,
              bottom: 0, // Keep it at the bottom
              child: SlideTransition(
                position: controller.slideAnimation,
                child: Container(
                  height: 475.h,
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.9, // Use percentage instead of fixed height
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey500.withOpacity(0.60),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      // Important: minimize the column size
                      children: [
                        Text(
                          'Phone Verification',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightGrey100,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'We need to register your phone number before getting started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: AppColors.lightGrey100,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: controller.phoneController,
                          hintText: '1234567890',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9+\-\s]'),
                            ),
                          ],
                          validator: controller.validatePhoneNumber,
                        ),
                        const Spacer(),
                        Obx(
                          () => CustomButton(
                            text: 'Get via SMS',
                            onPressed: controller.authController.isLoading
                                ? null
                                : controller.handleSendOTP,
                            isLoading: controller.authController.isLoading,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(
                                  text: "By clicking, I accept the "),
                              TextSpan(
                                text: "Terms of Services",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.termsAndConditions);
                                  },
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.privacyPolicy);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
