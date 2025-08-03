import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'logger_service.dart';
import 'log_entry.dart';

class AppLoggerInterceptor extends Interceptor {
  final LoggerService _loggerService = getx.Get.find<LoggerService>();

  // Use a map to associate requests with their start times
  final Map<int, DateTime> _requestStartTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Store the start time of the request
    _requestStartTimes[options.hashCode] = DateTime.now();
    // We don't log here yet, we wait for the response or error
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime =
        _requestStartTimes.remove(response.requestOptions.hashCode);
    final duration =
        DateTime.now().difference(startTime!); // <-- CALCULATE DURATION
    final log = LogEntry(
      id: _loggerService.getNextId(),
      requestOptions: response.requestOptions,
      response: response,
      timestamp: startTime ?? DateTime.now(),
      // Fallback to now
      duration: duration,
    );
    _loggerService.addLog(log);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = _requestStartTimes.remove(err.requestOptions.hashCode);
    final duration = DateTime.now().difference(startTime!);
    final log = LogEntry(
      id: _loggerService.getNextId(),
      requestOptions: err.requestOptions,
      response: err.response,
      // An error can still have a response
      error: err,
      timestamp: startTime ?? DateTime.now(),
      // Fallback to now
      duration: duration,
    );
    _loggerService.addLog(log);
    super.onError(err, handler);
  }
}
