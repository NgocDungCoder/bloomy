import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:get/get.dart';

class AlbumController extends GetxController {
  var waitingSongs = <SongModel>[].obs;
  var playedSongs = <SongModel>[].obs;
  var albumId = "".obs;
  var albumName = "".obs;
  var songsTemp = <SongModel>[].obs;
  final refreshTrigger = 0.obs;


  void updateSongsList(SongModel currentSong) {
    playedSongs.removeWhere((song) => song.id == currentSong.id);
    playedSongs.add(currentSong);
    final playedIds = playedSongs.map((e) => e.id).toSet();
    waitingSongs.removeWhere((song) => playedIds.contains(song.id));
    songsTemp.removeWhere((song) => playedIds.contains(song.id));

  }

  void updatePreviousSong(SongModel currentSong){
    playedSongs.remove(currentSong);
    waitingSongs.insert(0, currentSong);
  }

  void shuffleAlbum(bool isShuffle){
    if(isShuffle){
      songsTemp.value = List.from(waitingSongs); // SAO CHÉP danh sách gốc
      waitingSongs.shuffle(); // Xáo trộn
    } else {
      waitingSongs.value = List.from(songsTemp); // Trả lại danh sách ban đầu
      print("Restored: ${waitingSongs.length}");
    }
  }
}
