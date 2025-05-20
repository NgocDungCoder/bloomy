import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class AddSongSTate {
  final songs = <SongModel>[].obs;
  final album = Rxn<AlbumModel>();
  final state = <RxBool>[].obs;
  final addedSongIds = <String>{}.obs;

}