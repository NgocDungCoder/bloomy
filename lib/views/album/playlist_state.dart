import 'package:bloomy/models/Songs.dart';
import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class PlaylistState {
  Rx<AlbumModel> album = AlbumModel(id: '', name: '', coverImage: '', songs: []).obs;
}
