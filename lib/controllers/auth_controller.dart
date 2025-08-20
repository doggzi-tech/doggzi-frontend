import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/controllers/food_menu_controller.dart';
import 'package:doggzi/controllers/location_controller.dart';
import 'package:doggzi/controllers/pet_controller.dart';
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/core/common/CustomSnackbar.dart';
import 'package:doggzi/models/general_model.dart';
import 'package:doggzi/services/general_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'dart:async';

import '../services/onesignal_service.dart';

class AuthController extends GetxController {
  final AuthService _apiService = AuthService();
  final GeneralService generalService = GeneralService();
  final Rx<GeneralModel> generalSettings = GeneralModel(
    homeCarouselImages: [],
    subscriptionCarouselImages: [],
    offerTaglines: [],
    catBreeds: [],
    dogBreeds: [],
  ).obs;
  final GetStorage _storage = GetStorage();
  final oneSignalService = OneSignalService();

  final Rx<User?> _user = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isInitializing = true.obs;
  final RxString _accessToken = ''.obs;
  final RxString _refreshToken = ''.obs;

  // OTP related state
  final RxBool _isOTPSent = false.obs;
  final RxInt _otpExpiresIn = 0.obs;
  final RxInt _canResendIn = 0.obs;
  final RxString _currentPhoneNumber = ''.obs;

  Timer? _otpTimer;
  Timer? _resendTimer;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  User? get user => _user.value;

  bool get isLoading => _isLoading.value;

  bool get isInitializing => _isInitializing.value;

  bool get isProfileComplete =>
      _user.value?.email.isNotEmpty == true &&
      _user.value?.fullName.isNotEmpty == true;

  bool get isLoggedIn => _user.value != null && _accessToken.isNotEmpty;

  String get accessToken => _accessToken.value;

  String get refreshToken => _refreshToken.value;

  // OTP getters
  bool get isOTPSent => _isOTPSent.value;

  int get otpExpiresIn => _otpExpiresIn.value;

  int get canResendIn => _canResendIn.value;

  String get currentPhoneNumber => _currentPhoneNumber.value;

  // user onboarding status
  Rx<UserUpdateRequest> userOnboarding = UserUpdateRequest().obs;

  @override
  void onInit() {
    super.onInit();
    initializeApp();
    ever(_isInitializing, (isInitializing) {
      print('Initialization status changed: $isInitializing');
    });
  }

  Future<void> initializeApp() async {
    print('Splash screen started');
    print("start timing is ${DateTime.now()}");
    final stopwatch = Stopwatch()..start();
    try {
      await Future.wait<void>([
        _getGeneralSettings(),
        _loadStoredAuth(),
        _checkServerHealth(),
        _initializeMainPageControllers(),
      ]);
    } catch (e) {
      print('Error during initialization: $e');
    } finally {
      stopwatch.stop();
      // Logs an event when a user clicks the main call-to-action button
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      analytics.logEvent(
        name: 'InitializationCompleted',
        parameters: {
          'duration_ms': stopwatch.elapsedMilliseconds,
          'isLoggedIn': isLoggedIn == true ? 1 : 0,
          'isProfileComplete': isProfileComplete == true ? 1 : 0,
          "userId": user?.id ?? 'guest',
        },
      );
      print('Initialization completed in ${stopwatch.elapsedMilliseconds}ms');
      print("end timing is ${DateTime.now()}");
      _isInitializing.value = false;
      print('Splash screen ended');
    }
  }

