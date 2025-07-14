import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LikedSongService {
  static const _fileName = 'liked_songs.json';

  Future<String> get _filePath async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$_fileName";
  }

  /// Lấy danh sách ID các bài hát đã thích
  Future<List<String>> loadLikedSongIds() async {
    final path = await _filePath;
    final file = File(path);

    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final List decoded = json.decode(content);
    return decoded.cast<String>();
  }

  /// Lưu danh sách ID các bài hát đã thích
  Future<void> saveLikedSongIds(List<String> ids) async {
    final path = await _filePath;
    final file = File(path);
    final content = json.encode(ids);
    await file.writeAsString(content);
  }



  /// Thêm một bài hát vào danh sách yêu thích
  Future<void> likeSong(String songId) async {
    final ids = await loadLikedSongIds();
    if (!ids.contains(songId)) {
      ids.insert(0, songId);
      await saveLikedSongIds(ids);
    }
  }

  Future<void> likeSongs(List<String> songIds) async {
    final ids = await loadLikedSongIds();
    bool changed = false;

    for (final songId in songIds) {
      if (!ids.contains(songId)) {
        ids.add(songId);
        changed = true;
      }
    }
    if (changed) {
      await saveLikedSongIds(ids);
    }
  }


  /// Bỏ thích một bài hát
  Future<void> unlikeSong(String songId) async {
    final ids = await loadLikedSongIds();
    ids.remove(songId);
    await saveLikedSongIds(ids);
  }

  /// Kiểm tra xem một bài hát có được thích không
  Future<bool> isSongLiked(String songId) async {
    final ids = await loadLikedSongIds();
    return ids.contains(songId);
  }

  /// Xóa toàn bộ danh sách yêu thích
  Future<void> clearLikedSongs() async {
    final path = await _filePath;
    final file = File(path);
    if (await file.exists()) {
      await file.writeAsString('[]');
    }
  }
}

