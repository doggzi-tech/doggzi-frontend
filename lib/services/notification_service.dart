import 'package:dio/dio.dart';
import '../models/notification_model.dart';
import 'base_api_service.dart';

class NotificationService extends BaseApiService {
  // Get notifications
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await dio.get('/notifications');

      final data = response.data;
      if (data is List) {
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception(handleError(e));
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await dio.patch('/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw Exception(handleError(e));
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }
}
