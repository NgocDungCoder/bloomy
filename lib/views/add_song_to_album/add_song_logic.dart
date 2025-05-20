import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/views/add_song_to_album/add_song_state.dart';
import 'package:get/get.dart';

class AddSongLogic extends GetxController {
  final state = AddSongSTate();
  final AlbumService _albumService = Get.find<AlbumService>();
  final SongController _songService = Get.find<SongController>();

  @override
  void onInit() async {
    super.onInit();
    state.albumId.value = Get.arguments;
    state.songs.value = await _songService.loadSongs();
  }

  void addToAlbum(SongModel song) async {
    final albumId = state.albumId.value;
    final albums = await _albumService.loadAlbums(); // đọc tất cả album
    final index = albums.indexWhere((album) => album.id == albumId);

    if (index != -1) {
      final album = albums[index];

      // Kiểm tra nếu bài hát đã tồn tại thì không thêm lại
      final exists = album.songs.any((s) => s.id == song.id);
      if (!exists) {
        album.songs.insert(0,song);
        await _albumService.saveAlbums(albums); // lưu lại toàn bộ danh sách
        state.addedSongIds.add(song.id);
        state.addedSongIds.refresh();
        print("✅ Đã thêm bài hát vào album: ${album.name}");
      } else {
        print("⚠️ Bài hát đã tồn tại trong album");
      }
    } else {
      print("❌ Không tìm thấy album để thêm bài hát");
    }
  }
}