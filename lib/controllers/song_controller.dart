import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import '../services/song_service.dart';

class SongController extends GetxController {
  final SongService _songService = Get.find<SongService>();

  final isProcessing = false.obs;
  final processMessage = "".obs;
  final processSuccess = false.obs;

  final int waveformSamples = 200;

  final List<String> imageAssets = List.generate(
    100,
    (index) => 'assets/images/img${index + 1}.jpg',
  );

  Future<void> addSong(BuildContext context, Function onSongsUpdated) async {
    try {
      isProcessing.value = true;
      processMessage.value = "Đang chọn file...";
      processSuccess.value = false;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null && result.files.single.path != null) {
        File mp3File = File(result.files.single.path!);
        String fileName = result.files.single.name;

        processMessage.value = "Đang nhập thông tin bài hát...";
        String? songTitle =
            await _showInputDialog(Get.context!, "Nhập tên bài hát");
        if (songTitle == null || songTitle.isEmpty) {
          isProcessing.value = false;
          return;
        }

        String? artistName =
            await _showInputDialog(Get.context!, "Nhập tên nghệ sĩ");
        if (artistName == null || artistName.isEmpty) {
          isProcessing.value = false;
          return;
        }

        processMessage.value = "Đang lưu file mp3...";
        String newPath = await _songService.saveMp3File(mp3File, fileName);

        String songId = const Uuid().v4();
        final random = Random();
        final String imagePath =
            imageAssets[random.nextInt(imageAssets.length)];

        processMessage.value = "Đang đọc thời lượng bài hát...";
        Duration? duration = await getMp3Duration(newPath) ?? Duration.zero;

        List<double>? extractedWaveform;
        try {
          processMessage.value = "Đang trích xuất dữ liệu sóng nhạc...";
          final tempController = PlayerController();
          await tempController.preparePlayer(
            path: newPath,
            shouldExtractWaveform: true,
            noOfSamples: waveformSamples,
            volume: 0,
          );

          extractedWaveform = await tempController.extractWaveformData(
            path: newPath,
            noOfSamples: waveformSamples,
          );

          // Giải phóng controller
          await tempController.stopPlayer();
          tempController.dispose();
        } catch (e) {
          print("❌ Lỗi khi trích xuất sóng nhạc cho bài hát mới: $e");
          extractedWaveform = List.generate(waveformSamples, (index) {
            double value = 0.5 + 0.3 * sin(index / 5);
            return value.clamp(0.1, 0.9);
          });
        }

        processMessage.value = "Đang lưu thông tin bài hát...";
        SongModel song = SongModel(
          id: songId,
          title: songTitle,
          artist: artistName,
          filePath: newPath,
          coverImage: imagePath,
          duration: duration,
          waveformData: extractedWaveform,
        );

        await _songService.saveSongInfo(song);

        // Đánh dấu thành công
        processSuccess.value = true;
        processMessage.value = "Đã thêm bài hát '$songTitle' thành công!";

        // Hiển thị thông báo thành công
        _showSuccessSnackBar(
            Get.context!, "Đã thêm bài hát '$songTitle' thành công!");

        onSongsUpdated();
      } else {
        processMessage.value = "Đã hủy chọn file";
      }
    } catch (e) {
      processMessage.value = "Lỗi: ${e.toString()}";
      print("❌ Lỗi khi thêm bài hát: $e");

      // Hiển thị thông báo lỗi
      _showErrorSnackBar(Get.context!, "Lỗi khi thêm bài hát: ${e.toString()}");
    } finally {
      // Đặt lại trạng thái sau 2 giây nếu thành công
      if (processSuccess.value) {
        Future.delayed(Duration(seconds: 2), () {
          isProcessing.value = false;
        });
      } else {
        isProcessing.value = false;
      }
    }
  }

  // Hiển thị thông báo thành công
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Hiển thị thông báo lỗi
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<String?> _showInputDialog(BuildContext context, String label) async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(label),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: label),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(Get.context!),
              child: Text('Huỷ'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(Get.context!, controller.text),
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

  Future<void> removeAllSongs() async {
    await _songService.deleteSongFile();
  }

  Future<List<SongModel>> loadSongs() => _songService.getSavedSongs();
}
