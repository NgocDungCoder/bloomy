import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

import '../../models/song_model.dart';

class SongLogic extends GetxController {
  final audioPlayer = AudioPlayer();
  final songTemp = Rxn<SongModel>();
  final isReady = false.obs;
  final waveFormData = RxList<double>();

  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;
  final progress = 0.0.obs;
  final isPlaying = false.obs;

  // Thêm biến để theo dõi thời gian cập nhật cuối cùng
  DateTime _lastUpdateTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayer();
    loadData();
  }

  void _setupAudioPlayer() {
    // Tăng tần suất cập nhật vị trí
    audioPlayer.positionStream
        .listen((pos) {
      position.value = pos;
      _updateProgress();
    });

    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      // Nếu đang phát nhưng progress không cập nhật, force cập nhật
      if (state.playing && DateTime.now().difference(_lastUpdateTime).inSeconds > 1) {
        _updateProgress();
      }
    });

    audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
        _updateProgress();
      }
    });
  }

  void _updateProgress() {
    if (duration.value.inMilliseconds > 0) {
      _lastUpdateTime = DateTime.now();
      final oldProgress = progress.value;
      progress.value = position.value.inMilliseconds / duration.value.inMilliseconds;
      progress.value = progress.value.clamp(0.0, 1.0);

      // Debug print nếu có thay đổi đáng kể
      if ((progress.value - oldProgress).abs() > 0.01) {
        print('Progress updated: ${progress.value.toStringAsFixed(2)}');
        print('Position: ${position.value.inSeconds}s / ${duration.value.inSeconds}s');
      }

      // Force update UI
      update();
    }
  }

  Future<void> loadData() async {
    final args = Get.arguments;
    if (args is SongModel) {
      songTemp.value = args;

      // Tạo dữ liệu waveform nếu không có
      if (songTemp.value?.waveformData == null || songTemp.value!.waveformData!.isEmpty) {
        // Tạo waveform ngẫu nhiên nhưng có mẫu đẹp hơn
        final random = Random();
        final List<double> generatedData = [];

        // Tạo dữ liệu dạng sóng với 100 mẫu
        double prevValue = 0.5;
        for (int i = 0; i < 100; i++) {
          // Tạo giá trị mới không quá khác biệt so với giá trị trước đó
          double newValue = (prevValue + (random.nextDouble() * 0.4 - 0.2)).clamp(0.2, 0.9);
          generatedData.add(newValue);
          prevValue = newValue;
        }

        waveFormData.value = generatedData;
      } else {
        waveFormData.value = songTemp.value!.waveformData!;
      }

      await _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    try {
      final path = songTemp.value?.filePath ?? '';
      if (path.isEmpty) {
        print('Đường dẫn file rỗng');
        return;
      }

      await audioPlayer.setFilePath(path);
      duration.value = audioPlayer.duration ?? Duration.zero;

      // Tự động phát khi khởi tạo
      await audioPlayer.play();
      isPlaying.value = true;
      isReady.value = true;

      // Force update UI
      update();
    } catch (e) {
      print('Lỗi khi khởi tạo player: $e');
    }
  }

  void playPause() {
    if (isPlaying.value) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void seekTo(double milliseconds) {
    audioPlayer.seek(Duration(milliseconds: milliseconds.toInt()));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
