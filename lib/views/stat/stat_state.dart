import 'package:bloomy/models/Songs.dart';
import 'package:get/get.dart';

import '../../models/albums.dart';
import '../../models/song_model.dart';

class StatState {
  final List<String> tops = ['Tracks', 'Albums', 'Artists'];

  final RxList<SongModel> tracks = <SongModel>[].obs;
  final RxList<AlbumModel> albums = <AlbumModel>[].obs;
  final RxBool isGridView = false.obs;


  final List<Song> artists = [
    Song(name: 'Sill my heart', image: 'assets/images/img3.jpg'),
    Song(name: 'Love your self', image: 'assets/images/img4.jpg'),
    Song(name: 'Always love you', image: 'assets/images/img5.jpg'),
    Song(name: 'Forever', image: 'assets/images/img6.jpg'),
    Song(name: 'Don\'t leave me', image: 'assets/images/img7.jpg'),
    Song(name: 'Stay here', image: 'assets/images/img8.jpg'),
    Song(name: 'Focus me', image: 'assets/images/img9.jpg'),
    Song(name: 'Time', image: 'assets/images/img10.jpg'),
    Song(name: 'One way', image: 'assets/images/img11.jpg'),
    Song(name: 'Sorry', image: 'assets/images/img12.jpg'),
    Song(name: 'Behind you', image: 'assets/images/img13.jpg'),
    Song(name: 'Let me down', image: 'assets/images/img14.jpg'),
  ];

}