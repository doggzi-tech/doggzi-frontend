import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';

class ApiService {
  static const String baseUrl =
      'http://backend.doggzi.com/api/v1'; // Update with your server URL
  // "http://168.231.122.82/api/v1";
  // 'http://192.168.1.5:8000/api/v1'; // Update with your server URL
  late Dio _dio;

  ApiService() {
    _dio = Dio(
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
    _dio.interceptors.add(PrettyDioLogger());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to requests
          final authController = Get.find<AuthController>();
          if (authController.accessToken.isNotEmpty) {
            options.headers['Authorization'] =
                'Bearer ${authController.accessToken}';
          }

          // Log request for debugging
          print('🚀 ${options.method} ${options.path}');
          if (options.data != null) {
            print('📤 Request data: ${options.data}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response for debugging
          print('✅ ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) async {
          print('❌ ${error.response?.statusCode} ${error.requestOptions.path}');
          print('Error: ${error.response?.data}');

          if (error.response?.statusCode == 401) {
            // Token expired, try to refresh
            final authController = Get.find<AuthController>();
            final refreshed = await authController.refreshTokens();

            if (refreshed) {
              // Retry the original request
              final opts = error.requestOptions;
              opts.headers['Authorization'] =
                  'Bearer ${authController.accessToken}';
              try {
                final response = await _dio.fetch(opts);
                handler.resolve(response);
                return;
              } catch (e) {
                // If retry fails, proceed with original error
              }
            } else {
              // Refresh failed, logout user
              authController.logout();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<OTPResponse> sendOTP(SendOTPRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/send-otp',
        data: request.toJson(),
      );
      return OTPResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> verifyOTP(VerifyOTPRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/verify-otp',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/users/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateProfile(UserUpdateRequest request) async {
    try {
      final response = await _dio.put('/users/me', data: request.toJson());
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post('/auth/logout', data: {'refresh_token': refreshToken});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logoutAll() async {
    try {
      await _dio.post('/auth/logout-all');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dio.delete('/users/me');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getHealthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['detail'] ??
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
