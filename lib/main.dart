import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bloomy/controllers/init_controller.dart';
import 'package:bloomy/services/init_service.dart';
import 'package:bloomy/services/permission.dart';
import 'package:bloomy/views/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {

  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //làm cho thanh trạng thái ngày giờ trong suốt
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    await initServices();
    await initControllers();


    requestStoragePermission();

    // await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,);
    //
    // await initDeepLink();
    await initServices();
    await initControllers();

    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);



    runApp(App(savedThemeMode: savedThemeMode));
  }, (error, stack) async {
    print("=====> Error in main");
    print(error);
    print(stack);
  });
}

