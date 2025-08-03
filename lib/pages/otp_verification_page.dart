import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controllers/auth_controller.dart';
import '../controllers/food_menu_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/pet_controller.dart';
import '../services/onesignal_service.dart';
import '../theme/colors.dart';
import '../widgets/custom_button.dart';

class OTPVerificationPage extends GetView<AuthController> {
  OTPVerificationPage({super.key});

  final _otpController = TextEditingController();
  final oneSignalService = OneSignalService();

  Future<void> _handleVerifyOTP() async {
    if (_otpController.text.length != 4) {
      customSnackBar.show(
        message: 'Please enter a 4-digit verification code',
        type: SnackBarType.error,
      );
      return;
    }

    final success = await controller.verifyOTP(_otpController.text);

    if (success) {
      Get.offAllNamed(AppRoutes.mainPage);
    }
  }

  Future<void> _handleResendOTP() async {
    await controller.sendOTP(controller.currentPhoneNumber);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown.withOpacity(0.61),
      body: Stack(
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Keep at bottom
            child: Container(
              width: double.infinity,
              height: 475.w,
              decoration: BoxDecoration(
                color: AppColors.darkGrey500.withOpacity(0.60),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightGrey100,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Sent to ${controller.currentPhoneNumber}',
                          style: const TextStyle(
                            color: AppColors.lightGrey100,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.check_circle,
                        color: AppColors.green300,
                        size: 20.sp,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Change number?',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.lightGrey100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Pinput(
                      defaultPinTheme: PinTheme(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey100,
                          border: Border.all(
                            color: AppColors.orange400,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        textStyle: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.darkGrey400,
                        ),
                      ),
                      onCompleted: (_) => _handleVerifyOTP(),
                      controller: _otpController,
                      length: 4,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // OTP expiration timer
                  Obx(
                    () => controller.otpExpiresIn > 0
                        ? Center(
                            child: Text(
                              'Expires in ${_formatTime(controller.otpExpiresIn)}',
                              style: TextStyle(
                                color: AppColors.lightGrey400,
                                fontSize: 14.sp,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const Spacer(),
                  // Replace Spacer with fixed height
                  Obx(
                    () => CustomButton(
                      text: 'Continue',
                      onPressed: controller.isLoading ? null : _handleVerifyOTP,
                      isLoading: controller.isLoading,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Resend OTP row
                  Obx(
                    () {
                      final canResend = controller.canResendIn == 0;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Did not receive code? ',
                            style: TextStyle(color: AppColors.lightGrey400),
                          ),
                          TextButton(
                            onPressed: canResend ? _handleResendOTP : null,
                            child: canResend
                                ? const Text(
                                    'Resend',
                                    style: TextStyle(
                                      color: AppColors.orange400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    'Resend in ${_formatTime(controller.canResendIn)}',
                                    style: const TextStyle(
                                      color: AppColors.lightGrey400,
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
