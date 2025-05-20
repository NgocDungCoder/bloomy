import 'package:just_audio/just_audio.dart';

class MusicPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playMp3(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
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