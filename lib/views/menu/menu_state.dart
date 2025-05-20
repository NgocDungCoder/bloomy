import 'package:bloomy/controllers/album_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class MenuState {
  var song = SongModel(filePath: "", artist: "", id: "", title: "", coverImage: "", duration: Duration(milliseconds: 0),).obs;

}