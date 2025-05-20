import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfflineMusicPlayer extends StatefulWidget {
  const OfflineMusicPlayer({super.key});

  @override
  State<OfflineMusicPlayer> createState() => _OfflineMusicPlayerState();
}

class _OfflineMusicPlayerState extends State<OfflineMusicPlayer> {
  final SongController _controller = SongController();
  final MusicPlayerService _player = MusicPlayerService();

  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    List<SongModel> loaded = await _controller.loadSongs();
    setState(() => songs = loaded);
  }

  // Trong phương thức build của _OfflineMusicPlayerState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Music Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _controller.addSong(context, _loadSongs),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Danh sách bài hát
          songs.isEmpty
              ? const Center(child: Text('Không có bài hát nào'))
              : ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      title: Text(song.fileName),
                      subtitle: Text(song.artist),
                      onTap: () async {
                        await _player.stop();
                        await _player.playMp3(song.filePath);
                      },
                    );
                  },
                ),

          // Hiển thị tiến trình
          Obx(
            () => _controller.isProcessing.value
                ? Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _controller.processSuccess.value
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _controller.processMessage.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_controller.processSuccess.value) ...[
                                const SizedBox(height: 10),
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
