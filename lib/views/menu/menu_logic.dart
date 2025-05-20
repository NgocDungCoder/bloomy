import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:bloomy/views/menu/menu_state.dart';
import 'package:get/get.dart';

class MenuLogic extends GetxController {
  final state = MenuState();
  final songService = Get.find<SongService>();
  final albumService = Get.find<AlbumService>();
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map;

    if ( args['albumId'] != null) {
      state.albumId.value =  args['albumId'];
      state.inAlbum.value = true;
      print("Mở từ album: ${state.albumId.value}");
    }
    state.song.value = args['song'];
  }

  void removeFormPlaylist() {
    albumService.deleteSongInAlbum(state.albumId.value, state.song.value.id);
  }

  void deleteSong() {
    songService.deleteSong(state.song.value.id);
  }
}