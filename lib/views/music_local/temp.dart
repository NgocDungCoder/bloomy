import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';

class OfflineMusicPlayer extends StatefulWidget {
  const OfflineMusicPlayer({super.key});

  @override
  _OfflineMusicPlayerState createState() => _OfflineMusicPlayerState();
}

class _OfflineMusicPlayerState extends State<OfflineMusicPlayer> {
  List<File> mp3Files = [];
  final MusicPlayer musicPlayer = MusicPlayer();

  @override
  void initState() {
    super.initState();
    _loadMp3Files();
  }

  @override
  void dispose() {
    musicPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadMp3Files() async {
    final files = await getMp3Files();
    setState(() {
      mp3Files = files;
    });
  }

  Future<void> _addMp3File() async {
    String newFilePath = await saveMp3File();
    if (newFilePath.isNotEmpty) {
      await _loadMp3Files(); // Cập nhật danh sách file
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Music Player'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _addMp3File,
            child: const Text('Add MP3 File'),
          ),
          Expanded(
            child: mp3Files.isNotEmpty
                ? ListView.builder(
              itemCount: mp3Files.length,
              itemBuilder: (context, index) {
                final file = mp3Files[index];
                return ListTile(
                  title: Text(file.path.split('/').last),
                  onTap: () async {
                    await musicPlayer.stop();
                    await musicPlayer.playMp3(file.path);
                  },
                );
              },
            )
                : const Center(child: Text('No MP3 files found')),
          ),
        ],
      ),
    );
  }

  Future<String> saveMp3File() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null && result.files.single.path != null) {
      File mp3File = File(result.files.single.path!);
      String fileName = result.files.single.name;

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      Directory musicDir = Directory('$appDocPath/music');
      if (!await musicDir.exists()) {
        await musicDir.create(recursive: true);
      }

      String newPath = '${musicDir.path}/$fileName';
      await mp3File.copy(newPath);
      return newPath;
    }
    return '';
  }

  Future<List<File>> getMp3Files() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String musicDirPath = '${appDocDir.path}/music';

    Directory musicDir = Directory(musicDirPath);
    if (!await musicDir.exists()) {
      print(appDocDir);
      print(musicDirPath);
      print(musicDir);
      print("ko có file nào");
      return [];
    }

    List<FileSystemEntity> files = musicDir.listSync();
    List<File> mp3Files = files
        .where((file) => file.path.endsWith('.mp3'))
        .map((file) => File(file.path))
        .toList();

    return mp3Files;
  }
}

class MusicPlayer {
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

  void dispose() {
    _audioPlayer.dispose();
  }
}