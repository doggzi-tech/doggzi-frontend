import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/controllers/promo_code_controller.dart';
import 'package:doggzi/pages/main_page.dart';
import 'package:doggzi/pages/menu_page/menu_page.dart';
import 'package:doggzi/pages/offers_page/offers_page.dart';
import 'package:doggzi/pages/on_boarding_page.dart';
import 'package:doggzi/pages/order_status/cancelled.dart';
import 'package:doggzi/pages/order_status/confirmed.dart';
import 'package:doggzi/pages/order_status/order_page/widgets/order_details.dart';
import 'package:doggzi/pages/user_onboarding_page/user_onboarding_page.dart';
import 'package:get/get.dart';

import '../controllers/address_controller.dart';
import '../controllers/food_menu_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/pet_controller.dart';
import '../controllers/pet_onboarding_controller.dart';
import '../pages/address_page/address_list_page.dart';
import '../pages/address_page/map_pick_page.dart';
import '../pages/cart_page/cart_page.dart';
import '../pages/home_page/home_page.dart';
import '../pages/notification_page/notification_page.dart';
import '../pages/order_status/order_page/order_page.dart';
import '../pages/otp_verification_page.dart';
import '../pages/pet_onboarding_page/pet_onboarding_1_page.dart';
import '../pages/pet_onboarding_page/pet_onboarding_2_page.dart';
import '../pages/pet_onboarding_page/pet_onboarding_3_page.dart';
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
  static const petOnboarding1Page = '/pet-onboarding-1';
  static const petOnboarding2Page = '/pet-onboarding-2';
  static const petOnboarding3Page = '/pet-onboarding-3';
  static const userOnboardingPage = '/user-onboarding';
  static const addressListPage = '/address-list';
  static const mapPickPage = '/map-pick';
  static const offers = '/offers';
  static const order = '/order';
  static const orderDetailsPage = '/order-details';

  static final pages = [
    GetPage(name: confirmed, page: () => const OrderConfirmedPage()),
    GetPage(name: cancelled, page: () => const OrderCancelledPage()),
    GetPage(name: cart, page: () => CartPage()),
    GetPage(name: menu, page: () => MenuPage()),

    GetPage(name: initial, page: () => OnboardingPage()),
    GetPage(name: otpVerification, page: () => OTPVerificationPage()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: phoneAuth, page: () => PhoneAuthPage()),
    GetPage(
      name: mainPage,
      page: () => MainPage(),
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
    GetPage(
      name: petOnboarding1Page,
      page: () => const PetOnboarding1Page(),
      bindings: [
        BindingsBuilder(() {
          Get.put(PetOnboardingController(), permanent: false);
        }),
      ],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: petOnboarding2Page,
      page: () => const PetOnboarding2Page(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: petOnboarding3Page,
      page: () => const PetOnboarding3Page(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: userOnboardingPage,
      page: () => const UserOnboardingPage(),
    ),
    GetPage(
      name: order,
      page: () => const OrderPage(),
    ),
    GetPage(
      name: addressListPage,
      page: () => AddressListPage(),
      bindings: [
        BindingsBuilder(() {
          Get.put(AddressController(), permanent: true);
        }),
      ],
    ),
    GetPage(
      name: mapPickPage,
      page: () => MapPickPage(),
    ),
    GetPage(
      name: offers,
      page: () => const OffersPage(),
      // Assuming offers is part of the main page
      bindings: [
        BindingsBuilder(() {
          Get.put(PromoCodeController(), permanent: true);
        }),
      ],
    ),
    // Assuming main page is same as home
  ];
}
