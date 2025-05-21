import 'dart:io';
import 'dart:math';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/views/song/song_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import '../services/song_service.dart';

class SongController extends GetxController {
  final SongService _songService = Get.find<SongService>();
  final SongState state = SongState();

  final List<String> imageAssets = List.generate(
    100,
        (index) => 'assets/images/img${index + 1}.jpg',
  );

  @override
  void onInit() {
    state.song.value = SongModel(filePath: "", artist: "", id: '', title: '', coverImage: '', duration: Duration(milliseconds: 0));
    super.onInit();


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

      String? songTitle = await _showInputDialog(context, "Nhập tên bài hát");
      if (songTitle == null || songTitle.isEmpty) return;

      // 2. Hỏi tên nghệ sĩ
      String? artistName = await _showInputDialog(context, "Nhập tên nghệ sĩ");
      if (artistName == null || artistName.isEmpty) return;

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
        filePath: newPath, coverImage: imagePath,
        duration: duration,
      );

      await _songService.saveSongInfo(song);

      onSongsUpdated();
    }
  }


  Future<void> removeAllSongs() async {
    _songService.deleteSongFile();

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