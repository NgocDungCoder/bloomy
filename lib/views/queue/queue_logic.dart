import 'package:bloomy/controllers/album_controller.dart';
import 'package:bloomy/views/queue/queue_state.dart';
import 'package:get/get.dart';

class QueueLogic extends GetxController {
  final state = QueueState();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map;
    state.song.value = args['song'];
    state.album.value = args['album'];
    state.waitingSongs.value = args['songs'];

    state.playedSongs.add(state.song.value);

    // Lọc ra những bài chưa được chơi
    final playedIds = state.playedSongs.map((e) => e.id).toSet();

    state.waitingSongs.value = state.waitingSongs.where((song) => !playedIds.contains(song.id)).toList();

  }
}
