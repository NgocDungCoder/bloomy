import 'package:bloomy/controllers/album_controller.dart';
import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/views/float_play/float_play_logic.dart';
import 'package:get/get.dart';

import '../services/music_player_service.dart';
import '../services/song_service.dart';

Future initControllers() async {
 try {
   await Get.put(AlbumController(), permanent: true);
   await Get.put(SongService());

   await Get.put(SongController(), permanent: true);
   await Get.put(MusicPlayerService());

   Get.put(FloatPlayLogic(), permanent: true);

 } catch (e) {
  print("Lỗi trong initController: $e");
 }
}