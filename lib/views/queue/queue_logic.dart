import 'package:bloomy/views/queue/queue_state.dart';
import 'package:get/get.dart';

class QueueLogic extends GetxController {
  final state = QueueState();

  @override
  void onInit() {
    super.onInit();
    state.song.value = Get.arguments;
  }
}