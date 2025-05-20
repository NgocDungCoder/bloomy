import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class WaveformTestPage extends StatefulWidget {
  @override
  _WaveformTestPageState createState() => _WaveformTestPageState();
}

class _WaveformTestPageState extends State<WaveformTestPage> {
  final PlayerController _playerController = PlayerController();
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _prepareWaveform();
  }

  Future<void> _prepareWaveform() async {
    await Permission.storage.request();

    final path = await _downloadAndSaveMp3();
    if (path == null) {
      print("❌ Không tải được file mp3.");
      return;
    }

    try {
      await _playerController.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
      );
      print("✅ Sóng nhạc đã sẵn sàng.");
      setState(() {
        isReady = true;
      });
    } catch (e) {
      print("❌ Lỗi khi chuẩn bị sóng nhạc: $e");
    }
  }

  Future<String?> _downloadAndSaveMp3() async {
    final url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/test_song.mp3';
      final file = File(filePath);

      // Nếu file đã tồn tại thì khỏi tải lại
      if (!await file.exists()) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          print('✅ Đã lưu file tại $filePath');
        } else {
          print('❌ Lỗi tải file: ${response.statusCode}');
          return null;
        }
      }

      return filePath;
    } catch (e) {
      print('❌ Lỗi tải file: $e');
      return null;
    }
  }

  void _togglePlay() {
    if (_playerController.playerState == PlayerState.playing) {
      _playerController.pausePlayer();
    } else {
      _playerController.startPlayer();
    }
  }

  @override
  void dispose() {
    _playerController.stopAllPlayers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🎵 Sóng nhạc demo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isReady) ...[
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Đang tải và chuẩn bị sóng nhạc...")
            ] else ...[
              AudioFileWaveforms(
                playerController: _playerController,
                size: Size(double.infinity, 80),
                waveformType: WaveformType.long,
                playerWaveStyle: PlayerWaveStyle(
                  fixedWaveColor: Colors.grey.shade400,
                  liveWaveColor: Colors.blueAccent,
                  spacing: 6,
                  waveThickness: 2.5,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _togglePlay,
                icon: Icon(
                  _playerController.playerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                label: Text("Phát / Dừng"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
