import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bloomy/controllers/album_controller.dart';
import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongLogic extends GetxController {
  final SongController songController = Get.find<SongController>();
  final MusicPlayerService _playerService = Get.find<MusicPlayerService>();
  final playerController = PlayerController(); //  //sóng nhạc
  final duration = Duration.zero.obs; //tổng tgian bài hát
  final position = Duration.zero.obs; //thời gian hiện tại
  final sliderValue = 0.0.obs; //vị trí hiện tại
  final isDragging = false.obs; //có kéo ko
  var isReady = false.obs; //sóng nhạc đã oke chưa
  var progress = 0.0.obs; //tiến trình bài hát để đổi màu
  var album = Rxn<AlbumModel>();
  final albumController = Get.find<AlbumController>();





  MusicPlayerService get audioPlayer => _playerService;
  Timer? _waveformStopTimer;



  @override
  void onInit() async {
    super.onInit();
    final args = Get.arguments as Map;
    final SongModel songTemp = args['song'];
    final AlbumModel? albumTemp = args['album'];
    if (songController.state.song.value?.id != songTemp.id) {
      Future.delayed(
        Duration.zero,
        () async {
          songController.state.song.value = songTemp;
          songController.state.isPlay.value = true;
          songController.state.isShow.value = true;

          _playerService.playMp3(songController.state.song.value!.filePath);
        },
      );
    }

    if (albumTemp != null) {
      album.value = albumTemp;
      albumController.songs.value = album.value!.songs;
      print("Mở từ album: ${albumController.songs.value}");
    } else {
      albumController.songs.value = await songController.loadSongs();
    }
    //trả về thời gian của bài hất
    _playerService.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });

    // Theo dõi vị trí hiện tại
    _playerService.positionStream.listen(
      (p) {
        if (!isDragging.value) {
          position.value = p;
          sliderValue.value = p.inMilliseconds.toDouble();
          progress.value = sliderValue.value / duration.value.inMilliseconds.toDouble();
        }
      },
    );
    //có hàm delay để oninit khởi tạo xong mới chạy tránh lỗi
    Future.delayed(Duration.zero, () {
      prepare();
    });
  }

  Future<void> prepare() async {
    final path = songController.state.song.value?.filePath ?? "";

    if (path.isEmpty) {
      print("❌ File path rỗng hoặc null");
      return;
    }

    final file = File(path);
    final exists = await file.exists();

    print("📂 File exists: $exists");
    if (!exists) return;

    await playerController.preparePlayer(
      path: path,
      shouldExtractWaveform: true,
      noOfSamples: 5000,
      volume: 0,
    );

    isReady.value = true;

    // Nếu bạn không muốn phát tự động thì đừng gọi startPlayer
    await playerController.startPlayer();
    await playerController.seekTo(sliderValue.value.toInt());
  }

  @override
  void onClose() {
    playerController.stopPlayer();
    playerController.dispose();
    super.onClose();
  }


  void playPauseMusic() {
    if (songController.state.isPlay.value) {
      _playerService.pause();
      songController.state.isPlay.value = false;
      playerController.pausePlayer();
      print("slider value stop: $sliderValue");

    } else {

      _playerService.resume();
      songController.state.isPlay.value = true;
      playerController.startPlayer();
      playerController.seekTo(sliderValue.value.toInt());
      print("slider value start: $sliderValue");
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void seekTo(double milliseconds) {
    final pos = Duration(milliseconds: milliseconds.toInt());
    _playerService.seek(pos);
    position.value = pos;
    sliderValue.value = milliseconds;
    // playerController.seekTo(milliseconds.toInt());
  }
  List<Color> getGradientColors(double progress) {
    // Màu khởi đầu (gần đen, với ánh sắc nhẹ)
    const startColor1 = Color(0xFF0D1B2A); // Xám xanh đậm gần đen
    const startColor2 = Color(0xFF1B263B); // Xanh navy đậm

    // Màu kết thúc (hồng phấn và xanh cyan)// Hồng phấn nhẹ
    const endColor1 = Color(0xFF00BCD4);
    const endColor2 = Color(0xFF0D1B2A); // Xám xanh đậm gần đen


    // Tính toán màu trung gian dựa trên tiến trình
    Color color1 = Color.lerp(startColor1, endColor1, progress)!;
    Color color2 = Color.lerp(startColor2, endColor2, progress)!;

    return [color1, color2];
  }

}