  Future<void> _initializeMainPageControllers() async {
    try {
      print("LocationController initialization started at: ${DateTime.now()}");
      // Always initialize location first
      await Get.putAsync<LocationController>(
        () async => await LocationController().init(),
        permanent: true,
      );
      print('LocationController initialized completed at: ${DateTime.now()}');
      // Prepare futures for parallel initialization
      final futures = <Future>[];
      futures.add(
        Get.putAsync<FoodMenuController>(
          () async => await FoodMenuController().init(),
          permanent: true,
        ),
      );
      if (isLoggedIn) {
        futures.addAll([
          Get.putAsync<PetController>(
            () async => await PetController().init(),
            permanent: true,
          ),
          Get.putAsync<CartController>(
            () async => await CartController().init(),
            permanent: true,
          ),
        ]);
      }
      // Run the prepared futures in parallel
      await Future.wait(futures);
    } catch (e) {
      print('Error initializing main page controllers: $e');
    }
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    _resendTimer?.cancel();
    super.onClose();
  }

  Future<void> _getGeneralSettings() async {
    try {
      final settings = await generalService.getGeneralSettings();
      generalSettings.value = settings;
    } catch (e) {
      print('Failed to get general settings: $e');
      // Handle error appropriately, maybe show a snackbar
    }
  }

  Future<void> _loadStoredAuth() async {
    final storedAccessToken = _storage.read('access_token');
    final storedRefreshToken = _storage.read('refresh_token');
    final storedUser = _storage.read('user');

    if (storedAccessToken != null &&
        storedRefreshToken != null &&
        storedUser != null) {
      _accessToken.value = storedAccessToken;
      _refreshToken.value = storedRefreshToken;
      _user.value = User.fromJson(Map<String, dynamic>.from(storedUser));

      // Verify token is still valid by fetching profile
      await _verifyTokenValidity();
    }
  }

  Future<void> _verifyTokenValidity() async {
    try {
      final user = await _apiService.getProfile();
      _user.value = user;
      await _storage.write('user', user.toJson());
      if (!isProfileComplete) {
        Get.offNamed(AppRoutes.userOnboardingPage);
      }
    } catch (e) {
      // If the token is invalid, try to refresh it
      final refreshed = await refreshTokens();
      if (!refreshed) {
        // If refresh fails, clear stored data
        await _clearAuthData();
        _resetOTPState();
        Get.offAllNamed('/phone-auth');
        customSnackBar.show(
          message: 'You have been logged out from all devices',
          type: SnackBarType.success,
        );
      }
    }
  }

  Future<void> _checkServerHealth() async {
    try {
      await _apiService.getHealthCheck();
      print('✅ Server is healthy');
    } catch (e) {
      print('⚠️ Server health check failed: $e');
      customSnackBar.show(
        message: 'Server is currently unavailable. Please try again later.',
        type: SnackBarType.warning,
      );
    }
  }

