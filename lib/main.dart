import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'pages/phone_auth_page.dart';
import 'pages/otp_verification_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  // Initialize AuthController
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Doggzi',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Manrope',
            useMaterial3: true,
          ),
          initialRoute: _getInitialRoute(),
          // initialRoute: '/otp-verification',
          getPages: [
            GetPage(name: '/phone-auth', page: () => PhoneAuthPage()),
            GetPage(
              name: '/otp-verification',
              page: () => OTPVerificationPage(),
            ),
            GetPage(name: '/home', page: () => const HomePage()),
          ],
        );
      },
    );
  }

  String _getInitialRoute() {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn ? '/home' : '/phone-auth';
  }
}
