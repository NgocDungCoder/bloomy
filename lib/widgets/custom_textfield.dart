import 'package:bloomy/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomUnderlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;

  const CustomUnderlineTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        cursorColor: const Color(0xFF06A0B5),
        style: GoogleFonts.aBeeZee(
          color: AppColors.textWhite,
          decoration: TextDecoration.none,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.aBeeZee(
            color: AppColors.textHint,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textHint, width: 1.0),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textWhite, width: 1.0),
          ),
        ),
      ),
    );
  }
}