  Future<bool> sendOTP(String phoneNumber) async {
    try {
      _isLoading.value = true;
      final request = SendOTPRequest(phoneNumber: phoneNumber);
      final response = await _apiService.sendOTP(request);

      _currentPhoneNumber.value = phoneNumber;
      _isOTPSent.value = true;
      _otpExpiresIn.value = response.expiresIn;
      _canResendIn.value = response.canResendIn;

      _startOTPTimer();
      _startResendTimer();

      customSnackBar.show(
        message: 'OTP sent successfully .otp is ${response.message}',
        type: SnackBarType.success,
      );

      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> verifyOTP(String otpCode) async {
    try {
      _isLoading.value = true;

      final request = VerifyOTPRequest(
        phoneNumber: _currentPhoneNumber.value,
        otpCode: otpCode,
      );

      final response = await _apiService.verifyOTP(request);

      await _saveAuthData(response);
      _resetOTPState();

      customSnackBar.show(
        message: 'OTP verified successfully',
        type: SnackBarType.success,
      );

      if (Get.isRegistered<PetController>()) {
        Get.delete<PetController>(force: true);
      }
      if (Get.isRegistered<CartController>()) {
        Get.delete<CartController>(force: true);
      }

      // Initialize controllers in parallel
      await Future.wait([
        Get.putAsync<PetController>(
          () async => await PetController().init(),
          permanent: true,
        ),
        Get.putAsync<CartController>(
          () async => await CartController().init(),
          permanent: true,
        ),
      ]);

      if (!isProfileComplete) {
        Get.offAllNamed(AppRoutes.userOnboardingPage);
      } else {
        Get.offAllNamed(AppRoutes.mainPage);
      }

      return true;
    } catch (e) {
      customSnackBar.show(
        message: 'OTP verification failed: ${e.toString()}',
        type: SnackBarType.error,
      );
      print('OTP verification error: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> refreshTokens() async {
    if (_isRefreshing) {
      return await _refreshCompleter!.future;
    }
    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      if (_refreshToken.isEmpty) return false;

      final response = await _apiService.refreshToken(_refreshToken.value);
      print("refresh token response: $response");
      await _saveAuthData(response);
      _refreshCompleter!.complete(true);
      return true;
    } catch (e) {
      print('Token refresh failed: $e');
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<bool> updateProfile() async {
    try {
      _isLoading.value = true;

      final updatedUser = await _apiService.updateProfile(userOnboarding.value);
      _user.value = updatedUser.user;
      await _storage.write('user', updatedUser.user.toJson());

      customSnackBar.show(
        message: 'Profile updated successfully',
        type: SnackBarType.success,
      );

      Get.offNamed(AppRoutes.mainPage);

      return true;
    } catch (e) {
      customSnackBar.show(
        message: 'Failed to update profile: ${e.toString()}',
        type: SnackBarType.error,
      );
      print('Profile update error: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      if (_refreshToken.isNotEmpty) {
        await _apiService.logout(_refreshToken.value);
      }
    } catch (e) {
      print('Logout API call failed: $e');
      // Continue with logout even if API call fails
    } finally {
      Get.offAllNamed('/phone-auth');
      customSnackBar.show(
        message: 'You have been logged out successfully',
        type: SnackBarType.success,
      );
      await _clearAuthData();
      _resetOTPState();
    }
  }

  Future<void> logoutAll() async {
    try {
      await _apiService.logoutAll();
      await _clearAuthData();
      _resetOTPState();
      Get.offAllNamed('/phone-auth');
      customSnackBar.show(
        message: 'You have been logged out from all devices',
        type: SnackBarType.success,
      );
    } catch (e) {
      customSnackBar.show(
        message: 'Failed to logout from all devices: ${e.toString()}',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      _isLoading.value = true;

      await _apiService.deleteAccount();
      await _clearAuthData();
      _resetOTPState();
      Get.offAllNamed('/phone-auth');
      customSnackBar.show(
        message: 'Your account has been deleted successfully',
        type: SnackBarType.success,
      );
    } catch (e) {
      customSnackBar.show(
        message: 'Failed to delete account: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _startOTPTimer() {
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpExpiresIn.value > 0) {
        _otpExpiresIn.value--;
      } else {
        timer.cancel();
        _isOTPSent.value = false;
      }
    });
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_canResendIn.value > 0) {
        _canResendIn.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _resetOTPState() {
    _isOTPSent.value = false;
    _otpExpiresIn.value = 0;
    _canResendIn.value = 0;
    _currentPhoneNumber.value = '';
    _otpTimer?.cancel();
    _resendTimer?.cancel();
  }

  Future<void> _saveAuthData(AuthResponse response) async {
    _accessToken.value = response.accessToken;
    _refreshToken.value = response.refreshToken;
    _user.value = response.user;
    oneSignalService.registerUser(response.user.id);
    await _storage.write('access_token', response.accessToken);
    await _storage.write('refresh_token', response.refreshToken);
    await _storage.write('user', response.user.toJson());
  }

  Future<void> _clearAuthData() async {
    _accessToken.value = '';
    _refreshToken.value = '';
    _user.value = null;
    oneSignalService.logoutUser();
    await _storage.remove('access_token');
    await _storage.remove('refresh_token');
    await _storage.remove('user');
  }
}
