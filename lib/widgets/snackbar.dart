import 'package:bloomy/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error, warning }

void showCustomSnackbar({
  required String message,
  SnackbarType type = SnackbarType.success,
  Duration duration = const Duration(seconds: 2),
  SnackPosition position = SnackPosition.BOTTOM,
  double height = 70,
}) {
  // Cấu hình theo loại snackbar
  late final String title;
  late final IconData icon;
  late final Color backgroundColor;

  switch (type) {
    case SnackbarType.success:
      title = 'Succes';
      icon = Icons.check_circle;
      backgroundColor = AppColors.mint;
      break;
    case SnackbarType.error:
      title = 'Failed';
      icon = Icons.error;
      backgroundColor = AppColors.red;
      break;
    case SnackbarType.warning:
      title = 'Warning';
      icon = Icons.warning_amber_rounded;
      backgroundColor = AppColors.yellow;
      break;
  }

  Get.rawSnackbar(
    snackPosition: position,
    duration: duration,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    maxWidth: 280,
    backgroundColor: Colors.transparent,
    messageText: Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}