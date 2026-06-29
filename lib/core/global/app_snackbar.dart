import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/app_colors.dart';

class AppSnackBar {
  AppSnackBar._();

  static DateTime? _lastShownTime;

  static void show({
    required String message,
    bool isSuccess = true,
    String? title,
    Duration duration = const Duration(seconds: 2),
    SnackPosition snackPosition = SnackPosition.TOP,
  }) {
    final now = DateTime.now();

    // Prevent multiple snackbar spam within 500ms
    if (_lastShownTime != null &&
        now.difference(_lastShownTime!).inMilliseconds < 500) {
      return;
    }

    _lastShownTime = now;

    // Close previous snackbar before showing new one
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title ?? (isSuccess ? 'Success' : 'Failed'),
      message,

      snackPosition: snackPosition,
      duration: duration,

      backgroundColor: isSuccess ? AppColors.success : AppColors.error,
      colorText: Colors.white,

      borderRadius: 12,
      margin: const EdgeInsets.all(12),

      icon: Icon(
        isSuccess
            ? Icons.check_circle_outline
            : Icons.warning_amber_outlined,
        color: Colors.white,
      ),

      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,

      mainButton: TextButton(
        onPressed: Get.closeCurrentSnackbar,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Dismiss',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Optional shortcut methods
  static void success(String message) {
    show(
      message: message,
      isSuccess: true,
    );
  }

  static void error(String message) {
    show(
      message: message,
      isSuccess: false,
    );
  }
}
