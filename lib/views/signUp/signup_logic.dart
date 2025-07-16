import 'package:bloomy/services/auth_service.dart';
import 'package:bloomy/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/route.dart';

class SignupLogic extends GetxController {
  final AuthService authService;
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final hiddenPass = true.obs;
  final hiddenRepeatPass = true.obs;
  final RxBool isPasswordMismatch = false.obs;

  SignupLogic(this.authService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void onClose() {
    repeatPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void validateRepeatPassword() {
    final pw = passwordController.text.trim();
    final repeat = repeatPasswordController.text.trim();
    isPasswordMismatch.value =
        pw.isNotEmpty && repeat.isNotEmpty && pw != repeat;
  }

  Future<void> signUpWithEmail() async {
    if (!isPasswordMismatch.value) {
      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        final status = await authService.signUpWithEmail(
          email,
          password,
        );
        if(status) {
          showCustomSnackbar(message: "Sign up success !");
          Get.offNamed(Routes.login.p);
        } else {
          showCustomSnackbar(
              message: "Sign up failure !", type: SnackbarType.error);
        }
      } catch (e) {
        print("Lỗi đăng ký: $e");
        showCustomSnackbar(
            message: "Sign up failure !", type: SnackbarType.error);
      }
    } else {
      showCustomSnackbar(
          message: "Password is not match", type: SnackbarType.warning);
    }
  }
}
