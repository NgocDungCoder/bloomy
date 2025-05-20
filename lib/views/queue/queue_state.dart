import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/models/songs.dart';
import 'package:get/get.dart';

class QueueState {
  var song = SongModel(filePath: '', artist: '', id: '', title: '', coverImage: '', duration: Duration(milliseconds: 0)).obs;

  final List<Song> songs = [
    Song(name: "Made For You", image: "assets/images/img5.jpg"),
    Song(name: "RELEASED", image: "assets/images/img6.jpg"),
    Song(name: "Music Charts", image: "assets/images/img7.jpg"),
    Song(name: "Podcasts", image: "assets/images/img8.jpg"),
    Song(name: "Bollywood", image: "assets/images/img9.jpg"),
    Song(name: "Pop Fusion", image: "assets/images/img10.jpg"),
    Song(name: "Made For You", image: "assets/images/img11.jpg"),
    Song(name: "RELEASED", image: "assets/images/img12.jpg"),
    Song(name: "Music Charts", image: "assets/images/img13.jpg"),
    Song(name: "Podcasts", image: "assets/images/img14.jpg"),
    Song(name: "Bollywood", image: "assets/images/img15.jpg"),
    Song(name: "Pop Fusion", image: "assets/images/img16.jpg"),
  ];
}