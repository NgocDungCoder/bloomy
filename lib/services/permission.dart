import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

Future<bool> requestStoragePermission() async {
  try {
    // Kiểm tra phiên bản Android
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      print("Android SDK version: $sdkInt");

      // Android 13+ (API 33+) cần quyền READ_MEDIA_AUDIO
      if (sdkInt >= 33) {
        print("Checking audio permission for Android 13+...");
        var status = await Permission.audio.status;
        print("Permission status before request: $status");
        if (status.isGranted) {
          print("Audio permission already granted");
          return true;
        } else if (status.isDenied) {
          print("Audio permission denied, requesting...");
          status = await Permission.audio.request();
          print("Permission status after request: $status");
          if (status.isGranted) {
            print("Audio permission granted after request");
            return true;
          } else if (status.isPermanentlyDenied) {
            print("Audio permission permanently denied, opening app settings...");
            await openAppSettings();
            return false;
          }
          return false;
        } else if (status.isPermanentlyDenied) {
          print("Audio permission permanently denied, opening app settings...");
          await openAppSettings();
          return false;
        }
      } else {
        // Android 12 trở xuống (API < 33) dùng READ_EXTERNAL_STORAGE
        print("Checking storage permission for Android < 13...");
        var status = await Permission.storage.status;
        print("Permission status before request: $status");
        if (status.isGranted) {
          print("Storage permission already granted");
          return true;
        } else if (status.isDenied) {
          print("Storage permission denied, requesting...");
          status = await Permission.storage.request();
          print("Permission status after request: $status");
          if (status.isGranted) {
            print("Storage permission granted after request");
            return true;
          } else if (status.isPermanentlyDenied) {
            print("Storage permission permanently denied, opening app settings...");
            await openAppSettings();
            return false;
          }
          return false;
        } else if (status.isPermanentlyDenied) {
          print("Storage permission permanently denied, opening app settings...");
          await openAppSettings();
          return false;
        }
      }
    }
    // iOS hoặc các nền tảng khác
    return true;
  } catch (e) {
    print("Error requesting permission: $e");
    return false;
  }
}