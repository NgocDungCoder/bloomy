import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class QueueState {
  var song = SongModel(filePath: '', artist: '', id: '', title: '', coverImage: '', duration: Duration(milliseconds: 0)).obs;
  var album = Rxn<AlbumModel>();
  var waitingSongs = <SongModel>[].obs;
  var playedSongs = <SongModel>[].obs;
}