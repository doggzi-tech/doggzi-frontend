import 'package:doggzi/pages/home_page/home_page.dart';
import 'package:doggzi/pages/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'menu_page/menu_page.dart';
import 'subscription_page/subscription_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  // Make pages lazy-loaded for better performance
  late final List<Widget Function()> _pageBuilders = [
    () => HomePage(),
    () => MenuPage(),
    () => SubscriptionPage(),
    () => ProfilePage(),
  ];

  // Cache pages to avoid rebuilding
  final Map<int, Widget> _pageCache = {};

  Widget _getPage(int index) {
    return _pageCache.putIfAbsent(index, () => _pageBuilders[index]());
  }

  @override
  Widget build(BuildContext context) {
    // Get the bottom padding to handle safe area manually
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double bottomPadding = mediaQuery.padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: false, // Handle bottom safe area manually
        child: Obx(() {
          return IndexedStack(
            index: controller.selectedIndex.value,
            children: List.generate(
              _pageBuilders.length,
              (index) => _getPage(index),
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

// Alternative approach with extendBody if you want the content to extend behind the nav bar
class MainPageExtended extends StatelessWidget {
  MainPageExtended({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  late final List<Widget Function()> _pageBuilders = [
    () => HomePage(),
    () => MenuPage(),
    () => SubscriptionPage(),
    () => ProfilePage(),
  ];

  final Map<int, Widget> _pageCache = {};

  Widget _getPage(int index) {
    return _pageCache.putIfAbsent(index, () => _pageBuilders[index]());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true, // Allows body to extend behind bottom nav
      body: SafeArea(
        top: false,
        child: Obx(() {
          return IndexedStack(
            index: controller.selectedIndex.value,
            children: List.generate(
              _pageBuilders.length,
              (index) => _getPage(index),
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
