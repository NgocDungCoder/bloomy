import 'package:bloomy/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/route.dart';
import '../../widgets/snackbar.dart';

class SignInLogic extends GetxController {
  final AuthService authService;

  SignInLogic(this.authService) {
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
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
}