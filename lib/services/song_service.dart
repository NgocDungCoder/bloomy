import 'dart:convert';
import 'dart:io';
import 'package:bloomy/models/song_model.dart';
import 'package:path_provider/path_provider.dart';

class SongService {

  // Phương thức mới để lấy đường dẫn đến file songs.json
  Future<String> _getSongJsonPath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/songs.json';
  }

  //save file mp3 vô vùng nhớ dữ liệu của app
  Future<String> saveMp3File(File mp3File, String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String musicDirPath = '${appDocDir.path}/music';
    Directory musicDir = Directory(musicDirPath);
    if (!await musicDir.exists()) await musicDir.create(recursive: true);

    //Dart không tự đặt tên → bạn bắt buộc phải cung cấp tên file mới khi copy
    String newPath = '$musicDirPath/$fileName';
    await mp3File.copy(newPath);
    return newPath;
  }

  Future<void> saveSongInfo(SongModel song) async {
    String jsonFilePath = await _getSongJsonPath(); // Sử dụng phương thức mới
    File jsonFile = File(jsonFilePath);

    //lấy danh sách các bài hát ra
    List<SongModel> songs = await getSavedSongs();
    songs.insert(0, song);
    //thêm bài hát mới và chuyển thành json ghi lại vào file song.json
    List<Map<String, dynamic>> jsonList = songs.map((s) => s.toJson()).toList();
    await jsonFile.writeAsString(jsonEncode(jsonList));
  }

  //lấy các bài hát từ sóng.json, biến nó lại thàng SongModel
  Future<List<SongModel>> getSavedSongs() async {
    String jsonFilePath = await _getSongJsonPath(); // Sử dụng phương thức mới
    File jsonFile = File(jsonFilePath);
    if (!jsonFile.existsSync()) return [];
    String content = await jsonFile.readAsString();
    List<dynamic> data = jsonDecode(content);
    return data.map((e) => SongModel.fromJson(e)).toList();
  }

  Future<void> deleteSongFile() async {
    String jsonFilePath = await _getSongJsonPath(); // Sử dụng phương thức mới
    File file = File(jsonFilePath);

    if (await file.exists()) {
      await file.delete();
      print('Đã xoá file songs.json');
    } else {
      print('File songs.json không tồn tại');
    }
  }

  Future<void> deleteSong(String songId) async {
    String jsonFilePath = await _getSongJsonPath(); // Sử dụng phương thức mới
    File file = File(jsonFilePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> songs = jsonDecode(content);

      // Lọc danh sách để loại bỏ bài hát có songId
      final updatedSongs = songs.where((song) => song['id'] != songId).toList();

      await file.writeAsString(jsonEncode(updatedSongs));
      print('Đã xoá bài hát có ID: $songId');
    } else {
      print('File songs.json không tồn tại');
    }
  }

  Future<void> updateSongInfo(SongModel song) async {
    try {
      final songs = await getSavedSongs();
      final index = songs.indexWhere((s) => s.id == song.id);

      if (index != -1) {
        songs[index] = song;
        final jsonList = songs.map((s) => s.toJson()).toList();
        final file = File(await _getSongJsonPath());
        await file.writeAsString(jsonEncode(jsonList));
        print("✅ Đã cập nhật thông tin bài hát: ${song.title}");
      } else {
        print("❌ Không tìm thấy bài hát để cập nhật: ${song.id}");
      }
    } catch (e) {
      print("❌ Lỗi khi cập nhật thông tin bài hát: $e");
    }
  }

  // Thêm phương thức để lưu dữ liệu sóng nhạc riêng biệt nếu cần
  Future<void> saveWaveformData(String songId, List<double> waveformData) async {
    try {
      // Cập nhật bài hát hiện có với dữ liệu sóng nhạc mới
      final songs = await getSavedSongs();
      final index = songs.indexWhere((s) => s.id == songId);

      if (index != -1) {
        final song = songs[index];
        final updatedSong = SongModel(
          id: song.id,
          title: song.title,
          artist: song.artist,
          filePath: song.filePath,
          coverImage: song.coverImage,
          duration: song.duration,
          waveformData: waveformData,
        );

        await updateSongInfo(updatedSong);
        print("✅ Đã lưu dữ liệu sóng nhạc cho bài hát: ${song.title}");
      } else {
        print("❌ Không tìm thấy bài hát để lưu dữ liệu sóng nhạc: $songId");
      }
    } catch (e) {
      print("❌ Lỗi khi lưu dữ liệu sóng nhạc: $e");
    }
  }
}
