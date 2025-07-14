import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/views/library/library_logic.dart';
import 'package:bloomy/views/song/song_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import '../services/lyric_service.dart';
import '../services/song_service.dart';
import '../widgets/input_dialog.dart';
import '../widgets/snackbar.dart';

class SongController extends GetxController {
  final SongService _songService = Get.find<SongService>();
  final SongState state = SongState();
  final LyricService lyricService = Get.find<LyricService>();

  final List<String> imageAssets = List.generate(
    164,
    (index) => 'assets/images/img${index + 1}.jpg',
  );

  @override
  void onInit() {
    state.song.value = SongModel(
        filePath: "",
        artist: "",
        id: '',
        title: '',
        coverImage: '',
        duration: Duration(milliseconds: 0));
    super.onInit();
  }

  Future<void> loadLyrics(SongModel song) async {
    try {
      print("debug abc: ${song.getLyricAssetPath}");
      state.lyrics.value =
          await LyricService.loadFromAsset(song.getLyricAssetPath);

    } catch (e) {
      print("chưa có file lyrics của cái này: $e");
      state.lyrics.value = [];
    }
  }

  // Lấy danh sách đã lưu
  Future<List<SongModel>> loadSongs() => _songService.getSavedSongs();

//Thêm bài hát mới vô chỗ lưu
  Future<void> addSong(BuildContext context, Function onSongsUpdated) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null && result.files.single.path != null) {
      File mp3File = File(result.files.single.path!);
      String fileName = result.files.single.name;

      final input = await showSongInputDialog(context);
      if (input == null) return;

      String songTitle = input['title']!;
      String artistName = input['artist']!;


      //lưu cái này vô chỗ lưu riêng cua app và trả về path
      String newPath = await _songService.saveMp3File(mp3File, fileName);

      // 4. Tạo id tự động
      String songId = const Uuid().v4();

      // Chọn ngẫu nhiên ảnh từ danh sách
      final random = Random();
      final String imagePath = imageAssets[random.nextInt(imageAssets.length)];

      // ✅ Lấy thời lượng mp3
      Duration? duration = await getMp3Duration(newPath) ?? Duration.zero;

      //lưu bài hát vào file song.json
      SongModel song = SongModel(
        id: songId,
        title: songTitle,
        artist: artistName,
        filePath: newPath,
        coverImage: imagePath,
        duration: duration,
        playCount: 0,
        addedDate: DateTime.now(),
      );

      await _songService.saveSongInfo(song);
      await Get.find<LibraryLogic>().refreshLibrary();
      onSongsUpdated();
      showCustomSnackbar(
        message: 'Added new song',
      );
    }
  }

  void updateCurrentLyric(Duration position) {
    for (int i = 0; i < state.lyrics.length; i++) {
      if (position < state.lyrics[i].start) {
        state.currentLyricIndex.value = (i == 0) ? 0 : i - 1;
        update(); // hoặc notifyListeners nếu bạn dùng Provider
        return;
      }
    }
    state.currentLyricIndex.value = state.lyrics.length - 1;
    update();
  }

  Future<void> removeAllSongs() async {
    _songService.deleteAllSongFile();
    showCustomSnackbar(
      message: 'Removed Song',
    );
  }

  Future<String?> _showInputDialog(BuildContext context, String label) async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(label),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: label),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Huỷ'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> incrementPlayCount() async {
    // 1. Lấy danh sách bài hát hiện tại từ file
    List<SongModel> allSongs = await _songService.getSavedSongs();

    // 2. Tìm bài hát theo ID
    final index = allSongs.indexWhere((song) => song.id == state.song.value?.id );
    if (index == -1) return; // Không tìm thấy

    final currentSong = allSongs[index];

    // 3. Tạo bản sao mới với playCount + 1
    final updatedSong = currentSong.copyWith(
      playCount: (currentSong.playCount ?? 0) + 1,
      lastPlayedDate: DateTime.now(),
    );
    print("đã tăng 2: ${updatedSong.playCount}");
    // 4. Cập nhật lại danh sách
    allSongs[index] = updatedSong;

    // 5. Ghi lại danh sách vào file JSON
    await _songService.saveAllSongs(allSongs);
  }

  Future<void> likedSong() async {
    // 1. Lấy danh sách bài hát hiện tại từ file
    List<SongModel> allSongs = await _songService.getSavedSongs();

    // 2. Tìm bài hát theo ID
    final index = allSongs.indexWhere((song) => song.id == state.song.value?.id );
    if (index == -1) return; // Không tìm thấy

    final currentSong = allSongs[index];

    final updatedSong = currentSong.copyWith(
      isLiked: !state.song.value!.isLiked
    );
    // 4. Cập nhật lại danh sách
    allSongs[index] = updatedSong;

    // 5. Ghi lại danh sách vào file JSON
    await _songService.saveAllSongs(allSongs);

    state.song.value = updatedSong;
  }

  Future<void> updateSongInfo(String newTitle, String newArtist) async {
    // 1. Lấy danh sách bài hát hiện tại từ file
    List<SongModel> allSongs = await _songService.getSavedSongs();

    // 2. Tìm bài hát theo ID
    final index = allSongs.indexWhere((song) => song.id == state.song.value?.id);
    if (index == -1) return; // Không tìm thấy

    final currentSong = allSongs[index];

    // 3. Tạo bản sao mới với title và artist mới
    final updatedSong = currentSong.copyWith(
      title: newTitle,
      artist: newArtist,
    );

    // 4. Cập nhật lại danh sách
    allSongs[index] = updatedSong;

    // 5. Ghi lại danh sách vào file JSON
    await _songService.saveAllSongs(allSongs);

    // 6. Cập nhật lại state hiện tại nếu cần
    state.song.value = updatedSong;
  }

  Future<Duration?> getMp3Duration(String filePath) async {
    final player = AudioPlayer();
    try {
      await player.setFilePath(filePath);
      return player.duration;
    } catch (e) {
      print("Lỗi đọc duration: $e");
      return null;
    } finally {
      await player.dispose();
    }
  }
}
