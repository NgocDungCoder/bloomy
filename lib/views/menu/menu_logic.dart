import 'package:bloomy/services/song_service.dart';
import 'package:bloomy/views/menu/menu_state.dart';
import 'package:get/get.dart';

class MenuLogic extends GetxController {
  final state = MenuState();
  final songService = Get.find<SongService>();

  @override
  void onInit() {
    super.onInit();
    state.song.value = Get.arguments;
  }

  void deleteSong(String songId) {
    songService.deleteSong(songId);
  }
}