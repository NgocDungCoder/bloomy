import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class QueueState {
  var song = SongModel(filePath: '', artist: '', id: '', title: 'a', coverImage: '', duration: Duration(milliseconds: 0)).obs;
  var albumName = "Danh sách chung".obs;
}