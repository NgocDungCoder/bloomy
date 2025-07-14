import 'package:bloomy/configs/colors.dart';
import 'package:bloomy/widgets/primary_button.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/material.dart';

class ConfirmableButton extends StatelessWidget {
  final String text;
  final VoidCallback onConfirmed;
  final String confirmTitle;
  final String confirmMessage;
  final String confirmText;
  final String cancelText;
  final Color backgroundColor;
  final FontWeight fontWeight;

  const ConfirmableButton({
    Key? key,
    required this.text,
    required this.onConfirmed,
    this.confirmTitle = "Confirm",
    this.confirmMessage = "Are you sure?",
    this.confirmText = "OK",
    this.cancelText = "Cancel",
    this.backgroundColor = const Color(0xFF06A0B5),
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.tealGradient, // tím → xanh
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                text: confirmTitle,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              PrimaryText(
                text: confirmMessage,
                maxLine: 3,
                color: Colors.white70,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: PrimaryText(
                      text: cancelText,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton(text: confirmText, onPressed: () {
                    Navigator.of(context).pop();
                    onConfirmed();
                  },
                  backgroundColor: AppColors.buttonRed,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: backgroundColor, // Màu phát sáng
            blurRadius: 10, // Độ mờ của hào quang
            spreadRadius: 5,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        onPressed: () => _showConfirmationDialog(context),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
