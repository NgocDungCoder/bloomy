import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/liked_service.dart';
import 'package:bloomy/views/add_song_to_album/add_song_state.dart';
import 'package:bloomy/views/liked_song/liked_logic.dart';
import 'package:get/get.dart';

import '../album/playlist_logic.dart';

class AddSongLogic extends GetxController {
  final state = AddSongSTate();
  final AlbumService _albumService = Get.find<AlbumService>();
  final SongController _songService = Get.find<SongController>();
  final LikedSongService likedSongService = Get.find<LikedSongService>();

  @override
  void onInit() async {
    super.onInit();
    state.album.value = Get.arguments;
    state.songs.value = await _songService.loadSongs();
    state.addedSongIds.addAll(state.album.value!.songs.map((song) => song.id));
  }

  void addToAlbum(SongModel song) async {
    if(state.album.value?.id == "favorite") {
      await likedSongService.likeSong(song.id);
      state.addedSongIds.add(song.id);
      state.addedSongIds.refresh();
      await Get.find<LikedLogic>().refreshFavorite();
    } else {
      final albumId = state.album.value?.id;
      final albums = await _albumService.loadAlbums(); // đọc tất cả album
      final index = albums.indexWhere((album) => album.id == albumId);

      if (index != -1) {
        final album = albums[index];

        album.songs.insert(0, song);
        await _albumService.saveAlbums(albums); // lưu lại toàn bộ danh sách
        state.addedSongIds.add(song.id);
        state.addedSongIds.refresh();
        await Get.find<PlaylistLogic>().refreshAlbum();
        print("✅ Đã thêm bài hát vào album: ${album.name}");
      } else {
        print("❌ Không tìm thấy album để thêm bài hát");
      }
    }
  }
}
