import 'package:get/get.dart';
import 'log_entry.dart';

class LoggerService extends GetxService {
  final RxList<LogEntry> logs = <LogEntry>[].obs;
  final int maxLogs = 100; // Limit the number of logs to prevent memory issues
  int _nextId = 0;

  void addLog(LogEntry log) {
    if (logs.length >= maxLogs) {
      logs.removeLast(); // Remove the oldest log
    }
    logs.insert(0, log); // Add the new log to the top of the list
  }

  void clearLogs() {
    logs.clear();
  }

  // A helper to create log entries with unique IDs
  int getNextId() {
    return _nextId++;
  }
}
