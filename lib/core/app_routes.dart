import 'package:doggzi/pages/cart/cart.dart';
import 'package:doggzi/pages/main_page.dart';
import 'package:doggzi/pages/menu_page/menu_page.dart';
import 'package:doggzi/pages/on_boarding_page.dart';
import 'package:doggzi/pages/order_status/cancelled.dart';
import 'package:doggzi/pages/order_status/confirmed.dart';
import 'package:get/get.dart';

import '../controllers/food_menu_controller.dart';
import '../controllers/pet_controller.dart';
import '../pages/home_page/home_page.dart';
import '../pages/notification_page/notification_page.dart';
import '../pages/otp_verification_page.dart';
import '../pages/phone_auth_page.dart';
import '../pages/policies/privacy_policy.dart';
import '../pages/policies/terms_of_services.dart';

class AppRoutes {
  static const initial = "/on-boarding";
  static const otpVerification = "/otp-verification";
  static const home = "/home";
  static const phoneAuth = "/phone-auth";
  static const mainPage = "/main-page";
  static const notifications = "/notifications";
  static const termsAndConditions = "/terms-and-conditions";
  static const privacyPolicy = "/privacy-policy";
  static const confirmed = '/order-confirmed';
  static const cancelled = '/order-cancelled';
  static const cart = '/cart';
  static const menu = '/menu';

  static final pages = [
    GetPage(name: confirmed, page: () => const OrderConfirmedPage()),
    GetPage(name: cancelled, page: () => const OrderCancelledPage()),
    GetPage(name: cart, page: () => const CartPage()),
    GetPage(name: menu, page: () => MenuPage()),

    GetPage(name: initial, page: () => OnboardingPage()),
    GetPage(name: otpVerification, page: () => OTPVerificationPage()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: phoneAuth, page: () => PhoneAuthPage()),
    GetPage(
      name: mainPage,
      page: () => MainPage(),
      bindings: [
        BindingsBuilder(() {
          Get.put(FoodMenuController());
          Get.put(PetController());
        }),
      ],
    ),
    GetPage(name: notifications, page: () => NotificationsPage()),
    GetPage(
      name: termsAndConditions,
      page: () => const TermsAndConditions(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: privacyPolicy,
      page: () => const PrivacyPolicy(),
      transition: Transition.rightToLeft,
    ),
    // Assuming main page is same as home
  ];
}
