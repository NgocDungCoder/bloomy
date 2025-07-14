import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class HomeState {
  final RxList<SongModel> continueList = <SongModel>[].obs;

  final RxList<AlbumModel> mixesList = <AlbumModel>[].obs;

  final RxList<AlbumModel> recentList = <AlbumModel>[].obs;

}