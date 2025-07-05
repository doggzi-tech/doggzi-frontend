// Controller for managing onboarding state
import 'package:doggzi/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  void nextPage() {
    if (currentPage.value < 3) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Navigate to home or next screen
      Get.offAllNamed(AppRoutes.phoneAuth);
    }
  }

  void skipOnboarding() {
    Get.offAllNamed(AppRoutes.phoneAuth);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
