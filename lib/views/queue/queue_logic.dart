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
    state.songs.value = args['songs'];
    print("fffff");
    print(args['songs']);
    print(state.songs.value);

  }
}
