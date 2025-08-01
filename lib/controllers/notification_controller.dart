import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  // Observable variables
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      error.value = '';

      final fetchedNotifications =
          await _notificationService.getNotifications();
      notifications.assignAll(fetchedNotifications);
    } catch (e) {
      error.value = e.toString();
      // For demo purposes, add mock data if API fails
      _addMockData();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);

      // Update local state
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          title: notifications[index].title,
          description: notifications[index].description,
          type: notifications[index].type,
          createdAt: notifications[index].createdAt,
          isRead: true,
        );
        notifications.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark notification as read');
    }
  }

  void _addMockData() {
    notifications.assignAll([
      NotificationModel(
        id: '1',
        title: 'Exciting Offer',
        description: 'Up to 50% off on selected items',
        type: NotificationType.offer,
        createdAt: DateTime.now().subtract(
          const Duration(
            days: 1,
            minutes: 5,
          ),
        ),
      ),
      NotificationModel(
        id: '2',
        title: 'Order Is On The Way',
        description: 'Your order will be delivered in 30 minutes',
        type: NotificationType.order,
        createdAt: DateTime.now().subtract(
          const Duration(
            minutes: 10,
          ),
        ),
      ),
      NotificationModel(
        id: '3',
        title: 'Order Is On The Way',
        description: 'Fresh Chicken Rice is on the way',
        type: NotificationType.order,
        createdAt: DateTime.now().subtract(
          const Duration(
            minutes: 15,
          ),
        ),
      ),
      NotificationModel(
        id: '4',
        title: 'Exciting Offer',
        description: 'Up to 50% off on selected items',
        type: NotificationType.offer,
        createdAt: DateTime.now().subtract(
          const Duration(
            minutes: 30,
          ),
        ),
      ),
      NotificationModel(
        id: '5',
        title: 'Order Is On The Way',
        description: 'Your order will be delivered in 30 minutes',
        type: NotificationType.order,
        createdAt: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      ),
      NotificationModel(
        id: '6',
        title: 'Great News',
        description: 'New restaurant added to your area',
        type: NotificationType.news,
        createdAt: DateTime.now().subtract(
          const Duration(
            hours: 2,
          ),
        ),
      ),
    ]);
  }
}
