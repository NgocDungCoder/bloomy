// import 'package:bloomy/controllers/song_controller.dart';
// import 'package:bloomy/services/music_player_service.dart';
// import 'package:bloomy/views/float_play/float_play_state.dart';
// import 'package:flutter/animation.dart';
// import 'package:get/get.dart';
//
// class FloatPlayLogic extends GetxController {
//   final SongController songController = Get.find<SongController>();
//   final MusicPlayerService _playerService = Get.find<MusicPlayerService>();
//   final state = FloatPlayState();
//
//   void playPauseMusic() {
//     if (songController.state.isPlay.value) {
//       _playerService.pause();
//       songController.state.isPlay.value = false;
//     } else {
//       _playerService.resume(); // 👈 chỉ gọi resume nếu đã load bài
//       songController.state.isPlay.value = true;
//     }
//   }
//
//   void bindAnimation(AnimationController controller) {
//     ever(songController.state.isPlay, (isPlaying) {
//       if (isPlaying) {
//         controller.repeat();
//       } else {
//         controller.stop();
//       }
//     });
//   }
// }
