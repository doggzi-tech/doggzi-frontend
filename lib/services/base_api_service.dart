import 'dart:async';
import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../controllers/auth_controller.dart';
import '../utils/logger_interceptor.dart';

class BaseApiService {
  static String productionUrl = 'https://backend.doggzi.com';
  static String developmentUrl = "http://192.168.1.12:8000";
  static String baseUrl = dotenv.env["ENVIRONMENT"] == "PRODUCTION"
      ? productionUrl
      : dotenv.env["ENVIRONMENT"] == "LOCAL"
          ? developmentUrl
          : kReleaseMode
              ? productionUrl
              : developmentUrl;

  late Dio dio;

  // Token refresh management
  bool _isRefreshing = false;
  final Queue<_QueuedRequest> _requestQueue = Queue<_QueuedRequest>();
  Completer<bool>? _refreshCompleter;

  // Configuration for parallel processing
  bool enableParallelProcessing = true; // Set to false for sequential
  int maxConcurrentRequests = 5; // Limit concurrent requests

  BaseApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api/v1",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
    dio.interceptors.add(AppLoggerInterceptor());

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final authController = Get.find<AuthController>();
          if (authController.accessToken.isNotEmpty) {
            options.headers['Authorization'] =
                'Bearer ${authController.accessToken}';
            print('🔑 Using access token: ${authController.accessToken}');
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

          if (error.response?.statusCode == 401) {
            if (error.requestOptions.path == '/auth/refresh') {
              final authController = Get.find<AuthController>();
              authController.logout();
              return handler.next(error);
            }
            await _handle401Error(error, handler);
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  Future<void> _handle401Error(
      DioException error, ErrorInterceptorHandler handler) async {
    final authController = Get.find<AuthController>();

    // If already refreshing, queue this request and wait
    if (_isRefreshing && _refreshCompleter != null) {
      print('🔄 Token refresh in progress, queuing request...');
      _queueRequest(error, handler);

      try {
        // Wait for the ongoing refresh to complete
        final refreshSuccess = await _refreshCompleter!.future;
        if (refreshSuccess) {
          // Refresh was successful, the queued request will be processed automatically
          return;
        } else {
          // Refresh failed, request was already rejected in _processQueuedRequests
          return;
        }
      } catch (e) {
        print('💥 Error waiting for token refresh: $e');
        handler.next(error);
        return;
      }
    }

    // Start refresh process
    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();
    print('🔄 Starting token refresh...');

    bool refreshSuccess = false;

    try {
      refreshSuccess = await authController.refreshTokens();
      print('Token refresh result: $refreshSuccess');

      if (refreshSuccess) {
        // Refresh successful - retry original request
        await _retryRequest(error, handler);
        // Process all queued requests
        await _processQueuedRequests(true);
      } else {
        // Refresh failed - logout and reject all requests
        print('🚫 Token refresh failed, logging out user');
        await _handleRefreshFailure(error, handler, 'Token refresh failed');
      }
    } catch (e) {
      // Refresh process threw an exception
      print('💥 Token refresh process failed with exception: $e');
      await _handleRefreshFailure(
          error, handler, 'Token refresh process failed: $e');
      refreshSuccess = false;
    } finally {
      // Complete the refresh completer and reset state
      if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete(refreshSuccess);
      }
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<void> _handleRefreshFailure(DioException error,
      ErrorInterceptorHandler handler, String reason) async {
    final authController = Get.find<AuthController>();

    try {
      authController.logout();
    } catch (e) {
      print('💥 Error during logout: $e');
    }

    _rejectQueuedRequests(reason);
    handler.next(DioException(
      requestOptions: error.requestOptions,
      message: reason,
      type: DioExceptionType.badResponse,
      response: error.response,
    ));
  }

  void _queueRequest(DioException error, ErrorInterceptorHandler handler) {
    final queuedRequest = _QueuedRequest(error, handler);
    _requestQueue.add(queuedRequest);
    print(
        '📋 Queued request: ${error.requestOptions.method} ${error.requestOptions.path} (Queue size: ${_requestQueue.length})');
  }

  Future<void> _retryRequest(
      DioException error, ErrorInterceptorHandler handler) async {
    final authController = Get.find<AuthController>();
    final opts = _copyRequestOptions(error.requestOptions);
    opts.headers['Authorization'] = 'Bearer ${authController.accessToken}';

    try {
      print(
          '🔄 Retrying original request with new token: ${opts.method} ${opts.path}');
      final response = await dio.fetch(opts);
      handler.resolve(response);
    } catch (retryError) {
      print('💥 Original request retry failed: $retryError');
      await _handleRetryFailure(retryError, handler, authController);
    }
  }

  Future<void> _handleRetryFailure(dynamic retryError,
      ErrorInterceptorHandler handler, AuthController authController) async {
    // If retry fails with another 401, don't trigger another refresh
    if (retryError is DioException && retryError.response?.statusCode == 401) {
      print(
          '🚫 Original request retry got 401, token might be invalid, logging out user');
      try {
        authController.logout();
      } catch (e) {
        print('💥 Error during logout after retry failure: $e');
      }
      handler.next(DioException(
        requestOptions: retryError.requestOptions,
        message: 'Authentication failed after token refresh',
        type: DioExceptionType.badResponse,
        response: retryError.response,
      ));
    } else {
      handler.next(retryError);
    }
  }

  Future<void> _processQueuedRequests(bool refreshSuccess) async {
    if (_requestQueue.isEmpty) {
      print('📋 No queued requests to process');
      return;
    }

    print(
        '📋 Processing ${_requestQueue.length} queued requests (refresh success: $refreshSuccess, parallel: $enableParallelProcessing)...');
    final authController = Get.find<AuthController>();

    if (!refreshSuccess) {
      _rejectQueuedRequests('Token refresh failed');
      return;
    }

    // Convert queue to list and clear queue
    final queueCopy = List<_QueuedRequest>.from(_requestQueue);
    _requestQueue.clear();

    if (enableParallelProcessing) {
      await _processRequestsInParallel(queueCopy, authController);
    } else {
      await _processRequestsSequentially(queueCopy, authController);
    }
  }

  // Process requests in parallel with concurrency limit
  Future<void> _processRequestsInParallel(
      List<_QueuedRequest> requests, AuthController authController) async {
    print(
        '⚡ Processing ${requests.length} requests in parallel (max concurrent: $maxConcurrentRequests)');

    // Process requests in batches to limit concurrency
    for (int i = 0; i < requests.length; i += maxConcurrentRequests) {
      final batch = requests.skip(i).take(maxConcurrentRequests).toList();

      // Create futures for this batch
      final futures = batch.map((queuedRequest) async {
        try {
          final opts = _copyRequestOptions(queuedRequest.error.requestOptions);
          opts.headers['Authorization'] =
              'Bearer ${authController.accessToken}';

          print(
              '🔄 Retrying queued request (parallel): ${opts.method} ${opts.path}');
          final response = await dio.fetch(opts);
          queuedRequest.handler.resolve(response);
          print('✅ Parallel queued request completed successfully');
        } catch (retryError) {
          print('💥 Parallel queued request retry failed: $retryError');
          await _handleQueuedRequestFailure(
              retryError, queuedRequest.handler, authController);
        }
      }).toList();

      // Wait for this batch to complete before starting next batch
      await Future.wait(futures);

      if (i + maxConcurrentRequests < requests.length) {
        print(
            '⏭️ Batch ${(i / maxConcurrentRequests + 1).round()} completed, processing next batch...');
      }
    }

    print('🎉 All queued requests processed in parallel');
  }

  // Process requests sequentially (original behavior)
  Future<void> _processRequestsSequentially(
      List<_QueuedRequest> requests, AuthController authController) async {
    print('🔄 Processing ${requests.length} requests sequentially');

    for (final queuedRequest in requests) {
      try {
        final opts = _copyRequestOptions(queuedRequest.error.requestOptions);
        opts.headers['Authorization'] = 'Bearer ${authController.accessToken}';

        print(
            '🔄 Retrying queued request (sequential): ${opts.method} ${opts.path}');
        final response = await dio.fetch(opts);
        queuedRequest.handler.resolve(response);
        print('✅ Sequential queued request completed successfully');
      } catch (retryError) {
        print('💥 Sequential queued request retry failed: $retryError');
        await _handleQueuedRequestFailure(
            retryError, queuedRequest.handler, authController);
      }
    }

    print('🎉 All queued requests processed sequentially');
  }

  Future<void> _handleQueuedRequestFailure(dynamic retryError,
      ErrorInterceptorHandler handler, AuthController authController) async {
    // If retry fails with 401, the token might be invalid again
    if (retryError is DioException && retryError.response?.statusCode == 401) {
      print(
          '🚫 Queued request got 401, token might be invalid again, logging out user');
      try {
        authController.logout();
      } catch (e) {
        print('💥 Error during logout after queued request failure: $e');
      }
      handler.next(DioException(
        requestOptions: retryError.requestOptions,
        message: 'Authentication failed during queued request retry',
        type: DioExceptionType.badResponse,
        response: retryError.response,
      ));
    } else {
      handler.next(retryError);
    }
  }

  void _rejectQueuedRequests(String reason) {
    if (_requestQueue.isEmpty) {
      return;
    }

    print('🚫 Rejecting ${_requestQueue.length} queued requests: $reason');

    while (_requestQueue.isNotEmpty) {
      final queuedRequest = _requestQueue.removeFirst();
      queuedRequest.handler.next(DioException(
        requestOptions: queuedRequest.error.requestOptions,
        message: reason,
        type: DioExceptionType.badResponse,
        response: queuedRequest.error.response,
      ));
    }
  }

  // Helper method to copy request options to avoid modifying the original
  RequestOptions _copyRequestOptions(RequestOptions original) {
    return RequestOptions(
      path: original.path,
      method: original.method,
      data: original.data,
      queryParameters: original.queryParameters,
      headers: Map<String, dynamic>.from(original.headers),
      extra: original.extra,
      baseUrl: original.baseUrl,
      connectTimeout: original.connectTimeout,
      receiveTimeout: original.receiveTimeout,
      sendTimeout: original.sendTimeout,
      responseType: original.responseType,
      contentType: original.contentType,
      validateStatus: original.validateStatus,
      receiveDataWhenStatusError: original.receiveDataWhenStatusError,
      followRedirects: original.followRedirects,
      maxRedirects: original.maxRedirects,
      persistentConnection: original.persistentConnection,
      requestEncoder: original.requestEncoder,
      responseDecoder: original.responseDecoder,
      listFormat: original.listFormat,
    );
  }

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

  // Configuration methods
  void setParallelProcessing(bool enabled, {int? maxConcurrent}) {
    enableParallelProcessing = enabled;
    if (maxConcurrent != null && maxConcurrent > 0) {
      maxConcurrentRequests = maxConcurrent;
    }
    print(
        '🔧 Parallel processing: $enabled (max concurrent: $maxConcurrentRequests)');
  }

  // Optional: Add method to clear queue manually if needed
  void clearRequestQueue() {
    if (_requestQueue.isNotEmpty) {
      _rejectQueuedRequests('Queue cleared manually');
    }
    _isRefreshing = false;
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      _refreshCompleter!.complete(false);
    }
    _refreshCompleter = null;
  }

  // Optional: Get queue status for debugging
  int get queuedRequestsCount => _requestQueue.length;

  bool get isRefreshingToken => _isRefreshing;

  bool get isParallelProcessingEnabled => enableParallelProcessing;

  int get maxConcurrentRequestsLimit => maxConcurrentRequests;

  // Optional: Force logout and clear everything
  void forceLogoutAndClear() {
    try {
      final authController = Get.find<AuthController>();
      authController.logout();
    } catch (e) {
      print('💥 Error during force logout: $e');
    }
    clearRequestQueue();
  }
}

// Helper class to store queued requests
class _QueuedRequest {
  final DioException error;
  final ErrorInterceptorHandler handler;

  _QueuedRequest(this.error, this.handler);
}
