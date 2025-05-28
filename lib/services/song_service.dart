import 'dart:convert';
import 'dart:io';
import 'package:bloomy/models/song_model.dart';
import 'package:path_provider/path_provider.dart';

class SongService {

  Future<File> _getSongFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/songs.json');
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
    Directory dir = await getApplicationDocumentsDirectory();
    //file songs.json lưu path của file mp3 trong vùng nhớ riêng của app
    File jsonFile = File('${dir.path}/songs.json');

    //lấy danh sách các bài hát ra
    List<SongModel> songs = await getSavedSongs();
    songs.insert(0, song);
    //thêm bài hát mới và chuyển thành json ghi lại vào file song.json
    List<Map<String, dynamic>> jsonList = songs.map((s) => s.toJson()).toList();
    await jsonFile.writeAsString(jsonEncode(jsonList));
  }

  //lấy các bài hát từ sóng.json, biến nó lại thàng SongModel
  Future<List<SongModel>> getSavedSongs() async {
    Directory dir = await getApplicationDocumentsDirectory();
    File jsonFile = File('${dir.path}/songs.json');
    if (!jsonFile.existsSync()) return [];
    String content = await jsonFile.readAsString();
    List<dynamic> data = jsonDecode(content);
    return data.map((e) => SongModel.fromJson(e)).toList();
  }

  Future<void> deleteSongFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/songs.json');

    if (await file.exists()) {
      await file.delete();
      print('Đã xoá file songs.json');
    } else {
      print('File songs.json không tồn tại');
    }
  }


  Future<void> deleteSong(String songId) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/songs.json');

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

  Future<void> addLyricPathToSong(String songId, String lyricPath) async {
    // 1. Lấy danh sách bài hát từ storage
    List<SongModel> songs = await getSavedSongs();

    // 2. Tìm bài hát cần cập nhật theo ID
    int index = songs.indexWhere((song) => song.id == songId);
    if (index == -1) return; // không tìm thấy

    // 3. Tạo bản sao mới với lyricPath đã cập nhật
    SongModel updatedSong = songs[index].copyWith(lyricPath: lyricPath);

    // 4. Gán lại vào danh sách
    songs[index] = updatedSong;

    // 5. Ghi lại danh sách đã cập nhật vào file song.json
    await saveAllSongs(songs);
  }

  Future<void> saveAllSongs(List<SongModel> songs) async {
    final jsonList = songs.map((e) => e.toJson()).toList();
    final file = await _getSongFile(); // hàm này là hàm bạn dùng để lấy file path
    await file.writeAsString(jsonEncode(jsonList));
  }
}