import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'base_service.dart';

class AuthService extends BaseApiService {
  Future<OTPResponse> sendOTP(SendOTPRequest request) async {
    try {
      final response = await dio.post(
        '/auth/send-otp',
        data: request.toJson(),
      );
      return OTPResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<AuthResponse> verifyOTP(VerifyOTPRequest request) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      print("refresh token api response: ${response.data}");
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await dio.get('/users/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<User> updateProfile(UserUpdateRequest request) async {
    try {
      final response = await dio.put('/users/me', data: request.toJson());
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await dio.post('/auth/logout', data: {'refresh_token': refreshToken});
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<void> logoutAll() async {
    try {
      await dio.post('/auth/logout-all');
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await dio.delete('/users/me');
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Map<String, dynamic>> getHealthCheck() async {
    try {
      final response = await dio.get('/health');
      return response.data;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
