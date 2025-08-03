import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/logger_service.dart';
import 'log_entry_tile.dart';

class LoggerScreen extends StatelessWidget {
  const LoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil. You should ideally do this in your MaterialApp builder.
    ScreenUtil.init(context, designSize: const Size(375, 812));
    final LoggerService loggerService = Get.find<LoggerService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Network Logger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear Logs',
            onPressed: () {
              // Add a confirmation dialog before clearing
              Get.defaultDialog(
                title: "Clear Logs?",
                middleText: "Are you sure you want to delete all log entries?",
                textConfirm: "Clear",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  loggerService.clearLogs();
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (loggerService.logs.isEmpty) {
            return const Center(
              child: Text(
                'No requests logged yet.\nPerform a network request to see it here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: loggerService.logs.length,
            itemBuilder: (context, index) {
              final log = loggerService.logs[index];
              return LogEntryTile(log: log);
            },
          );
        },
      ),
    );
  }
}
