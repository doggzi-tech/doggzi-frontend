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

  final List<Widget> pages = [
    HomePage(),
    const MenuPage(),
    const SubscriptionPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set resizeToAvoidBottomInset to true to make the body resize when keyboard appears
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Obx(() {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: IndexedStack(
              key: ValueKey<int>(controller.selectedIndex.value),
              index: controller.selectedIndex.value,
              children: pages,
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
