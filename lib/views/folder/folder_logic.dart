import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/views/folder/folder_state.dart';
import 'package:get/get.dart';

class FolderLogic extends GetxController {
  final state = FolderState();
  final _albumService = Get.find<AlbumService>();

  @override
  void onInit() async {
    super.onInit();
    state.albumList.value = await _albumService.loadAlbums();
  }

}