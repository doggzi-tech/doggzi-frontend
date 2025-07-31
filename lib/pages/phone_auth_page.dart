import 'package:doggzi/pages/policies/privacy_policy.dart';
import 'package:doggzi/pages/policies/terms_of_services.dart';
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/common/CustomSnackbar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final AuthController _controller = Get.find<AuthController>();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOTP() async {
    if (_formKey.currentState!.validate()) {
      final success = await _controller.sendOTP(_phoneController.text.trim());
      if (success) {
        Get.toNamed('/otp-verification');
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    String phone = value.replaceAll(RegExp(r'\D'), '');

    if (phone.length < 10) return 'Phone number must be at least 10 digits';
    if (phone.length > 15) return 'Phone number cannot exceed 15 digits';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown.withOpacity(0.61),
      body: SafeArea(
        bottom: true,
        top: false,
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
            Positioned(
              bottom: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 400.w,
                    height: 560.h,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.60),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          'Phone Verification',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'We need to register your phone number before getting started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
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
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          height: MediaQuery.of(context).viewInsets.bottom > 0
                              ? 120.h
                              : 200.h,
                        ),
                        Obx(
                          () => CustomButton(
                            text: 'Get via SMS',
                            onPressed:
                                _controller.isLoading ? null : _handleSendOTP,
                            isLoading: _controller.isLoading,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TermsOfService()));
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PrivacyPolicy()));
                                    }),
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
