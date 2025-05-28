import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:bloomy/views/float_play/float_play_state.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class FloatPlayLogic extends GetxController {

  static FloatPlayLogic get to => Get.find<FloatPlayLogic>();

  final SongController songController = Get.find<SongController>();
  final MusicPlayerService _playerService = Get.find<MusicPlayerService>();
  final state = FloatPlayState();


  void playPauseMusic() {
    if (songController.state.isPlay.value) {
      _playerService.pause();
      songController.state.isPlay.toggle();
      state.isPlay.toggle();
    } else {
      _playerService.resume(); // 👈 chỉ gọi resume nếu đã load bài
      songController.state.isPlay.toggle();
      state.isPlay.toggle();
    }
  }

  void nextSong(){
    _playerService.playNextSong();
  }

  bool _controllerSafe(AnimationController controller) {
    try {
      // Nếu controller đã dispose, truy cập bất kỳ property nào cũng sẽ throw
      controller.value;
      return true;
    } catch (_) {
      return false;
    }
  }

}
