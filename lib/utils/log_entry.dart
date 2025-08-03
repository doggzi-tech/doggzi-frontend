import 'package:dio/dio.dart';

class LogEntry {
  final int id;
  final RequestOptions requestOptions;
  final Response? response;
  final DioException? error;
  final DateTime timestamp;
  final Duration duration;

  LogEntry({
    required this.id,
    required this.requestOptions,
    this.response,
    this.error,
    required this.timestamp,
    required this.duration,
  });

  // Helper to determine if the request was successful
  bool get isSuccess =>
      error == null &&
      response?.statusCode != null &&
      response!.statusCode! >= 200 &&
      response!.statusCode! < 300;
}
