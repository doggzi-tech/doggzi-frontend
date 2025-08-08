import 'package:doggzi/controllers/pet_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/services/onesignal_service.dart';
import 'package:doggzi/theme/theme.dart';
import 'package:doggzi/utils/logger_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:upgrader/upgrader.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  // Initialize AuthController
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar background color
      statusBarIconBrightness: Brightness.dark, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ),
  );
  Get.put(LoggerService(), permanent: true);
  Get.put(AuthController());
  Get.putAsync(() => OneSignalService().init());

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
          theme: DoggziTheme.theme,
          initialRoute: _getInitialRoute(),
          getPages: AppRoutes.pages,
          builder: (context, child) {
            return UpgradeAlert(
              barrierDismissible: false,
              showLater: true,
              upgrader: Upgrader(),
              child: child!,
            );
          },
        );
      },
    );
  }

  String _getInitialRoute() {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn ? AppRoutes.mainPage : AppRoutes.initial;
  }
}
