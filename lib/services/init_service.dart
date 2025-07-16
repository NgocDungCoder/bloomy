import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/auth_service.dart';
import 'package:bloomy/services/liked_service.dart';
import 'package:bloomy/services/lyric_service.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:get/get.dart';

Future initServices() async {
  Get.lazyPut(() => LyricService());
  await Get.put(LikedSongService());
  await Get.put(AlbumService());
  await Get.put(LyricService());
  await Get.put(AuthService());
}