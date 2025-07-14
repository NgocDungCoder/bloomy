import 'package:bloomy/enum/music_type.dart';
import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/artist.dart';
import 'package:bloomy/models/folders.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/models/songs.dart';
import 'package:bloomy/views/app.dart';
import 'package:get/get.dart';

class LibraryState {
  var selectedTag = 0.obs;
  final musicType = MusicType.songs.obs;
  var isSelecting = false.obs;
  var selectedIds = <String>{}.obs;


  List<MusicType> tags = [
    MusicType.songs,
    MusicType.albums,
    MusicType.artists,
    MusicType.podcasts,
  ];

  final songs = <SongModel>[].obs;
  final albums = <AlbumModel>[].obs;
  final artists = <Artist>[].obs;
  final podcasts = <Folder>[].obs;

  // final List<Album> recentList = [
  //   Album(name: "Made For You", image: "assets/images/img5.jpg"),
  //   Album(name: "RELEASED", image: "assets/images/img6.jpg"),
  //   Album(name: "Music Charts", image: "assets/images/img7.jpg"),
  //   Album(name: "Podcasts", image: "assets/images/img8.jpg"),
  //   Album(name: "Bollywood", image: "assets/images/img9.jpg"),
  //   Album(name: "Pop Fusion", image: "assets/images/img10.jpg"),
  // ];

}