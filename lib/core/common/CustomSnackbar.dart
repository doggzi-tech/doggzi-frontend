import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class customSnackBar {
  static void show({
    required String message,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 3),
    SnackBarType type = SnackBarType.normal,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: _getBackgroundColor(type),
      textColor: _getTextColor(type),
      fontSize: 16.0,
    );
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.black;
      case SnackBarType.error:
        return Colors.red[700]!;
      case SnackBarType.warning:
        return Colors.orange[700]!;
      default:
        return Colors.grey[800]!;
    }
  }

  static Color _getTextColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.warning:
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}

enum SnackBarType { normal, success, error, warning }
