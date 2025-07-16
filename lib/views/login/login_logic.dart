import 'package:bloomy/services/auth_service.dart';
import 'package:bloomy/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/route.dart';

class LoginLogic extends GetxController {
  final AuthService authService;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final hiddenPass = false.obs;

  LoginLogic(this.authService) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  Future loginWithGG() async {
    try {
      final isAuth = await authService.signInWithGoogle();
      if(isAuth) {
        showCustomSnackbar(message: "Logging in");
        Get.offNamed(Routes.main.p);
      } else {
        showCustomSnackbar(message: "Can\'t login", type: SnackbarType.error);
      }
    } catch (e) {
      print('Unexpected error login: $e');
    }
  }

  Future loginWithEmail() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final isAuth = await authService.signInWithEmail(email, password);
      if(isAuth) {
        showCustomSnackbar(message: "Logging in");
        Get.offNamed(Routes.main.p);
      } else {
        showCustomSnackbar(message: "Can\'t login", type: SnackbarType.error);
      }
    } catch (e) {
      print('Unexpected error login: $e');
    }
  }

}
