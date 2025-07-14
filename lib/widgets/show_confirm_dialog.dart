import 'package:bloomy/configs/colors.dart';
import 'package:bloomy/widgets/primary_button.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirmed,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Color(0xFF06202B),
      title: PrimaryText(text: title, fontWeight: FontWeight.bold, color: AppColors.textBlue,),
      content: PrimaryText(text: message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: PrimaryText(text: cancelText),
        ),
        // Gọi hàm được tru
        PrimaryButton(
          text: confirmText,
          onPressed: () {
            Navigator.of(context).pop(); // Đóng dialog
            onConfirmed();
          },
        ),
      ],
    ),
  );
}
