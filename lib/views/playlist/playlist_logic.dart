import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:bloomy/views/playlist/playlist_state.dart';
import 'package:get/get.dart';

class PlaylistLogic extends GetxController {
  final state = PlaylistState();
  final SongController songController = Get.find<SongController>();
  final MusicPlayerService _playerService = Get.find<MusicPlayerService>();
  final AlbumService _albumService = Get.find<AlbumService>();

  @override
  void onInit() {
    super.onInit();
    state.album.value = Get.arguments;

  }


  void deleteAlbum(String albumId) {
    _albumService.deleteAlbum(albumId);
  }
}