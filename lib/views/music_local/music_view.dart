import 'package:bloomy/controllers/song_controller.dart';
import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/music_player_service.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Music Player')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _controller.addSong(context, _loadSongs),
            child: const Text('Thêm MP3'),
          ),
          ElevatedButton(
            onPressed: () => _controller.removeAllSongs(),
            child: const Text('Xoá MP3'),
          ),
          Expanded(
            child: songs.isEmpty
                ? const Center(child: Text('Chưa có bài nào'))
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
          ),
        ],
      ),
    );
  }
}
