import 'dart:convert';
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/log_entry.dart';

class LogEntryTile extends StatelessWidget {
  final LogEntry log;

  const LogEntryTile({super.key, required this.log});

  // Helper to pretty-print JSON
  String _prettyJson(dynamic json) {
    if (json == null) return "null";
    const encoder = JsonEncoder.withIndent('  ');
    try {
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  Color _getStatusColor() {
    if (log.isSuccess) return Colors.green.shade400;
    if (log.response?.statusCode != null) return Colors.red.shade400;
    return Colors
        .orange.shade400; // Errors without a status code (e.g., timeout)
  }

  @override
  Widget build(BuildContext context) {
    final status = log.response?.statusCode ?? "ERR";
    final method = log.requestOptions.method;
    final path = log.requestOptions.path;

    return Card(
      color: AppColors.lightGrey100,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(),
          radius: 20.r,
          child: Text(
            status.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
        title: Text(
          '$method: $path',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Row(
          children: [
            Text(
              DateFormat('HH:mm:ss').format(log.timestamp),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.timer_outlined,
                size: 14.sp, color: Colors.grey.shade600),
            SizedBox(width: 2.w),
            Text(
              '${log.duration.inMilliseconds}ms', // <-- DISPLAY DURATION
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
        children: [
          _buildDetailSection(
            title: 'Request',
            details: {
              'Base URL': log.requestOptions.baseUrl,
              'Path': log.requestOptions.path,
              'Method': log.requestOptions.method,
              'Headers': _prettyJson(log.requestOptions.headers),
              'Body': _prettyJson(log.requestOptions.data),
              'Query Params': _prettyJson(log.requestOptions.queryParameters),
            },
          ),
          _buildDetailSection(
            title: 'Response',
            details: {
              'Status Code': log.response?.statusCode,
              'Status Message': log.response?.statusMessage,
              'Headers': _prettyJson(log.response?.headers.map),
              'Body': _prettyJson(log.response?.data),
            },
          ),
          if (log.error != null)
            _buildDetailSection(
              title: 'Error',
              details: {
                'Type': log.error?.type.toString(),
                'Message': log.error?.message,
                'Error': _prettyJson(log.error?.error),
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
      {required String title, required Map<String, dynamic> details}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 1.h),
          ...details.entries.map((entry) {
            if (entry.value == null ||
                entry.value.toString().isEmpty ||
                entry.value.toString() == "null")
              return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13.sp),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, size: 16.sp),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: entry.value.toString()));
                          Get.snackbar(
                              'Copied', '${entry.key} copied to clipboard',
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 1));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SelectableText(
                      entry.value.toString(),
                      style:
                          TextStyle(fontSize: 12.sp, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
