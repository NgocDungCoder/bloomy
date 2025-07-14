import 'package:bloomy/controllers/album_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/song_controller.dart';
import '../views/home/home_logic.dart';

class MusicPlayerService extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final albumController = Get.find<AlbumController>();
  final songController = Get.find<SongController>();

  @override
  void onInit() {
    super.onInit();

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNextSong(); // chuyển bài
      }
    });
  }

  Future<void> playMp3(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void playNextSong() async{
    albumController.playedSongs.forEach((song) => print(song));
    if (albumController.waitingSongs.isEmpty) {
      albumController.waitingSongs.value = List.from(albumController.playedSongs);
      albumController.playedSongs.clear();
    }

    final next = albumController.waitingSongs.removeAt(0);
    songController.state.song.value = next;
    await songController.incrementPlayCount();
    await Get.find<HomeLogic>().refreshSongs();
    await songController.loadLyrics(next);
    albumController.updateSongsList(next);
    playMp3(next.filePath);
  }

  void playPreviousSong() async{
    if (albumController.playedSongs.length > 1) {
      final previous =
          albumController.playedSongs[albumController.playedSongs.length - 2];
      songController.state.song.value = previous;
      await songController.incrementPlayCount();
      await Get.find<HomeLogic>().refreshSongs();
      await songController.loadLyrics(previous);
      albumController.updatePreviousSong(albumController.playedSongs.last);
      playMp3(previous.filePath);
    } else {
      print("Danh sách chờ rỗng.");
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play(); // 👈 chính hàm này sẽ "resume"
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  /// ✅ Thêm hàm seek
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  /// ✅ Stream để theo dõi tiến trình hiện tại
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// ✅ Stream để lấy thời lượng bài hát
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  /// ✅ Getter nếu bạn cần giá trị thời lượng hiện tại ngay
  Duration? get duration => _audioPlayer.duration;
}
