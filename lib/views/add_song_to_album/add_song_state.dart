import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class AddSongSTate {
  final songs = <SongModel>[].obs;
  final albumId = "".obs;
  final state = <RxBool>[].obs;
  final addedSongIds = <String>{}.obs;

}