import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/views/add_to_playlist/add_playlist_state.dart';
import 'package:get/get.dart';

class AddPlaylistLogic extends GetxController {
  final state = AddPlaylistState();
  final _albumService = Get.find<AlbumService>();

  @override
  void onInit() async {
    super.onInit();
    state.albums.value = await _albumService.loadAlbums();
    state.song.value = Get.arguments;
  }

  void addSongToPlaylist(String albumId) {
    _albumService.addSongToAlbum(albumId, state.song.value!);
  }
}