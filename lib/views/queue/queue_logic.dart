import 'package:bloomy/controllers/album_controller.dart';
import 'package:bloomy/views/queue/queue_state.dart';
import 'package:get/get.dart';

class QueueLogic extends GetxController {
  final state = QueueState();
  final albumController = Get.find<AlbumController>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      state.song.value = albumController.playedSongs.last;
      state.albumName.value = albumController.albumName.value;
      print("================>");
      printPlayedSong();
    });

  }


  void printSong() {
    albumController.waitingSongs.forEach((song) => print(song));
  }

  void printPlayedSong() {
    albumController.playedSongs.forEach((song) => print(song));
  }
}
