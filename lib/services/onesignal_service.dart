import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OneSignalService extends GetxService {
  static const String _appId = 'f1ff37e4-4f79-4c3a-b8b4-c9173c83bbae';
  RxString playerId = ''.obs;

  Future<OneSignalService> init() async {
    // Enable verbose logging
    if (kDebugMode) OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Initialize OneSignal
    OneSignal.initialize(_appId);

    // Prompt for push notification permission
    await OneSignal.Notifications.requestPermission(true);

    // Get player ID (pushSubscription.id)
    final pushSubscription = OneSignal.User.pushSubscription;
    playerId.value = pushSubscription.id ?? '';

    // Listen for push subscription changes
    pushSubscription.addObserver((OSPushSubscriptionChangedState state) {
      final newId = OneSignal.User.pushSubscription.id;
      playerId.value = newId ?? '';
      debugPrint("Push Subscription ID updated: $newId");
    });

    // Foreground notification handler
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event
          .preventDefault(); // You can show your own UI or call event.display()
      showSnackBar(event.notification.title, event.notification.body);
    });

    // When notification is clicked
    OneSignal.Notifications.addClickListener((event) {
      debugPrint(
          "Notification clicked with data: ${event.notification.additionalData}");
      // You can navigate or handle data here
    });

    return this;
  }

  Future<void> registerUser(String userId) async {
    try {
      await OneSignal.login(userId);
      debugPrint("OneSignal external user ID set: $userId");
    } catch (e) {
      debugPrint("Failed to set OneSignal external user ID: $e");
    }
  }

  // Optional: call this when user logs out
  Future<void> logoutUser() async {
    try {
      await OneSignal.logout();
      debugPrint("OneSignal external user ID removed.");
    } catch (e) {
      debugPrint("Failed to remove OneSignal external user ID: $e");
    }
  }

  void showSnackBar(String? title, String? body) {
    customSnackBar.show(
      message: body ?? 'No message',
      type: SnackBarType.normal,
      duration: const Duration(seconds: 3),
    );
  }
}
