import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:get/get.dart';

Future initServices() async {
  Get.put(MusicPlayerService());
  Get.put(AlbumService());
  Get.put(SongService());
}