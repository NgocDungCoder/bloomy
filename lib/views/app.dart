import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme/src/adaptive_theme_mode.dart';
import 'package:bloomy/configs/theme.dart';
import 'package:bloomy/routes/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  App({super.key, this.savedThemeMode});

  final _navigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: AppTheme.lightTheme,
        dark: AppTheme.darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => GetMaterialApp(
          key: _navigatorKey,
          smartManagement: SmartManagement.full,
          initialRoute: Routes.splash.p,
          getPages: getPages,
          debugShowCheckedModeBanner: false,
          title: "Bloomy",
          theme: theme,
          darkTheme: darkTheme,
          enableLog: kDebugMode,
          themeMode: ThemeMode.system,
          popGesture: !kIsWeb,
          defaultTransition: kIsWeb ? Transition.fadeIn : Transition.cupertino,
          onInit: () {

          },
        ));
  }

}