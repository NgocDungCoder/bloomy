import 'package:bloomy/controllers/album_controller.dart';
import 'package:bloomy/controllers/song_controller.dart';
import 'package:get/get.dart';

Future initControllers() async {
 try {
   Get.put(SongController(), permanent: true);
   Get.put(AlbumController(), permanent: true);

 } catch (e) {
  print("Lỗi trong initController: $e");
 }
}