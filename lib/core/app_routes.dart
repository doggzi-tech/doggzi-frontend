import 'package:doggzi/pages/main_page.dart';
import 'package:doggzi/pages/on_boarding_page.dart';
import 'package:get/get.dart';

import '../pages/home_page.dart';
import '../pages/otp_verification_page.dart';
import '../pages/phone_auth_page.dart';

class AppRoutes {
  static const initial = "/on-boarding";
  static const otpVerification = "/otp-verification";
  static const home = "/home";
  static const phoneAuth = "/phone-auth";
  static const mainPage = "/main-page";

  static final pages = [
    GetPage(name: initial, page: () => OnboardingPage()),
    GetPage(name: otpVerification, page: () => OTPVerificationPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: phoneAuth, page: () => PhoneAuthPage()),
    GetPage(name: mainPage, page: () => MainPage()),
    // Assuming main page is same as home
  ];
}
