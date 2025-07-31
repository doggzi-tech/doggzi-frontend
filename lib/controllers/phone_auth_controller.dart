import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class PhoneAuthController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    ));

    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> handleSendOTP() async {
    if (formKey.currentState!.validate()) {
      final success = await authController.sendOTP(phoneController.text.trim());
      if (success) {
        Get.toNamed('/otp-verification');
      }
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    String phone = value.replaceAll(RegExp(r'\D'), '');

    if (phone.length < 10) return 'Phone number must be at least 10 digits';
    if (phone.length > 15) return 'Phone number cannot exceed 15 digits';
    return null;
  }
}
