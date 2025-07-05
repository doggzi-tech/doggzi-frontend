import 'package:doggzi/pages/home_page.dart';
import 'package:doggzi/pages/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    HomePage(),
    HomePage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
