import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/liked_service.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:bloomy/views/album/playlist_state.dart';
import 'package:bloomy/views/library/library_logic.dart';
import 'package:bloomy/views/liked_song/liked_logic.dart';
import 'package:bloomy/widgets/snackbar.dart';
import 'package:get/get.dart';

class PlaylistLogic extends GetxController {
  final state = PlaylistState();
  final SongController songController = Get.find<SongController>();
  final AlbumService _albumService = Get.find<AlbumService>();
  final LikedSongService likedSongService = Get.find<LikedSongService>();
  final SongService songService = Get.find<SongService>();

  @override
  void onInit() {
    super.onInit();
    state.album.value = Get.arguments;
  }

  Future refreshAlbum() async {
    try {
      final newAlbum = await _albumService.loadAlbumById(state.album.value.id);
      if (newAlbum != null) {
        state.album.value = newAlbum;
      } else {
        print("Album không tìm thấy");
      }
    } catch (e) {
      print("Lỗi khi tải album: $e");
    }
  }


    Future deleteAlbum(String albumId) async {
    await _albumService.deleteAlbum(albumId);
    await Get.find<LibraryLogic>().refreshLibrary();
    }

  Future<void> addAllToFavorite() async {
    try {
      final songs = state.album.value.songs;
      final songIds = songs.map((song) => song.id).toList();
      await likedSongService.likeSongs(songIds);
      await songService.markSongsAsLiked(songIds);
      showCustomSnackbar(message: "Added All To Favorite");
    } catch (e) {
      showCustomSnackbar(message: "Can't Add to Favorite", type: SnackbarType.error);
    }
  }

}