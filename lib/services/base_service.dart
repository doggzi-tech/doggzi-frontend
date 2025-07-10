import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../controllers/auth_controller.dart';

class BaseApiService {
  // static const String baseUrl = 'https://backend.doggzi.com/api/v1';
  static const String baseUrl = 'http://192.168.1.7:8000/api/v1/';
  late Dio dio;

  BaseApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final authController = Get.find<AuthController>();
          if (authController.accessToken.isNotEmpty) {
            options.headers['Authorization'] =
                'Bearer ${authController.accessToken}';
          }
          print('🚀 ${options.method} ${options.path}');
          if (options.data != null) {
            print('📤 Request data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) async {
          print('❌ ${error.response?.statusCode} ${error.requestOptions.path}');
          print('Error: ${error.response?.data}');
          final authController = Get.find<AuthController>();

          if (error.response?.statusCode == 401) {
            // Try refreshing token
            final refreshed = await authController.refreshTokens();
            print('Token refreshed: $refreshed');
            if (refreshed) {
              // Retry the original request with new token
              final opts = error.requestOptions;
              opts.headers['Authorization'] =
                  'Bearer ${authController.accessToken}';
              try {
                final response = await dio.fetch(opts);
                handler.resolve(response);
                return;
              } catch (e) {
                // If retry fails, continue with original error
              }
            } else {
              // If refresh failed, logout user
              authController.logout();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Centralized error handler returning user-friendly error messages
  String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['detail'] ??
            error.response?.data?['message'] ??
            'An error occurred';

        switch (statusCode) {
          case 400:
            return message;
          case 401:
            return 'Invalid credentials or session expired';
          case 403:
            return 'Access denied';
          case 404:
            return 'Resource not found';
          case 422:
            return _handleValidationError(error.response?.data);
          case 500:
            return 'Server error. Please try again later.';
          case 503:
            return 'Service temporarily unavailable';
          default:
            return message;
        }
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true) {
          return 'Unable to connect to server. Please check your internet connection.';
        }
        return 'Network error. Please check your connection.';
      default:
        return 'An unexpected error occurred';
    }
  }

  String _handleValidationError(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('detail')) {
      final detail = data['detail'];
      if (detail is List && detail.isNotEmpty) {
        final firstError = detail.first;
        if (firstError is Map<String, dynamic> &&
            firstError.containsKey('msg')) {
          return firstError['msg'];
        }
      } else if (detail is String) {
        return detail;
      }
    }
    return 'Validation error';
  }
}
