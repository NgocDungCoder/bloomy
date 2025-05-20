import 'package:bloomy/models/Songs.dart';
import 'package:bloomy/models/albums.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:get/get.dart';

class PlaylistState {
  var album = AlbumModel(id: '', name: '', coverImage: '', songs: []).obs;
  var songs2 = <SongModel>[].obs;
  late final List<Song> songs = [
    Song(name: "Made For You", image: "assets/images/img5.jpg"),
    Song(name: "RELEASED", image: "assets/images/img6.jpg"),
    Song(name: "Music Charts", image: "assets/images/img7.jpg"),
    Song(name: "Podcasts", image: "assets/images/img8.jpg"),
    Song(name: "Bollywood", image: "assets/images/img9.jpg"),
    Song(name: "Pop Fusion", image: "assets/images/img10.jpg"),
  ];
}
