import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class AddPlaylistState {
  final albums = <AlbumModel>[].obs;
  var song = Rxn<SongModel>();
}