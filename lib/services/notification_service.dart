// notification_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/notification_model.dart';

class NotificationService {
  static const String baseUrl = 'https://your-api-endpoint.com/api';

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE', // Add your auth token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }
}
